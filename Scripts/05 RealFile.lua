-- 起動時処理（超重い） ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
local realFile = {};
local path = "DefaultMoreSave/RealFiles/";
local templist = FILEMAN:GetDirListing( path );
local pName = {};
for i=1, #templist do
	local length = string.len(templist[i]);
	local dirname = string.sub(templist[i], length-8);
	path2 = path .. templist[i] .. "/";
	if dirname == "RealFiles" then
		pName[i] = File.Read( path2.."_PlayerName" );
		if not pName[i] then
			pName[i] = string.sub(templist[i], 1, length-10);
		end;
	end;
	local file = FILEMAN:GetDirListing( path2 );
	for j=1, #file do
		local rFile = File.Read( path2..file[j] );
		local songOrCourseDir = string.lower(file[j]);
		if rFile then
			rFile = string.gsub(rFile, "[ \r\n]", "")
			local rDatas = split( ";", rFile )
			for k=1, #rDatas do
				local data = split( ",", rDatas[k]);
				realFile[data[1]..pName[i]..songOrCourseDir] = data;
			end
		end
	end;
end;

-- リアルファイルのプレイヤー名リスト ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function GetRealFilePlayerList()
	return pName;
end;

-- ターゲットのダンスポイントリスト ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function GetTargetDancePoint()
	local dplist = {}
	if File.Read( "DefaultMoreSave/DPList.txt" ) then
		local templist = split( ",", File.Read( "DefaultMoreSave/DPList.txt" ) )
		for i=1, #templist do
			local dpnum = tonumber(templist[i])
			if dpnum ~= nil and dpnum >= 0 and dpnum <= 100 then
				local exist = false
				for j=1, #dplist do
					if dpnum == dplist[j] then
						exist = true
					end
				end
				if not exist then
					dplist[#dplist+1] = dpnum
				end
			end
		end
	else
		dplist = { 100, 99.5, 99, 98, 97, 95, 90 }
		File.Write( "DefaultMoreSave/DPList.txt", "100, 99.5, 99, 98, 97, 95, 90" )
	end
	return dplist;
end;

-- リアルデータチェックキー ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function GetRealDataCheckKey( stepOrTrail, pn )
	local rv = stepOrTrail:GetRadarValues( pn )
	return (
		string.sub(GAMESTATE:GetPlayMode(),10) .. "/"
	..	string.sub(stepOrTrail:GetDifficulty(),12) .. "/"
	..	string.format("%i/%i/%i/%i/%i/%i",
			rv:GetValue("RadarCategory_TapsAndHolds"),
			rv:GetValue("RadarCategory_Jumps"),
			rv:GetValue("RadarCategory_Hands"),
			rv:GetValue("RadarCategory_Holds"),
			rv:GetValue("RadarCategory_Mines"),
			rv:GetValue("RadarCategory_Rolls")
		) .. "/"
	)
end

-- リアルデータテーブル ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
--[[
RealDataArray
	1	Key			(PlayMode / Difficulty / Steps / Jumps / Hands / Holds / Mines / Rolls / GPorDP)
	2	RealData
	3	count Marvelous
	4	count Perfect
	5	count Great
	6	count Good
	7	count Bad
	8	count Miss
	9	count Held
	10	count HitMine
	11	count LetGo
	12	count CheckpointHit
	13	count CheckpointMiss
	14	PerccentDP
	15	Score
	16	Date
	17	GradePoint	(CurrentGradePoint / MaxGradePoint)
	18	Grade
	19	ClearType
	20	TimingDifficulty
	21	LifeDifficulty
	22	PlayerOptions
	23	SongOptions
	24	MainTitle	(or CourseFullTitle)
	25	SubTitle
	26	Artist
	27	PlayerName
	#	PlayCount	(HighScore-Time / Total-Difficulty)
]]
-- リアルデータを取得 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function GetRealData( songOrCourse, playerName, ... )
	if not songOrCourse then
		return nil
	end
	local rDataArray = {}
	local key = { ... }
	local songOrCourseDirArray
	if GAMESTATE:IsCourseMode() then
		if songOrCourse:GetScripter() == "Autogen" then
			return rDataArray
		end
		songOrCourseDirArray = split("/", songOrCourse:GetCourseDir())
	else
		songOrCourseDirArray = split("/", songOrCourse:GetSongDir())
	end;
	local songOrCourseDir = string.lower(songOrCourseDirArray[#songOrCourseDirArray-1])..".txt"
	for i=1, #key do
		rDataArray[i] = realFile[key[i]..playerName..songOrCourseDir]
	end
	return rDataArray
end

-- リアルファイルランキングを取得 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function GetRFRanking( songOrCourse, key )
	local rDataList = {};
	if songOrCourse then
		local songOrCourseDirArray
		if GAMESTATE:IsCourseMode() then
			if songOrCourse:GetScripter() == "Autogen" then
				return rDataList
			end
			songOrCourseDirArray = split("/", songOrCourse:GetCourseDir())
		else
			songOrCourseDirArray = split("/", songOrCourse:GetSongDir())
		end;
		local songOrCourseDir = string.lower(songOrCourseDirArray[#songOrCourseDirArray-1])..".txt"
		local keyDP = key .. "DP";
		local keyGP = key .. "GP";
		for i=1, #pName do
			local tempRData = {
				realFile[keyDP..pName[i]..songOrCourseDir],
				realFile[keyGP..pName[i]..songOrCourseDir]
			};
			if tempRData[1] then
				rDataList[#rDataList+1] = tempRData[1];
				rDataList[#rDataList][27] = pName[i];
				if tempRData[2] then
					rDataList[#rDataList][17] = tempRData[2][17];
					rDataList[#rDataList][18] = tempRData[2][18];
					rDataList[#rDataList][19] = tempRData[2][19];
				end;
			elseif tempRData[2] then
				rDataList[#rDataList+1] = tempRData[2];
				rDataList[#rDataList][27] = pName[i];
			end;
		end;
		-- DPの降順に整理
		table.sort(rDataList,
			function(a, b)
				return(a[14] > b[14])
			end
		);
	end;
	return rDataList;
end

-- リアルデータを保存 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
function SetRealData( songOrCourse, playerName, key, data, isHighScore )
	local pdir = 
			"DefaultMoreSave/RealFiles/"
		..	playerName .. "_RealFiles/"
	local pNamePath = pdir .. "_PlayerName"
	if not File.Read( pNamePath ) then
		File.Write( pNamePath, playerName )
	end;
	if songOrCourse then
		local songOrCourseDirArray;
		if GAMESTATE:IsCourseMode() then
			if songOrCourse:GetScripter() == "Autogen" then
				return false
			end
			songOrCourseDirArray = split("/", songOrCourse:GetCourseDir())
		else
			songOrCourseDirArray = split("/", songOrCourse:GetSongDir())
		end;
		local songOrCourseDir = string.lower(songOrCourseDirArray[#songOrCourseDirArray-1])..".txt"
		local path = pdir .. songOrCourseDir
		local rFile = File.Read( path )
		local hsstr
		if rFile then
			rFile = string.gsub(rFile, "[ \r\n]", "")
			local exist = false
			local rData = split( ";", rFile )
			local str = ""
			for i=1, #rData do
				local part = split(",", rData[i])
				if part[1] == key then
					local pCount = split("/", part[#part])
					pCount[1], pCount[2] = tonumber(pCount[1]), tonumber(pCount[2]) + 1
					if isHighScore then
						str = str .. data .. "," .. pCount[2] .. "/" .. pCount[2] .. ";\r\n"
						hsstr = data .. "," .. pCount[2] .. "/" .. pCount[2]
					else
						for i=1, #part-1 do
							str = str .. part[i] .. ","
						end
						str = str .. pCount[1] .. "/" .. pCount[2] .. ";\r\n"
					end
					exist = true
				elseif rData[i] ~= "" then
					str = str .. rData[i] .. ";\r\n"
				end
			end
			if not exist then
				str = str .. data .. ",1/1;\r\n"
				hsstr = data..",1/1"
			end
			File.Write( path, str )
		else
			File.Write( path, data..",1/1;\r\n" )
			hsstr = data..",1/1"
		end
		if hsstr then
			realFile[key..playerName..songOrCourseDir] = split(",", hsstr)
			local hsPName
			for i=1, #pName do
				if pName[i] == playerName then
					hsPName = true
					break
				end
			end
			if not hsPName then
				pName[#pName+1] = playerName
			end
		end
		return true
	end
	return false
end

