VERSION = "1.0.0"

local micro = import("micro")
local config = import("micro/config")
local shell = import("micro/shell")
local buffer = import("micro/buffer")

config.RegisterCommonOption("cargo", "fmt", true)

function init()
	config.MakeCommand("cargofmt", cargofmt, config.NoComplete)
	config.AddRuntimeFile("cargofmt", config.RTHelp, "help/cargofmt.md")
end

-- to run the formatter on every save:
function onSave(bp)
	if bp.Buf:FileType() == "rust" then
   		cargofmt(bp)
   	end
    return true
end

function cargofmt(bp)
	if bp.Buf:FileType() == "rust" then
	    bp:Save()
	    local _, err = shell.RunCommand("cargo fmt")
	    if err ~= nil then
	        micro.InfoBar():Error(err)
	        return
	    end
    	bp.Buf:ReOpen()
	else
		micro.InfoBar():Message("No rust files present")
		return
	end
end

