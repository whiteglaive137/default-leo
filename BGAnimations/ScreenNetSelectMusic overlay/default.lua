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
	LoadFont("Common Normal") .. {
		Text="Best";
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-58;y,SCREEN_BOTTOM-180+(36/2)+6+00+2-50;zoom,0.75;diffuse,1,1,1,1;strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="BestRateValue";
		Text="0.00%";
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-18;y,SCREEN_BOTTOM-180+(36/2)+6+00+2-50;zoom,0.9;diffuse,1,1,1,1;strokecolor,Color("Outline"));
	};
	LoadFont("Common Normal") .. {
		Name="BestRateValueDetails";
		Text="0.00%";
		InitCommand=cmd(horizalign,left;x,SCREEN_CENTER_X-58;y,SCREEN_BOTTOM-180+(36/2)+6+00+2-38;zoom,0.475;diffuse,1,1,1,1;strokecolor,Color("Outline"));
	};

	--CDTitle Resizer/Container
	Def.ActorFrame{
		Name="CDTContainer";
		OnCommand=cmd(horizalign,center;x,SCREEN_CENTER_X+5;y,SCREEN_BOTTOM-180+(36/2)+6-50-25-27;zoomy,0;sleep,0.5;decelerate,0.25;zoomy,1);
		OffCommand=cmd(bouncebegin,0.15;zoomx,0);
		
		Def.Sprite {
			Name="CDTitle";
			InitCommand=cmd(y,0);
			OnCommandd=cmd(horizalign,center;vertalign,middle);
			--OnCommand=cmd(draworder,106;shadowlength,1;zoom,0.75;diffusealpha,1;zoom,0;bounceend,0.05;zoom,0.75;rainboww;effectmagnitude,0,10,0);
		};
	};
};


-- helper 

local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

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
	local P2NPS = self:GetChild("P2NPS");
	local SLength = self:GetChild("SongLength");
	local AText = self:GetChild("Artisttext");
	
	local BestRateValue = self:GetChild("BestRateValue");
	local BestRateValueDetails = self:GetChild("BestRateValueDetails");
	BestRateValue:settext("--");
	BestRateValueDetails:settext("");
	
	local currentRate;
	local optionsString = GAMESTATE:GetSongOptionsString();
	currentRate = string.match(optionsString,"%d%.%d+xMusic");
	
	if currentRate == nil then
		currentRate = "1.0xMusic";
	end;
	
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if song then
			local ChartLenghtInSec = song:GetStepsSeconds();
			local GetCurrSteps = GAMESTATE:GetCurrentSteps(PLAYER_1);
			if GetCurrSteps ~= nil then 
				local Getp1Radar = GetCurrSteps:GetRadarValues(PLAYER_1);
				local P1Taps = Getp1Radar:GetValue('RadarCategory_TapsAndHolds')+Getp1Radar:GetValue('RadarCategory_Jumps')+Getp1Radar:GetValue('RadarCategory_Hands');
				P1NPS:settext(string.format("%0.2f",P1Taps/ChartLenghtInSec));
				
				local difficulty = GetCurrSteps:GetDifficulty();
				local stepsType = GetCurrSteps:GetStepsType();
				
				local profile;
						
				if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
					profile = PROFILEMAN:GetProfile(PLAYER_1);
				else
					profile = PROFILEMAN:GetMachineProfile();
				end;
				
				highscorelist = profile:GetHighScoreList(song,GetCurrSteps);
				
				local scores = highscorelist:GetHighScores();
				
				local founded = false;
				for i, score in ipairs(scores) do
					local modifiers = score:GetModifiers();
					local rate = string.match(modifiers,"%d%.%d+xMusic");
					
					if rate == nil then
						rate = "1.0xMusic";
					end;
					
					if rate == currentRate then
						BestRateValue:settext(string.format("%.2f%%", score:GetPercentDP()*100.0));
						BestRateValueDetails:settext(currentRate .. " - " .. THEME:GetString("Grade",string.sub(score:GetGrade(),7)) .. " - DP");-- .. " - " .. score:GetScore());
						founded = true;
						break;
					end;
					
				end
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


-- Search functionalities

Songs = SONGMAN:GetAllSongs();
Results = {};
currentResult = 1;



local function showResult(self, index)

	song = Results[index];
	

	local topScreen = SCREENMAN:GetTopScreen();
	local screenName = topScreen:GetName();
	if screenName == "ScreenNetSelectMusic" then
		local MusicWheel = topScreen:GetChild("MusicWheel");
		if MusicWheel ~= nil then
			MusicWheel:SelectSong(song);
			MusicWheel:SelectSong(song); -- twice is better
			MusicWheel:Move(-1);
			MusicWheel:Move(1); -- lazy fix to trigger CurrentSongChanged
		end;
	end;
	
