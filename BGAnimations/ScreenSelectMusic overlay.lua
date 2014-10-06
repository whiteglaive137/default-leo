--I'ma call it the fuck you people with fucking huge cdtitles script, With Love - Jousway
--Update, Added a BAD NPS system
local t = Def.ActorFrame {
	
	--NPS Calculator/Display
	LoadFont("Common Normal") .. {
		Name="P1NPS";
		InitCommand=cmd(x,SCREEN_CENTER_X-62+400+15;y,SCREEN_CENTER_Y-10;zoom,0.75;diffuse,color("#ef403d");strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="P2NPS";
		InitCommand=cmd(x,SCREEN_CENTER_X-62+400+15;y,SCREEN_CENTER_Y+10;zoom,0.75;diffuse,color("#0089cf");strokecolor,Color("Outline"));
	};

	--CDTitle Resizer/Container
	
};

local function Update(self)
	local song = GAMESTATE:GetCurrentSong();
	
	
	
	
	--nps
	local P1NPS = self:GetChild("P1NPS");
	local P2NPS = self:GetChild("P2NPS");
		
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if song then
			local ChartLenghtInSec = song:GetStepsSeconds();
			local Getp1Radar = GAMESTATE:GetCurrentSteps(PLAYER_1):GetRadarValues(PLAYER_1);
			local P1Taps = Getp1Radar:GetValue('RadarCategory_TapsAndHolds')+Getp1Radar:GetValue('RadarCategory_Jumps')+Getp1Radar:GetValue('RadarCategory_Hands');
			P1NPS:settext(string.format("%0.2f",P1Taps/ChartLenghtInSec));
		else
			P1NPS:settext("0");
		end;		
		
	else
		
	end;
	
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if song then
			local ChartLenghtInSec = song:GetStepsSeconds();
			local Getp2Radar = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2);
			local P2Taps = Getp2Radar:GetValue('RadarCategory_TapsAndHolds')+Getp2Radar:GetValue('RadarCategory_Jumps')+Getp2Radar:GetValue('RadarCategory_Hands');
			P2NPS:settext(string.format("%0.2f",P2Taps/ChartLenghtInSec));
		else
			P2NPS:settext("0");
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,Update);
return t
