--mm2 
local GuiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrHaxerManBigball/GuiLib/main/Lib.lua", true))()
local Players = game:GetService("Players") 
local uis = game:GetService("UserInputService")
local http = game:GetService("HttpService")
local murderer2, sheriff2, espPart = {Plr = "nil", name = "nil"}, {Plr = "nil", name = "nil"}
if not getgenv().lplr then getgenv().lplr = Players.LocalPlayer end 
local mouse = lplr:GetMouse()
function isAlive(plr) 
    return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Humanoid").Health > 0 
end
function isTeammate(plr1) 
    return plr1.Team == lplr.Team and lplr.Team
end
function isMurderer(player) 
    if player.Character and player:FindFirstChild("Backpack") then 
        return player.Character:FindFirstChild("Knife")  or player.Backpack:FindFirstChild("Knife")
    end 
end 
function isSheriff(player2) 
    if player2.Character and player2:FindFirstChild("Backpack") then 
        return player2.Character:FindFirstChild("Gun")  or player2.Backpack:FindFirstChild("Gun")
    end 
end 
local monkey1, monkey2
function getMurderer() 
    for i,v in pairs(Players:GetPlayers()) do 
        if isMurderer(v) then 
            monkey1 = v 
            break 
        end 
    end 
    return monkey1 or nil 
end 
function getSheriff() 
    for i,v in pairs(Players:GetPlayers()) do 
        if isSheriff(v) then 
            monkey2 = v 
            break 
        end 
    end 
    return monkey2 or nil
end 
function makeEsp(part, color, role) 
    if part ~= lplr and part ~= lplr.Character then 
        espPart = Instance.new("Highlight", part)
        espPart.Name = role.."'s ESP" or "ESP"
        espPart.FillColor = color 
        espPart.OutlineColor = Color3.fromRGB(0,0,0)
    end 
