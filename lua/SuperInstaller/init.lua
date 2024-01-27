local M = {}

local install = require("SuperInstaller.methods.SuperAsyncDownLoad")

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

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

	local function lambda_download()
		install.SuperAsyncdDownload({
			progress_bar = configure.display.progress_bar.enable,
			use = configure.use,
			mode = configure.install_methods,
		})
	end

	vim.cmd("command! SuperAsyncDownload :lua require('SuperInstaller').setup().lambda_download()")
end

return {
	setup = M.setup,
}
