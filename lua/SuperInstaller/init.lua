local M = {}

local install_path = vim.fn.stdpath("data") .. "/site/super_installer/start"

local function Mode(mode)
	local any = nil
	if mode == "ssh" then
		any = "git@gitub.com:"
	end
	if mode == "https" then
		any = "https://github.com/"
	end
	return any
end

local function installMethods(opt, use)
	local mode = Mode(opt.mode)
	local exists = vim.fn.isdirectory(install_path .. vim.split(use.use, "/")[2]) == 1
	if exists then
		return ("cd " .. install_path .. "/" .. vim.split(use.use, "/")[2] .. " && git pull")
	else
		return ("git clone " .. mode .. use.use .. " " .. install_path .. "/" .. vim.split(use.use, "/")[2])
	end
end

local function progressInstall(opt)
	local win_width = 60
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
		title = "Pulling From Git ...",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local progress = 0
	local total_tasks = #opt.use

	for _, use in ipairs(opt.use) do
		local job_id = vim.fn.jobstart(installMethods({ mode = opt.mode }, { use = use }), {
			on_exit = function(_, code)
				if code ~= 0 then
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error: Git command failed." })
				else
					vim.api.nvim_buf_set_lines(
						buf,
						0,
						-1,
						false,
						{ "Install " .. vim.split(use, "/")[2] .. " successful ..." }
					)
				end
				progress = progress + 1
				local percentage = math.floor((progress / total_tasks) * 100)
				local progress_bar = string.rep("█", percentage / 2)
				vim.api.nvim_win_set_config(win, { title = "Progress: " .. percentage .. "%", title_pos = "center" })
				vim.api.nvim_buf_set_lines(buf, 1, -1, false, { "[" .. progress_bar .. "]" })
			end,
			stdout_buffered = true,
			stderr_buffered = true,
		})
	end
end

local function SuperSyncdDownload(opt)
	if opt.progress_bar then
		progressInstall(opt)
	else
		return
	end
end

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		display = {
			progress_bar = {
				enable = false,
			},
		},
		use = {},
	}, config or {})
	vim.keymap.set("n", "<C-i>", function()
		SuperSyncdDownload({
			progress_bar = configure.display.progress_bar.enable,
			use = configure.use,
			mode = configure.install_methods,
		})
	end)
end

return {
	setup = M.setup,
}
