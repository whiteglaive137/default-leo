local t = Def.ActorFrame{
	InitCommand=cmd(fov,70);
	LoadActor("_arrow")..{
		InitCommand=cmd(x,225;);
		OnCommand=cmd(wag;effectmagnitude,0,0,16;effectperiod,2.5;);
	};
	LoadActor("_text");
	LoadActor("_text")..{
		Name="TextGlow";
		InitCommand=cmd(blend,Blend.Add;diffusealpha,0.05;);
		OnCommand=cmd(glowshift;effectperiod,2.5;effectcolor1,color("1,1,1,0.25");effectcolor2,color("1,1,1,1"););
	};
	LoadActor("_author")..{
		InitCommand=cmd(x,129;y,30;zoom,0.5);
	};
	
};

return t;