end 
function closest(distance5) 
    local dist5, closestplr = distance5 or math.huge, nil
    for i,v in pairs(Players:GetPlayers()) do 
        if v ~= lplr and lplr.Character and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("HumanoidRootPart") and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < dist5 then 
            dist5 =  (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            closestplr = v 
        end 
    end 
    return closestplr 
end
local Whitelisted = {477367198, 4179478688, 1602837069, 607424200}
function isWhitelisted(whitelist1) 
    return table.find(Whitelisted, whitelist1.UserId)
end 
local rapedSounds = {}
for i,v in next, game:GetDescendants() do 
    if v:IsA("Sound") then 
        table.insert(rapedSounds, v)
    end 
end 
function isinDistance(target, tdist) 
    if isAlive(target) and isAlive(lplr) then 
        return (lplr.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).magnitude <= tdist
    end 
end 

GuiLib:CreateModule({
    Name = "RoleESP", 
    Window = "Render", 
    Function = function() 
        if GuiLib:Enabled("RoleESP") then 
            task.spawn(function()
                repeat 
                    for i,v in pairs(Players:GetPlayers()) do 
                        if v.Character and isMurderer(v) then 
                            if not v.Character:FindFirstChild("Murderer's ESP") and not v.Character:FindFirstChild("Whitelisted's ESP") then makeEsp(v.Character, Color3.fromRGB(255, 0, 0), "Murderer") end 
                            if v.Character:FindFirstChild("Innocent's ESP") then 
                                v.Character:FindFirstChild("Innocent's ESP"):Destroy()
                            end
                            if v.Character:FindFirstChild("Sheriffs's ESP") then 
                                v.Character:FindFirstChild("Sheriffs's ESP"):Destroy()
                            end 
                            if v.Character:FindFirstChild("Whitelisted's ESP") then 
                                v.Character:FindFirstChild("Whitelisted's ESP"):Destroy()
                            end 
                            murderer2 = {Plr = v, name = v.Name}
                        end
                        if isSheriff(v) then 
                            if not v.Character:FindFirstChild("Sheriff's ESP") and not v.Character:FindFirstChild("Whitelisted's ESP") then makeEsp(v.Character, Color3.fromRGB(0, 0, 255), "Sheriff") end 
                            if v.Character:FindFirstChild("Murderer's ESP") then 
                                v.Character:FindFirstChild("Murderer's ESP"):Destroy()
                            end 
                            if v.Character:FindFirstChild("Innocent's ESP") then 
                                v.Character:FindFirstChild("Innocent's ESP"):Destroy()
                            end
                            if v.Character:FindFirstChild("Whitelisted's ESP") then 
                                v.Character:FindFirstChild("Whitelisted's ESP"):Destroy()
                            end 
                            sheriff2 = {Plr = v, name = v.Name}
                        end 
                        if not isSheriff(v) and not isMurderer(v) and v.Character then 
                        if not v.Character:FindFirstChild("Innocent's ESP") and not v.Character:FindFirstChild("Whitelisted's ESP") then makeEsp(v.Character, Color3.fromRGB(0, 255, 0), "Innocent") end 
                            if v.Character:FindFirstChild("Murderer's ESP") then 
                                v.Character:FindFirstChild("Murderer's ESP"):Destroy()
                            end 
                            if v.Character:FindFirstChild("Sheriffs's ESP") then 
                                v.Character:FindFirstChild("Sheriffs's ESP"):Destroy()
                            end 
                        end 
                        if isWhitelisted(v) and v.Character and not v.Character:FindFirstChild("Whitelisted's ESP") then 
                            makeEsp(v.Character, Color3.fromRGB(255, 255, 0), "Whitelisted")
                        end 
                    end 
                    task.wait() 
                until not GuiLib:Enabled("RoleESP")
            end)
        else 
            for i,v in pairs(Players:GetPlayers()) do 
                if v.Character then 
                    for i2,v2 in pairs(v.Character:GetChildren()) do 
                        if v2.Name:find("ESP") then 
                            v2:Destroy()
                        end 
                    end 
                end 
            end 
        end 
    end, 
})


local Snitch
GuiLib:CreateModule({
    Name = "RolesGUI", 
    Window = "Render", 
    Function = function() 
        if GuiLib:Enabled("RolesGUI") then 
            Snitch = Instance.new("ScreenGui", gethui and gethui() or game:GetService("CoreGui")) 
            local Murderer = Instance.new("TextLabel", Snitch)
            local Sheriff = Instance.new("TextLabel", Snitch)
            local MurdererImage = Instance.new("ImageLabel", Murderer)
            local SheriffImage = Instance.new("ImageLabel", Sheriff)
            Snitch.Name = http:GenerateGUID(false)
            Murderer.Name = http:GenerateGUID(false)
            Murderer.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
            Murderer.BackgroundTransparency = 0.5
            Murderer.BorderSizePixel = 0
            Murderer.Position = UDim2.new(0, 0, 0.459677428, 0)
            Murderer.Size = UDim2.new(0, 200, 0, 70)
            Murderer.Font = Enum.Font.SourceSans
            Murderer.TextColor3 = Color3.fromRGB(0, 0, 0)
            Murderer.TextSize = 14
            Murderer.TextXAlignment = Enum.TextXAlignment.Left
            Murderer.Active = true 
            Murderer.Draggable = true 
            Sheriff.Name = http:GenerateGUID(false)
            Sheriff.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
            Sheriff.BackgroundTransparency = 0.5
            Sheriff.BorderSizePixel = 0
            Sheriff.Position = UDim2.new(0, 0, 0.510080636, 0)
            Sheriff.Size = UDim2.new(0, 200, 0, 70)
            Sheriff.Font = Enum.Font.SourceSans
            Sheriff.TextColor3 = Color3.fromRGB(0, 0, 0)
            Sheriff.TextSize = 14
            Sheriff.TextXAlignment = Enum.TextXAlignment.Left
            Sheriff.Active = true 
            Sheriff.Draggable = true 
            SheriffImage.Name = http:GenerateGUID(false)
            SheriffImage.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
            SheriffImage.BackgroundTransparency = 0.5
            SheriffImage.BorderSizePixel = 0
            SheriffImage.Position = UDim2.new(1, 0, 0.159999996, 0) - UDim2.new(0,0,0.16,0)
            SheriffImage.Size = UDim2.new(0, 105, 0, 70)
            SheriffImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            MurdererImage.Name = http:GenerateGUID(false)
            MurdererImage.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
            MurdererImage.BackgroundTransparency = 0.5
            MurdererImage.BorderSizePixel = 0
            MurdererImage.Position = UDim2.new(1, 0, 0, 0)
            MurdererImage.Size = UDim2.new(0, 105, 0, 70)
            MurdererImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            task.spawn(function()
                repeat 
                    pcall(function()
                        Sheriff.Text = " Sheriff: "..(getSheriff().Name)
                        Murderer.Text = " Murderer: "..(getMurderer().Name)
                        SheriffImage.Image = game:GetService("Players"):GetUserThumbnailAsync(getSheriff().UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420) 
                        MurdererImage.Image = game:GetService("Players"):GetUserThumbnailAsync(getMurderer().UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420) 
                    end)
                task.wait() 
                until not GuiLib:Enabled("RolesGUI")
            end)
        else 
            if Snitch then 
                Snitch:Destroy() 
            end
        end 
    end, 
})

local oldTrans = {} 
GuiLib:CreateModule({
    Name = "X-Ray", 
    Window = "World", 
    Function = function() 
        if GuiLib:Enabled("X-Ray") then 
            for i,v in next, workspace:GetDescendants() do 
                if v:IsA("Part") or v:IsA("MeshPart") and v.Transparency ~= 0 or nil then 
                    task.spawn(function()
                        oldTrans[v:GetFullName()] = v.Transparency 
                        task.wait(0.1)
                        v.Transparency = 0.7
                    end)
                end 
            end 
        else 
            for i,v in next, workspace:GetDescendants() do 
                if v:IsA("Part") or v:IsA("MeshPart") and oldTrans[v:GetFullName()] then 
                    v.Transparency = oldTrans[v:GetFullName()]
                end 
            end 
            oldTrans = {}
        end 
    end, 
})

local oldPos
GuiLib:CreateModule({
    Name = "PickupGun", 
    Window = "Utility", 
    Function = function() 
        if GuiLib:Enabled("PickupGun") then 
            if isAlive(lplr) then 
                if workspace:FindFirstChild("GunDrop") then 
                    oldPos = lplr.Character.HumanoidRootPart.Position
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.GunDrop.Position) 
                    --firetouchinterest(workspace.GunDrop, lplr.Character.HumanoidRootPart, true)
                    task.wait(0.3)
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(oldPos)
                end 
                GuiLib:Disable("PickupGun")
            else 
                GuiLib:Disable("PickupGun")
            end 
        end 
    end, 
})


