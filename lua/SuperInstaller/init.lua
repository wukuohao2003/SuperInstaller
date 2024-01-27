local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		use = {
			git = "ssh",
			repositories = {
				"wukuohao2003/SuperInstaller",
			},
		},
	}, config or {})

	vim.cmd(
		"command! SuperSyncdDownload lua require('SuperInstaller').SuperAsyncDownload("
			.. dkjson.encode(configure.use)
			.. ")"
	)
	print(dkjson.encode(configure.use))
end

return {
	setup = M.setup,
}
