--internals table
local Shared = {};
--Special Scoring types.
local r = {};
local DisabledScoringModes = { '[SSC] Radar Master' };
--the following metatable makes any missing value in a table 0 instead of nil.
local ZeroIfNotFound = { __index = function() return 0 end; };

-- Retrieve the amount of taps/holds/rolls involved. Used for some formulas.
function GetTotalItems(radars)
	local total = radars:GetValue('RadarCategory_TapsAndHolds')
	total = total + radars:GetValue('RadarCategory_Holds') 
	total = total + radars:GetValue('RadarCategory_Rolls')
	-- [ja] Liftを加えると一部二重加算になるため除外する。
	-- total = total + radars:GetValue('RadarCategory_Lifts')

	-- [en] prevent divide by 0
	-- [ja] 0除算対策（しなくても動作するけど満点になっちゃうんで）
	return math.max(1,total);
end;

-- Determine whether marvelous timing is to be considered.
function IsW1Allowed(tapScore)
	return tapScore == 'TapNoteScore_W2'
		and (PREFSMAN:GetPreference("AllowW1") ~= 'AllowW1_Never' 
		or not (GAMESTATE:IsCourseMode() and 
		PREFSMAN:GetPreference("AllowW1") == 'AllowW1_CoursesOnly'));
end;

-- Get the radar values directly. The individual steps aren't used much.
function GetDirectRadar(player)
	return GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
end;

