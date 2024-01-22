local istl = {}

local function open_window(width, height, ui)
	vim.notify("我成功执行了哦")
	local buf = vim.api.nvim_create_buf(true, true)
	local opts = {
		relative = "editor",
		title = "SuperInstaller",
		col = (ui.width - width) / 2,
		row = (ui.height - height) / 2,
		style = "minimal",
		border = "rounder",
		title_pos = "center",
	}
	vim.api.nvim_open_win(buf, true, opts)
end

local function setup(option)
	local ui = vim.api.nvim_list_uis()[1]
	local main = vim.tbl_extend("force", {
		display = {
			float = true,
			width = ui.width / 2,
			height = ui.height / 2,
			position = {
				x = "center",
				y = "center",
			},
		},
		ist_path = "",
		ist_methods = "HTTPS",
	}, option or {})
	vim.keymap.set("n", "<C-t>", function()
		open_window(main.display.width, main.display.height, ui)
	end, {})
end

return {
	setup = setup,
}
