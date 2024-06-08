local React = require(script.Parent.Parent.Packages.React)
local ReactSpring = require(script.Parent.Parent.Packages.ReactSpring)

local Context = require(script.Parent.Parent.Context)

local Badge = require(script.Parent.Components.Badge)
local Title = require(script.Parent.Components.Title)
local Info = require(script.Parent.Components.Info)
local Footer = require(script.Parent.Components.Footer)

local Rocket = require(script.Parent.Components.Rocket)

local function Interface(properties: {
	developerLevel: number,
	developerLevelPercent: number,

	rocketAnimationEnabled: boolean,
	rocketAnimationCallback: () -> (),

	footerLabel: string,

	stats: { string }
})
	local theme: StudioTheme = Context:getTheme()

	local animationHook, animationApi = ReactSpring.useSpring(function()
		return {
			from = { progress = 0 },
			to = { progress = 0 },
		}
	end)

	local rocketAnimationHook, rocketAnimationApi = ReactSpring.useSpring(function()
		return {
			from = { progress = 0 },
			to = { progress = 0 },
		}
	end)

	if properties.rocketAnimationEnabled then
		rocketAnimationApi.start({
			progress = 1,
	
			config = {
				easing = ReactSpring.easings.linear,
	
				duration = 0.5,
			},
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground, Enum.StudioStyleGuideModifier.Default)
	}, {
		ContentFrame = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			ZIndex = 1,
		}, {
			UIListLaytout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
	
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
	
			Title = React.createElement(Title),
	
			Content = React.createElement("Frame", {
				Size = UDim2.fromScale(0.4, 0.4),
				BackgroundTransparency = 1,
	
				LayoutOrder = 2,
			}, {
				Badge = React.createElement(Badge, {
					developerLevel = properties.developerLevel,
					developerLevelPercent = properties.developerLevelPercent,
	
					scaleHook = animationHook.progress,
	
					onShowStatsCallback = function()
						animationApi.start({
							progress = 1,
					
							config = {
								easing = ReactSpring.easings.easeOutBack,
					
								duration = 0.3,
							},
						})
					end,
					onHideStatsCallback = function()
						animationApi.start({
							progress = 0,
					
							config = {
								easing = ReactSpring.easings.easeOutBack,
					
								duration = 0.3,
							},
						})
					end
				}),
	
				Info = React.createElement(Info, {
					scaleHook = animationHook.progress,
	
					labels = properties.stats
				})
			}),
	
			Footer = React.createElement(Footer, {
				textContent = properties.footerLabel,
			})
		}),
		
		RocketFrame = properties.rocketAnimationEnabled and React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			ZIndex = 2,
		}, {
			Rocket1 = React.createElement(Rocket, {
				rocketAnimationCallback = properties.rocketAnimationCallback,
				rocketAnimationHook = rocketAnimationHook.progress,
			})
		}) or React.None,
	})
end

return Interface