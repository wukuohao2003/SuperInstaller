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
	local exists = vim.fn.isdirectory(install_path .. vim.split(use, "/")[2]) == 1
	if exists then
		return ("!cd " .. install_path .. "/" .. vim.split(use, "/")[2] .. " && git pull")
	else
		return ("!git clone " .. mode .. use .. " " .. install_path .. "/" .. vim.split(use, "/")[2])
	end
end

local function progressInstall(opt)
	local win_width = 40
	local win_height = 3
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
		border = "single",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Running Git command..." })

	for _, use in ipairs(opt.use) do
		local cmd = installMethods({ mode = opt.mode }, { use = use }) -- 替换成你需要执行的 Git 指令
		vim.fn.jobstart(cmd, {
			on_stdout = function(_, data, _)
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(data, "\n"))
			end,
			on_stderr = function(_, data, _)
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(data, "\n"))
			end,
			on_exit = function(_, exit_code)
				if exit_code == 0 then
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Done!" })
				else
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Error!" })
				end
				vim.api.nvim_win_close(win, true)
			end,
		})
	end
end

local function SuperSyncdDownload(opt)
	if opt.progress_bar then
		progressInstall(opt)
	end
	for _, value in ipairs(opt.use) do
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
