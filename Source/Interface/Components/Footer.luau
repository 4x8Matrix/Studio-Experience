local React = require(script.Parent.Parent.Parent.Packages.React)

local ReactSpring = require(script.Parent.Parent.Parent.Packages.ReactSpring)

local Label = require(script.Parent.Label)

local MAX_ROTATION_FORCE = 5

local function Footer(properties: {
	textContent: string,
})
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
		Size = UDim2.fromScale(1, 0.1),
		BackgroundTransparency = 1,

		LayoutOrder = 3,
	}, {
		ImageLabel = React.createElement(Label, {
			Text = properties.textContent,
			TextScaled = true,

			Rotation = animationHook.progress:map(function(value)
				return value * MAX_ROTATION_FORCE
			end),

			[React.Event.MouseEnter] = animateTextLabel,
			[React.Event.MouseLeave] = unanimateTextLabel,
		})
	})
end

return Footer