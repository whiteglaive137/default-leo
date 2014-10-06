--I'ma call it the fuck you people with fucking huge cdtitles script, With Love - Jousway
--Update, Added a BAD NPS system
local t = Def.ActorFrame {
	
	--NPS Calculator/Display
	LoadFont("Common Normal") .. {
		Text="NPS";
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-58;y,SCREEN_BOTTOM-180+(36/2)+6+00+2;zoom,0.75;diffuse,1,1,1,1;strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="P1NPS";
		InitCommand=cmd(x,SCREEN_CENTER_X-20;y,SCREEN_BOTTOM-180+(36/2)+6+00+2;diffuse,1,1,1,1;horizalign,left;strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="P2NPS";
		InitCommand=cmd(x,SCREEN_CENTER_X-20;y,SCREEN_BOTTOM-180+(36/2)+6+00;zoom,0.75;horizalign,left;diffuse,color("#0089cf");strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Text="Length";
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-58;y,SCREEN_BOTTOM-180+(36/2)+6+25;zoom,0.75;diffuse,1,1,1,1;strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="SongLength";
		InitCommand=cmd(x,SCREEN_CENTER_X+08;y,SCREEN_BOTTOM-180+(36/2)+6+25;diffuse,1,1,1,1;horizalign,left;strokecolor,Color("Outline"));
	};

	--CDTitle Resizer/Container
	Def.ActorFrame{
		Name="CDTContainer";
		OnCommand=cmd(horizalign,center;x,SCREEN_CENTER_X+5;y,SCREEN_BOTTOM-180+(36/2)+6-50-25;zoomy,0;sleep,0.5;decelerate,0.25;zoomy,1);
		OffCommand=cmd(bouncebegin,0.15;zoomx,0);
		
		Def.Sprite {
			Name="CDTitle";
			InitCommand=cmd(y,0);
			OnCommandd=cmd(horizalign,center;vertalign,middle);
			--OnCommand=cmd(draworder,106;shadowlength,1;zoom,0.75;diffusealpha,1;zoom,0;bounceend,0.05;zoom,0.75;rainboww;effectmagnitude,0,10,0);
		};
	};
};



local function Update(self)
	local song = GAMESTATE:GetCurrentSong();
	
	--cdtitle
	local cdtitle = self:GetChild("CDTContainer"):GetChild("CDTitle");
	local height = cdtitle:GetHeight();
	local width = cdtitle:GetWidth();
	
	if song then
		if song:HasCDTitle() then
			cdtitle:visible(true);
			cdtitle:Load(song:GetCDTitlePath());
		else
			cdtitle:visible(false);
		end;
	else
		cdtitle:visible(false);
	end;
	
	if height >= 60*1.2 and width >= 80*1.2 then
		if height*(80*1.2/60*1.2) >= width then
		cdtitle:zoom(60*1.2/height);
		else
		cdtitle:zoom(80*1.2/width);
		end;
	elseif height >= 60*1.2 then
		cdtitle:zoom(60*1.2/height);
	elseif width >= 80*1.2 then
		cdtitle:zoom(80*1.2/width);
	else 
		cdtitle:zoom(1);
	end;
	
	--nps
	local P1NPS = self:GetChild("P1NPS");
	local P2NPS = self:GetChild("P2NPS");
	local SLength = self:GetChild("SongLength");
	local AText = self:GetChild("Artisttext");
	
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if song then
			local ChartLenghtInSec = song:GetStepsSeconds();
			local GetCurrSteps = GAMESTATE:GetCurrentSteps(PLAYER_1);
			if GetCurrSteps ~= nil then 
				local Getp1Radar = GetCurrSteps:GetRadarValues(PLAYER_1);
				local P1Taps = Getp1Radar:GetValue('RadarCategory_TapsAndHolds')+Getp1Radar:GetValue('RadarCategory_Jumps')+Getp1Radar:GetValue('RadarCategory_Hands');
				P1NPS:settext(string.format("%0.2f",P1Taps/ChartLenghtInSec));
			else
				P1NPS:settext("0");
			end
			
		else
			P1NPS:settext("0");
		end;		
		P2NPS:x(SCREEN_CENTER_X-40);
	else
		P2NPS:x(SCREEN_CENTER_X-62);
	end;
	
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if song then
			local ChartLenghtInSec = song:GetStepsSeconds();
			local Getp2Radar = GAMESTATE:GetCurrentSteps(PLAYER_2):GetRadarValues(PLAYER_2);
			local P2Taps = Getp2Radar:GetValue('RadarCategory_TapsAndHolds')+Getp2Radar:GetValue('RadarCategory_Jumps')+Getp2Radar:GetValue('RadarCategory_Hands');
			P2NPS:settext(string.format("%0.0f",P2Taps/ChartLenghtInSec));
		else
			P2NPS:settext("0");
		end;
	end;
	
	if song then
		local s = song:GetStepsSeconds();
		if s>=60*60 then
			SLength:settext(string.format("%.2d:%.2d:%.2d", s/(60*60), s/60%60, s%60));
		else
			SLength:settext(string.format("%.2d:%.2d", s/60%60, s%60));
		end;
	end;

end;

t.InitCommand=cmd(SetUpdateFunction,Update);
return t