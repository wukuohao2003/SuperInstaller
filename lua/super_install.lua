local main = {}

local function setup(option)
	local ui = vim.api.nvim_list_uis()[1]
	main = vim.tbl_extend("force", {
		display = {
			width = ui.width / 2,
			height = ui.height / 2,
		},
		ist_path = "",
		ist_methods = "HTTPS",
		istl_plugin = {},
	}, option or {})
	vim.keymap.set("n", "<C-T>", function()
		local buf = vim.api.nvim_create_buf(true, true)
		local opts = {
			relative = "editor",
			title = "SuperInstaller",
			col = (ui.width - main.display.width) / 2,
			row = (ui.height - main.display.height) / 2,
			style = "minimal",
			border = "rounder",
			title_pos = "center",
		}
		vim.api.nvim_open_win(buf, true, opts)
	end, {})
end

return {
	setup = setup,
}
