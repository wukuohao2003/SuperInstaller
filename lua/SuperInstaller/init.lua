local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

M.setup = function(config)
	local configure = vim.tbl_extend("force", {
		use = {
			git_mode = "ssh",
			repositories = {
				"wukuohao2003/SuperInstaller",
			},
		},
	}, config or {})

	local install_args = tostring(dkjson.encode(configure.use))

	local install_cmd = "lua require('SuperInstaller.methods.SuperAsyncDownload').SuperAsyncDownload("
		.. install_args
		.. ")"

	vim.cmd("command! SuperAsyncDownload " .. install_cmd)
end

return {
	setup = M.setup,
}
