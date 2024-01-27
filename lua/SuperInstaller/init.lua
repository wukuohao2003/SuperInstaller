local M = {}

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

local function progressInstall(opt)
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
		title = "Cloing From Git ...",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	for _, use in ipairs(opt.use) do
		local command = installMethods({ mode = opt.mode, use = use })
		local result = nil
		local async_job = vim.fn.jobstart(command, {
			on_stderr = function(job_id, data, event)
				result = string.match(data[1], "^Receiving deltas: (%d+)%%")
				vim.api.nvim_buf_set_lines(buf, 0, 1, false, { result })
			end,
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
		use = {
			"wukuohao2003/SuperInstaller",
		},
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
