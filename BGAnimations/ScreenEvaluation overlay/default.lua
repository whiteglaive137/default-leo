local vStats = STATSMAN:GetCurStageStats();


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

local function UpdateGradeBar(self, MIGS, nowMIGS_MAX, DP, nowDP_MAX)
	local d = self:GetChildren().SongMeterDisplayFrame;
	local c = d:GetChildren();
	local tip = c.GradeTip:GetChildren();
	local percent = 1;
	local gradechanged = false;
	local PercentMIGS = MIGS/nowMIGS_MAX;

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
	c.Grade:diffusecolor(color(colors[grade]));
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
end;

local function CreateStats( pnPlayer )
	-- Actor Templates
	local aLabel = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	local aText = LoadFont("Common Normal") .. { InitCommand=cmd(zoom,0.5;shadowlength,1;horizalign,left); };
	-- DA STATS, JIM!!
	local pnStageStats = vStats:GetPlayerStageStats( pnPlayer );
	-- Organized Stats.
	local tStats = {
		W1			= pnStageStats:GetTapNoteScores('TapNoteScore_W1');
		W2			= pnStageStats:GetTapNoteScores('TapNoteScore_W2');
		W3			= pnStageStats:GetTapNoteScores('TapNoteScore_W3');
		W4			= pnStageStats:GetTapNoteScores('TapNoteScore_W4');
		W5			= pnStageStats:GetTapNoteScores('TapNoteScore_W5');
		Miss		= pnStageStats:GetTapNoteScores('TapNoteScore_Miss');
		HitMine		= pnStageStats:GetTapNoteScores('TapNoteScore_HitMine');
		AvoidMine	= pnStageStats:GetTapNoteScores('TapNoteScore_AvoidMine');
		Held		= pnStageStats:GetHoldNoteScores('HoldNoteScore_Held');
		LetGo		= pnStageStats:GetHoldNoteScores('HoldNoteScore_LetGo');
	};
	-- Organized Equation Values
	local tValues = {
		-- marvcount*7 + perfcount*6 + greatcount*5 + goodcount*4 + boocount*2 + okcount*7
		ITG			= ( tStats["W1"]*7 + tStats["W2"]*6 + tStats["W3"]*5 + tStats["W4"]*4 + tStats["W5"]*2 + tStats["Held"]*7 ), 
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount + okcount + ngcount)*7
		ITG_MAX		= ( tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"] + tStats["Held"] + tStats["LetGo"] )*7,
		-- marvcount*3 + perfcount*2 + greatcount*1 - boocount*4 - misscount*8 + okcount*6
		MIGS		= ( tStats["W1"]*3 + tStats["W2"]*2 + tStats["W3"] - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount)*3 + (okcount + ngcount)*6
		MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*3 + (tStats["Held"] + tStats["LetGo"])*6 ),
		-- marvcount*3 + perfcount*3 + greatcount*1 - boocount*4 - misscount*8 + okcount*6
		MIGS_MIGS		= ( tStats["W1"]*2 + tStats["W2"]*2 + tStats["W3"] - tStats["W4"] *0 - tStats["W5"]*4 - tStats["Miss"]*8 + tStats["Held"]*6 ),
		-- (marvcount + perfcount + greatcount + goodcount + boocount + misscount)*3 + (okcount + ngcount)*6
		MIGS_MIGS_MAX	= ( (tStats["W1"] + tStats["W2"] + tStats["W3"] + tStats["W4"] + tStats["W5"] + tStats["Miss"])*2 + (tStats["Held"] + tStats["LetGo"])*6 ),
	};

	local t = Def.ActorFrame {};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,-34);
		LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
			InitCommand=cmd(zoom,0.875;diffuse,PlayerColor( pnPlayer ));
		};
		aLabel .. { Text=THEME:GetString("ScreenEvaluation","ITG DP:"); InitCommand=cmd(x,-64) };
		aText .. { Text=string.format("%04i",tValues["ITG"]); InitCommand=cmd(x,-8;y,5;vertalign,bottom;zoom,0.6); };
		aText .. { Text="/"; InitCommand=cmd(x,28;y,5;vertalign,bottom;zoom,0.5;diffusealpha,0.5); };
		aText .. { Text=string.format("%04i",tValues["ITG_MAX"]); InitCommand=cmd(x,32;y,5;vertalign,bottom;zoom,0.5); };
	};
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(y,-6);
		LoadActor(THEME:GetPathG("ScreenTitleMenu","PreferenceFrame")) .. {
			InitCommand=cmd(zoom,0.875;diffuse,PlayerColor( pnPlayer ));
		};
		aLabel .. { Text=THEME:GetString("ScreenEvaluation","MIGS DP:"); InitCommand=cmd(x,-64) };
		aText .. { Text=string.format("%04i",tValues["MIGS"]); InitCommand=cmd(x,-8;y,5;vertalign,bottom;zoom,0.6); };
		aText .. { Text="/"; InitCommand=cmd(x,28;y,5;vertalign,bottom;zoom,0.5;diffusealpha,0.5); };
		aText .. { Text=string.format("%04i",tValues["MIGS_MAX"]); InitCommand=cmd(x,32;y,5;vertalign,bottom;zoom,0.5); };
	};
	
	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
		Name="SongMeterDisplayFrame";
		InitCommand=cmd(xy,0,18;addy,-60;linear,0.045;addy,1;linear,0.01;addy,59);
		--OnCommand=cmd(addy,-60;sleep,2.4;linear,0.2;addy,60);
		Def.ActorFrame {
			Name = "GradeTip";
			LoadActor("framedos") .. {
				InitCommand=cmd(setsize,(SCREEN_WIDTH*0.150)+4,8+4);
			};
			LoadActor( "ScoreDisplayRave") .. {
				Name = "Tip1";
				InitCommand=cmd(setsize,(SCREEN_WIDTH*0.150),8);
				OnCommand=cmd(x,000;y,000;z,-000;texcoordvelocity,1,0;customtexturerect,0,0,(SCREEN_WIDTH*0.150)/256,8/32;texturewrapping,true);
			};
			
			LoadActor( "maxscore") .. {
				Name = "Tip2";
				InitCommand=cmd(setsize,(SCREEN_WIDTH*0.150),8);
				OnCommand=cmd(x,000;y,000;z,-000;texcoordvelocity,1,0;customtexturerect,0,0,(SCREEN_WIDTH*0.150)/256,8/32;texturewrapping,true);
			};
			
			LoadActor("marco") .. {
				InitCommand=cmd(setsize,(SCREEN_WIDTH*0.150)+4+2,8+4+2);
			};
			
			
			};
			LoadFont("Common normal") .. {
					Name="Grade";
					InitCommand=cmd(zoom,0.6;horizalign,center);
					OnCommand=cmd(strokecolor,color("#000000"));
					Text="AAAA";
					
			};
		};
		BeginCommand=function(self)
				UpdateGradeBar(self,tValues["MIGS_MIGS"],tValues["MIGS_MIGS_MAX"],tValues["MIGS"],tValues["MIGS_MAX"]);
		end;
	};

	return t
