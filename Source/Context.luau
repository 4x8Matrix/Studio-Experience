local StudioService = game:GetService("StudioService")
local StudioSettings = settings():GetService("Studio")

local Context = {}

Context.Interface = {}
Context.Internal = {}

Context.Internal.UserId = StudioService:GetUserId()
Context.Internal.Plugin = newproxy()

Context.Interface.ToolbarName = ""
Context.Interface.LightButtonIcon = ""
Context.Interface.DarkButtonIcon = ""
Context.Interface.ButtonTooltip = ""
Context.Interface.ButtonName = ""

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