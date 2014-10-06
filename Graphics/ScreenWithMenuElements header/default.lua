local t = Def.ActorFrame {};

t[#t+1] = LoadActor("Header") .. {
	InitCommand=cmd(vertalign,top;zoomtowidth,SCREEN_WIDTH+1;diffuse,color("#ffd400"));
};
--[[ t[#t+1] = LoadActor("_texture stripe") .. {
	InitCommand=cmd(vertalign,top;zoomto,SCREEN_WIDTH+64,44;customtexturerect,0,0,SCREEN_WIDTH+64/8,44/32);
	OnCommand=cmd(fadebottom,0.8;texcoordvelocity,1,0;skewx,-0.0025;diffuse,Color("Black");diffusealpha,0.235);
}; --]]
t[#t+1] = LoadFont("Common Normal") .. {
	Name="HeaderText";
	Text=Screen.String("HeaderText");
	InitCommand=cmd(x,-SCREEN_CENTER_X+24;y,24;zoom,1;horizalign,left;shadowlength,0;maxwidth,200);
	OnCommand=cmd(skewx,-0.125;strokecolor,Color("Outline");diffusebottomedge,color("0.875,0.875,0.875"));
	UpdateScreenHeaderMessageCommand=function(self,param)
		self:settext(param.Header);
	end;
};


t[#t+1] = LoadFont("Common Normal") .. {
	Name="HeaderSubText";
	Text='';
	InitCommand=cmd(x,-SCREEN_CENTER_X+24;y,38;zoom,0.55;horizalign,left;shadowlength,0;maxwidth,500;playcommand,"Update");
	OnCommand=cmd(skewx,-0.125;strokecolor,Color("Outline");diffusebottomedge,color("0.875,0.875,0.875"));
	UpdateCommand=function(self)
		if ScreenString("HeaderSubText") then
			self:settext(ScreenString("HeaderSubText"))
		end;
	end;
};



t[#t+1] = LoadFont("Common Normal") .. {
	Name="SongPath";
	Text="";
	InitCommand=cmd(x,-SCREEN_CENTER_X+6;y,10;zoom,0.45;horizalign,left;shadowlength,0;maxwidth,675;playcommand,"Refresh");
	OnCommand=cmd(skewx,-0.0;strokecolor,Color("Outline");diffusebottomedge,color("0.875,0.875,0.875"));
	CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
	OutCommand=function(self)
		self:settext("");
	end;
	RefreshCommand=function(self)
		--if ScreenSelectMusic:GetMusicWheel():GetSelectedType() == 'WheelItemDataType_Song' then
			local sText = "";
			if GAMESTATE:GetCurrentSong() then
				--local sText = getenv
				local song = GAMESTATE:GetCurrentSong();
				sText = "[ "..GAMESTATE:GetCurrentSong():GetGroupName().."/"..GAMESTATE:GetCurrentSong():GetDisplayMainTitle().." ]";
			end;
			local topScreen = SCREENMAN:GetTopScreen()
			if topScreen then
				local screenName = topScreen:GetName()
				if screenName == "ScreenSelectMusic" then
					if topScreen:GetMusicWheel():GetSelectedType() ~= 'WheelItemDataType_Song' then
						local index = topScreen:GetMusicWheel():GetCurrentIndex();
						sText = "[ "..topScreen:GetMusicWheel():GetWheelItem(0+6):GetText().." ]";
					end;
				end;
				if screenName == "ScreenNetSelectMusic" then
					--local selectMusic = topScreen.ScreenSelectMusic;
					--local t = topScreen:GetChildren();
					--for key,value in pairs(t) do
						--sText = sText .. " " .. key;
					--end;
					local MusicWheel = topScreen:GetChild("MusicWheel");
					if MusicWheel then
						if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
							local index = MusicWheel:GetCurrentIndex();
							sText = "[ "..MusicWheel:GetWheelItem(0+6):GetText().." ]";
						end;
					end;
				end;
				if screenName ~= "ScreenEvaluation" and  screenName ~= "ScreenNetEvaluation" then
					self:maxwidth(1850);
				end;
				if screenName == "ScreenNetRoom" then
					sText = "";
				end;
			end;
			self:settext( sText );
	end;
};






return t