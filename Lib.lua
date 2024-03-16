if not game:IsLoaded() then game.Loaded:Wait() end 
local loadingGui, queueteleport = nil, syn and syn.queue_on_teleport or queue_on_teleport
if not gethui then loadingGui = game:GetService("CoreGui") else loadingGui = gethui() end 
if getgenv().executed then return error("Already Executed") end 
if not isfolder("testlib") then makefolder("testlib") end 
if not isfolder("testlib/config") then makefolder("testlib/config") end
if not isfolder("testlib/games") then makefolder("testlib/games") end
if not isfolder("testlib/config/"..game.PlaceId) then makefolder("testlib/config/"..game.PlaceId) end 
getgenv().executed = true
getgenv().canSave = true 
local guiLib = {}
shared.GuiLib = guiLib
guiLib.moduletable = {}
local Players = game:GetService("Players") 
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local config = {}
shared.config = config
local currentlyBinding
if isfile("testlib/config/"..game.PlaceId.."/Config.lua") and http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Modules then 
	config.Modules = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Modules
	config.Binds = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Binds
	config.Dropdowns = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Dropdowns
	config.Hud = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Hud
	config.Toggleables = http:JSONDecode(readfile("testlib/config/"..game.PlaceId.."/Config.lua")).Toggleables
else 
	config.Modules = {}
	config.Dropdowns = {}
	config.Binds = {}
	config.Hud = {}
	config.Toggleables = {}
	writefile("testlib/config/"..game.PlaceId.."/Config.lua" , http:JSONEncode(config))
end 
guiLib.disconnectfuncs = {}
local enabledColor
if config.Hud and config.Hud.Enabled and config.Hud.Enabled ~= "" then 
	enabledColor = config.Hud.Enabled
end 
function save() 
	writefile("testlib/config/"..game.PlaceId.."/Config.lua", http:JSONEncode(config))
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
function guiLib:Enabled(module)
	return guiLib.ModuleOn[tostring(module)] or false 
end 
local rainbowUtil = math.random()
guiLib.functions = {}
function getModuleFunc(moduletofunc)
	local returnedFunc
	for i,v in next, guiLib.functions do 
		for i2,v2 in next, v do 
			if v.Name == moduletofunc then 
				returnedFunc = v.Function
				break
			end
		end 
	end
	return returnedFunc
end
function guiLib:GetDropDownValue(dropped, dropname) 
	return config.Dropdowns[dropped..dropname]
