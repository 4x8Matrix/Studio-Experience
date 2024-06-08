local HttpService = game:GetService("HttpService")

local Context = require(script.Parent.Parent.Context)

local LOCAL_STORE_NAME = "StudioXP-LocalStore-v5"

local PluginStore = {}

PluginStore.Plugin = newproxy() :: Plugin
PluginStore.Data = {
	StudioSessions = { } :: {
		[string]: {
			StartedTimestamp: number,
			UpdatedTimestamp: number,

			PlaceId: number,
			PlaceName: string,
		}
	},
	DeadSessions = { } :: {
		[string]: {
			PlaceId: number,
			PlaceName: string,
		}
	},
}

function PluginStore.Save(self: PluginStore)
	local storeData = HttpService:JSONEncode(self.Data)

	Context:getPlugin():SetSetting(LOCAL_STORE_NAME, storeData)
end

function PluginStore.Load(self: PluginStore)
	local localStoreData = Context:getPlugin():GetSetting(LOCAL_STORE_NAME)

	if localStoreData then
		self.Data = HttpService:JSONDecode(localStoreData)
	else
		self:Save()
	end
end

function PluginStore.GetKey(self: PluginStore, path: string)
	self:Load()

	local base = self.Data
	local split = string.split(path, ".")

	for _, index_name in split do
		base = base[index_name]

		if not base then
			return nil
		end
	end

	return base
end

function PluginStore.SetKey(self: PluginStore, path: string, value: any)
	local base = self.Data
	local split = string.split(path, ".")

	for index, index_name in split do
		if index == #split then
			continue
		end

		base = base[index_name]
	end

	base[split[#split]] = value

	self:Save()
end

export type PluginStore = typeof(PluginStore)

return PluginStore