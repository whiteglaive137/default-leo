return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self)
			if IsUsingWideScreen() then
				self:zoomto(THEME:GetMetric(Var "LoadingScreen","ChatInputBoxWidth"),THEME:GetMetric(Var "LoadingScreen","ChatInputBoxHeight"));
			else
				self:zoomto(THEME:GetMetric(Var "LoadingScreen","ChatInputBoxWidth")+10,THEME:GetMetric(Var "LoadingScreen","ChatInputBoxHeight"));
				self:addx(-10);
			end;
			
			self:diffuse(color("0,0,0,0.85"));
		end;
		-- cmd(zoomto,THEME:GetMetric(Var "LoadingScreen","ChatInputBoxWidth"),THEME:GetMetric(Var "LoadingScreen","ChatInputBoxHeight");diffuse,color("0,0,0,0.85"));
	};
};