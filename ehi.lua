if not _G.EHI then
	return

	Hooks:PostHook(EHI,"IsPlayingCrimeSpree","IsPlayingCrimeSpreeBagged",function()
		return false
	end)
end

