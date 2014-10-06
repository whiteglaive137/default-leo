--[[ these are only useful if you remember to copy the scripts
from Graphics/_common/ as well as Scripts/Fonts.lua.
In addition to that, you have to rename fonts... not fun. you probably shouldn't
use this file in your themes. -aj ]]

-- used to choose between normal size and doubleres fonts
function AutoText(fontName,override)
	if override then
		return LoadActor( THEME:GetPathG("","_common/AutoText"), {fontName, override});
	else
		return LoadActor( THEME:GetPathG("","_common/AutoText"), fontName);
	end;
end;

function HDActor(element,override)
	if override then
		return LoadActor( THEME:GetPathG("","_common/HDActor"), {element, override});
	else
		return LoadActor( THEME:GetPathG("","_common/HDActor"), element);
	end;
end;

ScreenString = Screen.String
ScreenMetric = Screen.Metric