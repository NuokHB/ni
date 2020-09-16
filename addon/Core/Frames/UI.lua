local CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo,
	UIParent,
	GetSpellInfo =
	CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo,
	UIParent,
	GetSpellInfo

ni.frames.notification = CreateFrame("Frame", nil, ChatFrame1)
ni.frames.notification:SetSize(ChatFrame1:GetWidth(), 30)
ni.frames.notification:Hide()
ni.frames.notification:SetPoint("TOP", 0, 0)
ni.frames.notification.text = ni.frames.notification:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.notification.text:SetAllPoints()
ni.frames.notification.texture = ni.frames.notification:CreateTexture()
ni.frames.notification.texture:SetAllPoints()
ni.frames.notification.texture:SetTexture(0, 0, 0, .50)
function ni.frames.notification:message(message)
	self.text:SetText(message)
	self:Show()
end

ni.frames.spellqueueholder = CreateFrame("Frame")
ni.frames.spellqueueholder:ClearAllPoints()
ni.frames.spellqueueholder:SetHeight(30)
ni.frames.spellqueueholder:SetWidth(275)
ni.frames.spellqueueholder:SetMovable(true)
ni.frames.spellqueueholder:EnableMouse(true)
ni.frames.spellqueueholder:RegisterForDrag("LeftButton")
ni.frames.spellqueueholder:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	}
)
ni.frames.spellqueueholder:SetBackdropColor(0, 0, 0, 1)
ni.frames.spellqueueholder:SetPoint("CENTER", UIParent, "BOTTOM", 0, 130)
ni.frames.spellqueueholder:Hide()

ni.frames.spellqueue = CreateFrame("Frame", nil, ni.frames.spellqueueholder)
ni.frames.spellqueue:ClearAllPoints()
ni.frames.spellqueue:SetHeight(20)
ni.frames.spellqueue:SetWidth(200)
ni.frames.spellqueue:Show()
ni.frames.spellqueue.text = ni.frames.spellqueue:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
ni.frames.spellqueue.text:SetAllPoints()
ni.frames.spellqueue.text:SetJustifyV("MIDDLE")
ni.frames.spellqueue.text:SetJustifyH("CENTER")
ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
ni.frames.spellqueue:SetPoint("CENTER", ni.frames.spellqueueholder, 0, 0)
function ni.frames.spellqueue.update(str, bool)
	bool = true and bool or false
	if bool then
		if ni.frames.spellqueueholder:IsShown() == nil then
			ni.frames.spellqueueholder:Show()
		end
		ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615" .. GetSpellInfo(str))
	else
		ni.frames.spellqueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
		if ni.frames.spellqueueholder:IsShown() == 1 then
			ni.frames.spellqueueholder:Hide()
		end
	end
end

ni.frames.floatingtext = CreateFrame("Frame")
ni.frames.floatingtext:SetSize(400, 30)
ni.frames.floatingtext:SetAlpha(0)
ni.frames.floatingtext:SetPoint("CENTER", 0, 80)
ni.frames.floatingtext.text = ni.frames.floatingtext:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.floatingtext.text:SetAllPoints()
ni.frames.floatingtext.texture = ni.frames.floatingtext:CreateTexture()
ni.frames.floatingtext.texture:SetAllPoints()
function ni.frames.floatingtext:message(message)
	self.text:SetText(message)
	UIFrameFadeOut(self, 2.5, 1, 0)
end

ni.showstatus = function(str, enabled)
	if enabled then
		ni.frames.floatingtext:message("\124cff00ff00" .. str)
	else
		ni.frames.floatingtext:message("\124cffff0000" .. str)
	end
end

ni.toggleprofile = function(str)
	local unload = false;
	if ni.vars.profiles.active == str then
		ni.vars.profiles.enabled = not ni.vars.profiles.enabled;
		if ni.vars.profiles.enabled == false then
			unload = true;
		end
	else
		unload = true;
		ni.vars.profiles.enabled = true;
		ni.vars.profiles.active = str;
	end
	if unload then
		if ni.rotation.profile[ni.rotation.lastprofile] then
			if ni.rotation.profile[ni.rotation.lastprofile].unload then
				ni.rotation.profile[ni.rotation.lastprofile]:unload();
			end
			if ni.rotation.profile[ni.rotation.lastprofile].destroyGUI then
				ni.rotation.profile[ni.rotation.lastprofile]:destroyGUI();
			end
		end
	end
	if ni.vars.profiles.enabled then
		if ni.rotation.profile[str] then
			if ni.rotation.profile[str].load then
				ni.rotation.profile[str]:load();
			end
			if ni.rotation.profile[str].createGUI then
				ni.rotation.profile[str]:createGUI();
			end
		end
	end
	if ni.rotation.lastprofile ~= str then
		ni.rotation.lastprofile = str;
	end
	ni.showstatus(str, ni.vars.profiles.enabled);
end

ni.togglegeneric = function(str)
	local unload = false;
	if ni.vars.profiles.generic == str then
		ni.vars.profiles.genericenabled = not ni.vars.profiles.genericenabled;
		if ni.vars.profiles.genericenabled == false then
			unload = true;
		end
	else
		unload = true;
		ni.vars.profiles.genericenabled = true;
		ni.vars.profiles.generic = str;
	end
	if unload then
		if ni.rotation.profile[ni.rotation.lastgeneric] then
			if ni.rotation.profile[ni.rotation.lastgeneric].unload then
				ni.rotation.profile[ni.rotation.lastgeneric]:unload();
			end
			if ni.rotation.profile[ni.rotation.lastgeneric].destroyGUI then
				ni.rotation.profile[ni.rotation.lastgeneric]:destroyGUI();
			end
		end
	end
	if ni.vars.profiles.genericenabled then
		if ni.rotation.profile[str] then
			if ni.rotation.profile[str].load then
				ni.rotation.profile[str]:load();
			end
			if ni.rotation.profile[str].createGUI then
				ni.rotation.profile[str]:createGUI();
			end
		end
	end
	if ni.rotation.lastgeneric ~= str then
		ni.rotation.lastgeneric = str;
	end
	ni.showstatus(str, ni.vars.profiles.genericenabled);
end

ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.frames.floatingtext:message("Interrupts: \124cff00ff00Enabled")
	else
		ni.frames.floatingtext:message("Interrupts: \124cffff0000Disabled")
	end
end

ni.updatefollow = function(enabled)
	if enabled then
		ni.frames.floatingtext:message("Auto follow: \124cff00ff00Enabled")
	else
		ni.frames.floatingtext:message("Auto follow: \124cffff0000Disabled")
	end
end

ni.getspellidfromactionbar = function()
	local focus = GetMouseFocus():GetName()
	if string.match(focus, "Button") then
		local button = _G[focus]
		local slot =
			ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0
		if HasAction(slot) then
			local aType, aID, _, aMaxID = GetActionInfo(slot)
			if aType == "spell" then
				return aMaxID ~= nil and aMaxID or aID
			end
		end
	end
end
