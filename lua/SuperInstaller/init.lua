local M = {}

local package_path = vim.fb.stdpath("data") .. "/site/super_installer/start"

local function install(opt)
	if opt.progress_bar == true then
		vim.notify("正在以进度条形式下载插件...")
	else
		vim.notify("中止下载...")
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
		install({ progress_bar = configure.display.progress_bar.enable })
	end)
end

return {
	setup = M.setup,
}
