local ni = ...

ni.profile = {}

function ni.profile.new(name, queue, abilities, ui)
   local profile = {}
   profile.loaded = true
   profile.name = name
	function profile.execute(self)
		local temp_queue;
		if type(queue) == "function" then
			temp_queue = queue()
		else
			temp_queue = queue;
		end
		for i = 1, #temp_queue do
			local abilityinqueue = temp_queue[i]
			if abilities[abilityinqueue] ~= nil and abilities[abilityinqueue]() then
				break
			end
		end
	end
   profile.ui = ui or {}
   ni.profile[name] = profile
end

