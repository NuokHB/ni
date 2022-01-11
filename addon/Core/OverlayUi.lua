local ni = ...
local OverlayUi = {}
local UnitName = ni.backend.GetFunction("UnitName")
local Localization = {
	Assistant = "Rotation Assistant",
	Primary = "Select your primary rotation:",
	Secondary = "Select your secondary rotation:",
	Generic = "Select your generic rotation:",
	None = "None",
	Resource = "Resource Tracking Toggles",
	All = "All",
	Reload = "Reload after changing",
	Global = "toggle or global",
	GUI = "GUI Toggle:",
	PrimaryKey = "Primary Toggle:",
	SecondaryKey = "Secondary Toggle:",
	GenericToggle = "Generic Toggle:",
	Interrupt = "Interrupt Toggle:",
	Follow = "Follow Unit & Toggle:",
	GlobalDev = "Global variable:",
	Dev = "Dev Tools:",
	ReloadDev = "Reload",
	Console = "Console",
	Contact = "Contact:",
	Rotation = "Rotation Settings",
	MainSettings = "Main Settings",
	ResourceTrack = "Resource Tracking",
	CreatureTrack = "Creature Tracking",
	Close = "Close",
	Lockpicking = "Lockpicking",
	Herbs = "Herbs",
	Minerals = "Minerals",
	DisarmTrap = "Disarm Trap",
	Open = "Open",
	Treasure = "Treasure",
	CloseTrack = "Close",
	ArmTrap = "Arm Trap",
	QuickOpen = "Quick Open",
	CalcifiedElvenGems = "Calcified Elven Gems",
	QuickClose = "Quick Close",
	OpenTinkering = "Open Tinkering",
	OpenKneeling = "Open Kneeling",
	OpenAttacking = "Open Attacking",
	Gahzridian = "Gahzridian",
	Blasting = "Blasting",
	PvPOpen = "PvP Open",
	PvPClose = "PvP Close",
	Fishing = "Fishing",
	Inscription = "Inscription",
	OpenFromVehicle = "Open From Vehicle",
	CreatureTrackingToggles = "Creature Tracking Toggles",
	Beasts = "Beasts",
	Dragons = "Dragons",
	Demons = "Demons",
	Elementals = "Elementals",
	Giants = "Giants",
	Undead = "Undead",
	Humanoids = "Humanoids",
	Critters = "Critters",
	Machines = "Machines",
	Slimes = "Uncategorized",
	Totem = "Totem",
	NonCombatPet = "Non Combat Pet",
	GasCloud = "Gas Cloud",
	Latency = "Latency (" .. ni.vars.latency .. " ms)",
	AreaofEffectToggle = "Area of Effect Toggle:",
	PauseRotationModifier = "Pause Rotation Modifier:",
	CDToggle = "CD Toggle:",
	CustomToggle = "Custom Toggle:",
	MainTankOverride = "Main Tank Override:",
	Enabled = "Enabled:",
	OffTankOverride = "Off Tank Override:",
	IsMelee = "Is Melee:"
}
if (GetLocale() == "ruRU") then
	Localization.Assistant = "Помощник для Ротации"
	Localization.Primary = "Выберите свою основную ротацию:"
	Localization.Secondary = "Выберите второстепенную ротацию:"
	Localization.Generic = "Выберите свою общую ротацию:"
	Localization.None = "Нету"
	Localization.Resource = "Отслеживания ресурсов"
	Localization.All = "Всех"
	Localization.Reload = "Перезагрузитe после изменения"
	Localization.Global = "кнопки или глобальной"
	Localization.GUI = "Кнопка меню:"
	Localization.PrimaryKey = "Кнопка для основной:"
	Localization.SecondaryKey = "Кнопка для второстепенной:"
	Localization.Generic = "Кнопка для общей:"
	Localization.Interrupt = "Кнопка для прерывания:"
	Localization.Follow = "Авто-Следование и кнопка:"
	Localization.GlobalDev = "Глобальная переменная:"
	Localization.Dev = "Опции разработчика:"
	Localization.ReloadDev = "Перезагрузка"
	Localization.Console = "Консоль"
	Localization.Contact = "Контакты:"
	Localization.Rotation = "Настройки Ротаций"
	Localization.MainSettings = "Настройки"
	Localization.ResourceTrack = "Поиск Ресурсов"
	Localization.CreatureTrack = "Поиск НПЦ"
	Localization.Close = "Закрыть"
	Localization.Lockpicking = "Вскрытие замков"
	Localization.Herbs = "Травы"
	Localization.Minerals = "Минералы"
	Localization.DisarmTrap = "Обезв. Ловушки"
	Localization.Open = "Открываемые"
	Localization.Treasure = "Сокровища"
	Localization.CloseTrack = "Закрытые"
	Localization.ArmTrap = "Заряж. Ловушки"
	Localization.QuickOpen = "Быстрое открытие"
	Localization.CalcifiedElvenGems = "Эльфийский камень"
	Localization.QuickClose = "Быстрое закрытие"
	Localization.OpenTinkering = "Откр. ремеслом"
	Localization.OpenKneeling = "Открытие /kneel"
	Localization.OpenAttacking = "Открытие атакой"
	Localization.Gahzridian = "Газ'рилл"
	Localization.Blasting = "Взрываемое"
	Localization.PvPOpen = "Открытие в PvP"
	Localization.PvPClose = "Закрытие в PvP"
	Localization.Fishing = "Рыбная ловля"
	Localization.Inscription = "Начертание"
	Localization.OpenFromVehicle = "Открытие с транс."
	Localization.CreatureTrackingToggles = "Поиск НПЦ"
	Localization.Beasts = "Звери"
	Localization.Dragons = "Драконы"
	Localization.Demons = "Демоны"
	Localization.Elementals = "Элементали"
	Localization.Giants = "Великаны"
	Localization.Undead = "Нежить"
	Localization.Humanoids = "Гуманоиды"
	Localization.Critters = "Существа"
	Localization.Machines = "Механизмы"
	Localization.Slimes = "Разное"
	Localization.Totem = "Тотемы"
	Localization.NonCombatPet = "Спутник"
	Localization.GasCloud = "Облако газа"
	Localization.Latency = "Задержка (" .. ni.vars.latency .. " мс)"
	Localization.AreaofEffectToggle = "Кнопка включения АоЕ:"
	Localization.PauseRotationModifier = "Кнопка для паузы ротации:"
	Localization.CDToggle = "Кнопка включения КД:"
	Localization.CustomToggle = "Настраиваемая Кнопка:"
	Localization.MainTankOverride = "Имя главного танка:"
	Localization.Enabled = "Включить:"
	Localization.OffTankOverride = "Имя второго танка:"
	Localization.IsMelee = "Ближний бой:"
