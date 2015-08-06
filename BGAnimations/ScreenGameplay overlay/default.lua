local t = Def.ActorFrame{};


local tStats =  {
	TapNoteScore_W1 = 0,
	TapNoteScore_W2 = 0,
	TapNoteScore_W3 = 0,
	TapNoteScore_W4 = 0,
	TapNoteScore_W5 = 0,
	TapNoteScore_Miss = 0,
	HoldNoteScore_Held = 0,
	TapNoteScore_HitMine = 0,
	HoldNoteScore_LetGo = 0,
	TapNoteScore_AvoidMine = 0,
	TapNoteScore_CheckpointHit = 0,
	TapNoteScore_CheckpointMiss = 0,
};

-- GPにおける各パラメータの重み
local weightGP =  {
	TapNoteScore_W1				= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW1"),					--  2
	TapNoteScore_W2				= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW2"),					--  2
	TapNoteScore_W3				= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW3"),					--  1
	TapNoteScore_W4				= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW4"),					--  0
	TapNoteScore_W5				= THEME:GetMetric("ScoreKeeperNormal","GradeWeightW5"),					-- -4
	TapNoteScore_Miss			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightMiss"),				-- -8
	HoldNoteScore_Held			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightHeld"),				--  6
	TapNoteScore_HitMine		= THEME:GetMetric("ScoreKeeperNormal","GradeWeightHitMine"),				-- -8
	HoldNoteScore_LetGo			= THEME:GetMetric("ScoreKeeperNormal","GradeWeightLetGo"),				--  0
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= THEME:GetMetric("ScoreKeeperNormal","GradeWeightCheckpointHit"),		--  0
	TapNoteScore_CheckpointMiss = THEME:GetMetric("ScoreKeeperNormal","GradeWeightCheckpointMiss"),		--  0
};
-- DPにおける各パラメータの重み
local weightDP =  {
	TapNoteScore_W1				= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW1"),			--  3
	TapNoteScore_W2				= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW2"),			--  2
	TapNoteScore_W3				= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW3"),			--  1
	TapNoteScore_W4				= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW4"),			--  0
	TapNoteScore_W5				= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightW5"),			--  0
	TapNoteScore_Miss			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightMiss"),			--  0
	HoldNoteScore_Held			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightHeld"),			--  3
	TapNoteScore_HitMine		= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightHitMine"),		-- -2
	HoldNoteScore_LetGo			= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightLetGo"),		--  0
	TapNoteScore_AvoidMine		= 0,
	TapNoteScore_CheckpointHit	= THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightCheckpointHit"),--  0
	TapNoteScore_CheckpointMiss = THEME:GetMetric("ScoreKeeperNormal","PercentScoreWeightCheckpointMiss"),-- 0
};



local gradePercentTier = {
	AAAA	= 1,--THEME:GetMetric("PlayerStageStats", "GradePercentTier01"),	-- 1
	AAA		= 1,--THEME:GetMetric("PlayerStageStats", "GradePercentTier02"),	-- 1
	AA		= 0.93,--THEME:GetMetric("PlayerStageStats", "GradePercentTier03"),	-- 0.93
	A		= 0.8,--THEME:GetMetric("PlayerStageStats", "GradePercentTier04"),	-- 0.8
	B		= 0.65,--THEME:GetMetric("PlayerStageStats", "GradePercentTier05"),	-- 0.65
	C		= 0.45,
	D		= 0.45,
};

local colors = {
	AAAA	= "#FFE0A3",--THEME:GetMetric("PlayerStageStats", "GradePercentTier01"),	-- 1
	AAA		= "#66E0FF",--THEME:GetMetric("PlayerStageStats", "GradePercentTier02"),	-- 1
	AA		= "#66E0C2",--THEME:GetMetric("PlayerStageStats", "GradePercentTier03"),	-- 0.93
	A		= "#38ceff",--THEME:GetMetric("PlayerStageStats", "GradePercentTier04"),	-- 0.8
	B		= "#33CC33",--THEME:GetMetric("PlayerStageStats", "GradePercentTier05"),	-- 0.65
	C		= "#CCFF99",
	D		= "#FF0066",
};

