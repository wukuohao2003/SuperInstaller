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
	local win_width = 50
	local win_height = 10
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
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	for _, use in ipairs(opt.use) do
		local job_id = vim.fn.jobstart(installMethods({ mode = opt.mode }, { use = use }), {
			on_stdout = function(_, data, _)
				for _, line in ipairs(data) do
					local progress = string.match(line, "^Receiving objects: (%d+)%%")
					if progress then
						print("Download progress: " .. progress .. "%")
					end
				end
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
