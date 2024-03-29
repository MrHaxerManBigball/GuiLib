shared.GuiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/Lib.lua", true))()
local GuiLib = shared.GuiLib
local Players = game:GetService("Players") 
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local coregui = game:GetService("CoreGui")
if not getgenv().lplr then getgenv().lplr = Players.LocalPlayer end 
local mouse = lplr:GetMouse()
function isAlive(plr) 
    return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").Health > 0 
end
function isTeammate(plr) 
    return plr and plr ~= lplr and plr.Team == lplr.Team and lplr.Team
end
local fallingtime = 0 
task.spawn(function()
    repeat 
        if isAlive(lplr) and lplr.Character.Humanoid.FloorMaterial == Enum.Material.Air and not GuiLib:Enabled("Fly") then 
            if fallingtime < 50 then 
                fallingtime += 0.1 
            end 
        else 
            fallingtime = 0 
        end 
        task.wait(0.1) 
    until not getgenv().executed
end)

local FlyVelo, FlyY
GuiLib:CreateModule({
    Name = "Fly", 
    Window = "Movement", 
    Function = function() 
        if GuiLib:Enabled("Fly") then 
            task.spawn(function()
                repeat 
                    if isAlive(lplr) and GuiLib:GetDropDownValue("Fly", "Speed") then 
                        if uis:IsKeyDown(Enum.KeyCode.Space) and not uis:GetFocusedTextBox() then FlyY = GuiLib:GetDropDownValue("Fly", "VerticalSpeed") or 10 elseif not uis:IsKeyDown(Enum.KeyCode.LeftShift) then FlyY = 0 end 
                        if uis:IsKeyDown(Enum.KeyCode.LeftShift) and not uis:GetFocusedTextBox() then FlyY = -GuiLib:GetDropDownValue("Fly", "VerticalSpeed") or 10 elseif not uis:IsKeyDown(Enum.KeyCode.Space) then FlyY = 0 end  
                        if uis:IsKeyDown(Enum.KeyCode.LeftShift) and uis:IsKeyDown(Enum.KeyCode.Space) then FlyY = 0 end 
                        FlyVelo = lplr.Character.Humanoid.MoveDirection * (GuiLib:GetDropDownValue("Fly", "Speed") or 23)
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(FlyVelo.X,FlyY,FlyVelo.Z)
                    end 
                    task.wait() 
                until not GuiLib:Enabled("Fly")
            end)
        end 
    end,
})
GuiLib:CreateDropDown({
    Module = "Fly", 
    Name = "Speed", 
    Type = "number",
    Min = 0,
    Max = 200,
    Default = 23, 
})
GuiLib:CreateDropDown({
    Module = "Fly", 
    Name = "VerticalSpeed", 
    Type = "number",
    Min = 0,
    Max = 200,
    Default = 50, 
})

local OldFOV, FOVFunc = nil, nil
GuiLib:CreateModule({
    ["Name"] = "FOVChanger", 
    ["Window"] = "Render", 
    ["Function"] = function() 
        if GuiLib:Enabled("FOVChanger") then 
            task.spawn(function()
                repeat task.wait() until GuiLib:GetDropDownValue("FOVChanger", "FOV")
                OldFOV = workspace.Camera.FieldOfView
                workspace.Camera.FieldOfView = GuiLib:GetDropDownValue("FOVChanger", "FOV") or 120
                FOVFunc = workspace.Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function() 
                    workspace.Camera.FieldOfView = GuiLib:GetDropDownValue("FOVChanger", "FOV") or 120
                end) 
            end)
        else 
            if FOVFunc then 
                FOVFunc:Disconnect() 
            end
            workspace.Camera.FieldOfView = OldFOV
        end 
    end,
})

GuiLib:CreateDropDown({
    ["Module"] = "FOVChanger", 
    ["Name"] = "FOV", 
    ["Type"] = "number",
    ["Min"] = 15, 
    ["Max"] = 120, 
    ["Default"] = 120,
})

local SpeedVal, SpeedVelo
GuiLib:CreateModule({
    ["Name"] = "Speed", 
    ["Window"] = "Movement", 
    ["Function"] = function() 
        if GuiLib:Enabled("Speed") then 
            task.spawn(function()
                repeat task.wait() until GuiLib:GetDropDownValue("Speed", "Speed")
                repeat 
                    if isAlive(lplr) and not GuiLib:Enabled("Fly") and not GuiLib:GetDropDownValue("Speed", "Speed") == "" then 
                        SpeedVelo = lplr.Character.Humanoid.MoveDirection * GuiLib:GetDropDownValue("Speed", "Speed") or 23
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(SpeedVelo.X,lplr.Character.HumanoidRootPart.Velocity.Y,SpeedVelo.Z)
                    end 
                    task.wait()
                until not GuiLib:Enabled("Speed")
            end)
        else 
            SpeedVal = nil
        end  
    end,
})

GuiLib:CreateDropDown({
    ["Module"] = "Speed", 
    ["Name"] = "Speed", 
    ["Type"] = "number", 
    ["Min"] = 0, 
    ["Max"] = 1000, 
    ["Default"] = 100,
})