local MIGS_MAX = 1;
local nowMIGS_MAX = 0;			-- 現在のGPの理論値
local DP_MAX = 1;
local nowDP_MAX = 0;			-- 現在のDPの理論値
local Holds = 0;					-- 譜面全体のHoldNotes数
local Steps = 0;					-- 譜面全体のTapNotes数
local PercentMIGS = 100;
local DP = 0;
local MIGS = 0;
local rv = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1);	
Steps = rv:GetValue("RadarCategory_TapsAndHolds");				-- 譜面全体のTapNotes数
Holds = rv:GetValue("RadarCategory_Holds");						-- 譜面全体のHoldNotes数
local StepsAndHolds = Steps + Holds;
MIGS_MAX = Steps * weightGP['TapNoteScore_W1'] + Holds * weightGP['HoldNoteScore_Held'];	-- グレード決定ポイント理論値
local percent = 1;
local prev_percent = 1;
local grade = "AAAA";
local prev_grade = "AAAA";

local function UpdateGradeBar(self)
	local d = self:GetChildren().SongMeterDisplayFrame;
	local c = d:GetChildren();
	local tip = c.GradeTip:GetChildren();
	local percent = 1;
	local gradechanged = false;

	if DP == nowDP_MAX then
		grade = "AAAA";
	elseif MIGS == nowMIGS_MAX then
		grade = "AAA";
	elseif PercentMIGS >= gradePercentTier["AA"] then
		percent = (PercentMIGS - gradePercentTier["AA"])/(1-gradePercentTier["AA"]);
		grade = "AA";-- PercentMIGS  0.93
	elseif PercentMIGS >= gradePercentTier["A"]  then
		percent = (PercentMIGS - gradePercentTier["A"])/(gradePercentTier["AA"]-gradePercentTier["A"]);
		grade = "A";-- PercentMIGS  0.8
	elseif PercentMIGS >= gradePercentTier["B"]  then
		percent = (PercentMIGS - gradePercentTier["B"])/(gradePercentTier["A"]-gradePercentTier["B"]);
		grade = "B";		-- PercentMIGS  0.65
	elseif PercentMIGS >= gradePercentTier["C"]  then
		percent = (PercentMIGS - gradePercentTier["C"])/(gradePercentTier["B"]-gradePercentTier["C"]);
		grade = "C";
	else                     
		percent = (PercentMIGS - 0)/(gradePercentTier["C"]-0);
		grade = "D";	
	end;
	c.Grade:settext(grade);	
	c.Grade:diffuse(color(colors[grade]));
	--c.Grade:strokecolor("#000000FF");
	if percent > 1 then 
	percent=1; 
	end;
	if percent < 0 then
	percent =0;
	end;
	if grade ~= prev_grade then
		prev_grade = grade;
		gradechanged = true;
	end;
	if prev_percent ~= percent then
		
		prev_percent = percent;
		tip.Tip1:stoptweening();
		if gradechanged then
			
			tip.Tip1:linear(0.0);
			tip.Tip2:linear(0.0);
		else
			tip.Tip1:linear(0.04);
			tip.Tip2:linear(0.0);
		end;
		tip.Tip1:cropright(1-percent*1);
		tip.Tip2:cropright(1-percent*1);
		if percent == 1 then
			tip.Tip2:visible(true);
			tip.Tip1:visible(false);
		else
			tip.Tip1:visible(true);
			tip.Tip2:visible(false)
		end;
	end;
	

	
	--tip.Tip1:xy((-(SCREEN_WIDTH*0.225)/2)+percent*(SCREEN_WIDTH*0.225),0);
	--tip.Tip1:diffuse(color(colors[grade]));
	--c.Grade:settext(tostring(nowMIGS_MAX).."/"..tostring(MIGS));
end;