-----------------------------------------------------------
--Online UsualScoring by [DDR MAX2/Extreme(-esque) Scoring by @sakuraponila] arr.CL
-----------------------------------------------------------
local oln_Steps = {0,0};
local onlineUsualScore = {0,0};
local multLookup, steps, totalItems, sTotal, meter, baseScore, sOne, p, calculate;
r['More'] = function(params, pss)
		-- [en] initialized when score is 0
		-- [ja] スコアが0の時に初期化
		if pss:GetScore() == 0 then
			multLookup =
			{
				['TapNoteScore_W1'] = 1.0,
				['TapNoteScore_W2'] = 0.9,
				['TapNoteScore_W3'] = 0.5,
			};
			setmetatable(multLookup, ZeroIfNotFound);
			steps = GAMESTATE:GetCurrentSteps(params.Player);
			totalItems = GetTotalItems( GetDirectRadar(params.Player) );
			-- 1 + 2 + 3 + ... + totalItems value/の値
			sTotal = (totalItems + 1) * totalItems / 2;
			meter = math.min(10, steps:GetMeter());
			-- [en] score for one step
			-- [ja] 1ステップあたりのスコア
			baseScore = meter * 10000000;
			if (GAMESTATE:GetCurrentSong():IsMarathon()) then
				baseScore = baseScore * 3;
			elseif (GAMESTATE:GetCurrentSong():IsLong()) then
				baseScore = baseScore * 2;
			end;
			sOne = baseScore / sTotal;

			p = (params.Player == 'PlayerNumber_P1') and 1 or 2;
			oln_Steps[p] = 0;
			onlineUsualScore[p] = 0;
			calculate = ThemePrefs.Get("CalculateScore");
			if not calculate then calculate = "Addition"; end;
		end;
		-- [en] now step count
		-- [ja] 現在のステップ数
		oln_Steps[p] = oln_Steps[p] + 1;
		-- [en] current score
		-- [ja] 今回加算するスコア（W1の時）
		local vScore = sOne * oln_Steps[p];
		if oln_Steps[p] == totalItems then
			pss:SetCurMaxScore(baseScore);
		else
			pss:SetCurMaxScore(pss:GetCurMaxScore() + vScore);
		end;
		-- [ja] 判定によって加算量を変更
		if (params.HoldNoteScore == 'HoldNoteScore_Held') then
		-- [ja] O.K.判定時は問答無用で満点
			vScore = vScore;
		elseif (params.HoldNoteScore == 'HoldNoteScore_LetGo') then
		-- [ja] N.G.判定時は問答無用で0点
			vScore = 0;
		-- [en] non-long note scoring
		-- [ja] それ以外ということは、ロングノート以外の判定である
		else
			vScore = vScore * multLookup[params.TapNoteScore];
		end;

		onlineUsualScore[p] = onlineUsualScore[p] + vScore;
		if calculate == "Addition" then
			pss:SetScore( onlineUsualScore[p] );
		-- if ThemePrefs.Get("CalculateScore") == "Average" then
		else
			local avescore =  baseScore / pss:GetCurMaxScore() * math.ceil(onlineUsualScore[p]);
			if avescore > baseScore then avescore = baseScore; end;
			pss:SetScore( avescore );
		end;

		if oln_Steps[p] == totalItems then
			pss:SetScore( onlineUsualScore[p] );
			local pStats = STATSMAN:GetCurStageStats():GetPlayerStageStats( params.Player );
			local rv = GAMESTATE:GetCurrentSteps( params.Player ):GetRadarValues( params.Player );
			local taps = rv:GetValue("RadarCategory_TapsAndHolds");
			local holds = rv:GetValue("RadarCategory_Holds");
			local realTotal =
				  pStats:GetTapNoteScores("TapNoteScore_W1")
				+ pStats:GetTapNoteScores("TapNoteScore_W2")
				+ pStats:GetTapNoteScores("TapNoteScore_W3")
				+ pStats:GetTapNoteScores("TapNoteScore_W4")
				+ pStats:GetTapNoteScores("TapNoteScore_W5")
				+ pStats:GetTapNoteScores("TapNoteScore_Miss")
				+ pStats:GetHoldNoteScores("HoldNoteScore_Held")
				+ pStats:GetHoldNoteScores("HoldNoteScore_LetGo")
				+ 1;	-- 最後の1ノートが含まれてないので
			-- [ja] オートプレイ使ったら最後に0点にする
			if (taps + holds) > realTotal then
				pss:SetScore(0);
			-- [ja] 理論値なら満点にする
			elseif pStats:GetTapNoteScores("TapNoteScore_W1") == taps
			and    pStats:GetHoldNoteScores("HoldNoteScore_Held") == holds
			and    pStats:GetTapNoteScores("TapNoteScore_HitMine") == 0
			and   (params.TapNoteScore == "TapNoteScore_W1" or params.HoldNoteScore == "HoldNoteScore_Held")
			then
				pss:SetScore(baseScore);
			end;
		end;
end;

-------------------------------------------------------------------------------
-- Formulas end here.
for v in ivalues(DisabledScoringModes) do r[v] = nil end
Scoring = r;

function UserPrefScoringMode()
  local baseChoices = {}
  for k,v in pairs(Scoring) do table.insert(baseChoices,k) end
  if next(baseChoices) == nil then UndocumentedFeature "No scoring modes available" end
	local t = {
		Name = "UserPrefScoringMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = baseChoices;
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefScoringMode") ~= nil then
        --Load the saved scoring mode from UserPrefs.
				local theValue = ReadPrefFromFile("UserPrefScoringMode");
				local success = false; 
        --HACK: Preview 4 took out 1st and 4th scoring. Replace with a close equivalent.
        if theValue == "DDR 1stMIX" or theValue == "DDR 4thMIX" then theValue = "Oldschool" end
        --Search the list of scoring modes for the saved scoring mode.        
				for k,v in ipairs(baseChoices) do if v == theValue then list[k] = true success = true break end end;
        --We couldn't find it, pick the first available scoring mode as a sane default.
				if success == false then list[1] = true end;
			else
        WritePrefToFile("UserPrefScoringMode", baseChoices[1]);
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			for k,v in ipairs(list) do if v then WritePrefToFile("UserPrefScoringMode", baseChoices[k]) break end end;
		end;
	};
	setmetatable( t, t );
	return t;
end
