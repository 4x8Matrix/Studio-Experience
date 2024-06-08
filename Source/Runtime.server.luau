--[[
	StudioExperience:
		A simple plugin that keeps track of time spent in ALL studios + other cool stats!
]]
--

local RunService = game:GetService("RunService")

if RunService:IsRunMode() then
	return
end

local React = require(script.Parent.Packages.React)
local Runtime = require(script.Parent.Packages.Runtime)

local Toolbar = require(script.Parent.Classes.Toolbar)
local Widget = require(script.Parent.Classes.Widget)

local Interface = require(script.Parent.Interface.Interface)

local TimeTracker = require(script.Parent.Singletons.TimeTracker)

local Context = require(script.Parent.Context)

local MINUTES_PER_LEVEL = 30

local StudioExperience = {}

StudioExperience.Interface = {}
StudioExperience.Prototype = {}

StudioExperience.Prototype.pluginWidget = newproxy() :: Widget.Widget
StudioExperience.Prototype.pluginToolbar = newproxy() :: Toolbar.Toolbar

function StudioExperience.Prototype:NormalizeTime(value: number)
	if value < 10 then
		return string.format("0%d", value)
	else
		return tostring(value)
	end
end

function StudioExperience.Prototype:SecondsToDays(value: number)
	return self:NormalizeTime(math.floor(value / 86400))
end

function StudioExperience.Prototype:SecondsToHours(value: number)
	return self:NormalizeTime(math.floor((value % 86400) / 3600))
end

function StudioExperience.Prototype:SecondsToMinutes(value: number)
	return self:NormalizeTime(math.floor((value % 3600) / 60))
end

function StudioExperience.Prototype:SecondsToSeconds(value: number)
	return self:NormalizeTime(math.floor(value % 60))
end

function StudioExperience.Prototype:GetTotalExperience()
	return TimeTracker:GetTotalTimeTracked()
end

function StudioExperience.Prototype:GetLocalTotalExperience()
	return TimeTracker:GetSessionTimeTracked()
end

function StudioExperience.Prototype:GetTotalSessionCount()
	return TimeTracker:GetStudioCount()
end

function StudioExperience.Prototype:GetLiveSessionCount()
	return TimeTracker:GetLiveStudioCount()
end


function StudioExperience.Prototype:GetTotalSessionsForThisPlace()
	return TimeTracker:GetTotalSessionsForThisPlace()
end

function StudioExperience.Prototype:GetLevelFromExperience(experience: number)
	return experience / 60 / MINUTES_PER_LEVEL
end

function StudioExperience.Prototype:GetMaxTargetExperienceForLevel(level: number)
	return level * 60 * MINUTES_PER_LEVEL 
end

function StudioExperience.Prototype:StartProgression()
	self.ProgressionThread = task.spawn(function()
		local oldDeveloperLevel

		while true do
			local totalExperience = self:GetTotalExperience()
			local totalLocalExperience = self:GetLocalTotalExperience()

			local developerLevel = math.floor(self:GetLevelFromExperience(totalExperience))
			local maxTargetExp = self:GetMaxTargetExperienceForLevel(developerLevel + 1)
			local minTargetExp = self:GetMaxTargetExperienceForLevel(developerLevel)

			local percentage = math.clamp((totalExperience - minTargetExp) / (maxTargetExp - minTargetExp), 0, 1)

			local seconds = self:SecondsToSeconds(totalExperience)
			local minutes = self:SecondsToMinutes(totalExperience)
			local hours = self:SecondsToHours(totalExperience)
			local days = self:SecondsToDays(totalExperience)

			local rocketVisible = false

			if not oldDeveloperLevel then
				oldDeveloperLevel = developerLevel
			end

			if developerLevel ~= oldDeveloperLevel then
				rocketVisible = true

				oldDeveloperLevel = developerLevel
			end

			self.pluginWidget:Update(React.createElement(Interface, {
				developerLevel = developerLevel,
				developerLevelPercent = percentage,
				rocketAnimationEnabled = rocketVisible,
				footerLabel = `{
					days ~= "00" and `{days}d ` or ``
				}{
					hours ~= "00" and `{hours}h ` or ``
				}{
					minutes ~= "00" and `{minutes}m ` or ``
				}{
					`{seconds}s `
				}in\n studio.`,
				stats = {
					`<font color="#FF7800">{self:SecondsToHours(totalLocalExperience)}h {self:SecondsToMinutes(totalLocalExperience)}m</font> in the current studio!`,
					`<font color="#FF7800">{math.floor(totalExperience)}</font> / <font color="#FF7800">{math.floor(maxTargetExp)}</font> XP!`,
					`Studio Multiplier: <font color="#FF7800">x{self:GetLiveSessionCount() - 1}</font>`,
					`<font color="#FF7800">{self:GetTotalSessionCount()}</font> total sessions counted!`,
					`<font color="#FF7800">{self:GetTotalSessionsForThisPlace()}</font> total sessions for this place!`,
					`Percent to Level: <font color="#FF7800">{math.floor(percentage * 100)}%</font>`,
				}
			}))

			task.wait(1)
		end
	end)
end

function StudioExperience.Prototype:CreatePluginWidget()
	self.pluginWidget = Widget.new()

	self.pluginWidget:Mount(React.createElement(Interface, {
		developerLevel = 0,
		developerLevelPercent = 0,
		footerLabel = "0m in\n<bold>this</bold> studio.",
		stats = { "", "", "", "", "", "", }
	}))
end

function StudioExperience.Prototype:CreatePluginToolbar()
	self.pluginToolbar = Toolbar.new()

	self.pluginToolbar:SetCallbackFor("onButtonClicked", function()
		if self.pluginWidget:IsHidden() then
			self.pluginWidget:Show()
		else
			self.pluginWidget:Hide()
		end
	end)
end

function StudioExperience.new()
	local self = setmetatable({}, { __index = StudioExperience.Prototype })

	Context:_setPlugin(plugin)

	self:CreatePluginWidget()
	self:CreatePluginToolbar()

	self:StartProgression()
	
	Runtime:CallMethodOn(Runtime:RequireChildren(script.Parent.Singletons), "OnInit")
	Runtime:CallMethodOn(Runtime:RequireChildren(script.Parent.Singletons), "OnStart")

	plugin.Unloading:Once(function()
		self.pluginToolbar:Destroy()
		self.pluginWidget:Destroy()

		task.cancel(self.ProgressionThread)

		Runtime:CallMethodOn(Runtime:RequireChildren(script.Parent.Singletons), "OnStop")
	end)

	return self
end

return StudioExperience.new()