t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_TOP+50);	
};


t[#t+1] = Def.ActorFrame{
	Def.ActorFrame{
	Name="SongMeterDisplayFrame";
	InitCommand=cmd(xy,SCREEN_CENTER_X-25,SCREEN_TOP+35;addy,-60;linear,0.045;addy,1;linear,0.01;addy,59);
	--OnCommand=cmd(addy,-60;sleep,2.4;linear,0.2;addy,60);
	Def.ActorFrame {
		Name = "GradeTip";
		LoadActor("framedos") .. {
			InitCommand=cmd(setsize,(SCREEN_WIDTH*0.225)+4,8+4);
		};
		LoadActor( "ScoreDisplayRave") .. {
			Name = "Tip1";
			InitCommand=cmd(setsize,(SCREEN_WIDTH*0.225),8);
			OnCommand=cmd(x,000;y,000;z,-000;texcoordvelocity,1,0;customtexturerect,0,0,(SCREEN_WIDTH*0.225)/256,8/32;texturewrapping,true);
		};
		
		LoadActor( "maxscore") .. {
			Name = "Tip2";
			InitCommand=cmd(setsize,(SCREEN_WIDTH*0.225),8);
			OnCommand=cmd(x,000;y,000;z,-000;texcoordvelocity,1,0;customtexturerect,0,0,(SCREEN_WIDTH*0.225)/256,8/32;texturewrapping,true);
		};
		
		LoadActor("marco") .. {
			InitCommand=cmd(setsize,(SCREEN_WIDTH*0.225)+4,8+4);
			
		};
		
		
		};
		LoadFont("Common normal") .. {
				Name="Grade";
				InitCommand=cmd(zoom,0.6;horizalign,center);
				OnCommand=cmd(diffuse,color("0,0,0,1");strokecolor,color("#000000"));
				Text="AAAA";
				
		};
	};
	BeginCommand=function(self)
			if PREFSMAN:GetPreference("Center1Player")==false then
				self:addx(-192);
			end;
			self:SetUpdateFunction( UpdateGradeBar );
			self:SetUpdateRate( 1/15 );
	end;
};

t[#t+1] = Def.ActorFrame{
	JudgmentMessageCommand = function(self,params)
		if params.TapNoteScore == 'TapNoteScore_Invalid'
		or params.TapNoteScore == 'TapNoteScore_None'
		or params.TapNoteScore == 'TapNoteScore_HitMine'
		or params.TapNoteScore == 'TapNoteScore_AvoidMine'
		then
			return;
		end;
		
		local pStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
		local curNoteScore = params.TapNoteScore or params.HoldNoteScore;
		local nowHitMine = pStats:GetTapNoteScores("TapNoteScore_HitMine");
		if tStats["TapNoteScore_HitMine"] < nowHitMine then
			local minenum = nowHitMine - tStats["TapNoteScore_HitMine"];
			MIGS = MIGS + weightGP["TapNoteScore_HitMine"] * minenum;
			DP = DP + weightDP["TapNoteScore_HitMine"] * minenum;
			tStats["TapNoteScore_HitMine"] = nowHitMine;
		end;
		
		if	params.HoldNoteScore then
			nowMIGS_MAX = nowMIGS_MAX + weightGP["HoldNoteScore_Held"];
			nowDP_MAX = nowDP_MAX + weightDP["HoldNoteScore_Held"];
			MIGS = MIGS + weightGP["HoldNoteScore_Held"];
			DP = DP + weightDP["HoldNoteScore_Held"];
		else
			nowMIGS_MAX = nowMIGS_MAX + weightGP["TapNoteScore_W1"];
			nowDP_MAX = nowDP_MAX + weightDP["TapNoteScore_W1"];
			MIGS = MIGS + weightGP[curNoteScore];
			DP = DP + weightDP[curNoteScore];
		end;
		PercentMIGS = MIGS / nowMIGS_MAX;
		end;
};

t[#t+1] = LoadActor("keycounter")



return t;


