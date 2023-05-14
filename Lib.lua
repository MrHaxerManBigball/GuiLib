if not game:IsLoaded() then game.Loaded:Wait() end 
local loadingGui 
if not gethui then loadingGui = game:GetService("CoreGui") else loadingGui = gethui() end 
if getgenv().executed then return error("Already Executed") end 
if not isfolder("testlib") then makefolder("testlib") end 
if not isfolder("testlib/config") then makefolder("testlib/config") end 
if not isfolder("testlib/games") then makefolder("testlib/games") end
if not isfolder("testlib/config/"..game.PlaceId) then makefolder("testlib/config/"..game.PlaceId) end 
if not isfolder("testlib/config/"..game.PlaceId.."/Modules") then makefolder("testlib/config/"..game.PlaceId.."/Modules") end 
if not isfolder("testlib/config/"..game.PlaceId.."/DropDowns") then makefolder("testlib/config/"..game.PlaceId.."/DropDowns") end 
if not isfolder("testlib/config/"..game.PlaceId.."/Binds") then makefolder("testlib/config/"..game.PlaceId.."/Binds") end 
getgenv().executed = true
getgenv().canSave = true 
local guiLib = {}
guiLib.moduletable = {}
local Players = game:GetService("Players") 
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local config = {}
local currentlyBinding
if isfile("testlib/config/"..game.PlaceId.."/Modules/Main.txt") then 
	config.Modules = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Modules/Main.txt"))
else 
	config.Modules = {}
	writefile("testlib/config/"..game.PlaceId.."/Modules/Main.txt" , http:JSONEncode(config.Modules))
end 
if isfile("testlib/config/"..game.PlaceId.."/Dropdowns/Main.txt") then 
	config.Dropdowns = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Dropdowns/Main.txt"))
else 
	config.Dropdowns = {}
	writefile("testlib/config/"..game.PlaceId.."/Binds/Main.txt" , http:JSONEncode(config.Dropdowns))
end 
if isfile("testlib/config/"..game.PlaceId.."/Binds/Main.txt") then 
	config.Binds = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Binds/Main.txt"))
else 
	config.Binds = {}
	writefile("testlib/config/"..game.PlaceId.."/Binds/Main.txt" , http:JSONEncode(config.Binds))
end 
function save(whichconfig) 
	writefile("testlib/config/"..game.PlaceId.."/"..whichconfig.."/Main.txt", http:JSONEncode(config[whichconfig]))
end 
function code(b) 
	b() 
