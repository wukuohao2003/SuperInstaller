local M = {}

local install = require("methods.SuperAsyncDownload")

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		display = {
			progress_bar = {
				enable = false,
			},
		},
		use = {
			"wukuohao2003/SuperInstaller",
		},
	}, config or {})
	vim.keymap.set("n", "<C-i>", function()
		install.SuperAsyncdDownload({
			progress_bar = configure.display.progress_bar.enable,
			use = configure.use,
			mode = configure.install_methods,
		})
	end)
	vim.cmd(
		"command! SuperSyncdDownload lua require('SuperInstaller').SuperAsyncDownload({progress_bar = "
			.. tostring(configure.display.progress_bar)
			.. ", use = "
			.. vim.inspect(configure.use)
			.. ", mode = '"
			.. configure.install_methods
			.. "'})"
	)
end

return {
	setup = M.setup,
}
