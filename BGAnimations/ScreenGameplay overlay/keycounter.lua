local gamemode = GAMESTATE:GetCurrentGame():GetName()
local gamestyle = GAMESTATE:GetCurrentStyle():GetName()
--SCREENMAN:SystemMessage(gamestyle)
local cols = 0
local taps = {}
local tapsOld = {}
local tapsFlash = {}
local tapsFlashOld = {}
local tapsAlias = {}

local quadColor = "#ffdd55"
local diffuseColor = "#33333300"
local spacing = 35
local positionX = SCREEN_CENTER_X*2 - (SCREEN_WIDTH*0.4) + 20
local positionY = SCREEN_BOTTOM
local frameWidth = 30
local frameHeight = 35

if gamemode == "dance" then
	if gamestyle == "single" then
		cols = 4
		tapsAlias[0] = "Left"
		tapsAlias[1] = "Down"
		tapsAlias[2] = "Up"
		tapsAlias[3] = "Right"
	end;
	if gamestyle == "solo" then
		cols = 6
		tapsAlias[0] = "Left"
		tapsAlias[1] = "UpLeft"
		tapsAlias[2] = "Down"
		tapsAlias[3] = "Up"
		tapsAlias[4] = "UpRight"
		tapsAlias[5] = "Right"
	end;
end;
if gamemode == "pump" then
	if gamestyle == "single" then
		cols = 5
		tapsAlias[0] = "DownLeft"
		tapsAlias[1] = "UpLeft"
		tapsAlias[2] = "Center"
		tapsAlias[3] = "UpRight"
		tapsAlias[4] = "DownRight"
	end;
end;

for i=0,cols do
	taps[i] = 0
	tapsOld[i] = 0
	tapsFlash[i] = 0
	tapsFlashOld[i] = 0
end;

local function input(event)
	local topScreen = SCREENMAN:GetTopScreen();
	local KeyCounter = topScreen:GetChildren().Overlay:GetChildren().KeyCounter;
	local c = KeyCounter:GetChildren();
	if event.PlayerNumber == "PlayerNumber_P2" then
		return true;
	end;
	if event.type == "InputEventType_FirstPress" then
		for k,v in pairs(tapsAlias) do
			if event.button == v then
				taps[k] = taps[k]+1
				tapsFlash[k] = 1
			end;
		end;
	end;
	if event.type == "InputEventType_Release" then
		for k,v in pairs(tapsAlias) do
			if event.button == v then
				tapsFlash[k] = 0
			end;
		end;
	end;
	--SCREENMAN:SystemMessage(event.button)
	return true;
end

local function Update(self)
	for i=0,cols do
		if tapsOld[i] ~= taps[i] then
			self:GetChild("col"..tostring(i)):GetChild("TextField"):settext(taps[i])
			tapsOld[i] = taps[i]
		end
		if tapsFlashOld[i] ~= tapsFlash[i] then
			if tapsFlash[i] == 1 then
				self:GetChild("col"..tostring(i)):GetChild("QuadField"):diffusealpha(0.6)
			else
				self:GetChild("col"..tostring(i)):GetChild("QuadField"):diffusealpha(0.3)
			end;
			tapsFlashOld[i] = tapsFlash[i]
		end;
	end;
end;

local t = Def.ActorFrame{
	Name="KeyCounter";
	OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(input) end;
};

local function createColActor(index)
	local t = Def.ActorFrame {
		InitCommand=function(self)
			self:addx(index*spacing);
		end;
		Name="col"..tostring(index);
		LoadFont("Common normal") .. {
			Name="TextField";
			InitCommand=cmd(zoom,0.5;halign,0.5;valign,0.5;horizalign,center;maxwidth,frameWidth*2);
			OnCommand=cmd(diffuse,color("0.7,0.7,0.7,1");strokecolor,color("#000000"));
			Text="0";
		};
		Def.Quad{
			Name="QuadField";
			InitCommand=cmd(zoomto,frameWidth,frameHeight;halign,0.5;valign,0.5;diffuse,color(quadColor);diffusealpha,0.3;diffusebottomedge,color(diffuseColor));
		};
	};
	return t;	
end;

for i=0,cols-1 do
	t[#t+1] = createColActor(i)
end;

t.InitCommand=function(self)
	if IsUsingWideScreen() then
		self:xy(positionX, positionY);
	else
		self:xy(positionX, positionY);
	end;
	self:linear(0.02);
	self:addy(-(frameHeight/2+5));
	self:SetUpdateFunction(Update);
	self:SetUpdateRate( 1/30 );
end;

return t;