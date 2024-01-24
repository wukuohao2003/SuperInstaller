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
	local win_width = 40
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
		title = "install now ...",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	local function job_exit_cb(_, code, use)
		if code ~= 0 then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Error: Git command failed." })
		else
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { use .. "Installation successful." })
		end
	end

	local function createJob(cmd, use)
		local job_id =
			vim.fn.jobstart(cmd, { on_exit = job_exit_cb(use), stdout_buffered = true, stderr_buffered = true })
	end

	for _, use in ipairs(opt.use) do
		createJob(installMethods({ mode = opt.mode }, { use = use }), use)
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
