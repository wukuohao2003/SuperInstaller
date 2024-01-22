local istl = {}

local function setup(option)
	local ui = vim.api.nvim_list_uis()[1]
	istl = vim.tbl_extend("force", {
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
	local buf = vim.api.nvim_create_buf(true, true)
	local opts = {
		relative = "editor",
		title = "SuperInstaller",
		col = istl.position.x,
		row = istl.position.y,
		style = "minimal",
		border = "rounder",
		title_pos = "center",
	}
	vim.api.nvim_open_win(buf, true, opts)
end

return {
	setup = setup,
}
