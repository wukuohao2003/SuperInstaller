local function setup(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		display = {
			progress_bar = true,
			title = "",
			title_pos = "center",
			size = {
				width = 60,
				height = 7,
			},
			position = {
				pos = "cc",
			},
			color = {
				bar_color = "",
				font_color = "",
			},
		},
		use = {},
	}, config or {})
	vim.notify("我已成功加载")
end

local function install() end
local function updae() end
local function clean() end

return {
	setup = setup,
}
