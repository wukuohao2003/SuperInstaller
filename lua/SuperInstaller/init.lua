local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

local command_trigger = function()
	vim.cmd(
		"command! SuperAsyncDownload lua require('SuperInstaller.methods.SuperAsyncDownload').SuperAsyncDownload(vim.fn.getenv('JSON_CONFIGURE'))"
	)
end

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

	vim.env.JSON_CONFIGURE = json_configure

	command_trigger()
end

return {
	setup = M.setup,
}
