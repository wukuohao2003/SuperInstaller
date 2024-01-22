local M = {}

local install_path = vim.fn.stdpath("data") .. "/site/super_installer/start"

local function isExit(opt)
	local resp = vim.fn.glob(install_path .. "/" .. vim.split(opt, "/")[2])
	if vim.fn.empty(resp) > 0 then
		return
	else
		vim.api.nvim_command("!git clone git@github.com:" .. opt .. " " .. install_path .. "/SuperInstaller")
	end
end

local function install(opt)
	for _, value in ipairs(opt.plugin) do
		isExit(value)
	end
end
local function updae() end
local function clean() end

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		display = {
			progress_bar = {
				enable = true,
				title = "",
				title_pos = "center",
				vasize = { w = 60, h = 7 },
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
		install({ progress_bar = configure.display.progress_bar.enable, plugin = configure.use })
	end)
end

return {
	setup = M.setup,
}
