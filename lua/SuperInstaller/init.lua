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

	vim.env.JSON_CONFIGURE = json_configure

	print(vim.fn.getenv("JSON_CONFIGURE"))

	vim.cmd(
		"command! SuperAsyncDownload lua require('SuperInstaller.methods.SuperAsyncDownload').SuperAsyncDownload(vim.fn.getenv('JSON_CONFIGURE'))"
	)
end

return {
	setup = M.setup,
}
