local React = require(script.Parent.Parent.Parent.Packages.React)

local Label = require(script.Parent.Label)

local BASE_LEVEL = 10
local BASE_LEVEL_MULTIPLIER = 1.5

local BASE_IMAGE_ID = "http://www.roblox.com/asset/?id=17757579693"

local LEVEL_METADATA = {
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 2), Url = "http://www.roblox.com/asset/?id=17757580418", Color = Color3.fromHex("#00c0fd") },
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 4), Url = "http://www.roblox.com/asset/?id=17757581108", Color = Color3.fromHex("#dcf7ff") },
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 6), Url = "http://www.roblox.com/asset/?id=17757581879", Color = Color3.fromHex("#ff6767") },
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 8), Url = "http://www.roblox.com/asset/?id=17757582434", Color = Color3.fromHex("#bd6cff") },
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 10), Url = "http://www.roblox.com/asset/?id=17757583960", Color = Color3.fromHex("#fdb804") },
	{ Score = BASE_LEVEL * (BASE_LEVEL_MULTIPLIER * 100), Url = "http://www.roblox.com/asset/?id=17757585082", Color = Color3.fromHex("#00c0fd") }
}

local function getPropertyForLevel(level: number, property: string)
	local targetValue = LEVEL_METADATA[#LEVEL_METADATA][property]

	for _, object in LEVEL_METADATA do
		if level < object.Score then
			targetValue = object[property]

			break
		end
	end

	return targetValue
end

local function lerp(a, b, v)
	return (a + (b - a) * v);
end

local function Badge(properties: {
	developerLevel: number,
	developerLevelPercent: number,

	scaleHook: any,

	onShowStatsCallback: () -> (),
	onHideStatsCallback: () -> ()
})
	local image = getPropertyForLevel(properties.developerLevel, "Url")
	local color = getPropertyForLevel(properties.developerLevel, "Color")

	local keypoints = {}

	table.insert(keypoints, ColorSequenceKeypoint.new(0, color))

	if properties.developerLevelPercent - 0.001 > 0 then
		table.insert(keypoints, ColorSequenceKeypoint.new(properties.developerLevelPercent - 0.001, color))
	end

	if properties.developerLevelPercent + 0.05 < 1 then
		table.insert(keypoints, ColorSequenceKeypoint.new(properties.developerLevelPercent + 0.05, Color3.new(0, 0, 0)))
	end

	table.insert(keypoints, ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)))

	return React.createElement("Frame", {
		BackgroundTransparency = 1,

		Size = properties.scaleHook:map(function(value: number)
			local offset = lerp(0, 0.2, value)

			return UDim2.fromScale(1 - offset, 1 - offset)
		end),

		ZIndex = 1,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		[React.Event.MouseEnter] = properties.onShowStatsCallback,
		[React.Event.MouseLeave] = properties.onHideStatsCallback,
	}, {
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}), 

		BackgroundBadgeIcon = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = BASE_IMAGE_ID,
			ResampleMode = Enum.ResamplerMode.Pixelated,
			ZIndex = 0
		}),

		LabelText = React.createElement(Label, {
			Text = properties.developerLevel,
			Size = UDim2.fromScale(0.6, 0.6),
			Position = UDim2.fromScale(0.48, 0.45),
			ZIndex = 1,
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}, {
			Gradient = React.createElement("UIGradient", {
				Color = ColorSequence.new(keypoints),
				Rotation = -15,
			}),
		}),

		LevelBadgeIcon = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = image,
			ResampleMode = Enum.ResamplerMode.Pixelated,
			ZIndex = 2
		}),
	})
end

return Badge