local M = {}

local dkjson = require("SuperInstaller.dependence.share.lua.dkjson.dkjson")

local current_dir = os.getenv("PWD")

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
end

if vim.fn.filereadable(vim.fn.expand(current_dir .. "/init.lua")) then
	vim.cmd("luafile " .. current_dir .. "/init.lua")
end

vim.cmd(
	"command! SuperAsyncDownload lua require('SuperInstaller.methods.SuperAsyncDownload').SuperAsyncDownload(vim.fn.getenv('JSON_CONFIGURE'))"
)

return {
	setup = M.setup,
}
