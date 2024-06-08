local React = require(script.Parent.Parent.Parent.Packages.React)

local ROCKET_IMAGE_ID = "http://www.roblox.com/asset/?id=17765854658"

local randomX0 = math.random()
local randomX1 = math.random()

local theta = math.atan2(1, randomX0 - randomX1)

local function Rocket(properties: {
	rocketAnimationCallback: () -> (),
	rocketAnimationHook: any,
})
	return React.createElement("Frame", {
		Size = UDim2.fromScale(0.1, 0.1),
		BackgroundTransparency = 1,

		AnchorPoint = Vector2.new(0.5, 0.5),

		Position = properties.rocketAnimationHook:map(function(value: number)
			return UDim2.fromScale(randomX0, 1):Lerp(UDim2.fromScale(randomX1, 0), value)
		end),

		LayoutOrder = 1,
	}, {
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint"),

		RocketImage = React.createElement("ImageLabel", {
			Size = properties.rocketAnimationHook:map(function(value: number)
				return UDim2.fromScale(4, 4):Lerp(UDim2.fromScale(0, 0), value / 2)
			end),

			ImageTransparency = properties.rocketAnimationHook:map(function(value: number)
				return value ^ 6
			end),

			AnchorPoint = Vector2.new(0.5, 0.5),

			Position = UDim2.fromScale(0.5, 0.5),

			BackgroundTransparency = 1,
			Image = ROCKET_IMAGE_ID,
			Rotation = math.deg(theta) - 100,
		})
	})
end

return Rocket