end 
if not config.Hud.Windows then config.Hud.Windows = {} end
local windowcolor = (config.Hud and config.Hud.Windows and guiLib:GetDropDownValue("HUD", "WindowColors(rgb)") and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[3])) or Color3.fromRGB(111, 128, 200)
local Transparency = (config.Hud and config.Hud.Transparency and guiLib:GetDropDownValue("HUD", "Transparency")) or 0.5
local mouse = lplr:GetMouse()
guiLib.Boney = Instance.new("ScreenGui", loadingGui)
guiLib.Boney.Enabled = false 
guiLib.Boney.Name = guiLib:randomString(50)
guiLib.Boney.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
guiLib.Boney.ResetOnSpawn = false
if not config.Hud.WindowPositions then config.Hud.WindowPositions = {} end 
if not config.Hud.WindowPositions.WorldWindow then config.Hud.WindowPositions.WorldWindow = "0.108897775, 0, 0.0302419364, 0" end
local WorldWindow = Instance.new("TextLabel", guiLib.Boney)
WorldWindow.Name = guiLib:randomString(50)
WorldWindow.BackgroundColor3 = windowcolor
WorldWindow.BackgroundTransparency = Transparency
WorldWindow.Position = UDim2.new(string.split(config.Hud.WindowPositions.WorldWindow, ",")[1], string.split(config.Hud.WindowPositions.WorldWindow, ",")[2], string.split(config.Hud.WindowPositions.WorldWindow, ",")[3], string.split(config.Hud.WindowPositions.WorldWindow, ",")[4])
WorldWindow.Size = UDim2.new(0, 200, 0, 50)
WorldWindow.Font = Enum.Font.Highway
WorldWindow.Text = "World"
WorldWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
WorldWindow.TextSize = 25
WorldWindow.Active = true 
WorldWindow.Draggable = true 
WorldWindow.BorderSizePixel = 0 
table.insert(guiLib.disconnectfuncs, WorldWindow:GetPropertyChangedSignal("Position"):Connect(function()
	config.Hud.WindowPositions.WorldWindow = string.gsub(string.gsub(tostring(WorldWindow.Position), "}", ""), "{", "")
	save()
end))
if not config.Hud.WindowPositions.CombatWindow then config.Hud.WindowPositions.CombatWindow = "0.3, 0, 0.0302419364, 0" end
local CombatWindow = Instance.new("TextLabel", guiLib.Boney)
CombatWindow.Name = guiLib:randomString(50)
CombatWindow.BackgroundColor3 = windowcolor
CombatWindow.BackgroundTransparency = Transparency
CombatWindow.Position = UDim2.new(string.split(config.Hud.WindowPositions.CombatWindow, ",")[1], string.split(config.Hud.WindowPositions.CombatWindow, ",")[2], string.split(config.Hud.WindowPositions.CombatWindow, ",")[3], string.split(config.Hud.WindowPositions.CombatWindow, ",")[4])
CombatWindow.Size = UDim2.new(0, 200, 0, 50)
CombatWindow.Font = Enum.Font.Highway
CombatWindow.Text = "Combat"
CombatWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
CombatWindow.TextSize = 25
CombatWindow.Active = true 
CombatWindow.Draggable = true 
CombatWindow.BorderSizePixel = 0 
table.insert(guiLib.disconnectfuncs, CombatWindow:GetPropertyChangedSignal("Position"):Connect(function()
	config.Hud.WindowPositions.CombatWindow = string.gsub(string.gsub(tostring(CombatWindow.Position), "}", ""), "{", "")
	save()
end))
if not config.Hud.WindowPositions.UtilityWindow then config.Hud.WindowPositions.UtilityWindow = "0.7, 0, 0.0302419364, 0" end
local UtilityWindow = Instance.new("TextLabel", guiLib.Boney)
UtilityWindow.Name = guiLib:randomString(50)
UtilityWindow.BackgroundColor3 = windowcolor
UtilityWindow.BackgroundTransparency = Transparency
UtilityWindow.Position = UDim2.new(string.split(config.Hud.WindowPositions.UtilityWindow, ",")[1], string.split(config.Hud.WindowPositions.UtilityWindow, ",")[2], string.split(config.Hud.WindowPositions.UtilityWindow, ",")[3], string.split(config.Hud.WindowPositions.UtilityWindow, ",")[4])
UtilityWindow.Size = UDim2.new(0, 200, 0, 50)
UtilityWindow.Font = Enum.Font.Highway
UtilityWindow.Text = "Utility"
UtilityWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
UtilityWindow.TextSize = 25
UtilityWindow.Active = true 
UtilityWindow.Draggable = true 
UtilityWindow.BorderSizePixel = 0 
table.insert(guiLib.disconnectfuncs, UtilityWindow:GetPropertyChangedSignal("Position"):Connect(function()
	config.Hud.WindowPositions.UtilityWindow = string.gsub(string.gsub(tostring(UtilityWindow.Position), "}", ""), "{", "")
	save()
end))

