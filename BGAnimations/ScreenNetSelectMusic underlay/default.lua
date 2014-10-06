local t = Def.ActorFrame{};

local function SpriteOff( self )
	(cmd(linear,0.1;diffusealpha,0))(self);
end;

local songdir = "";
local bnpath = "";
local offBanner = true;
local nobanner = false;
local groupBanner = true;


if GetUserPrefB("UserPrefNetSelectMusicBackgroundFavorite") then
	local file = FILEMAN:GetDirListing( THEME:GetCurrentThemeDirectory() .. "BGAnimations/ScreenNetSelectMusic underlay/backgrounds/" );
	if #file > 0 then
		t[#t+1] = LoadActor( "backgrounds/" .. file[math.random(#file)] ) .. {
			InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0.75);
		};
	end;
else
	local bgpath = "";
	local offBg = true;
	local nobg = false;

	t[#t+1] = Def.Sprite {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
		BeginCommand=cmd(playcommand,"Set";sleep,0.4;queuecommand,"Begin");
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				if song:HasBackground() then
					if song:GetBackgroundPath() == bgpath then
						if offBg then
							self:LoadBackground( bgpath );
							(cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;linear,0.01;diffusealpha,0.5;))(self);
							offBg = false;
						end;
					else
						if not offBg then
							SpriteOff(self);
							offBg = true;
						end;
						bgpath = song:GetBackgroundPath();
					end;
				elseif songdir == song:GetSongDir() then
					bgpath = GetSongExBackground( songdir );		-- 05 More.lua
					if bgpath ~= nil then
						if offBg then
							self:LoadBackground( bgpath );
							(cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT;linear,0.01;diffusealpha,0.4;))(self);
							offBg = false;
						end;
					elseif not offBg then
						SpriteOff(self);
						offBg = true;
					end;
				elseif not offBg then
					SpriteOff(self);
					offBg = true;
				end;
			elseif not offBg then
				SpriteOff(self);
				offBg = true;
			end;
		end;
	};
--[[
	t[#t+1] = LoadActor("../ScreenWithMenuElements background/_bg top") .. {
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+256,SCREEN_HEIGHT);
	};
]]
end;


t[#t+1] = Def.Sprite  {
	InitCommand=cmd(draworder,2222;x,SCREEN_CENTER_X-50;y,SCREEN_CENTER_Y+165;diffusealpha,1;playcommand,"Refresh");
	--BeginCommand=cmd(playcommand,"Set";sleep,0.2;queuecommand,"Begin");
	RefreshCommand=function(self)
		local topScreen = SCREENMAN:GetTopScreen();
		if topScreen then
			local screenName = topScreen:GetName();
			if screenName == "ScreenNetSelectMusic" then
				local MusicWheel = topScreen:GetChild("MusicWheel");
				if MusicWheel:GetSelectedType() ~= 2 then
					local bnpath = SONGMAN:GetSongGroupBannerPath(MusicWheel:GetWheelItem(0+6):GetText());

					if bnpath and bnpath ~= '' then
					self:LoadBanner( "/"..bnpath );
					(cmd(zoomtowidth,256;zoomtoheight,80;linear,0.01;diffusealpha,1;draworder,400;))(self);
						if groupBanner then
							groupBanner = false;
							
						end;
					else
						SpriteOff(self);
						groupBanner = true;
					end;	
				else
					SpriteOff(self);
					groupBanner = true;
				end;
			end;
		end;

		self:sleep(0.3);
		self:queuecommand("Refresh");
	end;
};


t[#t+1] = Def.Banner {
	InitCommand=cmd(draworder,2222;x,SCREEN_CENTER_X-50;y,SCREEN_CENTER_Y+165;diffusealpha,0);
	BeginCommand=cmd(playcommand,"Set";sleep,0.2;queuecommand,"Begin");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local group = false;
		
		if not group and song then
			if song:HasBanner() then
				if song:GetBannerPath() == bnpath then
					if offBanner then
						self:LoadBanner( bnpath );
						(cmd(zoomtowidth,256;zoomtoheight,80;linear,0.01;diffusealpha,1;draworder,300;))(self);
						offBanner = false;
					end;
				else
					if not offBanner then
						SpriteOff(self);
						offBanner = true;
					end;
					bnpath = song:GetBannerPath();
				end;
			elseif songdir == song:GetSongDir() then
				bnpath = GetSongExBanner( songdir );			-- 05 More.lua
				if bnpath ~= nil then
					if offBanner then
						self:LoadBanner( bnpath );
						(cmd(zoomtowidth,256;zoomtoheight,80;linear,0.01;diffusealpha,1;draworder,300;))(self);
						offBanner = false;
					end;
				elseif not offBanner then
					SpriteOff(self);
					offBanner = true;
				end;
			else
				if not offBanner then
					SpriteOff(self);
					offBanner = true;
				end;
			end;
			songdir = song:GetSongDir();
		elseif not offBanner then
			SpriteOff(self);
			offBanner = true;
		end;
	end;
};

local pn;
if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	pn = PLAYER_1;
else
	pn = PLAYER_2;
end;
local dx = 52;
local position = {
	Difficulty_Edit = 0,
	Difficulty_Beginner = dx,
	Difficulty_Easy = dx * 2,
	Difficulty_Medium = dx * 3,
	Difficulty_Hard = dx * 4,
	Difficulty_Challenge = dx * 5,
};

return t;
