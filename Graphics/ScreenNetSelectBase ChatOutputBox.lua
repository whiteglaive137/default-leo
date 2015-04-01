return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(self)
			if IsUsingWideScreen() then
				self:zoomto(THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxWidth"),THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxHeight"));
			else
				self:zoomto(THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxWidth")+10,THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxHeight"));
				self:addx(-10);
			end;
			
			self:diffuse(color("0,0,0,0.85"));
		end;
		-- cmd(zoomto,THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxWidth"),THEME:GetMetric(Var "LoadingScreen","ChatOutputBoxHeight");diffuse,color("0,0,0,0.85"));
	};
};