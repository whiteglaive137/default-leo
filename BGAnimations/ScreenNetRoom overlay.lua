local t =  Def.ActorFrame {
	BeginCommand = function(self)
		--dfwjiodf
		if IsUsingWideScreen() == false then
			local topScreen = SCREENMAN:GetTopScreen();
			if topScreen then
				local screenName = topScreen:GetName();
				if screenName == "ScreenNetRoom" then
					local children = topScreen:GetChildren();
					children.ChatOutput:addx(-15);
					children.ChatInput:addx(-15);
				end;
			end;
		end;
	end;
};

return t;