if not config.Hud.WindowPositions.MovementWindow then config.Hud.WindowPositions.MovementWindow = "0.5, 0, 0.0302419364, 0" end
local MovementWindow = Instance.new("TextLabel", guiLib.Boney)
MovementWindow.Name = guiLib:randomString(50)
MovementWindow.BackgroundColor3 = windowcolor
MovementWindow.BackgroundTransparency = Transparency
MovementWindow.Position = UDim2.new(string.split(config.Hud.WindowPositions.MovementWindow, ",")[1], string.split(config.Hud.WindowPositions.MovementWindow, ",")[2], string.split(config.Hud.WindowPositions.MovementWindow, ",")[3], string.split(config.Hud.WindowPositions.MovementWindow, ",")[4])
MovementWindow.Size = UDim2.new(0, 200, 0, 50)
MovementWindow.Font = Enum.Font.Highway
MovementWindow.Text = "Movement"
MovementWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
MovementWindow.TextSize = 25
MovementWindow.Active = true 
MovementWindow.Draggable = true
MovementWindow.BorderSizePixel = 0 
table.insert(guiLib.disconnectfuncs, MovementWindow:GetPropertyChangedSignal("Position"):Connect(function()
	config.Hud.WindowPositions.MovementWindow = string.gsub(string.gsub(tostring(MovementWindow.Position), "}", ""), "{", "")
	save()
end))
if not config.Hud.WindowPositions.RenderWindow then config.Hud.WindowPositions.RenderWindow = "0.9, 0, 0.0302419364, 0" end
local RenderWindow = Instance.new("TextLabel", guiLib.Boney)
RenderWindow.Name = guiLib:randomString(50)
RenderWindow.BackgroundColor3 = windowcolor
RenderWindow.BackgroundTransparency = Transparency
RenderWindow.Position = UDim2.new(string.split(config.Hud.WindowPositions.RenderWindow, ",")[1], string.split(config.Hud.WindowPositions.RenderWindow, ",")[2], string.split(config.Hud.WindowPositions.RenderWindow, ",")[3], string.split(config.Hud.WindowPositions.RenderWindow, ",")[4])
RenderWindow.Size = UDim2.new(0, 200, 0, 50)
RenderWindow.Font = Enum.Font.Highway
RenderWindow.Text = "Render"
RenderWindow.TextColor3 = Color3.fromRGB(0, 0, 0)
RenderWindow.TextSize = 25
RenderWindow.Active = true 
RenderWindow.Draggable = true 
RenderWindow.BorderSizePixel = 0 
table.insert(guiLib.disconnectfuncs, RenderWindow:GetPropertyChangedSignal("Position"):Connect(function()
	config.Hud.WindowPositions.RenderWindow = string.gsub(string.gsub(tostring(RenderWindow.Position), "}", ""), "{", "")
	save()
end))
ModuleAmmount = {}
guiLib.ModuleOn = {}
ModuleAmmount.WorldWindow = 0  
ModuleAmmount.CombatWindow = 0
ModuleAmmount.UtilityWindow = 0
ModuleAmmount.MovementWindow = 0
ModuleAmmount.RenderWindow = 0 
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
	module.BackgroundTransparency = Transparency
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
			if config.Hud and config.Hud.RainbowModules and config.Hud.RainbowModules == "true" then 
				task.spawn(function() 
					repeat 
						if guiLib:Enabled(tbl.Name) then 
							module.BackgroundColor3 = Color3.fromHSV((tick() * rainbowUtil) % (11 - guiLib:GetDropDownValue("HUD", "RainbowSpeed")), 1, 1)
						end
						task.wait() 
					until not getgenv().executed or guiLib:GetDropDownValue("HUD", "RainbowModules") == "false"
					if v and guiLib:Enabled(string.split(v.Text, " ")[2]) then 
						v.BackgroundColor3 = Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])
					else 
						v.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
					end
				end) 
			else 
				module.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
			end 
			if tbl.Name ~= "Uninject" and getgenv().canSave then 
				config.Modules[tbl.Name] = "false"
				save()
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
					if not string.sub(bindmenu.Text, 1, 1):upper():match("[^a-zA-Z]+") and bindmenu.Text ~= "" then 
						guiLib:Notify("Binds", "Bound "..tbl.Name.." to "..string.sub(bindmenu.Text, 1, 1):upper(), 3)
						config.Binds[tbl.Name] = string.sub(bindmenu.Text, 1, 1):upper()
						save()
					elseif bindmenu.Text == "" then 
						guiLib:Notify("Binds", "Unbound "..tbl.Name.."!", 3)
						config.Binds[tbl.Name] = ""
						save()
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
		save() 
	end 
	table.insert(guiLib.disconnectfuncs, uis.InputBegan:Connect(function(input) 
		if config.Binds[tbl.Name] ~= "" and input.KeyCode == Enum.KeyCode[config.Binds[tbl.Name]] and not uis:GetFocusedTextBox() then 
			if guiLib:Enabled(tbl.Name) then 
				guiLib:Disable(tbl.Name)
				if tbl.Name ~= "Uninject" and getgenv().canSave then 
					config.Modules[tbl.Name] = "false"
					save()
				end
			else 
				guiLib:Enable(tbl.Name)
				if tbl.Name ~= "Uninject" and getgenv().canSave then 
					config.Modules[tbl.Name] = "true"
					save()
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
	local module = guiLib:GetModule(realModule)
    TabAmount[realModule] += 1.4
	local dropdownText = Instance.new("TextLabel", realwindow)
	local dropdown2 = Instance.new("TextBox", dropdownText) 
	dropdownText.Position = UDim2.new(module.Position) + UDim2.new(0,0,1.32 * (TabAmount[realModule]))
	dropdownText.TextSize = 10
	dropdownText.Text = tbl2.Name..": "
	dropdownText.BackgroundTransparency = Transparency
	dropdownText.BorderSizePixel = 0 
	dropdownText.TextTransparency = 1
	dropdownText.LayoutOrder = math.huge
	dropdownText.Size = UDim2.new(0,0,0)
	dropdownText.Name = guiLib:randomString(50)
	dropdownText.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	dropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
	dropdownText.ZIndex = 5000

	dropdown2.Position = UDim2.new(dropdownText.Position) + UDim2.new(0,0,1) 
	dropdown2.TextSize = 10
	dropdown2.BackgroundTransparency = 0.6 
	dropdown2.BorderSizePixel = 0 
	dropdown2.TextTransparency = 1
	dropdown2.TextEditable = false 
	dropdown2.LayoutOrder = math.huge
	dropdown2.Size = UDim2.new(0,0,0)
	dropdown2.Name = guiLib:randomString(50)
	dropdown2.BackgroundColor3 = Color3.fromRGB(36, 38, 42)
	dropdown2.TextColor3 = Color3.fromRGB(255, 255, 255)
	if tbl2.Default then 
		if config.Dropdowns[tbl2.Module..tbl2.Name] and config.Dropdowns[tbl2.Module..tbl2.Name] ~= "" then 
			if getgenv().canSave then 
				save()
			end
		else 
			config.Dropdowns[tbl2.Module..tbl2.Name] = tbl2.Default
			if getgenv().canSave then 
				save()
			end
		end 
	end
	table.insert(guiLib.disconnectfuncs, dropdown2:GetPropertyChangedSignal("Text"):Connect(function(balling)
		pcall(function()
			if dropdown2 and dropdown2.Text and tbl2 and typeof(dropdown2.Text) == tbl2.Type and tbl2.Min and tonumber(dropdown2.Text) < tbl2.Min then 
				dropdown2.Text = tbl2.Min
			elseif dropdown2 and tbl2 and tbl2.Max and tonumber(dropdown2.Text) > tonumber(tbl2.Max) then
				dropdown2.Text = tbl2.Max
			end 
		end)
		repeat task.wait() until not uis:GetFocusedTextBox() 
		if tbl2.Function and dropdown2.Text ~= "" then 
			task.spawn(code, tbl2.Function)
		end 
		if getgenv().canSave then 
			config.Dropdowns[tbl2.Module..tbl2.Name] = dropdown2.Text
			save()
		end
	end)) 
	table.insert(guiLib.disconnectfuncs, module.MouseButton2Down:Connect(function(right) 
		table.insert(guiLib.disconnectfuncs, connection2)
		if dropdown2.TextEditable then 
			dropdown2.BackgroundTransparency = 1 
			dropdown2.TextTransparency = 1
			dropdown2.TextEditable = false  
			dropdown2.Selectable = false 
			module.TextSize = 18
			module.ZIndex = 1
			dropdown2.Size = UDim2.new(0,0,0)

			dropdownText.BackgroundTransparency = 1 
			dropdownText.TextTransparency = 1
			dropdownText.Selectable = false 
			dropdownText.Size = UDim2.new(0,0,0)
		else 
			dropdown2.Text = config.Dropdowns[tbl2.Module..tbl2.Name]
			dropdown2.ZIndex = 50000
			dropdown2.BackgroundTransparency = 0 
			dropdown2.TextTransparency = 0
			dropdown2.TextEditable = true 
			dropdown2.Selectable = true
			dropdown2.Size = UDim2.new(0, 200, 0, 50)
			module.TextSize = 15
			module.ZIndex = 50000

			dropdownText.Text = tbl2.Name..": "
			dropdownText.BackgroundTransparency = 0.6
			dropdownText.TextTransparency = 0
			dropdownText.Selectable = true
			dropdownText.Size = UDim2.new(0, 200, 0, 50)
			dropdownText.ZIndex = 50000
		end 
	end))
end 
local ToggleableOn = {} 
function guiLib:ToggleEnabled(whichmodule, togglename)
	return ToggleableOn[whichmodule] and ToggleableOn[whichmodule][togglename]
end
function guiLib:CreateToggleable(tbl3) 
	local realModule = tbl3.Module
	table.insert(guiLib.functions, tbl3)
	repeat task.wait() until guiLib:GetModule(realModule)
	if not TabAmount[realModule] then TabAmount[realModule] = 0 end
	if not ToggleableOn[realModule] then ToggleableOn[realModule] = {} end
	if config.Toggleables[tbl3.Name] then 
		ToggleableOn[realModule][tbl3.Name] = config.Toggleables[tbl3.Name]
	else 
		config.Toggleables[tbl3.Name] = tostring(tbl3.Default)
		ToggleableOn[realModule][tbl3.Name] = tbl3.Default
	end 
	if not ToggleableOn[realModule][tbl3.Name] then ToggleableOn[realModule][tbl3.Name] = tbl3.Default end
	local module = guiLib:GetModule(realModule)
    TabAmount[realModule] += 1
	local toggle = Instance.new("TextButton", module) 
	toggle.Position = UDim2.new(module.Position) + UDim2.new(0,0,1.32 * (TabAmount[realModule]))
	toggle.TextSize = 10
	toggle.Text = " "..tbl3.Name
	toggle.BackgroundTransparency = Transparency
	toggle.BorderSizePixel = 0 
	toggle.TextTransparency = 1
	toggle.TextXAlignment = Enum.TextXAlignment.Left
	toggle.LayoutOrder = 0
	toggle.ZIndex = 0
	toggle.Size = UDim2.new(0,0,0)
	toggle.Name = guiLib:randomString(50)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	if config.Toggleables[tbl3.Name] and config.Toggleables[tbl3.Name] == "true" then  
		ToggleableOn[realModule][tbl3.Name] = true 
		config.Toggleables[tbl3.Name] = "true"
		if tbl3.Function then task.spawn(code, getModuleFunc(tbl3.Name)) end
		toggle.BackgroundColor3 = (Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])) 
		save()
	else
		config.Toggleables[tbl3.Name] = "false" 
		ToggleableOn[realModule][tbl3.Name] = false 
		toggle.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
		save() 
	end 
	module.MouseButton2Down:Connect(function()
		if toggle.Size == UDim2.new(0,0,0) then 
			toggle.Size = UDim2.new(0, 200, 0, 50)
			toggle.TextTransparency = 0
			toggle.ZIndex = 50000
		else 
			toggle.Size = UDim2.new(0,0,0)
			toggle.TextTransparency = 1
			toggle.ZIndex = 1
		end 
	end)
	toggle.MouseButton1Down:Connect(function()
		if ToggleableOn[realModule][tbl3.Name] then 
			ToggleableOn[realModule][tbl3.Name] = false 
			config.Toggleables[tbl3.Name] = "false"
			save()
			if tbl3.Function then task.spawn(code, getModuleFunc(tbl3.Name)) end
			toggle.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
		else 
			ToggleableOn[realModule][tbl3.Name] = true 
			config.Toggleables[tbl3.Name] = "true"
			save()
			if tbl3.Function then task.spawn(code, getModuleFunc(tbl3.Name)) end
			toggle.BackgroundColor3 = (config.Hud.Enabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])) or Color3.fromRGB(83, 33, 153)
		end 
	end)
