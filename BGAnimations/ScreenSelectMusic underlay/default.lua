local t = Def.ActorFrame{};

local function SpriteOff( self )
	(cmd(linear,0.1;diffusealpha,0))(self);
end;

local songdir = "";
local bnpath = "";
local offBanner = true;
local nobanner = false;


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
		BeginCommand=cmd(playcommand,"Set";sleep,0.9;queuecommand,"Begin");
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



return t;
