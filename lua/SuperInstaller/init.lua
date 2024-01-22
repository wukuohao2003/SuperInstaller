local M = {}

local install_path = vim.fn.stdpath("data") .. "/site/super_installer/start"

local function install(opt)
	for _, value in ipairs(opt.plugin) do
		local function isDirectoryExists(path)
			local stat = vim.loop.fs_stat(path)
			return stat and stat.type == "directory"
		end
		local folderPath = install_path .. value
		if isDirectoryExists(folderPath) then
			return
		else
			vim.api.nvim_command("!git clone git@github.com:" .. value .. " " .. install_path .. "/SuperInstaller")
		end
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