end
OverlayUi.window = ni.ui.new("Window", "ni", false)
local label = ni.ui.new("Label", OverlayUi.window)
label.Text = "Test"
local tabselector = ni.ui.new("TabSelector", OverlayUi.window)
--#region profile selection
local mainTab = tabselector:AddTab(Localization.MainSettings)
local combobox = ni.ui.new("ComboBox", mainTab)
combobox.Text = "Profiles"
combobox.Callback = function(selected)
	ni.vars.profiles.primary = selected
	for k, v in ipairs(ni.profiles) do
		if selected == v.title then
			print("Selected ".. selected)
			ni.vars.profiles.primaryidx = k
			local f, e = ni.backend.LoadFile(v.path)
			if error then
				ni.backend.Error(error, v.title)
			end
			return f(ni)
		end
	end
	ni.utils.savesetting(UnitName("player") .. ".json", ni.utils.json.encode(ni.vars))
end
for k, v in ipairs(ni.profiles) do
	if v.version == 0 or v.version == ni.vars.build then
		combobox:Add(v.title)
	end
end
local loadButton = ni.ui.new("Button", mainTab)
loadButton.Text = "Start"
loadButton.Callback = function()
	if ni.vars.profiles.primary ~= "None" and ni.vars.profiles.primaryidx ~= 0 then
		ni.toggleprofile(ni.vars.profiles.primary);
	end
end

--Resource tracking menu
local resourcetab = tabselector:AddTab(Localization.ResourceTrack)
local bitwise = {}
function bitwise.hasbit(x, p)
	return x % (p + p) >= p
end
function bitwise.setbit(x, p)
	return bitwise.hasbit(x, p) and x or x + p
end
function bitwise.clearbit(x, p)
	return bitwise.hasbit(x, p) and x - p or x