GuiLib:CreateModule({
    ["Name"] = "HighJump", 
    ["Window"] = "Movement", 
    ["Function"] = function() 
        if GuiLib:Enabled("HighJump") then     
            if isAlive(lplr) then 
                lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X,GuiLib:GetDropDownValue("HighJump", "Power"),lplr.Character.HumanoidRootPart.Velocity.Z)
                GuiLib:Disable("HighJump")
            else 
                GuiLib:Disable("HighJump")
            end 
        end 
    end,
})

GuiLib:CreateDropDown({
    ["Module"] = "HighJump", 
    ["Name"] = "Power", 
    ["Type"] = "number",
    ["Min"] = 0, 
    ["Max"] = 500,
    ["Default"] = 100,
})

local infJumpConnection
GuiLib:CreateModule({
    ["Name"] = "InfiniteJump", 
    ["Window"] = "Movement", 
    ["Function"] = function() 
        if GuiLib:Enabled("InfiniteJump") then 
            task.spawn(function()
                repeat task.wait() until GuiLib:GetDropDownValue("InfiniteJump", "Hold")
                infJumpConnection = uis.InputBegan:Connect(function(input) 
                    if input.KeyCode == Enum.KeyCode.Space and isAlive(lplr) and lplr.Character:FindFirstChild("Humanoid") and not uis:GetFocusedTextBox() and not GuiLib:Enabled("InfiniteFly") then 
                        if GuiLib:GetDropDownValue("InfiniteJump", "Hold") == "true" then 
                            repeat 
                                if isAlive(lplr) then 
                                    lplr.Character.Humanoid:ChangeState("Jumping")
                                end 
                                task.wait() 
                            until not uis:IsKeyDown(Enum.KeyCode.Space)
                        else 
                            lplr.Character.Humanoid:ChangeState("Jumping")
                        end
                    end 
                end)
            end)
        else 
            if infJumpConnection then 
                infJumpConnection:Disconnect() 
            end 
        end
    end, 
})

GuiLib:CreateDropDown({
    ["Module"] = "InfiniteJump", 
    ["Name"] = "Hold", 
    ["type"] = "string", 
    ["Default"] = "false",
})

local lowest
function getLowestPoint()
    lowest = math.huge
    for _,v in next, workspace:GetDescendants() do 
        if v:IsA("Part") or v:IsA("MeshPart") and v.Position.Y < lowest then 
            lowest = v.Position.Y 
        end 
    end 
    return (lowest - 10)
end 
GuiLib:CreateModule({
    ["Name"] = "AntiVoid", 
    ["Window"] = "World", 
    ["Function"] = function()
        if GuiLib:Enabled("AntiVoid") then 
            local realLow = getLowestPoint()
            task.spawn(function()
                repeat 
                    if isAlive(lplr) and realLow and lplr.Character.HumanoidRootPart.Position.Y <= realLow  then 
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 75 * (1 + fallingtime), lplr.Character.HumanoidRootPart.Velocity.Z)
                    end 
                    task.wait() 
                until not GuiLib:Enabled("AntiVoid")
            end)
        end 
    end,
})

local espPart, espPlr, espChr, team
local espfuncs = {}
GuiLib:CreateModule({
    ["Name"] = "ESP", 
    ["Window"] = "Render", 
    ["Function"] = function() 
        if GuiLib:Enabled("ESP") then 
            for _,v in pairs(Players:GetPlayers()) do 
                if v ~= lplr and not isTeammate(v) then 
                    task.spawn(function()
                    repeat task.wait() until v.Character 
                        espPart = Instance.new("Highlight", v.Character)
                        espPart.Name = v.Name.."'s esp"
                        espPart.FillColor = Color3.new(0, 255, 0)
                        espPart.OutlineColor = Color3.new(0, 255, 0)
                    end)
                end 
            end 
            espPlr = Players.PlayerAdded:Connect(function(plr) 
                espChr = plr.CharacterAdded:Connect(function(chr)
                    if plr ~= lplr and not isTeammate(plr) then
                        task.spawn(function()
                            repeat task.wait() until plr.Character 
                            espPart = Instance.new("Highlight", chr)
                            espPart.Name = plr.Name.."'s esp"
                            espPart.FillColor = Color3.new(0, 255, 0)
                            espPart.OutlineColor =Color3.new(0, 255, 0)
                        end)
                    end
                end)
            end)
        else 
            for _,v in pairs(Players:GetPlayers()) do 
                if v.Character and v.Character:FindFirstChild(v.Name.."'s esp") then 
                    v.Character:FindFirstChild(v.Name.."'s esp"):Destroy()
                end 
            end 
            if espPlr then espPlr:Disconnect() end 
            if espChr then espChr:Disconnect() end 
            for _,v in pairs(espfuncs) do 
                v:Disconnect() 
                v = nil 
            end
            espfuncs = {}
        end 
    end,
})

local tpPos
GuiLib:CreateModule({
    ["Name"] = "ClickTP", 
    ["Window"] = "Movement", 
    ["Function"] = function()
        if GuiLib:Enabled("ClickTP") then 
            if isAlive(lplr) and mouse.Target then 
                tpPos = mouse.Hit 
                lplr.Character.HumanoidRootPart.CFrame = CFrame.new(tpPos.X, tpPos.Y, tpPos.Z)
                GuiLib:Disable("ClickTP")
            else 
                GuiLib:Disable("ClickTP")
            end 
        end 
    end, 
})
