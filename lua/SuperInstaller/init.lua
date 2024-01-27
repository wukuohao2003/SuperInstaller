local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		install_methods = "ssh",
		use = {
			"wukuohao2003/SuperInstaller",
		},
	}, config or {})

	vim.cmd(
		"command! SuperSyncdDownload lua require('SuperInstaller').SuperAsyncDownload({progress_bar = true"
			.. ", use = "
			.. dkjson.encode(configure.use)
			.. ", mode = '"
			.. configure.install_methods
			.. "'})"
	)
end

return {
	setup = M.setup,
}
