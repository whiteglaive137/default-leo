-- StepMania 5 Default Theme Preferences Handler
local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end
checkTimingDifficulty = "?"
-- Example usage of new system (not fully implemented yet)
local Prefs =
{
	AutoSetStyle =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowStepsDisplay = 
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowScore =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowLotsaOptions =
	{
		Default = true,
		Choices = { OptionNameString('Many'), OptionNameString('Few') },
		Values = { true, false }
	},
	LongFail =
	{
		Default = false,
		Choices = { OptionNameString('Short'), OptionNameString('Long') },
		Values = { false, true }
	},
	NotePosition =
	{
		Default = true,
		Choices = { OptionNameString('Normal'), OptionNameString('Lower') },
		Values = { true, false }
	},
	ComboOnRolls =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FlashyCombo =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FancyUIBG =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TimingDisplay =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayFooter =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	CountDown =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	
	SkipScreenStageInformation =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	SmallBackground =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	SelectMusicBackground =
	{
		Default = "16:9",
		Choices = { "GameScreen", "4:3(small)" },
		Values = { "16:9", "4:3" }
	},
	ChangeDPBest =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	SimpleProTiming =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	CalculateScore =
	{
		Default = "Addition",
		Choices = { "Addition", "Average" },
		Values = { "Addition", "Average" }
	},
	SimpleMode =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},

	--[[
	ProtimingP1,
	ProtimingP2,

	UserPrefScoringMode = 'DDR Extreme'
	--]]
}
if true then
	local dplist = GetTargetDancePoint()
	for i=1, #dplist do
		Prefs["DefaultTarget"]["Choices"][#Prefs["DefaultTarget"]["Choices"]+1] = "DP" .. dplist[i] .. "%"
		Prefs["DefaultTarget"]["Values"][#Prefs["DefaultTarget"]["Values"]+1] = "D" .. dplist[i]
	end
end

ThemePrefs.InitAll(Prefs)
function GetTimingWindows()
return PREFSMAN:GetPreference("TimingWindowAdd")+PREFSMAN:GetPreference("TimingWindowHopo")+PREFSMAN:GetPreference(
"TimingWindowJump")+PREFSMAN:GetPreference("TimingWindowScale")+PREFSMAN:GetPreference("TimingWindowSecondsAttack")+
PREFSMAN:GetPreference("TimingWindowSecondsHold")+PREFSMAN:GetPreference("TimingWindowSecondsMine")+PREFSMAN:GetPreference(
"TimingWindowSecondsRoll")+PREFSMAN:GetPreference("TimingWindowSecondsW1")+PREFSMAN:GetPreference("TimingWindowSecondsW2")+
PREFSMAN:GetPreference("TimingWindowSecondsW3")+PREFSMAN:GetPreference("TimingWindowSecondsW4")+PREFSMAN:GetPreference(
"TimingWindowSecondsW5")+PREFSMAN:GetPreference("TimingWindowSecondsHold")+PREFSMAN:GetPreference("TimingWindowStrum")+
PREFSMAN:GetPreference("TimingWindowSecondsHold") end
function InitUserPrefs()
	local Prefs = {
		UserPrefScoringMode = 'DDR Extreme',
		UserPrefProtimingP1 = false,
		UserPrefProtimingP2 = false,
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetPref(k) == nil then
			SetUserPref(k, v)
		end
	end

	-- screen filter
	setenv("ScreenFilterP1",0)
	setenv("ScreenFilterP2",0)
end

function GetProTiming(pn)
	local pname = ToEnumShortString(pn)
	if GetUserPref("ProTiming"..pname) then
		return GetUserPrefB("ProTiming"..pname)
	else
		SetUserPref("ProTiming"..pname,false)
		return false
	end
end

--[[ option rows ]]

-- screen filter
function OptionRowScreenFilter()
	local t = {
		Name="ScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { THEME:GetString('OptionNames','Off'), '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0', },
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local filterValue = getenv("ScreenFilter"..pName)
			if filterValue ~= nil then
				local val = scale(tonumber(filterValue),0,1,1,#list )
				list[val] = true
			else
				setenv("ScreenFilter"..pName,0)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						local val = scale(i,1,#list,0,1)
						setenv("ScreenFilter"..pName,val)
						found = true
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

-- protiming
function OptionRowProTiming()
	local t = {
		Name = "ProTiming",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = {
			THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionNames','On')
		},
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn)) then
				local bShow = GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn))
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave = list[2] and true or false
			SetUserPref("UserPrefProtiming" .. ToEnumShortString(pn), bSave)
		end
	}
	setmetatable(t, t)
	return t
end

function OptionRowParameterDisplay()
	local t = {
		Name = "ParameterDisplay",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = {
			THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionNames','On')
		},
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefParameterDisplay") then
				local bShow = GetUserPrefB("UserPrefParameterDisplay")
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
--			local bSave = list[2] and true or false
			SetUserPref("UserPrefParameterDisplay", list[2])
		end
	}
	setmetatable(t, t)
	return t
end

function OptionRowSomeScoreDisplay()
	local listName = {
		THEME:GetString('OptionNames', "GP"),
		THEME:GetString('OptionNames', "DP"),
		THEME:GetString('OptionNames', "Score")
	}
	local t = {
		Name = "SomeScoreDisplay",
		LayoutType = "ShowAllInRow",
		SelectType = "Selectmultiple",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = listName,
		LoadSelections = function(self, list, pn)
			for i=1, #listName do
				if GetUserPrefB("UserPrefSomeScoreDisplay_"..listName[i]) then
					list[i] = true
				else
					list[i] = false
				end
			end
		end,
		SaveSelections = function(self, list, pn)
			for i=1, #listName do
				SetUserPref("UserPrefSomeScoreDisplay_"..listName[i], list[i])
			end
		end
	}
	setmetatable(t, t)
	return t
end
function OptionRowSelectMusicBackgroundFavorite()
	local t = {
		Name = "SelectMusicBackgroundFavorite",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = {
			"CurrentSong",
			"Favorite"
		},
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefSelectMusicBackgroundFavorite") then
				local bShow = GetUserPrefB("UserPrefSelectMusicBackgroundFavorite")
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
--			local bSave = list[2] and true or false
			SetUserPref("UserPrefSelectMusicBackgroundFavorite", list[2])
		end
	}
	setmetatable(t, t)
	return t
end

function OptionRowSelectMModType()
	local t = {
		Name = "SelectMModType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = {
			"MaxBPM",
			"MediumBPM",
			"MinBPM",
			"MainBPM"
		},
		LoadSelections = function(self, list, pn)
			local mtype = File.Read( "DefaultMoreSave/MModType.txt" )
			if mtype then
					if	mtype=="Medium"	then list[2] = true
				elseif	mtype=="Min"	then list[3] = true
				elseif	mtype=="Main"	then list[4] = true
				else						 list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local mtype
				if list[2] then mtype = "Medium"
			elseif list[3] then mtype = "Min"
			elseif list[4] then mtype = "Main"
			else				mtype = "Max"
			end
			File.Write( "DefaultMoreSave/MModType.txt", mtype )
		end
	}
	setmetatable(t, t)
	return t
end

-- ターゲットのオプション ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function OptionRowRankTarget()
	local dplist = GetTargetDancePoint()
	local vslist = {}
	local vslistName = {}
	local playerNum
	if GAMESTATE:IsHumanPlayer( PLAYER_1 ) then
		playerNum = PLAYER_1
	else
		playerNum = PLAYER_2
	end
	local curplayer = GAMESTATE:GetPlayerDisplayName(playerNum)
	local pName = GetRealFilePlayerList()
	for i=1, #pName do
		if not string.match(pName[i], curplayer) then
			vslist[#vslist+1] = pName[i].."_DP"
			vslistName[#vslistName+1] = pName[i].."_DP"
			vslist[#vslist+1] = pName[i].."_GP"
			vslistName[#vslistName+1] = pName[i].."_GP"
		end
	end
	local rt_path = "DefaultMoreSave/RankTarget.txt"
	local t = {
		Name = "Target",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = {
			THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionNames','GPBest'),
			THEME:GetString('OptionNames','AAA'),
			THEME:GetString('OptionNames','AA'),
			THEME:GetString('OptionNames','A'),
			THEME:GetString('OptionNames','DPBest'),
		},
		LoadSelections = function(self, list, pn)
			local rankTarget = File.Read( rt_path )
			if rankTarget ~= nil then
					if	rankTarget=="GB"	then list[2] = true
				elseif	rankTarget=="G100"	then list[3] = true
				elseif	rankTarget=="G93"	then list[4] = true
				elseif	rankTarget=="G80"	then list[5] = true
				elseif	rankTarget=="DB"	then list[6] = true
				elseif	string.sub(rankTarget,1,1)=="D" then
					local liston = false
					for i=1, #dplist do
						if rankTarget=="D"..dplist[i] then
							list[6+i] = true
							liston = true
						end
					end
					if not liston then
						list[1] = true
					end
				elseif	string.sub(rankTarget,1,1)=="V" then
					local liston = false
					for i=1, #vslist do
						if rankTarget=="V"..vslist[i] then
							list[6+#dplist+i] = true
							liston = true
						end
					end
					if not liston then
						list[1] = true
					end
				elseif rankTarget=="RNDP" then
					list[7+#dplist+#vslist] = true
				elseif rankTarget=="RNGP" then
					list[8+#dplist+#vslist] = true
				elseif rankTarget=="RTDP" then
					list[9+#dplist+#vslist] = true
				elseif rankTarget=="RTGP" then
					list[10+#dplist+#vslist] = true
				else
					list[1] = true
				end
			else
				File.Write( rt_path, "Off" )
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local rankTarget
			local bSave
				if	list[1] then rankTarget = "Off"
			elseif	list[2] then rankTarget = "GB"
			elseif	list[3] then rankTarget = "G100"
			elseif	list[4] then rankTarget = "G93"
			elseif	list[5] then rankTarget = "G80"
			elseif	list[6] then rankTarget = "DB"
			elseif	list[7+#dplist+#vslist] then
				rankTarget = "RNDP"
			elseif	list[8+#dplist+#vslist] then
				rankTarget = "RNGP"
			elseif	list[9+#dplist+#vslist] then
				rankTarget = "RTDP"
			elseif	list[10+#dplist+#vslist] then
				rankTarget = "RTGP"
			else
				for i=1, #dplist do
					if list[6+i] then
						rankTarget = "D"..dplist[i]
					end
				end
				for i=1, #vslist do
					if list[6+#dplist+i] then
						rankTarget = "V"..vslist[i]
					end
				end
			end
			File.Write( rt_path, rankTarget )
		end
	}
	for i=1, #dplist do
		t["Choices"][#t["Choices"]+1] = "DP" .. dplist[i] .. "%"
	end
	for i=1, #vslistName do
		t["Choices"][#t["Choices"]+1] = vslistName[i]
	end
	t["Choices"][#t["Choices"]+1] = "RankingNextDP"
	t["Choices"][#t["Choices"]+1] = "RankingNextGP"
	t["Choices"][#t["Choices"]+1] = "RankingTopDP"
	t["Choices"][#t["Choices"]+1] = "RankingTopGP"
	setmetatable(t, t)
	return t
end

--[[ end option rows ]]