end;

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function searchSong(self ,searchString)
	if string.len(searchString) < 3 then
		return;
	end;
	
	searchString = string.lower(searchString);
	Results = {};
	text = "";
	n = 0;
	for k,v in pairs(Songs) do
		title = string.lower(v:GetDisplayFullTitle());
		if string.find(title,searchString) ~= nil and
		v:GetStepsSeconds() > 0.0 then
			text = text .. title .. "\n";
			n = n + 1;
			
			key = {song = v, i=n}
			table.insert(Results, n, v);
		end;
	end;
	
	local c = self:GetChildren();
	

	if tablelength(Results) > 0 then
		if tablelength(Results) == 1 then
			c.textfield2:settext(tablelength(Results) .. " Resultado encontrado para \""..searchString.."\"");
		else
			c.textfield2:settext(tablelength(Results) .. " Resultados encontrados para \""..searchString.."\"");
		end;
		
		currentResult = 1;
		showResult(self, currentResult);
	else
		c.textfield2:settext("No se encontraron resultados para \""..searchString.."\" :(");
	end;
end;

local function DetermineHighlight(self,element,highlightedElement)
	local region_x = self:GetX() + element:GetX();
	local region_y = self:GetY() + element:GetY();
	local region_width = element:GetZoomedWidth();
	local region_height = element:GetZoomedHeight();
	
	local mouse_x = INPUTFILTER:GetMouseX();
	local mouse_y = INPUTFILTER:GetMouseY();
	
	if region_x - region_width/2 <= mouse_x and
		region_x + region_width/2 >= mouse_x and
		region_y - region_height/2 <= mouse_y and
		region_y + region_height/2 >= mouse_y then
		highlightedElement:diffusealpha(1.0);
	else
		highlightedElement:diffusealpha(0.0);
	end;
end;

local function DeterminePressed(self,element)
	local region_x = self:GetX() + element:GetX();
	local region_y = self:GetY() + element:GetY();
	local region_width = element:GetZoomedWidth();
	local region_height = element:GetZoomedHeight();
	
	local mouse_x = INPUTFILTER:GetMouseX();
	local mouse_y = INPUTFILTER:GetMouseY();
	
	if region_x - region_width/2 <= mouse_x and
		region_x + region_width/2 >= mouse_x and
		region_y - region_height/2 <= mouse_y and
		region_y + region_height/2 >= mouse_y then
		return true;
	else
		return false;
	end;
end;


mouseClickHandled = false;

local function UpdateSearchBar(self)

	if self == nil then
		return;
	end;
	
	local c = self:GetChildren();
	
	DetermineHighlight(self,c.frame,c.highlightedFrame);
	DetermineHighlight(self,c.searchButton,c.highlightedSearchButton);
	DetermineHighlight(self,c.leftButton,c.highlightedLeftButton);
	DetermineHighlight(self,c.rightButton,c.highlightedRightButton);
	
	if mouseClickHandled then
		mouseClickHandled = false;
	end;
	
end;



