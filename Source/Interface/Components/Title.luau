local React = require(script.Parent.Parent.Parent.Packages.React)

local ReactSpring = require(script.Parent.Parent.Parent.Packages.ReactSpring)

local Context = require(script.Parent.Parent.Parent.Context)

local DARK_MODE_TITLE_TEXT_ICON = "http://www.roblox.com/asset/?id=17757845846"
local LIGHT_MODE_TITLE_TEXT_ICON = "http://www.roblox.com/asset/?id=17758130684"

local MAX_ROTATION_FORCE = 5

local function Title()
	local theme = Context:getTheme()

	local animationHook, animationApi = ReactSpring.useSpring(function()
		return {
			from = { progress = 0 },
			to = { progress = 0 },
		}
	end)
	
	local function animateTextLabel()
		animationApi.start({
			progress = math.random() > 0.5 and 1 or -1,
	
			config = {
				easing = ReactSpring.easings.easeOutBack,
	
				duration = 0.3,
			},
		})
	end
	
	local function unanimateTextLabel()
		animationApi.start({
			progress = 0,
	
			config = {
				easing = ReactSpring.easings.easeOutBack,
	
				duration = 0.3,
			},
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0.14),
		BackgroundTransparency = 1,

		LayoutOrder = 1,
	}, {
		ImageLabe = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,

			Rotation = animationHook.progress:map(function(value)
				return value * MAX_ROTATION_FORCE
			end),

			Image = theme.Name == "Light" and LIGHT_MODE_TITLE_TEXT_ICON or DARK_MODE_TITLE_TEXT_ICON,
			ResampleMode = Enum.ResamplerMode.Pixelated,

			[React.Event.MouseEnter] = animateTextLabel,
			[React.Event.MouseLeave] = unanimateTextLabel,
		})
	})
end

return Title