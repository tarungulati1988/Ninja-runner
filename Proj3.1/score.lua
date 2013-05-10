
local fileName="score.json"

local tab={}
local json = require( "json" )
function scoreUpdate(level,score,replayData)
print("score Update ",level,score,type(level))
	local M=require("loadsave")
	local t=nil
	t=M.loadTable(fileName)
  print(t,M)
	if t then		
		for k,v in pairs(t["scoredata"]) do
			
			if(v["level"]==level  ) then
				if(v["highscore"]<score) then
				v["highscore"]=score
				v["isSync"]=0
				v["replayData"]=replayData --json.encode( replayData)
				print("high score updated!!");		
				M.saveTable(t,fileName)
				return				
				else
					print("less score")
					return
				end
			end			
		end
					local r={}				
					r["level"]=level
					r["highscore"]=score
					r["isSync"]=0
					r["replayData"]=replayData --json.encode( replayData)
					--t["scoredata"]={r}
					table.insert(t["scoredata"],r)
					print("new score inserted")
		
					M.saveTable(t,fileName)
					return
				
	else
		
		local r={}
		
		r["level"]=level
		r["highscore"]=score
		r["isSync"]=0
		r["replayData"]=replayData--json.encode( replayData)
		tab["scoredata"]={r}
		
		M.saveTable(tab,fileName)
		print ("score file created and updated!!!")
		return
	end
	
  
end

function selectReplay(levelID,replayFileName)
	print("inside select Replay",levelID,replayFileName,type(levelID))
	local M=require("loadsave")
	local t=nil
	if(replayFileName~=nil) then
		t=M.loadTable(replayFileName)
		return t.replayData
	else
		t=M.loadTable(fileName)
		print("replay table contents",t)
		if(t~=nil) then
		for k,v in pairs(t["scoredata"]) do
			print(k,v["level"],type(levelID))
			if(v["level"]==levelID  ) then
				
				return v.replayData			
			end
		end
		
		return nil
		else
			print("replay content table throwing nil value")
			return nil
		end
		
	end
	
	
end