t[#t+1] = Def.ActorFrame{

	Name="SearchBar";

	InitCommand=function(self)
		if IsUsingWideScreen() then
			self:xy(SCREEN_CENTER_X*2 - (SCREEN_WIDTH*0.3) + 28 + 10, SCREEN_TOP);
		else
			self:xy(SCREEN_CENTER_X*2 - (SCREEN_WIDTH*0.3) + 28 - 20, SCREEN_TOP);
		end;
		
		self:addy(-60);
		self:linear(0.0005);
		self:addy(1);
		self:linear(0.0005);
		self:addy(78);
	end;
	
	SM_SearchMessageCommand = function(self,params)
		local c = self:GetChildren();
		c.textfield:settext(params.searchString);
	end;
	
	LeftClickMessageCommand = function(self, params)
		local c = self:GetChildren();
		
		if mouseClickHandled == false then 
		
			if DeterminePressed(self,c.frame) then
				c.textfield:settext("");
				local topScreen = SCREENMAN:GetTopScreen();
				local screenName = topScreen:GetName();
				if screenName == "ScreenNetSelectMusic" then
					SCREENMAN:AddNewScreenToTop("ScreenTextEntry");
					local searchSettings = {
						Question = "Buscar:",
						MaxInputLength = 14,
						OnOK = function(answer)
							MESSAGEMAN:Broadcast("SM_Search",{searchString = answer});
						end,
					};
					SCREENMAN:GetTopScreen():Load(searchSettings);
				end;
			end;
			
			if DeterminePressed(self,c.searchButton) then
				local searchString = c.textfield:GetText();
				if searchString ~= "Presiona para buscar..." then
					searchSong(self, searchString);
				end;
			end;
			
			if DeterminePressed(self,c.leftButton) then
				if currentResult > 1 and currentResult <= tablelength(Results) then
					currentResult = currentResult - 1;
					showResult(self, currentResult);
				end;
			end;
			
			if DeterminePressed(self,c.rightButton) then
				if currentResult >= 1 and currentResult < tablelength(Results) then
					currentResult = currentResult + 1;
					showResult(self, currentResult);
				end;
			end;
			
			mouseClickHandled = true;
			
		end;
		
		return true;
		
	end;
	
	LoadActor( "searchButton") .. {
		Name = "searchButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18,0;setsize,24,24);
		OnCommand=cmd();
	};
	
	LoadActor( "highlightedSearchButton") .. {
		Name = "highlightedSearchButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18,0;setsize,24,24;diffusealpha,0.0);
		OnCommand=cmd();
	};
	
	LoadActor( "leftButton") .. {
		Name = "leftButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18 + 28 ,0;setsize,24,24);
		OnCommand=cmd();
	};
	
	LoadActor( "highlightedLeftButton") .. {
		Name = "highlightedLeftButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18 + 28 ,0;setsize,24,24;diffusealpha,0.0);
		OnCommand=cmd();
	};
	
	LoadActor( "rightButton") .. {
		Name = "rightButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18 + 28 + 28, 0;setsize,24,24);
		OnCommand=cmd();
	};
	
	LoadActor( "highlightedRightButton") .. {
		Name = "highlightedRightButton";
		InitCommand=cmd(xy,(SCREEN_WIDTH*0.3)/2 + 18 + 28 + 28, 0;setsize,24,24;diffusealpha,0.0);
		OnCommand=cmd();
	};
	
	LoadActor("frame") .. {
		Name = "frame";
		InitCommand=cmd(setsize,(SCREEN_WIDTH*0.3),24);
	};
	
	LoadActor("highlightedFrame") .. {
		Name = "highlightedFrame";
		InitCommand=cmd(setsize,(SCREEN_WIDTH*0.3),24;diffusealpha,0.0);
	};
	
	LoadActor("focusedFrame") .. {
		Name = "focusedFrame";
		InitCommand=cmd(setsize,(SCREEN_WIDTH*0.3),24;diffusealpha,0.0);
	};
	
	LoadFont("Common normal") .. {
		Name="textfield";
		InitCommand=cmd(zoom,0.6;horizalign,center);
		OnCommand=cmd(diffuse,color("0.7,0.7,0.7,1");strokecolor,color("#000000"));
		Text="Presiona para buscar...";
	};
	
	LoadFont("Common normal") .. {
		Name="textfield2";
		InitCommand=cmd(xy,-(SCREEN_WIDTH*0.3)/2 + 20,19;zoom,0.5;horizalign,center);
		OnCommand=cmd(halign,0;diffuse,color("0.7,0.7,0.7,1");strokecolor,color("#000000"));
		Text="Usa la lupa para empezar la busqueda.";
	};
	
	BeginCommand=function(self)
		if PREFSMAN:GetPreference("Center1Player")==false then
			self:addx(-192);
		end;
		self:SetUpdateFunction( UpdateSearchBar );
		self:SetUpdateRate( 1/30 );
	end;
};

t[#t+1] = LoadFont("Common normal")..{
	
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y - 100;diffusealpha,0;playcommand,"Refresh");
	--BeginCommand=cmd(playcommand,"Set";sleep,0.2;queuecommand,"Begin");
	RefreshCommand=function(self)
		local topScreen = SCREENMAN:GetTopScreen();
		if topScreen then
			local screenName = topScreen:GetName();
			if screenName == "ScreenNetSelectMusic" then
			
				local children = topScreen:GetChildren().StepsDisplayP1:GetChildren();
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

t[#t+1] = Def.ActorFrame {
	BeginCommand = function(self)
		--dfwjiodf
		
		if IsUsingWideScreen() == false then
			local topScreen = SCREENMAN:GetTopScreen();
			if topScreen then
				local screenName = topScreen:GetName();
				if screenName == "ScreenNetSelectMusic" then
					local children = topScreen:GetChildren();
					children.ChatOutput:addx(-15);
					children.ChatInput:addx(-15);
					
					children.StepsDisplayP1:addx(67);
					children.StepsDisplayP1:GetChildren().Frame:zoomx(0.82);
					children.StepsDisplayP1:GetChildren().Frame:zoomy(1.0);
					children.StepsDisplayP1:GetChildren().Description:zoom(0.82);
					children.StepsDisplayP1:GetChildren().Meter:zoom(0.82);
					children.StepsDisplayP1:GetChildren().Meter:addx(-4);
					children.StepsDisplayP1:GetChildren().StepsType:zoom(0.82);
				end;
			end;
		end;
	end;
};

t.InitCommand=cmd(SetUpdateFunction,Update);
return t