GuiLib:CreateModule({
    Name = "Shift-Speed", 
    Window = "Movement", 
    Function = function() 
        if GuiLib:Enabled("Shift-Speed") then
            task.spawn(function() 
                repeat task.wait() until GuiLib:GetDropDownValue("Shift-Speed", "Speed")
                repeat 
                    if isAlive(lplr) and uis:IsKeyDown(Enum.KeyCode.LeftShift) then 
                        SpeedVal = GuiLib:GetDropDownValue("Shift-Speed", "Speed") or 32
                        SpeedVelo = lplr.Character.Humanoid.MoveDirection * SpeedVal
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(SpeedVelo.X,lplr.Character.HumanoidRootPart.Velocity.Y,SpeedVelo.Z)
                    elseif isAlive(lplr) then 
                        Speedval = 16 
                    end 
                    task.wait()
                until not GuiLib:Enabled("Shift-Speed")
            end)
        end 
    end, 
})
GuiLib:CreateDropDown({
    Module = "Shift-Speed", 
    Name = "Speed", 
    type = "number", 
    Min = 0, 
    Max = 100, 
    Default = 32,
})

local FlyVelo, FlyY
GuiLib:CreateModule({
    Name = "Fly", 
    Window = "Movement", 
    Function = function() 
        if GuiLib:Enabled("Fly") then 
            task.spawn(function()
                repeat task.wait() until GuiLib:GetDropDownValue("Fly", "Speed") 
                repeat 
                    if isAlive(lplr) then 
                        if uis:IsKeyDown(Enum.KeyCode.Space) and not uis:GetFocusedTextBox() then FlyY = GuiLib:GetDropDownValue("Fly", "Speed") or 10 elseif not uis:IsKeyDown(Enum.KeyCode.LeftShift) then FlyY = 0 end 
                        if uis:IsKeyDown(Enum.KeyCode.LeftShift) and not uis:GetFocusedTextBox() then FlyY = -GuiLib:GetDropDownValue("Fly", "Speed")  or 10 elseif not uis:IsKeyDown(Enum.KeyCode.Space) then FlyY = 0 end  
                        FlyVelo = lplr.Character.Humanoid.MoveDirection * GuiLib:GetDropDownValue("Fly", "Speed") or 22.5
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
    type = "number",
    Name = "Speed", 
    Min = 0,
    Max = 100, 
    Default = 30,
})

GuiLib:CreateModule({
    Name = "HighJump", 
    Window = "Movement", 
    Function = function() 
        if GuiLib:Enabled("HighJump") then     
            task.spawn(function()
                repeat task.wait() until GuiLib:GetDropDownValue("HighJump", "Height") 
                if isAlive(lplr) then 
                    lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X,GuiLib:GetDropDownValue("HighJump", "Height"),lplr.Character.HumanoidRootPart.Velocity.Z)
                    GuiLib:Disable("HighJump")
                else 
                    GuiLib:Disable("HighJump")
                end 
            end)
        end 
    end,
})
GuiLib:CreateDropDown({
    Module = "HighJump", 
    Name = "Height", 
    type = "number", 
    Min = 0, 
    Max = 500, 
    Default = 100,
})

