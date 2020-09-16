local CreateFrame = CreateFrame

ni.frames.members = CreateFrame("frame", nil)
ni.frames.members:RegisterEvent("PARTY_MEMBERS_CHANGED")
ni.frames.members:RegisterEvent("RAID_ROSTER_UPDATE")
ni.frames.members:RegisterEvent("GROUP_ROSTER_UPDATE")
ni.frames.members:RegisterEvent("PARTY_CONVERTED_TO_RAID")
ni.frames.members:RegisterEvent("ZONE_CHANGED")
ni.frames.members:RegisterEvent("PLAYER_ENTERING_WORLD")
ni.frames.members_OnEvent = function()
	ni.members.reset()
end