end 
local letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", 1,2,3,4,5,6,7,8,9,0, "!", "@", "#","$","%","^","&","*","(",")","_","-","=","+", "|", "{", "}", ".", ",", ";", ":","<",">","'",'"', "`", "?","/", "\\",}
function guiLib:randomString(amount)
    local returnedString = ""
    for i = 1, math.random(amount) do 
        if math.random(2) == 2 then 
            returnedString = returnedString..string.lower(letters[math.random(#letters)])
        else 
            returnedString = returnedString..letters[math.random(#letters)]
        end 
    end 
    return returnedString
end

local lplr = Players.LocalPlayer
guiLib.isAlive = function(plr)
	return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").Health > 0 
end
function guiLib:Enabled(module)
	return guiLib.ModuleOn[tostring(module)] or false 
end 
guiLib.isTeammate =  function(plr) 
	return plr.Team == lplr.Team and lplr.Team
end

guiLib.functions = {}
function getModuleFunc(moduletofunc)
	local returnedFunc
	for i,v in next, guiLib.functions do 
		for i2,v2 in next, v do 
			if v.Name == moduletofunc then 
				returnedFunc = v["Function"]
				break
			end
		end 
	end
	return returnedFunc
end
local mouse = lplr:GetMouse()
guiLib.Boney = Instance.new("ScreenGui", loadingGui)
guiLib.Boney.Enabled = false 
local TextButton = Instance.new("TextButton")
guiLib.Boney.Name = guiLib:randomString(50)
guiLib.Boney.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
guiLib.Boney.ResetOnSpawn = false
local WorldWindow = Instance.new("TextLabel", guiLib.Boney)
WorldWindow.Name = guiLib:randomString(50)
WorldWindow.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
WorldWindow.BackgroundTransparency = 0.3
WorldWindow.Position = UDim2.new(0.0308897775, 0, 0.0302419364, 0)
WorldWindow.Size = UDim2.new(0, 200, 0, 50)
WorldWindow.Font = Enum.Font.Highway
WorldWindow.Text = "World"
WorldWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
WorldWindow.TextSize = 25
WorldWindow.Active = true 
WorldWindow.Draggable = true 
WorldWindow.BorderSizePixel = 0 
local CombatWindow = Instance.new("TextLabel", guiLib.Boney)
CombatWindow.Name = guiLib:randomString(50)
CombatWindow.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
CombatWindow.BackgroundTransparency = 0.3
CombatWindow.Position = UDim2.new(WorldWindow.Position) + UDim2.new(0.15,0,0.031)
CombatWindow.Size = UDim2.new(0, 200, 0, 50)
CombatWindow.Font = Enum.Font.Highway
CombatWindow.Text = "Combat"
CombatWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
CombatWindow.TextSize = 25
CombatWindow.Active = true 
CombatWindow.Draggable = true 
CombatWindow.BorderSizePixel = 0 
local UtilityWindow = Instance.new("TextLabel", guiLib.Boney)
UtilityWindow.Name = guiLib:randomString(50)
UtilityWindow.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
UtilityWindow.BackgroundTransparency = 0.3
UtilityWindow.Position = UDim2.new(WorldWindow.Position) + UDim2.new(0.3,0,0.031)
UtilityWindow.Size = UDim2.new(0, 200, 0, 50)
UtilityWindow.Font = Enum.Font.Highway
UtilityWindow.Text = "Utility"
UtilityWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
UtilityWindow.TextSize = 25
UtilityWindow.Active = true 
UtilityWindow.Draggable = true 
UtilityWindow.BorderSizePixel = 0 
local MovementWindow = Instance.new("TextLabel", guiLib.Boney)
MovementWindow.Name = guiLib:randomString(50)
MovementWindow.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
MovementWindow.BackgroundTransparency = 0.3
MovementWindow.Position = UDim2.new(WorldWindow.Position) + UDim2.new(0.45,0,0,40)
MovementWindow.Size = UDim2.new(0, 200, 0, 50)
MovementWindow.Font = Enum.Font.Highway
MovementWindow.Text = "Movement"
MovementWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
MovementWindow.TextSize = 25
MovementWindow.Active = true 
MovementWindow.Draggable = true
MovementWindow.BorderSizePixel = 0 
local RenderWindow = Instance.new("TextLabel", guiLib.Boney)
RenderWindow.Name = guiLib:randomString(50)
RenderWindow.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
RenderWindow.BackgroundTransparency = 0.3
RenderWindow.Position = UDim2.new(WorldWindow.Position) + UDim2.new(0.6,0,0,49)
RenderWindow.Size = UDim2.new(0, 200, 0, 50)
RenderWindow.Font = Enum.Font.Highway
RenderWindow.Text = "Render"
RenderWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
RenderWindow.TextSize = 25
RenderWindow.Active = true 
RenderWindow.Draggable = true 
RenderWindow.BorderSizePixel = 0 
ModuleAmmount = {}
guiLib.ModuleOn = {}
guiLib.DropDownValue = {"Value" == 0}
ModuleAmmount.WorldWindow = 0  
ModuleAmmount.CombatWindow = 0
ModuleAmmount.UtilityWindow = 0
ModuleAmmount.MovementWindow = 0
ModuleAmmount.RenderWindow = 0 
guiLib.disconnectfuncs = {}
local connection1, connection2, connection3, connection4, realwindow, wname, binds2
function guiLib:CreateModule(tbl)
	realwindow = nil
	table.insert(guiLib.moduletable, tbl.Name)
	table.insert(guiLib.functions, tbl)
	if tbl.Window == "World" then
		realwindow = WorldWindow
		wname = "WorldWindow"
	elseif tbl.Window == "Combat" then
		realwindow = CombatWindow 
		wname = "CombatWindow"
	elseif tbl.Window == "Utility" then 
		realwindow = UtilityWindow
		wname = "UtilityWindow"
	elseif tbl.Window == "Movement" then 
		realwindow = MovementWindow 
		wname = "MovementWindow"
	elseif tbl.Window == "Render" then 
		realwindow = RenderWindow
		wname = "RenderWindow"
	end 
	ModuleAmmount[wname] += 1
	local module = Instance.new("TextButton", realwindow or WorldWindow)
	local bindmenu = Instance.new("TextBox", realwindow)
	module.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	module.BackgroundTransparency = 0.5
	module.Position = UDim2.new(realwindow.Position) + UDim2.new(0,0,1 * ModuleAmmount[wname])
	module.Size = UDim2.new(0, 200, 0, 50)
	module.Font = Enum.Font.SourceSans
	module.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)
	module.TextColor3 = Color3.fromRGB(255, 255, 255)
	module.TextSize = 18
	module.TextXAlignment = "Left"
	module.Text = " "..tostring(tbl.Name)
	module.TextTransparency = 0 
	module.BorderSizePixel = 0 
	module.ZIndex = 0 
	module.Name = guiLib:randomString(50)
	bindmenu.Name = guiLib:randomString(50)
	bindmenu.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	bindmenu.BackgroundTransparency = 1
	bindmenu.Position = UDim2.new(module.Position) + UDim2.new(0,0,1.5)
	bindmenu.Size = UDim2.new(0, 0, 0, 0)
	bindmenu.Font = Enum.Font.SourceSans
	bindmenu.TextStrokeColor3 = Color3.fromRGB(255, 0, 255)
	bindmenu.TextColor3 = Color3.fromRGB(255, 255, 255)
	bindmenu.TextSize = 18
	bindmenu.Text = ""
	bindmenu.TextXAlignment = "Left"
	bindmenu.TextTransparency = 0 
	bindmenu.BorderSizePixel = 0 
	bindmenu.TextTransparency = 1
		if config.Modules[tbl.Name] == "true" then
			guiLib:Enable(tbl.Name, "dont notify mannnnnn") 
		else 	
			guiLib.ModuleOn[tbl.Name] = false
			if tbl.Name ~= "Uninject" and getgenv().canSave then 
				config.Modules[tbl.Name] = "false"
				save("Modules")
			end 
		end
		table.insert(guiLib.disconnectfuncs, module.MouseButton1Down:Connect(function(func) 
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then 
			if bindmenu.Size == UDim2.new(0, 0, 0, 0) and not currentlyBinding then 
				currentlyBinding = true 
				bindmenu.Size = UDim2.new(0, 100, 0, 50)
				bindmenu.BackgroundTransparency = 0.3 
				bindmenu.TextTransparency = 0 
				bindmenu.ZIndex = 500
				bindmenu.Text = config.Binds[tbl.Name]
				task.spawn(function()
					repeat task.wait() until (not uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.Return)) and not uis:GetFocusedTextBox()
					if not bindmenu.Text:upper():match("[^a-zA-Z]+") and bindmenu.Text ~= "" then 
						guiLib:Notify("Binds", "Bound "..tbl.Name.." to "..string.sub(bindmenu.Text, 1, 1):upper(), 3)
						config.Binds[tbl.Name] = string.sub(bindmenu.Text, 1, 1):upper()
						save("Binds")
					elseif bindmenu.Text == "" then 
						guiLib:Notify("Binds", "Unbound "..tbl.Name.."!", 3)
						config.Binds[tbl.Name] = ""
						save("Binds")
					else 
						guiLib:Notify("Binds", "Enter an ALPHABETICAL\n character....", 3)
					end
					currentlyBinding = false
					bindmenu.Size = UDim2.new(0, 0, 0, 0)
					bindmenu.BackgroundTransparency = 1 
					bindmenu.TextTransparency = 1
					bindmenu.ZIndex = 0
				end)
			end
		else 
			if guiLib:Enabled(tbl.Name) then 
				guiLib:Disable(tbl.Name)
			else 
				guiLib:Enable(tbl.Name)
			end 
		end
	end))
	if not config.Binds[tbl.Name] and getgenv().canSave then 
		config.Binds[tbl.Name] = "" 
		save("Binds") 
	end 
	table.insert(guiLib.disconnectfuncs, uis.InputBegan:Connect(function(input) 
		if config.Binds[tbl.Name] ~= "" and input.KeyCode == Enum.KeyCode[config.Binds[tbl.Name]] and not uis:GetFocusedTextBox() then 
			if guiLib:Enabled(tbl.Name) then 
				guiLib:Disable(tbl.Name)
				if tbl.Name ~= "Uninject" and getgenv().canSave then 
					config.Modules[tbl.Name] = "false"
					save("Modules")
				end
			else 
				guiLib:Enable(tbl.Name)
				if tbl.Name ~= "Uninject" and getgenv().canSave then 
					config.Modules[tbl.Name] = "true"
					save("Modules")
				end 
			end 
		end
	end))
end 
local TabAmount = {}
local gottenModule
function guiLib:GetModule(mname) 
	for i,v in next, guiLib.Boney:GetDescendants() do 
		if v:IsA("TextButton") and v.Text == " "..mname then
			gottenModule = v 
			break
		end
	end
	return gottenModule
end
function guiLib:CreateDropDown(tbl2)
    local realModule = tbl2.Module
	repeat task.wait() until guiLib:GetModule(realModule)
	if not TabAmount[realModule] then TabAmount[realModule] = 0 end 
	if not guiLib.DropDownValue[realModule] then guiLib.DropDownValue[realModule] = {} end 
	local module = guiLib:GetModule(realModule)
    TabAmount[realModule] +=1
	local dropdownText = Instance.new("TextLabel", realwindow)
	local dropdown2 = Instance.new("TextBox", dropdownText) 
	dropdownText.Position = UDim2.new(module.Position) + UDim2.new(0,0,2 * (TabAmount[realModule]))
	dropdownText.TextSize = 10
	dropdownText.Text = tbl2.Name..": "
	dropdownText.BackgroundTransparency = 0.9
	dropdownText.BorderSizePixel = 0 
	dropdownText.TextTransparency = 1
	dropdownText.LayoutOrder = 0
	dropdownText.Size = UDim2.new(0,0,0)
	dropdownText.Name = guiLib:randomString(50)
	dropdownText.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	dropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)

	dropdown2.Position = UDim2.new(dropdownText.Position) + UDim2.new(0,0,1) 
	dropdown2.TextSize = 10
	dropdown2.BackgroundTransparency = 0.6 
	dropdown2.BorderSizePixel = 0 
	dropdown2.TextTransparency = 1
	dropdown2.TextEditable = false 
	dropdown2.LayoutOrder = 0
	dropdown2.Size = UDim2.new(0,0,0)
	dropdown2.Name = guiLib:randomString(50)
	dropdown2.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	dropdown2.TextColor3 = Color3.fromRGB(255, 255, 255)
	if not guiLib.DropDownValue[realModule[tbl2.Module..tbl2.Name]] then 
		guiLib.DropDownValue[realModule][tbl2.Module..tbl2.Name] = 0 
	end
	if tbl2.Default then 
		if config.Dropdowns[tbl2.Module..tbl2.Name] and config.Dropdowns[tbl2.Module..tbl2.Name] ~= "" then 
			guiLib.DropDownValue[realModule][tbl2.Module..tbl2.Name] = config.Dropdowns[tbl2.Module..tbl2.Name]
		else 
			guiLib.DropDownValue[realModule][tbl2.Module..tbl2.Name] = tbl2.Default
			if getgenv().canSave then 
				config.Dropdowns[tbl2.Module..tbl2.Name] = tbl2.Default
				save("Dropdowns")
			end
		end 
	end
	table.insert(guiLib.disconnectfuncs, dropdown2:GetPropertyChangedSignal("Text"):Connect(function(balling) 
		pcall(function())
			if dropdown2 and dropdown2.Text and tbl2.Type and string.lower(tbl2.Type) == "number" and dropdown2.Text and tbl2 and typeof(dropdown2.Text) == tbl2.Type and tbl2.Min and tonumber(dropdown2.Text) < tbl2.Min then 
				dropdown2.Text = tbl2.Min
			elseif string.lower(tbl2.Type) == "number" and dropdown2 and dropdown2.Text and dropdown2.Text ~= "" and typeof(dropdown2.Text) == "number" and tbl2 and tbl2.Max and tonumber(dropdown2.Text) > tonumber(tbl2.Max) then
				dropdown2.Text = tbl2.Max
			end 
			repeat task.wait() until not uis:GetFocusedTextBox() 
			if tbl2.Function and dropdown2.Text ~= "" then 
				code(tbl2.Function) 
			end
			if getgenv().canSave then 
				config.Dropdowns[tbl2.Module..tbl2.Name] = dropdown2.Text
				save("Dropdowns")
			end
		end)
	end)) 
	table.insert(guiLib.disconnectfuncs, module.MouseButton2Down:Connect(function(right) 
		table.insert(guiLib.disconnectfuncs, connection2)
		if dropdown2.TextEditable then 
			dropdown2.BackgroundTransparency = 1 
			dropdown2.TextTransparency = 1
			dropdown2.TextEditable = false  
			dropdown2.Selectable = false 
			module.TextSize = 18
			dropdown2.Size = UDim2.new(0,0,0)

			dropdownText.BackgroundTransparency = 1 
			dropdownText.TextTransparency = 1
			dropdownText.Selectable = false 
			dropdownText.Size = UDim2.new(0,0,0)
			dropdownText.ZIndex = 1
		else 
			dropdown2.Text = config.Dropdowns[tbl2.Module..tbl2.Name]
			dropdown2.BackgroundTransparency = 0 
			dropdown2.TextTransparency = 0
			dropdown2.TextEditable = true 
			dropdown2.Selectable = true
			dropdown2.Size = UDim2.new(0, 200, 0, 50)
			dropdownText.ZIndex = 5
			module.TextSize = 15

			dropdownText.Text = tbl2.Name..": "
			dropdownText.BackgroundTransparency = 0.6
			dropdownText.TextTransparency = 0
			dropdownText.Selectable = true
			dropdownText.Size = UDim2.new(0, 200, 0, 50)
		end 
	end))
end 
function guiLib:GetDropDownValue(dropped, dropname) 
	return config.Dropdowns[dropped..dropname]
end 
function guiLib:Disable(disablemodule, displaydisablenotification)
	guiLib.ModuleOn[disablemodule] = false 
	for i,v in next, guiLib.Boney:GetDescendants() do 
		if v:IsA("TextButton") and v.Text == " "..disablemodule then 
			v.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
			if not displaydisablenotification then guiLib:Notify(disablemodule, "Disabled", 1) end
			if getgenv().canSave then 
                config.Modules[disablemodule] = "false"
				save("Modules")
			end
			task.spawn(code, getModuleFunc(disablemodule))
			break
		end 
	end 
end
function guiLib:Enable(enabledmodule, displayenablenotification)
	guiLib.ModuleOn[enabledmodule] = true 
	for i,v in next, guiLib.Boney:GetDescendants() do 
		if v:IsA("TextButton") and v.Text == " "..enabledmodule then 
			v.BackgroundColor3 = Color3.fromRGB(83, 33, 153)
			if not displayenablenotification then guiLib:Notify(enabledmodule, "Enabled", 1) end
			if enabledmodule ~= "Uninject" and getgenv().canSave then 
				config.Modules[enabledmodule] = "true"
				save("Modules")
			end 
			task.spawn(code, getModuleFunc(enabledmodule))
			break
		end 
	end 
end 
local notifications = 0
function guiLib:Notify(header, text, time, tweentime)
	task.spawn(function() 
		notifications += 1 
		local Notification = Instance.new("ScreenGui", loadingGui)
		local Frame = Instance.new("Frame", Notification)
		local Header = Instance.new("TextLabel", Frame)
		local Bottomtext = Instance.new("TextLabel", Frame)
		Notification.Name = guiLib:randomString(50)
		Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Frame.Name = guiLib:randomString(50)
		Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
		Frame.BackgroundTransparency = 0.6
		Frame.Position = UDim2.new(0.897371888, 0, 0.917338729, 0)
		Frame.Size = UDim2.new(0, 270, 0, 114)
		Header.Name = guiLib:randomString(50)
		Header.BackgroundColor3 = Color3.fromRGB(111, 128, 200)
		Header.BackgroundTransparency = 0.2
		Header.Position = UDim2.new(-0.00371747208, 0, 0, 0)
		Header.Size = UDim2.new(0, 270, 0, 39)
		Header.Font = Enum.Font.SourceSans
		Header.Text = header or "Header"
		Header.TextColor3 = Color3.fromRGB(0, 0, 0)
		Header.TextSize = 25
		Header.BorderSizePixel = 0.5

		Bottomtext.Name = guiLib:randomString(50)
		Bottomtext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Bottomtext.BackgroundTransparency = 1
		Bottomtext.Position = UDim2.new(0, 0, 0.342105269, 0)
		Bottomtext.Size = UDim2.new(0, 270, 0, 114)
		Bottomtext.Font = Enum.Font.SourceSans
		Bottomtext.Text = text or "Text"
		Bottomtext.TextColor3 = Color3.fromRGB(255, 255, 255)
		Bottomtext.TextSize = 25
		Bottomtext.TextXAlignment = Enum.TextXAlignment.Left
		Bottomtext.TextYAlignment = Enum.TextYAlignment.Top
		Bottomtext.BorderSizePixel = 0 
		Frame:TweenPosition(UDim2.new(0.85,0.1,0.8 - (notifications / 11.65),0.4), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, tweentime or 0.1, false) 
		task.wait(time - 0.2) 
		Frame:TweenPosition(UDim2.new(0.897371888, 0, 0.917338729, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, tweentime or 0.1, false)
		Notification:Destroy()
		notifications -= 1 
	end)
end
table.insert(guiLib.disconnectfuncs, lplr.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
        syn.queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/loader", true))()')
    end
end))
if uis.TouchEnabled then 
	guiLib:Notify("Josiah", "Tap the Boney Icon to\nopen GUI", 3)
	guiLib.whytheFUCK = Instance.new("ScreenGui", loadingGui)
	local josiah = Instance.new("TextButton", guiLib.whytheFUCK) 
	josiah.Name = guiLib:randomString(50)
	josiah.TextSize = 5
	josiah.Position = UDim2.new(1, -30, 0, 0)
	josiah.Text = "Boney"
	josiah.BorderSizePixel = 0
	josiah.Size = UDim2.new(0, 20, 0, 20)
	josiah.BackgroundTransparency = 0.5
	table.insert(guiLib.disconnectfuncs, josiah.MouseButton1Click:Connect(function() 
		guiLib.Boney.Enabled = not guiLib.Boney.Enabled
	end))
else 
	table.insert(guiLib.disconnectfuncs, uis.InputBegan:Connect(function(input) 
		if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Quote and not uis:GetFocusedTextBox() then 
			guiLib.Boney.Enabled = not guiLib.Boney.Enabled
		end 
	end))
	guiLib:Notify("Josiah", "Press Right-Shift to\nopen GUI", 3)
end

guiLib:CreateModule({
    Name = "Uninject", 
    Window = "Utility", 
    Function = function() 
        if guiLib:Enabled("Uninject") then 
            getgenv().canSave = false 
            for _,v in pairs(guiLib.moduletable) do 
                if v ~= "Uninject" and guiLib:Enabled(v) then 
                    guiLib:Disable(v, "dont even think about it")
                end 
            end 
            for _,v in pairs(guiLib.disconnectfuncs) do 
                v:Disconnect() 
            end 
            guiLib.functions = {}
            guiLib.Boney:Destroy()  
            guiLib.ModuleOn = {}
            guiLib.moduletable = {}
			shared.GuiLib = nil 
            getgenv().executed = false 
        end 
    end,
})
return guiLib

--[[ examples
local guiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/Lib.lua", true))()
guiLib:CreateModule({
	Name = "Test", 
	Window = "Utility", 
	Function = function() 
		if guiLib:Enabled("Test") then 
			if guiLib:GetDropDownValue("Test", "Balls") then 
				print(guiLib:GetDropDownValue("Test", "Balls")) -- will play when the module is enabled
			end 
		else 
			print('off') -- will play when module is disabled
		end
	end,
})

guiLib:CreateDropDown({
	Module = "Test",
	Name = "Balls", 
	Type = "number", 
	Min = 10, 
	Max = 50,
	Default = 150,
})


guiLib:CreateDropDown({
	Module = "Test",
	Name = "Balls2", 
	Type = "number", 
	Min = 10, 
	Max = 50,
	Default = 150,
})
]]
