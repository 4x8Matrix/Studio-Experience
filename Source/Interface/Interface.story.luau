local React = require(script.Parent.Parent.Packages.React)
local ReactRoblox = require(script.Parent.Parent.Packages.ReactRoblox)

local component = require(script.Parent.Interface)

return function(target)
	local root = ReactRoblox.createRoot(target)

	root:render(React.createElement(component, {
		developerLevel = 200,
		developerLevelPercent = 0.5,
		rocketAnimationEnabled = true,
		footerLabel = "1y, 20d, 10h in\n<bold>this</bold> studio.",
		stats = {
			"Hello, World 0",
			"Hello, World 1",
			"Hello, World 2",
			"Hello, World 3",
			"Hello, World 4",
			"Hello, World 5",
		}
	}))

	return function()
		root:unmount()
	end
end