end
local currentresources = 0
local boxes = {
	resource_lockpicking = {bit = 0x1},
	resource_herbs = {bit = 0x2},
	resource_minerals = {bit = 0x4},
	resource_disarmtrap = {bit = 0x8},
	resource_open = {bit = 0x10},
	resource_treasure = {bit = 0x20},
	resource_calcifiedelvengems = {bit = 0x40},
	resource_close = {bit = 0x80},
	resource_armtrap = {bit = 0x100},
	resource_quickopen = {bit = 0x200},
	resource_quickclose = {bit = 0x400},
	resource_opentinkering = {bit = 0x800},
	resource_openkneeling = {bit = 0x1000},
	resource_openattacking = {bit = 0x2000},
	resource_gahzridian = {bit = 0x4000},
	resource_blasting = {bit = 0x8000},
	resource_pvpopen = {bit = 0x10000},
	resource_pvpclose = {bit = 0x20000},
	resource_fishing = {bit = 0x40000},
	resource_inscription = {bit = 0x80000},
	resource_openfromvehicle = {bit = 0x100000}
}
local function update_boxes(c_bit)
	for k, v in pairs(boxes) do
		if c_bit == -1 and v.bit ~= 0 then
			v.box.Checked = true
			currentresources = bitwise.setbit(currentresources, v.bit)
		elseif c_bit == 0 and v.bit == 0 then
			v.box.Checked = true
			currentresources = bitwise.setbit(currentresources, v.bit)
		elseif v.value ~= -1 and bitwise.hasbit(c_bit, v.bit) then
			v.box.Checked = true
			currentresources = bitwise.setbit(currentresources, v.bit)
		else
			v.box.Checked = false
			currentresources = bitwise.clearbit(currentresources, v.bit)
		end
	end
	ni.backend.SetResourceTracking(c_bit)
end
local function AddCheckBox(tab, text, value)
	local rb = ni.ui.new("Checkbox", tab)
	rb.Text = text
	rb.Callback = function(checked)
		if checked then
			currentresources = bitwise.setbit(currentresources, value)
		else
			currentresources = bitwise.clearbit(currentresources, value)
		end
		update_boxes(currentresources)
	end
	return rb
end
boxes.resource_lockpicking.box = AddCheckBox(resourcetab, Localization.Lockpicking, boxes.resource_lockpicking.bit)
boxes.resource_herbs.box = AddCheckBox(resourcetab, Localization.Herbs, boxes.resource_herbs.bit)
boxes.resource_minerals.box = AddCheckBox(resourcetab, Localization.Minerals, boxes.resource_minerals.bit)
boxes.resource_disarmtrap.box = AddCheckBox(resourcetab, Localization.DisarmTrap, boxes.resource_disarmtrap.bit)
boxes.resource_open.box = AddCheckBox(resourcetab, Localization.Open, boxes.resource_open.bit)
boxes.resource_treasure.box = AddCheckBox(resourcetab, Localization.Treasure, boxes.resource_treasure.bit)
boxes.resource_close.box = AddCheckBox(resourcetab, Localization.Close, boxes.resource_close.bit)
boxes.resource_armtrap.box = AddCheckBox(resourcetab, Localization.ArmTrap, boxes.resource_armtrap.bit)
boxes.resource_quickopen.box = AddCheckBox(resourcetab, Localization.QuickOpen, boxes.resource_quickopen.bit)
boxes.resource_calcifiedelvengems.box =
	AddCheckBox(resourcetab, Localization.CalcifiedElvenGems, boxes.resource_calcifiedelvengems.bit)
boxes.resource_quickclose.box = AddCheckBox(resourcetab, Localization.QuickClose, boxes.resource_quickclose.bit)
boxes.resource_opentinkering.box =
	AddCheckBox(resourcetab, Localization.OpenTinkering, boxes.resource_opentinkering.bit)
boxes.resource_openkneeling.box = AddCheckBox(resourcetab, Localization.OpenKneeling, boxes.resource_openkneeling.bit)
boxes.resource_openattacking.box =
	AddCheckBox(resourcetab, Localization.OpenAttacking, boxes.resource_openattacking.bit)
