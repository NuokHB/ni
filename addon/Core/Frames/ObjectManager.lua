local GetFramerate, CreateFrame, rawset = GetFramerate, CreateFrame, rawset

ni.frames.objectmanager = CreateFrame("frame")
ni.frames.objectmanager_OnUpdate = function(self, elapsed)
	if ni.objects ~= nil and ni.functions.getfunction("getobjects") ~= "nil" then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			local tmp = ni.objectmanager.get() or {};
			for i = 1, #tmp do
				local ob = ni.objects:new(tmp[i].guid, tmp[i].type, tmp[i].name)
				if ob then
					rawset(ni.objects, tmp[i].guid, ob)
				end
			end
			ni.objects:updateobjects()
		end
	end
end
