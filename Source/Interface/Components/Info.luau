local React = require(script.Parent.Parent.Parent.Packages.React)

local Label = require(script.Parent.Label)

local ID_MAP_MATRIX = {
	[1] = {
		Position = UDim2.fromScale(-0.25, 0.25),
		Rotation = 10
	},
	[2] = {
		Position = UDim2.fromScale(-0.285, 0.5),
		Rotation = 0
	},
	[3] = {
		Position = UDim2.fromScale(-0.25, 0.75),
		Rotation = -10
	},
	[4] = {
		Position = UDim2.fromScale(1.25, 0.25),
		Rotation = -10
	},
	[5] = {
		Position = UDim2.fromScale(1.285, 0.5),
		Rotation = 0
	},
	[6] = {
		Position = UDim2.fromScale(1.254, 0.75),
		Rotation = 10
	}
}

local function lerp(a, b, v)
	return (a + (b - a) * v);
end

local function Info(properties: {
	scaleHook: any,

	labels: { string }
})
	local textLabelComponents = {}

	for labelId, labelName in properties.labels do
		table.insert(textLabelComponents, React.createElement(Label, {
			Text = labelName,
			TextScaled = true,
			Size = UDim2.fromScale(0.75, 0.2),
			Position = ID_MAP_MATRIX[labelId].Position,
			Rotation = ID_MAP_MATRIX[labelId].Rotation,

			TextSize = properties.scaleHook:map(function(value: number)
				return lerp(0, 15, value)
			end),
		}))
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,

		ZIndex = 0,

		Size = properties.scaleHook:map(function(value: number)
			local scale = lerp(0, 1, value)

			return UDim2.fromScale(scale, scale)
		end),

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, {
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}), 

		TextLebels = React.createElement(React.Fragment, nil, table.unpack(textLabelComponents))
	})
end

return Info