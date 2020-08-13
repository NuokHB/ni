local CreateFrame, unpack, tremove, tinsert = CreateFrame, unpack, tremove, tinsert

ni.frames.delay = CreateFrame("Frame")
ni.frames.delay_OnUpdate = function(self, elapsed)
	for k, v in pairs(ni.delays) do
		if k <= GetTime() then
			v();
			ni.delays[k] = nil;
		end
	end
end

ni.delayfor = function(delay, callback)
	if type(delay) ~= "number" or type(callback) ~= "function" then
		return false
	end
	ni.delays[GetTime() + delay] = callback;
	return true
end