GuiLib:CreateModule({
    Name = "CameraFix", 
    Window = "Render", 
    Function = function() 
        if GuiLib:Enabled("CameraFix") then 
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            GuiLib:Disable("CameraFix")
        end 
    end,
})

GuiLib:CreateModule({
    Name = "CursorFix", 
    Window = "Render", 
    Function = function() 
        if GuiLib:Enabled("CursorFix") then 
            uis.MouseIconEnabled = true
            uis.MouseBehavior = Enum.MouseBehavior.Default	
            GuiLib:Disable("CursorFix")
        end 
    end,
})

local infJumpConnection
GuiLib:CreateModule({
    Name = "InfiniteJump", 
    Window = "Movement", 
    Function = function() 
        if GuiLib:Enabled("InfiniteJump") then 
            infJumpConnection = uis.InputBegan:Connect(function(input) 
                if input.KeyCode == Enum.KeyCode.Space and isAlive(lplr) and lplr.Character:FindFirstChild("Humanoid") and not uis:GetFocusedTextBox() and not GuiLib:Enabled("TestFly") then 
                    lplr.Character.Humanoid:ChangeState("Jumping")
                end 
            end)
        else 
            if infJumpConnection then 
                infJumpConnection:Disconnect() 
            end 
        end
    end, 
})

GuiLib:CreateModule({
    Name = "RemoveBarriers", 
    Window = "World", 
    Function = function() 
        if GuiLib:Enabled("RemoveBarriers") then 
            for i,v in pairs(workspace:GetChildren()) do 
                for i2,v2 in pairs(v:GetChildren()) do 
                    if v2.Name:find("Glitch") or v2.Name:find("Invis") then 
                        v2:Destroy()
                    end 
                end 
            end 
            GuiLib:Disable("RemoveBarriers")
        end 
    end,
})

local tpPos
GuiLib:CreateModule({
    Name = "ClickTP", 
    Window = "Movement", 
    Function = function()
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

GuiLib:CreateModule({
    Name = "BlurtRoles", 
    Window = "World", 
    Function = function() 
        if GuiLib:Enabled("BlurtRoles") then 
            if getMurderer() then 
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({[1] = getMurderer().DisplayName.."("..getMurderer().Name..") is Murderer!",[2] = "normalchat"}))
            end
            if getSheriff() then 
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack({[1] = getSheriff().DisplayName.."("..getSheriff().Name..") is Sheriff!",[2] = "normalchat"}))
            end
            GuiLib:Disable("BlurtRoles")
        end 
    end, 
})


local AcceptedTypes, testmul, collidedparts, noclipfunc = { [1] = "Part", [2] = "MeshPart", [3] = "UnionOperation"}, 2, {}
GuiLib:CreateModule({ 
    Name = "Noclip", 
    Window = "Movement",
    Function = function() 
        if GuiLib:Enabled("Noclip") then 
            noclipfunc = game:GetService("RunService").RenderStepped:Connect(function()
                if lplr.Character then 
                    for i,v in next, lplr.Character:GetDescendants() do 
                        if v:IsA("BasePart") and v.CanCollide then 
                            v.CanCollide = false 
                            table.insert(collidedparts, v)
                        end 
                    end 
                end 
            end)
        else 
            if noclipfunc then noclipfunc:Disconnect() end 
            for i,v in pairs(collidedparts) do 
                if v and not v.CanCollide then 
                    v.CanCollide = true 
                end
            end 
        end 
    end, 
})

GuiLib:CreateModule({
    Name = "GunESP", 
    Window = "Render", 
    Function = function() 
        if GuiLib:Enabled("GunESP") then 
            task.spawn(function()
                repeat 
                    if workspace:FindFirstChild("GunDrop") and not workspace.GunDrop:FindFirstChild("Gun's ESP") then 
                        makeEsp(workspace:FindFirstChild("GunDrop"), Color3.fromRGB(0, 0, 255), "Gun")
                    end 
                    task.wait() 
                until not GuiLib:Enabled("GunESP")
            end)
        else 
            if workspace:FindFirstChild("GunDrop") and workspace.GunDrop:FindFirstChild("Gun's ESP") then 
                workspace.GunDrop:FindFirstChild("Gun's ESP"):Destroy()
            end 
        end 
    end, 
})

