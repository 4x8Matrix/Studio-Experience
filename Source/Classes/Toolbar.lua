local HttpService = game:GetService("HttpService")

local Trove = require(script.Parent.Parent.Packages.Trove)

local Context = require(script.Parent.Parent.Context)

local Toolbar = {}

Toolbar.Interface = {}
Toolbar.Prototype = {}

function Toolbar.Prototype:SetCallbackFor(callbackName, callbackFunction)
	self.callbacks[callbackName] = callbackFunction
end

function Toolbar.Prototype:Destroy()
	self.trove:Destroy()
end

function Toolbar.Interface.new()
	local self = setmetatable({}, {
		__index = Toolbar.Prototype,
	})

	self.plugin = Context:getPlugin()

	self.callbacks = {}
	self.trove = Trove.new()

	self.toolbar = self.plugin:CreateToolbar(Context.ToolbarName)
	self.button = self.toolbar:CreateButton(
		HttpService:GenerateGUID(false),
		Context.ButtonTooltip,

		Context:getTheme().Name == "Light" and Context.LightButtonIcon
			or Context.DarkButtonIcon,
			Context.ButtonName
	)

	self.toolbar.Parent = self.plugin
	self.toolbar.Name = `Toolbar<"{Context.ToolbarName}">`

	self.button.Parent = self.toolbar
	self.button.Name = `ToolbarButton<"{Context.ButtonName}">`

	self.button.Enabled = true
	self.button.ClickableWhenViewportHidden = true

	self.trove:Add(self.toolbar)
	self.trove:Add(self.button)

	self.trove:Connect(Context.ThemeChanged, function()
		self.button.Icon = Context:getTheme().Name == "Light" and Context.LightButtonIcon
			or Context.DarkButtonIcon
	end)

	self.trove:Connect(self.button.Click, function()
		if not self.callbacks.onButtonClicked then
			return
		end

		self.callbacks.onButtonClicked()
	end)

	return self
end

export type Toolbar = typeof(Toolbar.Prototype)

return Toolbar.Interface