boxes.resource_gahzridian.box = AddCheckBox(resourcetab, Localization.Gahzridian, boxes.resource_gahzridian.bit)
boxes.resource_blasting.box = AddCheckBox(resourcetab, Localization.Blasting, boxes.resource_blasting.bit)
boxes.resource_pvpopen.box = AddCheckBox(resourcetab, Localization.PvPOpen, boxes.resource_pvpopen.bit)
boxes.resource_pvpclose.box = AddCheckBox(resourcetab, Localization.PvPClose, boxes.resource_pvpclose.bit)
boxes.resource_fishing.box = AddCheckBox(resourcetab, Localization.Fishing, boxes.resource_fishing.bit)
boxes.resource_inscription.box = AddCheckBox(resourcetab, Localization.Inscription, boxes.resource_inscription.bit)
boxes.resource_openfromvehicle.box =
	AddCheckBox(resourcetab, Localization.OpenFromVehicle, boxes.resource_openfromvehicle.bit)

--Creature tracking menu
local creaturetab = tabselector:AddTab(Localization.CreatureTrack)
local currentcreatures = 0
local cboxes = {
	beasts = {bit = 0x1},
	dragons = {bit = 0x2},
	demons = {bit = 0x4},
	elementals = {bit = 0x8},
	giants = {bit = 0x10},
	undead = {bit = 0x20},
	humanoids = {bit = 0x40},
	critters = {bit = 0x80},
	machines = {bit = 0x100},
	slimes = {bit = 0x200},
	totem = {bit = 0x400},
	noncombatpet = {bit = 0x800},
	gascloud = {bit = 0x1000}
}
local function update_cboxes(c_bit)
	for k, v in pairs(cboxes) do
		if c_bit == -1 and v.bit ~= 0 then
			v.box.Checked = true
			currentcreatures = bitwise.setbit(currentcreatures, v.bit)
		elseif c_bit == 0 and v.bit == 0 then
			v.box.Checked = true
			currentcreatures = bitwise.setbit(currentcreatures, v.bit)
		elseif v.value ~= -1 and bitwise.hasbit(c_bit, v.bit) then
			v.box.Checked = true
			currentcreatures = bitwise.setbit(currentcreatures, v.bit)
		else
			v.box.Checked = false
			currentcreatures = bitwise.clearbit(currentcreatures, v.bit)
		end
	end
	ni.backend.SetCreatureTracking(c_bit)
end
local function AddCCheckBox(tab, text, value)
	local b = ni.ui.new("Checkbox", tab)
	b.Text = text
	b.Checked = bitwise.hasbit(currentcreatures, value)
	b.Callback = function(checked)
		if checked then
			currentcreatures = bitwise.setbit(currentcreatures, value)
		else
			currentcreatures = bitwise.clearbit(currentcreatures, value)
		end
		update_cboxes(currentcreatures)
	end
	return b
end

cboxes.beasts.box = AddCCheckBox(creaturetab, Localization.Beasts, cboxes.beasts.bit)
cboxes.critters.box = AddCCheckBox(creaturetab, Localization.Critters, cboxes.critters.bit)
cboxes.demons.box = AddCCheckBox(creaturetab, Localization.Demons, cboxes.demons.bit)
cboxes.dragons.box = AddCCheckBox(creaturetab, Localization.Dragons, cboxes.dragons.bit)
cboxes.elementals.box = AddCCheckBox(creaturetab, Localization.Elementals, cboxes.elementals.bit)
cboxes.gascloud.box = AddCCheckBox(creaturetab, Localization.GasCloud, cboxes.gascloud.bit)
cboxes.giants.box = AddCCheckBox(creaturetab, Localization.Giants, cboxes.giants.bit)
cboxes.humanoids.box = AddCCheckBox(creaturetab, Localization.Humanoids, cboxes.humanoids.bit)
cboxes.machines.box = AddCCheckBox(creaturetab, Localization.Machines, cboxes.machines.bit)
cboxes.noncombatpet.box = AddCCheckBox(creaturetab, Localization.NonCombatPet, cboxes.noncombatpet.bit)
cboxes.slimes.box = AddCCheckBox(creaturetab, Localization.Slimes, cboxes.slimes.bit)
cboxes.totem.box = AddCCheckBox(creaturetab, Localization.Totem, cboxes.totem.bit)
cboxes.undead.box = AddCCheckBox(creaturetab, Localization.Undead, cboxes.undead.bit)

return OverlayUi