local beforeMassacre
GuiLib:CreateModule({
    Name = "KillAll", 
    Window = "Combat", 
    Function = function() 
        if GuiLib:Enabled("KillAll") then 
            if isAlive(lplr) and isMurderer(lplr) then 
                beforeMassacre = lplr.Character.HumanoidRootPart.Position
                    for i,v in pairs(Players:GetPlayers()) do
                        if v ~= lplr and isAlive(lplr) and isAlive(v) and not isWhitelisted(v) and isinDistance(v, 250) then 
                            if lplr.Backpack:FindFirstChild("Knife") then lplr.Backpack:FindFirstChild("Knife").Parent = lplr.Character end 
                            lplr.Character.HumanoidRootPart.CFrame = CFrame.new(v.Character.HumanoidRootPart.Position) 
                            lplr.Character.Knife.Stab:FireServer("Down")
                            lplr.Character.Knife.Stab:FireServer("Slash") 
                            task.wait(0.1)
                        end 
                    end 
                lplr.Character.HumanoidRootPart.CFrame = CFrame.new(beforeMassacre) 
                GuiLib:Disable("KillAll")
            else 
                GuiLib:Disable("KillAll")
            end 
        end 
    end, 
})

local beforeSlaughtering
GuiLib:CreateModule({
    Name = "KillMurderer", 
    Window = "Combat", 
    Function = function() 
        if GuiLib:Enabled("KillMurderer") then 
            if isAlive(lplr) and isSheriff(lplr) and getMurderer() and isAlive(getMurderer()) then 
                beforeSlaughtering = lplr.Character.HumanoidRootPart.Position
                if lplr.Backpack:FindFirstChild("Gun") then lplr.Backpack:FindFirstChild("Gun").Parent = lplr.Character end 
                lplr.Character.HumanoidRootPart.CFrame = CFrame.new(getMurderer().Character.HumanoidRootPart.Position) 
                task.wait(0.1)
                    task.spawn(function() 
                        lplr.Character.Gun.KnifeServer.ShootGun:InvokeServer(table.unpack({
                        [1] = 1,
                        [2] = getMurderer().Character.HumanoidRootPart.Position,
                        [3] = "AH",
                    }))
                end) 
                task.wait(0.5)
                if isAlive(lplr) then 
                    lplr.Character.HumanoidRootPart.CFrame = CFrame.new(beforeSlaughtering)
                end 
                GuiLib:Disable("KillMurderer")
            else 
                GuiLib:Disable("KillMurderer")
            end 
        end 
    end, 
})

GuiLib:CreateModule({ 
    Name = "ShootMurderer", 
    Window = "Combat", 
    Function = function() 
        if GuiLib:Enabled("ShootMurderer") then 
            if isAlive(lplr) and isSheriff(lplr) and getMurderer() and isAlive(getMurderer()) then 
                if lplr.Backpack:FindFirstChild("Gun") then lplr.Backpack:FindFirstChild("Gun").Parent = lplr.Character end 
                task.spawn(function() 
                    lplr.Character.Gun.KnifeServer.ShootGun:InvokeServer(table.unpack({
                        [1] = 1,
                        [2] = getMurderer().Character.HumanoidRootPart.Position,
                        [3] = "AH",
                    }))
                end) 
                GuiLib:Disable("ShootMurderer")
            else 
                GuiLib:Disable("ShootMurderer")
            end 
        end 
    end, 
})

GuiLib:CreateModule({ 
    Name = "EarRape", 
    Window = "World", 
    Function = function() 
        if GuiLib:Enabled("EarRape") then 
            GuiLib:Notify("MM2", "2014 game moment", 3)
            for i,v in pairs(rapedSounds) do 
                v:Play() 
            end 
        else 
            for i,v in pairs(rapedSounds) do 
                v:Stop()
            end 
        end 
    end, 
})


GuiLib:CreateModule({
    Name = "AntiVoid", 
    Window = "World", 
    Function = function()
        if GuiLib:Enabled("AntiVoid") then 
            task.spawn(function()
                repeat 
                    if isAlive(lplr) and lplr.Character.HumanoidRootPart.Position.Y <= -70  then 
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(lplr.Character.HumanoidRootPart.Velocity.X, 75, lplr.Character.HumanoidRootPart.Velocity.Z)
                    end 
                    task.wait() 
                until not GuiLib:Enabled("AntiVoid")
            end)
        end 
    end,
})
