repeat task.wait() until game:IsLoaded() 
if isfolder("testlib") and isfile("testlib/games/"..game.PlaceId..".lua") then 
	loadstring(readfile("testlib/games/"..game.PlaceId..".lua"))()
	elseif not game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/games/"..game.PlaceId) == "404: Not Found" then 
		loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/games/"..game.PlaceId, true))()
	else 
	loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/anyGame", true))()
end 