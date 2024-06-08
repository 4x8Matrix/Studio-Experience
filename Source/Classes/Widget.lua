local HttpService = game:GetService("HttpService")

local Trove = require(script.Parent.Parent.Packages.Trove)

local ReactRoblox = require(script.Parent.Parent.Packages.ReactRoblox)

local Context = require(script.Parent.Parent.Context)

local Widget = {}

Widget.Interface = {}
Widget.Prototype = {}

function Widget.Prototype:Mount(reactElement)
	self.root = ReactRoblox.createRoot(self.pluginWidget)

	self.root:render(reactElement)
end

function Widget.Prototype:Update(reactElement)
	self.root:render(reactElement)
end

function Widget.Prototype:Unmount()
	self.root:unmount()
end

function Widget.Prototype:Show()
	self.pluginWidget.Enabled = true
end

function Widget.Prototype:IsHidden()
	return not self.pluginWidget.Enabled
end

function Widget.Prototype:Hide()
	self.pluginWidget.Enabled = false
end

function Widget.Prototype:Destroy()
	self.trove:Destroy()
end

function Widget.Interface.new()
	local self = setmetatable({}, {
		__index = Widget.Prototype,
	})

	self.plugin = Context:getPlugin()
	self.trove = Trove.new()

	self.pluginWidgetInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		false,
		false,
		Context.MinimumSize.X,
		Context.MinimumSize.Y,
		Context.MinimumSize.X,
		Context.MinimumSize.Y
	)

	self.pluginWidget = self.plugin:CreateDockWidgetPluginGui(HttpService:GenerateGUID(false), self.pluginWidgetInfo)

	self.pluginWidget.Name = `Widget<"{Context.WidgetTitle}">`
	self.pluginWidget.Title = Context.WidgetTitle
	self.pluginWidget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	self.trove:Add(self.pluginWidget)
	self.trove:Add(function()
		if not self.handle then
			return
		end

		self:Unmount()
	end)

	return self
end

export type Widget = typeof(Widget.Prototype)

return Widget.Interface
