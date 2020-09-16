local GetSpellInfo, UnitCastingInfo = GetSpellInfo, UnitCastingInfo

ni.stopcastingtracker = {
	shouldstop = function(spell)
		local spellcasttime = ni.spell.casttime(spell)
		local bosscast, _, _, _, bosscastend = UnitCastingInfo("boss1")
		local mycasttime, _, _, _, mycastend = UnitCastingInfo("player")

		if bosscast == nil or ni.spell.isinstant(spell) then
			return false
		end

		if mycasttime ~= nil then
			mycastend = spellcasttime
		end

		for i = 1, #ni.tables.stopcasting.continue do
			local buff = ni.tables.stopcasting.continue[i]

			if ni.player.buff(buff) and ni.player.buffremaining(buff) + 0.1 > bosscastend then
				return false
			end
		end

		if not ni.player.iscasting() and not ni.player.ischanneling() and spellcasttime and spellcasttime > bosscastend then
			return true
		end

		for i = 1, #ni.tables.stopcasting.stop do
			local casting = ni.tables.stopcasting.stop[i]

			if bosscast == select(1, GetSpellInfo(casting)) then
				if mycastend ~= nil and mycastend > bosscastend then
					return true
				end
			end
		end
	end
}
