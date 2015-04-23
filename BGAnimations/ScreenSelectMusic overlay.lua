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

t[#t+1] = LoadFont("Common normal")..{

	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y + 150;diffusealpha,0;playcommand,"Refresh");
	--BeginCommand=cmd(playcommand,"Set";sleep,0.2;queuecommand,"Begin");
	RefreshCommand=function(self)
		local topScreen = SCREENMAN:GetTopScreen();
		if topScreen then
			local screenName = topScreen:GetName();
			if screenName == "ScreenSelectMusic" then
				
				local children = topScreen:GetChildren();
				local sortOrder = children.SortOrder;
				local sortOrderFrame = children.SortOrderFrame;
				sortOrder:zoom(0.0);
				sortOrderFrame:zoom(0.0);
				text = "";
				x = 0;
				for name, child in pairs(children) do
					x = x + string.len(name);
					text = text .. name .. " ";
					if(x > 40) then
						text = text .. "\n";
						x = 0;
					end;
				end
				self:settext(text);

				(cmd(zoom,0.0;diffuse,color("#FF0000");strokecolor,color("#202020");))(self);
				
				-- local ChatInput = topScreen:GetChild("ChatInput");
				-- local ChatInputText = ChatInput:GetText();
				
				
				-- --self:settext(ChatInputText);
				
				-- if string.len(prevText) > 0 and ChatInputText == "" then
					-- --self:settext(prevText);
					-- searchSong(self,prevText);
				-- end;
				
				-- prevText = ChatInputText;
				
				-- -- self:settext();

				-- -- if MusicWheel:GetSelectedType() ~= 2 then
					-- -- local bnpath = SONGMAN:GetSongGroupBannerPath(MusicWheel:GetWheelItem(0+6):GetText());

					-- -- if bnpath and bnpath ~= '' then
					-- -- self:LoadBanner( "/"..bnpath );
					-- -- (cmd(zoomtowidth,256;zoomtoheight,80;linear,0.01;diffusealpha,1;draworder,400;))(self);
						-- -- if groupBanner then
							-- -- groupBanner = false;
							
						-- -- end;
					-- -- else
						-- -- SpriteOff(self);
						-- -- groupBanner = true;
					-- -- end;	
				-- -- else
					-- -- SpriteOff(self);
					-- -- groupBanner = true;
				-- -- end;
			end;
		end;

		self:sleep(0.1);
		self:queuecommand("Refresh");
	end;
};

t[#t+1] = LoadActor("searchbar")

t.InitCommand=cmd(SetUpdateFunction,Update);
return t
