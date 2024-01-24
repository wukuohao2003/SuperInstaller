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

local function SuperSyncdDownload(opt)
	for _, value in ipairs(opt.use) do
		local mode = Mode(opt.mode)
		print(vim.fn.isdirectory(install_path .. "/SuperInstaller"))
	end
end

local a = function(value, mode)
	if vim.fn.isdirectory(install_path .. vim.split(value, "/")[2]) == 0 then
		vim.api.nvim_command("!git clone " .. mode .. value .. " " .. install_path .. "/" .. vim.split(value, "/")[2])
	else
		vim.api.nvim_command("!cd " .. install_path .. "/" .. vim.split(value, "/")[2] .. " || git pull")
	end
end

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		display = {
			progress_bar = {
				enable = false,
				title = "",
				title_pos = "center",
				size = { w = 60, h = 7 },
				position = "cc",
				style = {
					f_color = "",
					b_color = "",
				},
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
