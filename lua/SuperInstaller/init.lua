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

	local json_configure = dkjson.encode(configure.use)

	print(json_configure)

	vim.cmd(
		"command! SuperAsyncDownload "
			.. "lua require('SuperInstaller.methods.SuperAsyncDownload').SuperAsyncDownload("
			.. json_configure
			.. ")"
	)
end

return {
	setup = M.setup,
}
