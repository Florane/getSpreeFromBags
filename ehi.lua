Hooks:PostHook(EHI,"IsLootCounterVisible","IsLootCounterVisibleSpree",function(self)
	return self:GetTrackerOrWaypointOption("show_loot_counter", "show_waypoints_loot_counter")
end)
Hooks:PostHook(EHI,"IsSyncedLootCounterVisible","IsSyncedLootCounterVisibleSpree",function(self)
	return self.IsHost
end)
Hooks:PostHook(EHI.TrackerUtils,"IsLootCounterVisible","TrackerIsLootCounterVisibleSpree",function(self)
	if self.super:IsLootCounterVisible() and managers.job:get_memory("EHI_SavedLoot") and not Hooks:GetReturn() then
		return managers.job:get_memory("EHI_SavedLoot") > 0
	end
	return true
end)