end;

local function GetTime(self)
  local c = self:GetChildren();
	local tss = GetTimeSinceStart();
	local ftss = string.format("%.2d:%.2d:%.2d", tss/(60*60), tss/60%60, tss%60);
	-- c.Time:settext("Jugando hace: "..ftss);
	c.Time:settext("");
end;

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function showGradeImg()
	local t = Def.ActorFrame {};
	local grade = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetGrade();
	local note_w1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W1");
	local note_w2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_W2");
	local note_miss = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetTapNoteScores("TapNoteScore_Miss");
	local stages = STATSMAN:GetStagesPlayed();
	local times = tonumber(string.sub(Time.Now(),4,5))*10000;--+tonumber(string.sub(Time.Now(),3,4))*100+tonumber(string.sub(Time.Now(),6,7))*1;
	math.randomseed(math.abs(math.floor(stages+times)));
	local var_rand = math.abs(math.floor((note_w1 + note_w2 - note_miss)*math.random(11)*math.random(50)+math.random(137)+note_w1*math.random(2594)));
	var_rand = var_rand * math.floor(GetTimeSinceStart()%60);
	local gImages = {
		t_0 = "ramona";
		t_1 = "smoooch";
		t_2 = "1_roku";
		t_3 = "taiga-tiger";
		t_4 = "reisen";
		t_5 = "mario-bot";
		t_6 = "skelleton-spider";
		t_7 = "zombie1";
		t_8 = "enderman1";
		t_9 = "pigman1";
		t_10 = "ghast1";
		t_11 = "creeper";
		t_12 = "steve";
		t_13 = "diamond_steve";
		t_14 = "sk_el";
		t_15 = "sheep_pig_chicken";
		t_16 = "ghast_2";
		t_17 = "zombie_2";
		t_18 = "pigman_2";
		t_19 = "dragon";
		t_20 = "enderman_2";
		t_21 = "hellokitty";
		t_22 = "hellok2";
		t_23 = "cirno";
		t_24 = "marisa1";
		t_25 = "sakuya";
		t_26 = "marisa_2";
		t_27 = "1_remillia";
		t_28 = "2_remillia";
		t_29 = "yoshi";
		t_30 = "1_shyguy";
		t_31 = "2_shyguy";
		t_32 = "babybowser";
		t_33 = "flandre_remillia";
		t_34 = "1_flandre";
		t_35 = "2_flandre";
		t_36 = "1_kero";
		t_37 = "2_kero";
		t_38 = "1_jiburiru";
		t_39 = "2_jiburiru";
		t_40 = "1_peggy";
		t_41 = "1_kirisaki";
		t_42 = "2_kirisaki";
		t_43 = "1_kanoko";
		t_44 = "1_syo";
		t_45 = "2_roku";
		t_46 = "1_sora_hoshino";
		t_47 = "1_yunta";
		t_48 = "1_mzd";
		t_49 = "2_mzd";
		
		
		Grade_TierOther = "ramona";
	};
	
	local gX = {
		t_0 = SCREEN_CENTER_X+380;
		t_1 = SCREEN_CENTER_X+340;
		t_2 = SCREEN_CENTER_X+340;
		t_3 = SCREEN_CENTER_X+340;
		t_4 = SCREEN_CENTER_X+340;
		t_5 = SCREEN_CENTER_X+340;
		
		t_6 = SCREEN_CENTER_X+340;
		t_7 = SCREEN_CENTER_X+340;
		t_8 = SCREEN_CENTER_X+340;
		t_9 = SCREEN_CENTER_X+340;
		t_10 = SCREEN_CENTER_X+340;
		t_11 = SCREEN_CENTER_X+340;
		t_12 = SCREEN_CENTER_X+340-10;
		t_13 = SCREEN_CENTER_X+340-10;
		t_14 = SCREEN_CENTER_X+340;
		t_15 = SCREEN_CENTER_X+340-25;
		t_16 = SCREEN_CENTER_X+340;
		t_17 = SCREEN_CENTER_X+340;
		t_18 = SCREEN_CENTER_X+340;
		t_19 = SCREEN_CENTER_X+340-30;
		t_20 = SCREEN_CENTER_X+340;
		t_21 = SCREEN_CENTER_X+340;
		t_22 = SCREEN_CENTER_X+340;
		t_23 = SCREEN_CENTER_X+340-10;
		t_24 = SCREEN_CENTER_X+340;
		t_25 = SCREEN_CENTER_X+340;
		t_26 = SCREEN_CENTER_X+340;
		t_27 = SCREEN_CENTER_X+340+10;
		t_28 = SCREEN_CENTER_X+340+10;
		t_29 = SCREEN_CENTER_X+340+10;
		t_30 = SCREEN_CENTER_X+340+10;
		t_31 = SCREEN_CENTER_X+340+10;
		t_32 = SCREEN_CENTER_X+340+10;
		t_33 = SCREEN_CENTER_X+340-30;
		t_34 = SCREEN_CENTER_X+340-30;
		t_35 = SCREEN_CENTER_X+340-30;
		t_36 = SCREEN_CENTER_X+340-10;
		t_37 = SCREEN_CENTER_X+340+10;
		t_38 = SCREEN_CENTER_X+340+0;
		t_39 = 60;
		t_40 = SCREEN_CENTER_X+340+10;
		t_41 = SCREEN_CENTER_X+340+10;
		t_42 = SCREEN_CENTER_X+340+10;
		t_43 = SCREEN_CENTER_X+340+10;
		t_44 = SCREEN_CENTER_X+340+10;
		t_45 = SCREEN_CENTER_X+340+10;
		t_46 = SCREEN_CENTER_X+340+10;
		t_47 = SCREEN_CENTER_X+340+10;
		t_48 = SCREEN_CENTER_X+340+10;
		t_49 = SCREEN_CENTER_X+340+10;
		t_50 = SCREEN_CENTER_X+340+10;
		t_51 = SCREEN_CENTER_X+340+10;
		t_52 = SCREEN_CENTER_X+340+10;
		t_53 = SCREEN_CENTER_X+340+10;
		
		Grade_TierOther = SCREEN_CENTER_X+380;
	};
	
	local gY = {
		t_0 = SCREEN_CENTER_Y*2-142/2;
		t_1 = SCREEN_CENTER_Y*2-195/2-10;
		t_2 = SCREEN_CENTER_Y*2-200/2-10;
		t_3 = SCREEN_CENTER_Y*2-190/2-10;
		t_4 = (SCREEN_CENTER_Y*2-214/2)-20;
		t_5 = (SCREEN_CENTER_Y*2-200/2)-20;
		t_6 = (SCREEN_CENTER_Y*2-192/2)-20;
		t_7 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_8 = (SCREEN_CENTER_Y*2-196/2)-20;
		t_9 = (SCREEN_CENTER_Y*2-196/2)-20;
		t_10 = (SCREEN_CENTER_Y*2-200/2)-20;
		t_11 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_12 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_13 = (SCREEN_CENTER_Y*2-208/2)-20;
		t_14 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_15 = (SCREEN_CENTER_Y*2-182/2)-20;
		t_16 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_17 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_18 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_19 = (SCREEN_CENTER_Y*2-210/2)-20;
		t_20 = (SCREEN_CENTER_Y*2-210/2)-20;
		t_21 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_22 = (SCREEN_CENTER_Y*2-198/2)-20;
		t_23 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_24 = (SCREEN_CENTER_Y*2-200/2)-20;
		t_25 = (SCREEN_CENTER_Y*2-208/2)-20;
		t_26 = (SCREEN_CENTER_Y*2-210/2)-20;
		t_27 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_28 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_29 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_30 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_31 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_32 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_33 = (SCREEN_CENTER_Y*2-210/2)-20;
		t_34 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_35 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_36 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_37 = (SCREEN_CENTER_Y*2-212/2)-31;
		t_38 = (SCREEN_CENTER_Y*2-212/2)-31;
		t_39 = (SCREEN_CENTER_Y*2-212/2)-31;
		t_40 = (SCREEN_CENTER_Y*2-212/2)-31;
		t_41 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_42 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_43 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_44 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_45 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_46 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_47 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_48 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_49 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_50 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_51 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_52 = (SCREEN_CENTER_Y*2-212/2)-20;
		t_53 = (SCREEN_CENTER_Y*2-212/2)-20;
		
		Grade_TierOther = SCREEN_CENTER_Y*2-142/2;
	};
	t[#t+1] = Def.ActorFrame {
		LoadFont("Common normal") .. {
				Name="Time";
				InitCommand=cmd(x,SCREEN_CENTER_X+233;y,27;horizalign,left;strokecolor,1,0.9,0.2,0.4;diffuse,color"1,1,0,1";zoom,0.6);
				BeginCommand=cmd(playcommand, "Set");
				SetCommand=function(self)
					local tss = GetTimeSinceStart();
					local ftss = string.format("%.2d:%.2d:%.2d", tss/(60*60), tss/60%60, tss%60);
					self:settext("Jugando hace: "..ftss);
				end;
			};
		
		BeginCommand=function(self)
			self:SetUpdateFunction( GetTime );
			self:SetUpdateRate( 1/30 );
		end;
	};
	
	local n = var_rand%(tablelength(gImages)-1);
	-- n = 37;
	
	
	if n == 39 then 
		-- lol
		t[#t+1] = LoadActor(gImages["t_"..n])..{
			InitCommand=cmd(zoom,0.9;x,gX["t_"..n]-20;y,gY["t_"..n]-60;diffusealpha,0.4;);	
		};
		
		t[#t+1] = LoadActor("2_inv_jiburiru")..{
			InitCommand=cmd(zoom,0.9;x,SCREEN_CENTER_X+340+20;y,(SCREEN_CENTER_Y*2-212/2)-31-60;diffusealpha,0.4;);	
		};
		
		t[#t+1] = LoadActor("2_inv_jiburiru")..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340+0;y,(SCREEN_CENTER_Y*2-212/2)-31;diffusealpha,1.0;);	
		};
		
		t[#t+1] = LoadActor("2_icon_jiburiru")..{
			InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X;y,(SCREEN_CENTER_Y*2-212/2)+40;diffusealpha,1.0;draworder,4000);	
		};
		
		math.randomseed(n);
		local h = math.random(1,12);
		for i = 0, 150, 1 do
			t[#t+1] = LoadActor("2_icon_jiburiru")..{
				InitCommand=cmd(zoom,0.2;x,SCREEN_CENTER_X;y,(SCREEN_CENTER_Y*2-212/2)+40;diffusealpha,0.7;draworder,4000;rainbow;effectperiod,0.9;playcommand,"Setup";playcommand,"Refresh");
				SetupCommand=function(self)
					math.randomseed(i*h);
					self:x( math.random(-self:GetZoomedWidth()/2,SCREEN_CENTER_X*2));
					self:y( math.random(-self:GetZoomedHeight()/2,SCREEN_CENTER_Y*2+ self:GetZoomedHeight()/2));
					self:rotationy(math.random(0,360));
					self:effectoffset(math.random(0,200)/100);
				end;
				RefreshCommand=function(self)
					self:addy(5);
					self:addx(5);
					self:addrotationy(3);
					if self:GetY() > SCREEN_CENTER_Y*2 + self:GetZoomedHeight()/2 then
						self:y(-self:GetZoomedHeight()/2);
					end;
					
					if self:GetX() > SCREEN_CENTER_X*2 + self:GetZoomedWidth()/2 then
						self:x(-self:GetZoomedWidth()/2);
					end;
					
					self:sleep(0.02);
					self:queuecommand("Refresh");
				end;
			};
		end;
	
	end;
	
	t[#t+1] = LoadActor(gImages["t_"..n])..{
			InitCommand=cmd(x,gX["t_"..n];y,gY["t_"..n];diffusealpha,1.0;);	
	};
	
	if IsUsingWideScreen() == false then
		t.BeginCommand = function(self)
			self:addx(-120);
		end;
	end;
	
	return t;
end;



local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
	showGradeImg();
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_1);x,WideScale(math.floor(SCREEN_CENTER_X*0.3)-8,math.floor(SCREEN_CENTER_X*0.22)-8);y,SCREEN_CENTER_Y+140;z,999);
	CreateStats( PLAYER_1 );
};
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_2);x,WideScale(math.floor(SCREEN_CENTER_X*1.7)+8,math.floor(SCREEN_CENTER_X*1.78)+8);y,SCREEN_CENTER_Y+140);
	CreateStats( PLAYER_2 );
};

if GAMESTATE:GetNumPlayersEnabled() == 1 then
	t[#t+1] = LoadActor("scoreboard")
end;






return t