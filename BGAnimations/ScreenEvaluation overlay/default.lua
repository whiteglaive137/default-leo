local vStats = STATSMAN:GetCurStageStats();

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
	return t
end;

local function GetTime(self)
  local c = self:GetChildren();
	local tss = GetTimeSinceStart();
	local ftss = string.format("%.2d:%.2d:%.2d", tss/(60*60), tss/60%60, tss%60);
	c.Time:settext("Jugando hace: "..ftss);
end;

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
	local gImages = {
		t_0 = "ramona";
		t_1 = "smoooch";
		t_2 = "roku";
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
		
		Grade_TierOther = "ramona";
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
	if var_rand%27==0 then
		t[#t+1] = LoadActor(gImages["t_0"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+380;y,SCREEN_CENTER_Y*2-142/2;diffusealpha,1.0;);	
		};
	elseif var_rand%27==1 then						
		t[#t+1] = LoadActor(gImages["t_1"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,SCREEN_CENTER_Y*2-195/2-10;diffusealpha,1.0;);	
		};
	elseif var_rand%27==2 then
		t[#t+1] = LoadActor(gImages["t_2"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,SCREEN_CENTER_Y*2-200/2-10;diffusealpha,1.0;);	
		};
	elseif var_rand%27==3 then
		t[#t+1] = LoadActor(gImages["t_3"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,SCREEN_CENTER_Y*2-190/2-10;diffusealpha,1.0;);	
		};
	elseif var_rand%27==4 then
		t[#t+1] = LoadActor(gImages["t_4"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-214/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==5 then
		t[#t+1] = LoadActor(gImages["t_5"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-200/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==6 then
		t[#t+1] = LoadActor(gImages["t_6"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-192/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==7 then
		t[#t+1] = LoadActor(gImages["t_7"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==8 then
		t[#t+1] = LoadActor(gImages["t_8"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-196/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==9 then
		t[#t+1] = LoadActor(gImages["t_9"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-196/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==10 then
		t[#t+1] = LoadActor(gImages["t_10"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-200/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==11 then
		t[#t+1] = LoadActor(gImages["t_11"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==12 then
		t[#t+1] = LoadActor(gImages["t_12"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==13 then
		t[#t+1] = LoadActor(gImages["t_13"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-208/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==14 then
		t[#t+1] = LoadActor(gImages["t_14"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==15 then
		t[#t+1] = LoadActor(gImages["t_15"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-25;y,(SCREEN_CENTER_Y*2-182/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==16 then
		t[#t+1] = LoadActor(gImages["t_16"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==17 then
		t[#t+1] = LoadActor(gImages["t_17"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==18 then
		t[#t+1] = LoadActor(gImages["t_18"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==19 then
		t[#t+1] = LoadActor(gImages["t_19"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-30;y,(SCREEN_CENTER_Y*2-210/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==20 then
		t[#t+1] = LoadActor(gImages["t_20"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-210/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==21 then
		t[#t+1] = LoadActor(gImages["t_21"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==22 then
		t[#t+1] = LoadActor(gImages["t_22"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-198/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==24 then
		t[#t+1] = LoadActor(gImages["t_24"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-200/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==25 then
		t[#t+1] = LoadActor(gImages["t_25"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-208/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==26 then
		t[#t+1] = LoadActor(gImages["t_26"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340;y,(SCREEN_CENTER_Y*2-210/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	elseif var_rand%27==23 then
		t[#t+1] = LoadActor(gImages["t_23"])..{
			InitCommand=cmd(x,SCREEN_CENTER_X+340-10;y,(SCREEN_CENTER_Y*2-212/2)-20;diffusealpha,1.0;);	
		};
	end;
	return t;
end;



local t = Def.ActorFrame {};
GAMESTATE:IsPlayerEnabled(PLAYER_1)
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_1);x,WideScale(math.floor(SCREEN_CENTER_X*0.3)-8,math.floor(SCREEN_CENTER_X*0.5)-8);y,SCREEN_CENTER_Y-34);
	CreateStats( PLAYER_1 );
};
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(hide_if,not GAMESTATE:IsPlayerEnabled(PLAYER_2);x,WideScale(math.floor(SCREEN_CENTER_X*1.7)+8,math.floor(SCREEN_CENTER_X*1.5)+8);y,SCREEN_CENTER_Y-34);
	CreateStats( PLAYER_2 );
};


t[#t+1] = Def.ActorFrame {
	showGradeImg();
};
return t