end 
function guiLib:Disable(disablemodule, displaydisablenotification)
	guiLib.ModuleOn[disablemodule] = false 
	for i,v in next, guiLib.Boney:GetDescendants() do 
		if v:IsA("TextButton") and v.Text == " "..disablemodule then 
			v.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
			if not displaydisablenotification then guiLib:Notify(disablemodule, "Disabled", 1) end
			if getgenv().canSave then 
                config.Modules[disablemodule] = "false"
				save()
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
			if config.Hud and config.Hud.RainbowModules and config.Hud.RainbowModules == "true" then 
				task.spawn(function()
					repeat 
						if guiLib:Enabled(string.split(v.Text, " ")[2]) then 
							v.BackgroundColor3 = Color3.fromHSV((tick() * rainbowUtil) % (11 - guiLib:GetDropDownValue("HUD", "RainbowSpeed")), 1, 1)
						end
						task.wait()
						until not guiLib:Enabled(enabledmodule)
					end)
				else 
					v.BackgroundColor3 = (config.Hud.Enabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])) or Color3.fromRGB(83, 33, 153)
				end
			if not displayenablenotification and (enabledmodule ~= "HUD") then guiLib:Notify(enabledmodule, "Enabled", 1) end
			if enabledmodule ~= "Uninject" and getgenv().canSave then 
				config.Modules[enabledmodule] = "true"
				save()
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
		Frame.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(0, 0, 0)
		Frame.BackgroundTransparency = Transparency
		Frame.Position = UDim2.new(0.897371888, 0, 0.917338729, 0)
		Frame.Size = UDim2.new(0, 270, 0, 114)
		Header.Name = guiLib:randomString(50)
		Header.BackgroundColor3 = windowcolor
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
		task.wait((time or 1) - 0.2) 
		Frame:TweenPosition(UDim2.new(0.897371888, 0, 0.917338729, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, tweentime or 0.1, false)
		notifications -= 1 
		task.wait(0.1)
		Notification:Destroy()
	end)
