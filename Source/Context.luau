local StudioService = game:GetService("StudioService")
local StudioSettings = settings():GetService("Studio")

local Context = {}

Context.Interface = {}
Context.Internal = {}

Context.Internal.UserId = StudioService:GetUserId()
Context.Internal.Plugin = newproxy()

Context.Interface.ToolbarName = "Studio XP"
Context.Interface.LightButtonIcon = "http://www.roblox.com/asset/?id=17765858525"
Context.Interface.DarkButtonIcon = "http://www.roblox.com/asset/?id=17765858525"
Context.Interface.ButtonTooltip = "Open the Interface for the Studio XP plugin!"
Context.Interface.ButtonName = "Open Interface"

Context.Interface.MinimumSize = Vector2.new(300, 300)
Context.Interface.WidgetTitle = "Studio Experience"

Context.Interface.ThemeChanged = StudioSettings.ThemeChanged

function Context.Interface._setPlugin(_, plugin: Plugin)
	Context.Internal.Plugin = plugin
end

function Context.Interface.getTheme()
	return (StudioSettings.Theme :: unknown) :: StudioTheme
end

function Context.Interface.getUserId()
	return (Context.Internal.UserId :: unknown) :: number
end

function Context.Interface.getPlugin()
	return (Context.Internal.Plugin :: unknown) :: Plugin
end

return Context.Interface