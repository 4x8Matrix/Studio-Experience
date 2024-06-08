local HttpService = game:GetService("HttpService")

local PluginStore = require(script.Parent.PluginStore)

local UPDATE_PERSISTENCE_EVERY = 10
local OUTDATED_TIMESTAMP_TIME = 60

local TimeTracker = {}

TimeTracker.Timestamp = workspace:GetServerTimeNow()
TimeTracker.Uuid = string.upper(HttpService:GenerateGUID(false))

TimeTracker.QueuedThread = newproxy() :: thread

function TimeTracker._ExpirePersistence(self: TimeTracker)
	local liveSessions = PluginStore:GetKey("StudioSessions")

	liveSessions[self.Uuid] = {
		StartedTimestamp = self.Timestamp,
		UpdatedTimestamp = workspace:GetServerTimeNow(),
		
		PlaceId = game.PlaceId,
		PlaceName = game.Name,

		Expired = true,
	}

	PluginStore:SetKey("StudioSessions", liveSessions)
end

function TimeTracker._UpdatePersistence(self: TimeTracker)
	local liveSessions = PluginStore:GetKey("StudioSessions")

	liveSessions[self.Uuid] = {
		StartedTimestamp = self.Timestamp,
		UpdatedTimestamp = workspace:GetServerTimeNow(),
		
		PlaceId = game.PlaceId,
		PlaceName = game.Name,

		Expired = false
	}

	PluginStore:SetKey("StudioSessions", liveSessions)
	
	self:_QueueUpdatePersistence(UPDATE_PERSISTENCE_EVERY)
end

function TimeTracker._QueueUpdatePersistence(self: TimeTracker, delay: number)
	self.QueuedThread = task.delay(delay, function()
		self:_UpdatePersistence()
	end)
end

function TimeTracker.GetTotalSessionsForThisPlace(self: TimeTracker)
	local liveStudios = PluginStore:GetKey("StudioSessions")
	local liveStudioCount = 0

	for _, studioData in liveStudios do
		if studioData.PlaceId ~= game.PlaceId then
			continue
		end

		liveStudioCount += 1
	end

	return liveStudioCount
end

function TimeTracker.GetStudioCount(self: TimeTracker)
	local liveStudios = PluginStore:GetKey("StudioSessions")
	local liveStudioCount = 0

	for _ in liveStudios do
		liveStudioCount += 1
	end

	return liveStudioCount
end

function TimeTracker.GetLiveStudioCount(self: TimeTracker)
	local liveStudios = PluginStore:GetKey("StudioSessions")
	local liveStudioCount = 0

	for _, studioData in liveStudios do
		if studioData.Expired then
			continue
		end

		if workspace:GetServerTimeNow() - studioData.UpdatedTimestamp > OUTDATED_TIMESTAMP_TIME then
			continue
		end

		liveStudioCount += 1
	end

	return liveStudioCount
end

function TimeTracker.GetTotalTimeTracked(self: TimeTracker)
	local liveStudios = PluginStore:GetKey("StudioSessions")
	local epochTime = workspace:GetServerTimeNow()
	local totalTimeTracked = 0

	for _, studioData in liveStudios do
		local deltaTime

		if studioData.Expired or workspace:GetServerTimeNow() - studioData.UpdatedTimestamp > OUTDATED_TIMESTAMP_TIME then
			deltaTime = studioData.UpdatedTimestamp - studioData.StartedTimestamp
		else
			deltaTime = epochTime - studioData.StartedTimestamp
		end

		totalTimeTracked += deltaTime
	end

	return totalTimeTracked
end

function TimeTracker.GetSessionTimeTracked(self: TimeTracker)
	return workspace:GetServerTimeNow() - self.Timestamp
end

function TimeTracker.OnStart(self: TimeTracker)
	self:_UpdatePersistence()
end

function TimeTracker.OnStop(self: TimeTracker)
	task.cancel(self.QueuedThread)

	self:_ExpirePersistence()
end

export type TimeTracker = typeof(TimeTracker)

return TimeTracker