end
table.insert(guiLib.disconnectfuncs, lplr.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.InProgress then
       	queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/loader", true))()')
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
local WaterMark, WaterMarkFunction
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
			if WaterMark then WaterMark:Destroy() end 
        end 
    end,
})
guiLib:CreateModule({ 
	Name = "HUD", 
	Window = "Render", 
	Function = function()  
		if guiLib:Enabled("HUD") then 
			guiLib:Disable("HUD", "no")
			guiLib:Notify("HUD", "This module is only used\nfor the dropdowns!", 1)
		end 
	end, 
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "ModuleEnableColor(rgb)", 
	Default = "83, 33, 153",
	Function = function() 
		for i,v in next, guiLib.Boney:GetDescendants() do 
			if v:IsA("TextButton") and guiLib:Enabled(string.split(v.Text, " ")[2]) then 
				v.BackgroundColor3 = Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])
				config.Hud.Enabled = guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)")
				save()
			end 
		end 
	end,
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "Transparency", 
	Min = 0.1, 
	Max = 1,
	Default = 0.5,
	Function = function() 
		for i,v in next, guiLib.Boney:GetDescendants() do 
			if v:IsA("TextButton") or v:IsA("TextLabel") and not v.Text:find(":") then 
				v.BackgroundTransparency = guiLib:GetDropDownValue("HUD", "Transparency")
				config.Hud.Transparency = guiLib:GetDropDownValue("HUD", "Transparency")
				Transparency = guiLib:GetDropDownValue("HUD", "Transparency")
				save()
			end 
		end 
	end,
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "ModuleDisableColor(rgb)", 
	Default = "36, 38, 42",
	Function = function() 
		for i,v in next, guiLib.Boney:GetDescendants() do 
			if v:IsA("TextButton") and not guiLib:Enabled(string.split(v.Text, " ")[2]) then 
				v.BackgroundColor3 = Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])
				config.Hud.Disabled = guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)")
				save()
			end 
		end 
	end,
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "WindowColors(rgb)", 
	Default = "111, 128, 200",
	Function = function() 
		for i,v in next, guiLib.Boney:GetDescendants() do 
			if v:IsA("TextLabel") and not v.Text:find(":") then 
				v.BackgroundColor3 = Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[3])
				config.Hud.Windows = guiLib:GetDropDownValue("HUD", "WindowColors(rgb)")
				windowcolor = (config.Hud and config.Hud.Windows and guiLib:GetDropDownValue("HUD", "WindowColors(rgb)") and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "WindowColors(rgb)"),",")[3])) or Color3.fromRGB(111, 128, 200)
				save()
			end 
		end 
	end,
})
guiLib:CreateToggleable({
	Module = "HUD", 
	Name = "ResetConfig", 
	Default = false,
	Function = function() 
		if isfile("testlib/config/"..game.PlaceId.."/Config.lua") and guiLib:ToggleEnabled("HUD", "ResetConfig") then 
			writefile("testlib/config/"..game.PlaceId.."/Config.lua", "[]")
			guiLib:Enable("Uninject")
		end 
	end,
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "RainbowModules", 
	Default = "false",
	Function = function() 
		for i,v in next, guiLib.Boney:GetDescendants() do 
			if v:IsA("TextButton") and not v.Text:find(":") then 
				task.spawn(function()
					repeat 
						if guiLib:Enabled(string.split(v.Text, " ")[2]) then 
							v.BackgroundColor3 = Color3.fromHSV((tick() * rainbowUtil) % (11 - guiLib:GetDropDownValue("HUD", "RainbowSpeed")), 1, 1)
						end
						task.wait()
					until not getgenv().executed or guiLib:GetDropDownValue("HUD", "RainbowModules") ~= "true"
					if guiLib:Enabled(string.split(v.Text, " ")[2]) then 
						v.BackgroundColor3 = Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleEnableColor(rgb)"),",")[3])
					else 
						v.BackgroundColor3 = (config.Hud.Disabled and Color3.fromRGB(string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[1], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[2], string.split(guiLib:GetDropDownValue("HUD", "ModuleDisableColor(rgb)"),",")[3])) or Color3.fromRGB(36, 38, 42)
					end
				end)
			end 
		end 
		config.Hud.RainbowModules = guiLib:GetDropDownValue("HUD", "RainbowModules")
		save()
	end,
})
guiLib:CreateDropDown({
	Module = "HUD", 
	Name = "RainbowSpeed", 
	Default = 10,
	Max = 10, 
	Min = 1,
})
local fps, total, startingtick
guiLib:CreateToggleable({
	Module = "HUD", 
	Name = "WaterMark", 
	Default = false, 
	Function = function() 
		if guiLib:ToggleEnabled("HUD", "WaterMark") then 
			if not config.Hud.WaterMark then config.Hud.WaterMark = "0.5, 0, 0.4, 0" save() end
			fps, total, startingtick = 0, 0, tick()
			WaterMark = Instance.new("ScreenGui", loadingGui) 
			local WaterMarkFrame = Instance.new("Frame", WaterMark) 
			local JosiahLabel = Instance.new("TextLabel", WaterMarkFrame)
			local ColorFrame = Instance.new("TextLabel", WaterMarkFrame)
			WaterMarkFunction = game:GetService("RunService").RenderStepped:Connect(function()
				fps += 1 
				total += 1 
				JosiahLabel.Text = "\nBoney | "..game.PlaceId.."\n\nFPS: "..fps.."| Average: "..math.floor((total / (tick() - startingtick)))
				ColorFrame.BackgroundColor3 = Color3.fromHSV((tick() * rainbowUtil % 0.9), 1, 1)
				task.spawn(function()
					task.wait(1) 
					fps -= 1
				end)
			end)
			WaterMark.Name = guiLib:randomString(50)
			ColorFrame.Name = guiLib:randomString(50)
			WaterMarkFrame.Name = guiLib:randomString(50)
			JosiahLabel.Name = guiLib:randomString(50)
			WaterMarkFrame.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
			WaterMarkFrame.BackgroundTransparency = 0.6
			WaterMarkFrame.Active = true 
			WaterMarkFrame.Draggable = true 
			WaterMarkFrame.BorderSizePixel = 0
			WaterMarkFrame.Size = UDim2.new(0, 326, 0, 60)
			WaterMarkFrame.Position = UDim2.new(string.split(config.Hud.WaterMark, ",")[1], string.split(config.Hud.WaterMark, ",")[2], string.split(config.Hud.WaterMark, ",")[3], string.split(config.Hud.WaterMark, ",")[4])
			JosiahLabel.Size = UDim2.new(0, 194, 0, 22)
			JosiahLabel.TextXAlignment = Enum.TextXAlignment.Left
			JosiahLabel.Text = string.rep(" ", (15 - string.len(game.PlaceId))).."Boney | "..game.PlaceId
			JosiahLabel.BorderSizePixel = 0
			JosiahLabel.BackgroundTransparency = 1
			JosiahLabel.Position += UDim2.new(0, 0, 0, 15)
			JosiahLabel.TextColor3 = Color3.fromRGB(255,255,255)
			ColorFrame.Size = UDim2.new(0, 326, 0, 8)
			ColorFrame.Text = ""
			ColorFrame.BorderSizePixel = 0
			table.insert(guiLib.disconnectfuncs, WaterMarkFrame:GetPropertyChangedSignal("Position"):Connect(function()
				config.Hud.WaterMark = string.gsub(string.gsub(tostring(WaterMarkFrame.Position), "}", ""), "{", "")
				save()
			end))
		else 
			if WaterMarkFunction then WaterMarkFunction:Disconnect() end
			if WaterMark then WaterMark:Destroy() end
			fps, total, startingtick = 0, 0, nil
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
	Max = 200,
	Default = 150,
})


guiLib:CreateDropDown({
	Module = "Test",
	Name = "Balls2", 
	Type = "number", 
	Min = 10, 
	Max = 200,
	Default = 150,
})

guiLib:CreateToggleable({
	Module = "Test", 
	Name = "balls3", 
	Default = true, 
	Function = function() 
		if guiLib:ToggleEnabled("Test", "balls3") then 
			print('on') 
		else 
			print('off')
		end 
	end, 
})
guiLib:CreateDropDown({
	Module = "Test",
	Name = "Balls4", 
	Type = "number", 
	Min = 10, 
	Max = 200,
	Default = 150,
})
]]
