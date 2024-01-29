local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

local install_path = vim.fn.stdpath("data") .. "/site/super_installer/start"

local function Mode(mode)
	local git_mode = nil
	if mode == "ssh" then
		git_mode = "git@gitub.com:"
	end
	if mode == "https" then
		git_mode = "https://github.com/"
	end
	return git_mode
end

local function installMethods(opt)
	local mode = Mode(opt.mode)
	local exists = vim.fn.isdirectory(install_path .. vim.split(opt.use, "/")[2]) == 1
	if exists then
		return ("cd " .. install_path .. "/" .. vim.split(opt.use, "/")[2] .. " && git pull")
	else
		return ("git clone --progress " .. mode .. opt.use .. " " .. install_path .. "/" .. vim.split(opt.use, "/")[2])
	end
end

local function progressInstall(mode, use)
	local win_width = 50
	local win_height = 1
	local win_row = math.floor((vim.o.lines - win_height) / 2)
	local win_col = math.floor((vim.o.columns - win_width) / 2)
	local buf = vim.api.nvim_create_buf(false, true)

	local opts = {
		relative = "editor",
		row = win_row,
		col = win_col,
		width = win_width,
		height = win_height,
		style = "minimal",
		border = "rounded",
		title = "Cloing " .. vim.split(use, "/")[2] .. " From Git ...",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local command = installMethods({ mode = mode, use = use })
	local result = nil
	local async_job = vim.fn.jobstart(command, {
		on_stderr = function(job_id, data, event)
			result = string.match(data[1], "^Resolving deltas:  (%d+)%%")
			print(result)
			if result then
				vim.api.nvim_buf_set_lines(
					buf,
					1,
					-1,
					false,
					{ string.rep("█", math.ceil(50 * tonumber(result) / 100)) }
				)
			end
		end,
		on_exit = function(job_id, code, event)
			print(code)
			if code == 0 then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
end

M.SuperAsyncDownload = function(opt)
	local option = dkjson.decode(opt)
	for _, value in ipairs(option.repositories) do
		progressInstall(option.git, value)
	end
end

return {
	SuperAsyncDownload = M.SuperAsyncDownload,
}
