-- This actor is duplicated.  Upvalues will not be duplicated.

local grades = {
	Grade_Tier01 = 0;
	Grade_Tier02 = 1;
	Grade_Tier03 = 2;
	Grade_Tier04 = 3;
	Grade_Tier05 = 4;
	Grade_Tier06 = 5;
	Grade_Tier07 = 6;
	Grade_Failed = 7;
	Grade_None = 8;
};

--[[ local t = LoadActor( "grades" ) .. {
	InitCommand=cmd(pause);
	SetGradeCommand=function(self, params)
		local state = grades[params.Grade] or grades.Grade_None;
		state = state*2;

		if params.PlayerNumber == PLAYER_2 then
			state = state+1;
		end

		self:setstate(state);
	end;
}; --]]


local song = nil;
local t = Def.ActorFrame{
			
			LoadFont("Common Normal") .. {
				InitCommand=cmd(zoom,0.75;shadowlength,1;strokecolor,Color("Black"));
				ShowCommand=cmd(stoptweening;bounceend,0.15;zoomy,0.75);
				HideCommand=cmd(stoptweening;bouncebegin,0.15;zoomy,0);
				SetGradeCommand=function(self,params)
					local pnPlayer = params.PlayerNumber;
					local sGrade = params.Grade or 'Grade_None';
					local gradeString = THEME:GetString("Grade",string.sub(sGrade,7));

					self:settext(gradeString);
					self:diffuse(PlayerColor(pnPlayer));
					self:diffusetopedge(BoostColor(PlayerColor(pnPlayer),1.5));
					self:strokecolor(BoostColor(PlayerColor(pnPlayer),0.25));
					
			--[[ 		if sGrade == "Grade_NoTier" then
						self:playcommand("Hide");
					else
						self:playcommand("Show");
					end; --]]
				end;
			};
			-- LoadFont("Common Normal") .. {
				-- InitCommand=cmd(xy,0,5,zoom,0.3;shadowlength,1;strokecolor,Color("Black"));
				-- ShowCommand=cmd(stoptweening;bounceend,0.15;zoomy,0.75);
				-- HideCommand=cmd(stoptweening;bouncebegin,0.15;zoomy,0);
				-- SetCommand=function(self,params)
					-- if params.Song then
						-- song = params.Song;
					-- end;
				-- end;
				-- SetGradeCommand=function(self,params)
					-- local pnPlayer = params.PlayerNumber;
					-- local sGrade = params.Grade or 'Grade_None';
					-- local gradeString = THEME:GetString("Grade",string.sub(sGrade,7));
					
					-- if gradeString == "" then
						-- self:settext("");
					-- else
					
						-- local pn;
						
						-- if params.PlayerNumber == "PlayerNumber_P1" then 
							-- pn = PLAYER_1;
						-- else
							-- pn = PLAYER_2;
						-- end;
						
						-- local profile;
						
						-- if PROFILEMAN:IsPersistentProfile(params.PlayerNumber) then
							-- profile = PROFILEMAN:GetProfile(params.PlayerNumber);
						-- else
							-- profile = PROFILEMAN:GetMachineProfile();
						-- end;
						
						-- local steps;
						-- steps = GAMESTATE:GetCurrentSteps(pn);
						
						-- if song ~= nil and profile ~= nil and steps ~= nil then
							
							-- local stepsType = steps:GetStepsType();
							-- local stepsDifficulty = steps:GetDifficulty();
							-- local localSteps = song:GetOneSteps(stepsType,stepsDifficulty);
							
							-- if localSteps ~= nil then
								-- --SCREENMAN:SystemMessage(localSteps:GetFilename())--GetFilename
								-- local scorelist = profile:GetHighScoreList(song,localSteps);
								
								-- local scores = scorelist:GetHighScores();
								-- local topscore = scores[1];
								-- if topscore then
									-- local hs = {};
									-- hs["PercentDP"]						= string.format("%.2f%%", topscore:GetPercentDP()*100.0);
										-- if hs["PercentDP"]=="100.00%" then hs["PercentDP"] = "100%"; end;
									
									-- self:settext(song:GetDisplayMainTitle().. " "..hs["PercentDP"]);
								-- else
								
								-- end;
							-- end;
						-- end;
						-- self:diffuse(PlayerColor(pnPlayer));
						-- self:diffusetopedge(BoostColor(PlayerColor(pnPlayer),1.5));
						-- self:strokecolor(BoostColor(PlayerColor(pnPlayer),0.25));			
					-- end;

					
				-- end;
			-- };
		};

return t;

-- (c) 2007 Glenn Maynard
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.
