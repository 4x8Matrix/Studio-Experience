local React = require(script.Parent.Parent.Parent.Packages.React)
local Sift = require(script.Parent.Parent.Parent.Packages.Sift)

local Context = require(script.Parent.Parent.Parent.Context)

local function Label(properties: { [any]: any })
	local theme: StudioTheme = Context:getTheme()

	return React.createElement("TextLabel", Sift.Dictionary.merge({
		FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic),
		RichText = true,
		TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonText),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, properties))
end

return Label