--[[
    LIBRAYS UI - BIBLIOTECA DE INTERFACE V1.0
    by: Dnxm200
    GitHub: https://github.com/seu-usuario/LIBRAYS-UI
    
    COMO USAR:
    
    local Libra = loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/LIBRAYS-UI/main/source.lua"))()
    
    local Window = Libra:CreateWindow({
        Name = "Meu Script",                    -- Título da janela
        Subtitle = "By: Dnxm200",               -- Subtítulo
        LogoID = "123456789",                    -- ID da imagem (opcional)
        OpenButtonName = "MENU",                  -- Nome do botão flutuante
        OpenButtonPosition = {X = 350, Y = 30},   -- Posição do botão {X, Y}
        
        ConfigSettings = {
            RootFolder = "LIBRAYS HUB",           -- Pasta principal
            ConfigFolder = "Meu Script"           -- Pasta de configs
        },
        
        KeySystem = false,                         -- Ativar key system?
        KeySettings = {
            Title = "Key System",
            Subtitle = "Insira sua key",
            Note = "Adquira sua key em...",
            SaveKey = true,
            Key = {"1234", "5678"}                 -- Keys válidas
        }
    })
    
    -- Criar aba
    local Tab = Window:CreateTab({Name = "Principal"})
    
    -- Criar botão
    Tab:CreateButton({
        Name = "Meu Botão",
        Description = "Clique aqui",
        Callback = function()
            print("Clicou!")
        end
    })
    
    -- Criar toggle
    Tab:CreateToggle({
        Name = "Meu Toggle",
        Description = "Liga/Desliga",
        CurrentValue = false,
        Callback = function(Value)
            print("Toggle:", Value)
        end
    })
    
    -- Mais elementos: Input, Dropdown, Slider, Keybind, ColorPicker, Label, Divider, Section
]]

local Libra = {}
local Libraries = {}

-- Serviços
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HapticService = game:GetService("HapticService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Easing personalizado
local Easing = {
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    Bounce = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    Elastic = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    Quick = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
}

-- Utilitários
local function Vibrate()
    pcall(function() HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.5); task.wait(0.1); HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0) end)
end

-- Cores padrão
local DefaultThemes = {
    Dark = {Main = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(0, 255, 130), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(25, 25, 25)},
    Blue = {Main = Color3.fromRGB(10, 15, 25), Accent = Color3.fromRGB(0, 160, 255), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(20, 30, 45)},
    Red = {Main = Color3.fromRGB(20, 10, 10), Accent = Color3.fromRGB(255, 50, 50), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(35, 15, 15)},
    Purple = {Main = Color3.fromRGB(15, 10, 20), Accent = Color3.fromRGB(180, 50, 255), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(30, 20, 40)},
    Emerald = {Main = Color3.fromRGB(10, 20, 15), Accent = Color3.fromRGB(50, 255, 150), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(20, 35, 25)},
    Sunset = {Main = Color3.fromRGB(25, 15, 10), Accent = Color3.fromRGB(255, 120, 50), Text = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(40, 25, 20)},
    Light = {Main = Color3.fromRGB(240, 240, 240), Accent = Color3.fromRGB(0, 120, 255), Text = Color3.fromRGB(30, 30, 30), Secondary = Color3.fromRGB(220, 220, 220)}
}

-- Sistema de notificações
local NotificationSystem = {
    Active = {},
    Max = 3,
    Spacing = 0.14,
    StartY = 0.02
}

function Libra:Notify(title, desc, duration, ScreenGui)
    duration = duration or 3
    ScreenGui = ScreenGui or Libraries[1] and Libraries[1].Screen
    
    if not ScreenGui then return end
    
    if #NotificationSystem.Active >= NotificationSystem.Max then
        local oldest = NotificationSystem.Active[1]
        if oldest and oldest.Parent then
            oldest:TweenPosition(UDim2.new(0.83197, 0, -0.15, 0), "In", "Quart", 0.3, true, function()
                if oldest and oldest.Parent then
                    oldest:Destroy()
                end
            end)
            table.remove(NotificationSystem.Active, 1)
        end
    end
    
    local Notif = Instance.new("TextButton", ScreenGui)
    Notif.Name = "not" .. (#NotificationSystem.Active + 1)
    Notif.Size = UDim2.new(0.16018, 0, 0.13015, 0)
    Notif.Position = UDim2.new(0.83197, 0, -0.15, 0)
    Notif.BackgroundColor3 = Libraries[1].CurrentTheme.Secondary
    Notif.TextColor3 = Libraries[1].CurrentTheme.Text
    Notif.Text = title:upper() .. "\n" .. desc
    Notif.Font = "GothamBold"
    Notif.TextSize = 12
    Notif.TextWrapped = true
    Notif.BorderSizePixel = 0
    Notif.ZIndex = 100 + #NotificationSystem.Active
    Notif.BackgroundTransparency = 0.1
    
    local Aspect = Instance.new("UIAspectRatioConstraint", Notif)
    Aspect.AspectRatio = 2.91304
    
    local Corner = Instance.new("UICorner", Notif)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = Libraries[1].CurrentTheme.Accent
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.3
    
    local yPos = NotificationSystem.StartY + (#NotificationSystem.Active * NotificationSystem.Spacing)
    table.insert(NotificationSystem.Active, Notif)
    
    Notif:TweenPosition(UDim2.new(0.83197, 0, yPos, 0), "Out", "Quart", 0.5)
    
    local dragStart, dragActive = nil, false
    local changedConnection, endedConnection
    
    local function cleanupDrag()
        dragActive = false
        if changedConnection then
            changedConnection:Disconnect()
            changedConnection = nil
        end
        if endedConnection then
            endedConnection:Disconnect()
            endedConnection = nil
        end
    end
    
    Notif.InputBegan:Connect(function(input)
        if not Notif or not Notif.Parent then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragActive = true
            dragStart = input.Position.X
            
            if not changedConnection then
                changedConnection = UserInputService.InputChanged:Connect(function(changedInput)
                    if not dragActive or not Notif or not Notif.Parent then 
                        cleanupDrag()
                        return 
                    end
                    
                    if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch then
                        local delta = changedInput.Position.X - dragStart
                        if delta > 0 then
                            Notif.Position = UDim2.new(0.83197 + (delta/1000), 0, yPos, 0)
                        end
                    end
                end)
            end
            
            if not endedConnection then
                endedConnection = UserInputService.InputEnded:Connect(function(endedInput)
                    if not dragActive or not Notif or not Notif.Parent then 
                        cleanupDrag()
                        return 
                    end
                    
                    if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                        local delta = endedInput.Position.X - dragStart
                        
                        if delta > 100 then
                            local idx = table.find(NotificationSystem.Active, Notif)
                            if idx then
                                table.remove(NotificationSystem.Active, idx)
                            end
                            
                            Notif:TweenPosition(UDim2.new(1.5, 0, yPos, 0), "Out", "Quint", 0.3, true, function()
                                if Notif and Notif.Parent then
                                    Notif:Destroy()
                                end
                            end)
                            Vibrate()
                            
                            task.wait(0.1)
                            for i, n in ipairs(NotificationSystem.Active) do
                                if n and n.Parent then
                                    local newY = NotificationSystem.StartY + ((i-1) * NotificationSystem.Spacing)
                                    n:TweenPosition(UDim2.new(0.83197, 0, newY, 0), "Out", "Quart", 0.3)
                                end
                            end
                        else
                            Notif:TweenPosition(UDim2.new(0.83197, 0, yPos, 0), "Out", "Quart", 0.2)
                        end
                        
                        cleanupDrag()
                    end
                end)
            end
        end
    end)
    
    task.delay(duration, function()
        if Notif and Notif.Parent then
            local idx = table.find(NotificationSystem.Active, Notif)
            if idx then
                table.remove(NotificationSystem.Active, idx)
            end
            
            Notif:TweenPosition(UDim2.new(0.83197, 0, -0.15, 0), "In", "Quart", 0.5, true, function()
                if Notif and Notif.Parent then
                    Notif:Destroy()
                end
            end)
            
            for i, n in ipairs(NotificationSystem.Active) do
                if n and n.Parent then
                    local newY = NotificationSystem.StartY + ((i-1) * NotificationSystem.Spacing)
                    n:TweenPosition(UDim2.new(0.83197, 0, newY, 0), "Out", "Quart", 0.3)
                end
            end
        end
    end)
end

-- Função para criar janela principal
function Libra:CreateWindow(config)
    config = config or {}
    
    -- Configurações padrão
    config.Name = config.Name or "LIBRAS UI"
    config.Subtitle = config.Subtitle or ""
    config.LogoID = config.LogoID or nil
    config.OpenButtonName = config.OpenButtonName or "OPEN MENU"
    config.OpenButtonPosition = config.OpenButtonPosition or {X = 350, Y = 30}
    
    -- Configurações de pasta
    config.ConfigSettings = config.ConfigSettings or {}
    config.ConfigSettings.RootFolder = config.ConfigSettings.RootFolder or "LIBRAYS HUB"
    config.ConfigSettings.ConfigFolder = config.ConfigSettings.ConfigFolder or "Configs"
    
    -- Sistema de key
    config.KeySystem = config.KeySystem or false
    config.KeySettings = config.KeySettings or {}
    config.KeySettings.Title = config.KeySettings.Title or "Key System"
    config.KeySettings.Subtitle = config.KeySettings.Subtitle or "Insira sua key"
    config.KeySettings.Note = config.KeySettings.Note or ""
    config.KeySettings.SaveKey = config.KeySettings.SaveKey or true
    config.KeySettings.Key = config.KeySettings.Key or {"1234"}
    
    -- Criar pasta se não existir
    local FullPath = config.ConfigSettings.RootFolder .. "/" .. config.ConfigSettings.ConfigFolder
    if not isfolder(config.ConfigSettings.RootFolder) then
        makefolder(config.ConfigSettings.RootFolder)
    end
    if not isfolder(FullPath) then
        makefolder(FullPath)
    end
    
    -- Estado da janela
    local Window = {
        Name = config.Name,
        Subtitle = config.Subtitle,
        LogoID = config.LogoID,
        OpenButtonName = config.OpenButtonName,
        OpenButtonPosition = config.OpenButtonPosition,
        ConfigSettings = config.ConfigSettings,
        KeySystem = config.KeySystem,
        KeySettings = config.KeySettings,
        Screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")),
        CurrentTheme = DefaultThemes.Dark,
        Themes = DefaultThemes,
        Tabs = {},
        CurrentTab = nil,
        Settings = {
            Toggles = {},
            ThemeName = "Dark",
            AutoLoad = false,
            CompactMode = true,
            CustomColors = {
                Main = nil,
                Secondary = nil,
                Accent = nil,
                Text = nil
            }
        },
        LastKey = "",
        StartTime = tick()
    }
    
    Window.Screen.Name = "LIBRAS_UI_" .. config.Name:gsub("%s+", "_")
    Window.Screen.ResetOnSpawn = false
    Window.Screen.IgnoreGuiInset = true
    
    -- Overlay
    Window.Overlay = Instance.new("Frame", Window.Screen)
    Window.Overlay.Size = UDim2.new(1, 0, 1, 0)
    Window.Overlay.BackgroundTransparency = 0.5
    Window.Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Window.Overlay.Visible = false
    Window.Overlay.ZIndex = 19
    Window.Overlay.Active = true
    Window.Overlay.Draggable = false
    
    -- Blur
    Window.Blur = Instance.new("BlurEffect", Lighting)
    Window.Blur.Size = 0
    Window.Blur.Enabled = false
    
    -- Criar estrutura da UI
    Window.Main = Instance.new("Frame", Window.Screen)
    if IsMobile then
        Window.Main.Size = UDim2.new(0, 550, 0, 350)
        Window.Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    else
        Window.Main.Size = UDim2.new(0, 650, 0, 400)
        Window.Main.Position = UDim2.new(0.5, -325, 0.5, -200)
    end
    Window.Main.BackgroundColor3 = Window.CurrentTheme.Main
    Window.Main.Visible = false
    Window.Main.ClipsDescendants = true
    Instance.new("UICorner", Window.Main).CornerRadius = UDim.new(0, 12)
    
    -- TopBar
    Window.TopBar = Instance.new("Frame", Window.Main)
    Window.TopBar.Size = UDim2.new(1, 0, 0, 45)
    Window.TopBar.BackgroundColor3 = Window.CurrentTheme.Secondary
    Instance.new("UICorner", Window.TopBar).CornerRadius = UDim.new(0, 12)
    
    -- Título
    Window.Title = Instance.new("TextLabel", Window.TopBar)
    Window.Title.Size = UDim2.new(0.5, 0, 1, 0)
    Window.Title.Text = "  " .. config.Name .. " <font color='#FFFFFF'>" .. config.Subtitle .. "</font>"
    Window.Title.RichText = true
    Window.Title.TextColor3 = Window.CurrentTheme.Accent
    Window.Title.Font = "GothamBold"
    Window.Title.TextSize = IsMobile and 16 or 18
    Window.Title.TextXAlignment = "Left"
    Window.Title.BackgroundTransparency = 1
    
    -- Botão minimizar
    Window.MiniBtn = Instance.new("TextButton", Window.TopBar)
    Window.MiniBtn.Text = "-"
    Window.MiniBtn.Size = UDim2.new(0, 28, 0, 28)
    Window.MiniBtn.Position = UDim2.new(1, -70, 0.5, -14)
    Window.MiniBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Window.MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Window.MiniBtn.Font = "GothamBold"
    Window.MiniBtn.AutoButtonColor = false
    Instance.new("UICorner", Window.MiniBtn).CornerRadius = UDim.new(1, 0)
    
    -- Botão OPEN MENU flutuante
    Window.OpenBtn = Instance.new("TextButton", Window.Screen)
    Window.OpenBtn.Size = UDim2.new(0, 140, 0, 35)
    Window.OpenBtn.Position = UDim2.new(0, config.OpenButtonPosition.X, 0, config.OpenButtonPosition.Y)
    Window.OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Window.OpenBtn.Text = config.OpenButtonName
    Window.OpenBtn.TextColor3 = Window.CurrentTheme.Accent
    Window.OpenBtn.Font = "GothamBold"
    Window.OpenBtn.TextSize = 14
    Window.OpenBtn.Visible = true
    Window.OpenBtn.BackgroundTransparency = 0
    Window.OpenBtn.BorderSizePixel = 0
    Window.OpenBtn.AutoButtonColor = false
    Instance.new("UICorner", Window.OpenBtn).CornerRadius = UDim.new(0, 8)
    
    -- Sidebar
    Window.Sidebar = Instance.new("ScrollingFrame", Window.Main)
    Window.Sidebar.Size = UDim2.new(0, IsMobile and 120 or 140, 1, -60)
    Window.Sidebar.Position = UDim2.new(0, 10, 0, 55)
    Window.Sidebar.BackgroundTransparency = 1
    Window.Sidebar.ScrollBarThickness = 0
    Window.Sidebar.CanvasSize = UDim2.new(0,0,0,0)
    
    -- Container
    Window.Container = Instance.new("Frame", Window.Main)
    Window.Container.Size = UDim2.new(1, -(IsMobile and 150 or 170), 1, -70)
    Window.Container.Position = UDim2.new(0, IsMobile and 140 or 160, 0, 55)
    Window.Container.BackgroundTransparency = 1
    Window.Container.ClipsDescendants = true
    
    -- Lista da sidebar
    Window.SidebarList = Instance.new("UIListLayout", Window.Sidebar)
    Window.SidebarList.Padding = UDim.new(0, 5)
    Window.SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Window.Sidebar.CanvasSize = UDim2.new(0, 0, 0, Window.SidebarList.AbsoluteContentSize.Y)
    end)
    
    -- Controles de arrastar
    local dStart, sPos, drag = nil, nil, false
    Window.TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dStart = i.Position
            sPos = Window.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dStart
            Window.Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function()
        drag = false
    end)
    
    -- Controles de minimizar
    Window.MiniBtn.MouseButton1Click:Connect(function()
        Vibrate()
        Window.Main.Visible = false
        Window.Blur.Enabled = false
        Window.OpenBtn.Visible = true
        Window.OpenBtn:TweenPosition(UDim2.new(0, config.OpenButtonPosition.X, 0, config.OpenButtonPosition.Y), "Out", "Quart", 0.5)
    end)
    
    Window.OpenBtn.MouseButton1Click:Connect(function()
        Vibrate()
        Window.Main.Visible = true
        Window.Blur.Enabled = true
        Window.OpenBtn:TweenPosition(UDim2.new(0, config.OpenButtonPosition.X, 0, -154), "In", "Quart", 0.5, true, function()
            Window.OpenBtn.Visible = false
        end)
    end)
    
    -- Função para criar aba
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        tabConfig.Name = tabConfig.Name or "Aba"
        
        local Tab = {
            Name = tabConfig.Name,
            Window = Window,
            Page = nil,
            Elements = {}
        }
        
        -- Botão da aba na sidebar
        Tab.TabBtn = Instance.new("TextButton", Window.Sidebar)
        Tab.TabBtn.Size = UDim2.new(1, 0, 0, IsMobile and 35 or 38)
        Tab.TabBtn.BackgroundColor3 = Window.CurrentTheme.Secondary
        Tab.TabBtn.Text = "  " .. tabConfig.Name
        Tab.TabBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        Tab.TabBtn.Font = "GothamSemibold"
        Tab.TabBtn.TextSize = IsMobile and 12 or 13
        Tab.TabBtn.TextXAlignment = "Left"
        Tab.TabBtn.AutoButtonColor = false
        Instance.new("UICorner", Tab.TabBtn).CornerRadius = UDim.new(0, 8)
        
        -- Página da aba
        Tab.Page = Instance.new("ScrollingFrame", Window.Container)
        Tab.Page.Name = tabConfig.Name .. "_Page"
        Tab.Page.Size = UDim2.new(1, 0, 1, 0)
        Tab.Page.BackgroundTransparency = 1
        Tab.Page.Visible = false
        Tab.Page.ScrollBarThickness = 4
        Tab.Page.ScrollBarImageColor3 = Window.CurrentTheme.Accent
        Tab.Page.CanvasSize = UDim2.new(0,0,0,0)
        
        -- Layout da página
        Tab.PageList = Instance.new("UIListLayout", Tab.Page)
        Tab.PageList.Padding = UDim.new(0, 8)
        Tab.PageList.HorizontalAlignment = "Center"
        Tab.PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Tab.Page.CanvasSize = UDim2.new(0, 0, 0, Tab.PageList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Evento de clique na aba
        Tab.TabBtn.MouseButton1Click:Connect(function()
            Vibrate()
            for _, p in pairs(Window.Container:GetChildren()) do
                if p:IsA("ScrollingFrame") then
                    p.Visible = false
                end
            end
            for _, b in pairs(Window.Sidebar:GetChildren()) do
                if b:IsA("TextButton") then
                    b.TextColor3 = Color3.fromRGB(160, 160, 160)
                end
            end
            Tab.Page.Visible = true
            Tab.TabBtn.TextColor3 = Window.CurrentTheme.Accent
        end)
        
        -- Se não há aba selecionada, seleciona esta
        if not Window.CurrentTab then
            Window.CurrentTab = Tab
            Tab.Page.Visible = true
            Tab.TabBtn.TextColor3 = Window.CurrentTheme.Accent
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- FUNÇÕES DA ABA
        
        -- Criar seção expansível
        function Tab:CreateSection(name)
            local SectionFrame = Instance.new("Frame", Tab.Page)
            SectionFrame.Size = UDim2.new(0.95, 0, 0, 35)
            SectionFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            SectionFrame.BackgroundTransparency = 0.2
            SectionFrame.ClipsDescendants = true
            SectionFrame.ZIndex = 1
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 8)
            
            -- Cabeçalho
            local Header = Instance.new("Frame", SectionFrame)
            Header.Size = UDim2.new(1, 0, 0, 35)
            Header.BackgroundTransparency = 1
            Header.ZIndex = 10
            Header.Active = true
            
            -- Botão do cabeçalho
            local SectionBtn = Instance.new("TextButton", Header)
            SectionBtn.Size = UDim2.new(1, 0, 1, 0)
            SectionBtn.BackgroundTransparency = 1
            SectionBtn.Text = ""
            SectionBtn.AutoButtonColor = false
            SectionBtn.ZIndex = 11
            
            -- Seta
            local Arrow = Instance.new("TextLabel", Header)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Window.CurrentTheme.Accent
            Arrow.Font = "GothamBold"
            Arrow.TextSize = 14
            Arrow.ZIndex = 12
            
            -- Título
            local TitleLabel = Instance.new("TextLabel", Header)
            TitleLabel.Size = UDim2.new(1, -40, 1, 0)
            TitleLabel.Position = UDim2.new(0, 10, 0, 0)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = "  " .. name
            TitleLabel.TextColor3 = Window.CurrentTheme.Text
            TitleLabel.Font = "GothamBold"
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = "Left"
            TitleLabel.ZIndex = 12
            
            -- Container para elementos
            local Container = Instance.new("Frame", SectionFrame)
            Container.Size = UDim2.new(1, 0, 0, 0)
            Container.Position = UDim2.new(0, 0, 0, 35)
            Container.BackgroundTransparency = 1
            Container.ClipsDescendants = true
            Container.ZIndex = 5
            
            local ContainerList = Instance.new("UIListLayout", Container)
            ContainerList.Padding = UDim.new(0, 8)
            ContainerList.HorizontalAlignment = "Center"
            
            local open = true
            local contentHeight = 0
            
            ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                contentHeight = ContainerList.AbsoluteContentSize.Y
                if open then
                    SectionFrame.Size = UDim2.new(0.95, 0, 0, 35 + contentHeight)
                    Container.Size = UDim2.new(1, 0, 0, contentHeight)
                end
            end)
            
            SectionBtn.MouseButton1Click:Connect(function()
                open = not open
                Arrow.Text = open and "▼" or "▶"
                
                if open then
                    TweenService:Create(SectionFrame, Easing.Smooth, {
                        Size = UDim2.new(0.95, 0, 0, 35 + contentHeight)
                    }):Play()
                    TweenService:Create(Container, Easing.Smooth, {
                        Size = UDim2.new(1, 0, 0, contentHeight)
                    }):Play()
                else
                    TweenService:Create(SectionFrame, Easing.Smooth, {
                        Size = UDim2.new(0.95, 0, 0, 35)
                    }):Play()
                    TweenService:Create(Container, Easing.Smooth, {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                end
            end)
            
            local SectionAPI = {}
            SectionAPI.Container = Container
            
            function SectionAPI:AddElement(elemento)
                elemento.Parent = Container
            end
            
            return SectionAPI
        end
        
        -- Criar botão
        function Tab:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            btnConfig.Name = btnConfig.Name or "Botão"
            btnConfig.Description = btnConfig.Description or ""
            btnConfig.Callback = btnConfig.Callback or function() end
            
            local Btn = Instance.new("TextButton", Tab.Page)
            Btn.Size = UDim2.new(0.95, 0, 0, 45)
            Btn.BackgroundColor3 = Window.CurrentTheme.Secondary
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", Btn)
            T.Size = UDim2.new(1, -20, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = btnConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", Btn)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -20, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = btnConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            Btn.MouseButton1Click:Connect(function()
                Vibrate()
                pcall(btnConfig.Callback)
            end)
            
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, Easing.Quick, {BackgroundColor3 = Window.CurrentTheme.Secondary:Lerp(Color3.fromRGB(45,45,45), 0.5)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, Easing.Quick, {BackgroundColor3 = Window.CurrentTheme.Secondary}):Play()
            end)
            
            return Btn
        end
        
        -- Criar toggle
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            toggleConfig.Name = toggleConfig.Name or "Toggle"
            toggleConfig.Description = toggleConfig.Description or ""
            toggleConfig.CurrentValue = toggleConfig.CurrentValue or false
            toggleConfig.Callback = toggleConfig.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame", Tab.Page)
            ToggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
            ToggleFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", ToggleFrame)
            T.Size = UDim2.new(1, -70, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = toggleConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", ToggleFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -70, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = toggleConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local ToggleBtn = Instance.new("TextButton", ToggleFrame)
            ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
            
            local ToggleCircle = Instance.new("Frame", ToggleBtn)
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Window.CurrentTheme.Text
            Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
            
            local state = toggleConfig.CurrentValue
            local function UpdateToggle()
                if state then
                    TweenService:Create(ToggleBtn, Easing.Quick, {BackgroundColor3 = Window.CurrentTheme.Accent}):Play()
                    TweenService:Create(ToggleCircle, Easing.Quick, {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
                else
                    TweenService:Create(ToggleBtn, Easing.Quick, {BackgroundColor3 = Color3.fromRGB(80,80,80)}):Play()
                    TweenService:Create(ToggleCircle, Easing.Quick, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
                pcall(toggleConfig.Callback, state)
            end
            UpdateToggle()
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Vibrate()
                state = not state
                UpdateToggle()
            end)
            
            return ToggleFrame
        end
        
        -- Criar input
        function Tab:CreateInput(inputConfig)
            inputConfig = inputConfig or {}
            inputConfig.Name = inputConfig.Name or "Input"
            inputConfig.Description = inputConfig.Description or ""
            inputConfig.PlaceholderText = inputConfig.PlaceholderText or "Digite algo..."
            inputConfig.Numeric = inputConfig.Numeric or false
            inputConfig.Callback = inputConfig.Callback or function() end
            
            local InputFrame = Instance.new("Frame", Tab.Page)
            InputFrame.Size = UDim2.new(0.95, 0, 0, 70)
            InputFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", InputFrame)
            T.Size = UDim2.new(1, -20, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = inputConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", InputFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -20, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = inputConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local Box = Instance.new("TextBox", InputFrame)
            Box.Size = UDim2.new(0.95, 0, 0, 25)
            Box.Position = UDim2.new(0.025, 0, 0, 40)
            Box.BackgroundColor3 = Window.CurrentTheme.Main
            Box.TextColor3 = Window.CurrentTheme.Text
            Box.PlaceholderText = inputConfig.PlaceholderText
            Box.PlaceholderColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(120,120,120), 0.5)
            Box.Font = "Gotham"
            Box.TextSize = 12
            Box.Text = ""
            Box.ClearTextOnFocus = false
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
            
            Box.FocusLost:Connect(function(enter)
                if enter then
                    local value = Box.Text
                    if inputConfig.Numeric then
                        value = tonumber(value) or 0
                    end
                    pcall(inputConfig.Callback, value)
                end
            end)
            
            return InputFrame
        end
        
        -- Criar dropdown
        function Tab:CreateDropdown(dropConfig)
            dropConfig = dropConfig or {}
            dropConfig.Name = dropConfig.Name or "Dropdown"
            dropConfig.Description = dropConfig.Description or ""
            dropConfig.Options = dropConfig.Options or {"Opção 1", "Opção 2"}
            dropConfig.CurrentOption = dropConfig.CurrentOption or dropConfig.Options[1]
            dropConfig.MultipleOptions = dropConfig.MultipleOptions or false
            dropConfig.Callback = dropConfig.Callback or function() end
            
            local DropFrame = Instance.new("Frame", Tab.Page)
            DropFrame.Size = UDim2.new(0.95, 0, 0, 45)
            DropFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", DropFrame)
            T.Size = UDim2.new(1, -100, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = dropConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", DropFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -100, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = dropConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local SelectedFrame = Instance.new("Frame", DropFrame)
            SelectedFrame.Size = UDim2.new(0, 80, 0, 25)
            SelectedFrame.Position = UDim2.new(1, -100, 0.5, -12.5)
            SelectedFrame.BackgroundColor3 = Window.CurrentTheme.Main
            Instance.new("UICorner", SelectedFrame).CornerRadius = UDim.new(0, 4)
            
            local SelectedLabel = Instance.new("TextLabel", SelectedFrame)
            SelectedLabel.Size = UDim2.new(1, -10, 1, 0)
            SelectedLabel.Position = UDim2.new(0, 5, 0, 0)
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Text = dropConfig.CurrentOption
            SelectedLabel.TextColor3 = Window.CurrentTheme.Accent
            SelectedLabel.Font = "GothamBold"
            SelectedLabel.TextSize = 11
            SelectedLabel.TextXAlignment = "Left"
            
            local Arrow = Instance.new("TextLabel", DropFrame)
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -30, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Window.CurrentTheme.Accent
            Arrow.Font = "GothamBold"
            Arrow.TextSize = 12
            
            local DropBtn = Instance.new("TextButton", DropFrame)
            DropBtn.Size = UDim2.new(1, 0, 0, 45)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.AutoButtonColor = false
            
            local DropContainer = Instance.new("ScrollingFrame", DropFrame)
            DropContainer.Size = UDim2.new(1, -10, 0, 0)
            DropContainer.Position = UDim2.new(0, 5, 0, 45)
            DropContainer.BackgroundTransparency = 1
            DropContainer.ClipsDescendants = true
            DropContainer.ScrollBarThickness = 4
            DropContainer.ScrollBarImageColor3 = Window.CurrentTheme.Accent
            DropContainer.CanvasSize = UDim2.new(0, 0, 0, #dropConfig.Options * 25)
            DropContainer.Visible = false
            
            local DropList = Instance.new("UIListLayout", DropContainer)
            DropList.Padding = UDim.new(0, 2)
            DropList.HorizontalAlignment = "Center"
            
            local open = false
            local selected = dropConfig.CurrentOption
            
            for _, opt in ipairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton", DropContainer)
                OptBtn.Size = UDim2.new(0.95, 0, 0, 23)
                OptBtn.BackgroundColor3 = Window.CurrentTheme.Main
                OptBtn.Text = "  " .. opt
                OptBtn.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(200,200,200), 0.5)
                OptBtn.Font = "Gotham"
                OptBtn.TextSize = 11
                OptBtn.TextXAlignment = "Left"
                OptBtn.AutoButtonColor = false
                Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
                
                OptBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    SelectedLabel.Text = opt
                    DropContainer.Visible = false
                    open = false
                    Arrow.Text = "▼"
                    TweenService:Create(DropFrame, Easing.Smooth, {Size = UDim2.new(0.95, 0, 0, 45)}):Play()
                    pcall(dropConfig.Callback, opt)
                end)
                
                OptBtn.MouseEnter:Connect(function()
                    TweenService:Create(OptBtn, Easing.Quick, {BackgroundColor3 = Window.CurrentTheme.Secondary}):Play()
                end)
                OptBtn.MouseLeave:Connect(function()
                    TweenService:Create(OptBtn, Easing.Quick, {BackgroundColor3 = Window.CurrentTheme.Main}):Play()
                end)
            end
            
            DropBtn.MouseButton1Click:Connect(function()
                open = not open
                Arrow.Text = open and "▲" or "▼"
                DropContainer.Visible = open
                if open then
                    local newHeight = 45 + math.min(150, #dropConfig.Options * 25)
                    TweenService:Create(DropFrame, Easing.Smooth, {Size = UDim2.new(0.95, 0, 0, newHeight)}):Play()
                    DropContainer.Size = UDim2.new(1, -10, 0, newHeight - 45)
                else
                    TweenService:Create(DropFrame, Easing.Smooth, {Size = UDim2.new(0.95, 0, 0, 45)}):Play()
                end
            end)
            
            return DropFrame
        end
        
        -- Criar slider
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            sliderConfig.Name = sliderConfig.Name or "Slider"
            sliderConfig.Description = sliderConfig.Description or ""
            sliderConfig.Range = sliderConfig.Range or {0, 100}
            sliderConfig.Increment = sliderConfig.Increment or 1
            sliderConfig.CurrentValue = sliderConfig.CurrentValue or sliderConfig.Range[1]
            sliderConfig.Callback = sliderConfig.Callback or function() end
            
            local SliderFrame = Instance.new("Frame", Tab.Page)
            SliderFrame.Size = UDim2.new(0.95, 0, 0, 70)
            SliderFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", SliderFrame)
            T.Size = UDim2.new(1, -80, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = sliderConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", SliderFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -80, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = sliderConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local ValueLabel = Instance.new("TextLabel", SliderFrame)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(sliderConfig.CurrentValue)
            ValueLabel.TextColor3 = Window.CurrentTheme.Accent
            ValueLabel.Font = "GothamBold"
            ValueLabel.TextSize = 14
            
            local SliderBar = Instance.new("Frame", SliderFrame)
            SliderBar.Size = UDim2.new(0.95, 0, 0, 6)
            SliderBar.Position = UDim2.new(0.025, 0, 0, 50)
            SliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
            Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame", SliderBar)
            Fill.Size = UDim2.new((sliderConfig.CurrentValue - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1]), 0, 1, 0)
            Fill.BackgroundColor3 = Window.CurrentTheme.Accent
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            local Drag = Instance.new("TextButton", SliderBar)
            Drag.Size = UDim2.new(0, 18, 0, 18)
            Drag.Position = UDim2.new((sliderConfig.CurrentValue - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1]), -9, 0.5, -9)
            Drag.BackgroundColor3 = Window.CurrentTheme.Text
            Drag.Text = ""
            Drag.ZIndex = 5
            Drag.AutoButtonColor = false
            Instance.new("UICorner", Drag).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            local function updateSlider(input)
                if not dragging then return end
                
                local localPoint = SliderBar.AbsolutePosition
                local x = input.Position.X
                local relativeX = math.clamp(x - localPoint.X, 0, SliderBar.AbsoluteSize.X)
                local percent = relativeX / SliderBar.AbsoluteSize.X
                
                local rawValue = sliderConfig.Range[1] + (sliderConfig.Range[2] - sliderConfig.Range[1]) * percent
                local steppedValue = math.floor(rawValue / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                steppedValue = math.clamp(steppedValue, sliderConfig.Range[1], sliderConfig.Range[2])
                
                local adjustedPercent = (steppedValue - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1])
                
                Fill.Size = UDim2.new(adjustedPercent, 0, 1, 0)
                Drag.Position = UDim2.new(adjustedPercent, -9, 0.5, -9)
                
                ValueLabel.Text = tostring(steppedValue)
                
                pcall(sliderConfig.Callback, steppedValue)
            end
            
            Drag.MouseButton1Down:Connect(function(input)
                dragging = true
                updateSlider(input)
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            if IsMobile then
                Drag.TouchTap:Connect(function(touch)
                    dragging = true
                    updateSlider(touch)
                end)
            end
            
            return SliderFrame
        end
        
        -- Criar keybind
        function Tab:CreateKeybind(keyConfig)
            keyConfig = keyConfig or {}
            keyConfig.Name = keyConfig.Name or "Keybind"
            keyConfig.Description = keyConfig.Description or ""
            keyConfig.CurrentBind = keyConfig.CurrentBind or "G"
            keyConfig.HoldToInteract = keyConfig.HoldToInteract or false
            keyConfig.Callback = keyConfig.Callback or function() end
            keyConfig.OnChangedCallback = keyConfig.OnChangedCallback or function() end
            
            local KeyFrame = Instance.new("Frame", Tab.Page)
            KeyFrame.Size = UDim2.new(0.95, 0, 0, 45)
            KeyFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", KeyFrame)
            T.Size = UDim2.new(1, -100, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = keyConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", KeyFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -100, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = keyConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local KeyBtn = Instance.new("TextButton", KeyFrame)
            KeyBtn.Size = UDim2.new(0, 60, 0, 25)
            KeyBtn.Position = UDim2.new(1, -70, 0.5, -12.5)
            KeyBtn.BackgroundColor3 = Window.CurrentTheme.Main
            KeyBtn.Text = keyConfig.CurrentBind
            KeyBtn.TextColor3 = Window.CurrentTheme.Accent
            KeyBtn.Font = "GothamBold"
            KeyBtn.TextSize = 12
            KeyBtn.AutoButtonColor = false
            Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)
            
            local listening = false
            local currentKey = keyConfig.CurrentBind
            local holding = false
            
            KeyBtn.MouseButton1Click:Connect(function()
                listening = true
                KeyBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        KeyBtn.Text = currentKey
                        listening = false
                        pcall(keyConfig.OnChangedCallback, {Name = currentKey})
                    end
                end
                
                if not gameProcessed and input.KeyCode.Name == currentKey then
                    if keyConfig.HoldToInteract then
                        holding = true
                        pcall(keyConfig.Callback, true)
                    else
                        pcall(keyConfig.Callback)
                    end
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if keyConfig.HoldToInteract and input.KeyCode.Name == currentKey then
                    holding = false
                    pcall(keyConfig.Callback, false)
                end
            end)
            
            return KeyFrame
        end
        
        -- Criar color picker
        function Tab:CreateColorPicker(colorConfig)
            colorConfig = colorConfig or {}
            colorConfig.Name = colorConfig.Name or "Color Picker"
            colorConfig.Description = colorConfig.Description or ""
            colorConfig.Color = colorConfig.Color or Color3.fromRGB(86, 171, 128)
            colorConfig.Callback = colorConfig.Callback or function() end
            
            local ColorFrame = Instance.new("Frame", Tab.Page)
            ColorFrame.Size = UDim2.new(0.95, 0, 0, 45)
            ColorFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            Instance.new("UICorner", ColorFrame).CornerRadius = UDim.new(0, 8)
            
            local T = Instance.new("TextLabel", ColorFrame)
            T.Size = UDim2.new(1, -80, 0, 20)
            T.Position = UDim2.new(0, 10, 0, 5)
            T.BackgroundTransparency = 1
            T.Text = colorConfig.Name
            T.TextColor3 = Window.CurrentTheme.Text
            T.Font = "GothamBold"
            T.TextSize = IsMobile and 13 or 14
            T.TextXAlignment = "Left"
            
            local D = Instance.new("TextLabel", ColorFrame)
            D.Name = "Desc"
            D.Size = UDim2.new(1, -80, 0, 18)
            D.Position = UDim2.new(0, 10, 0, 22)
            D.BackgroundTransparency = 1
            D.Text = colorConfig.Description
            D.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            D.Font = "Gotham"
            D.TextSize = IsMobile and 10 or 11
            D.TextXAlignment = "Left"
            D.Visible = not Window.Settings.CompactMode
            
            local ColorDisplay = Instance.new("Frame", ColorFrame)
            ColorDisplay.Size = UDim2.new(0, 30, 0, 20)
            ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
            ColorDisplay.BackgroundColor3 = colorConfig.Color
            Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 4)
            
            local PickBtn = Instance.new("TextButton", ColorFrame)
            PickBtn.Size = UDim2.new(1, 0, 0, 45)
            PickBtn.BackgroundTransparency = 1
            PickBtn.Text = ""
            PickBtn.AutoButtonColor = false
            
            -- Picker Frame
            local PickerFrame = Instance.new("Frame", Window.Screen)
            PickerFrame.Size = UDim2.new(0, 320, 0, 380)
            PickerFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
            PickerFrame.BackgroundColor3 = Window.CurrentTheme.Main
            PickerFrame.Visible = false
            PickerFrame.ZIndex = 20
            PickerFrame.ClipsDescendants = true
            Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 12)
            
            -- Título
            local PickerTitle = Instance.new("TextLabel", PickerFrame)
            PickerTitle.Size = UDim2.new(1, 0, 0, 40)
            PickerTitle.BackgroundColor3 = Window.CurrentTheme.Secondary
            PickerTitle.Text = "  SELECIONAR COR - " .. colorConfig.Name
            PickerTitle.TextColor3 = Window.CurrentTheme.Accent
            PickerTitle.Font = "GothamBold"
            PickerTitle.TextSize = 12
            PickerTitle.TextXAlignment = "Left"
            PickerTitle.ZIndex = 21
            Instance.new("UICorner", PickerTitle).CornerRadius = UDim.new(0, 12)
            
            -- Botões Confirmar/Cancelar
            local ConfirmBtn = Instance.new("TextButton", PickerFrame)
            ConfirmBtn.Size = UDim2.new(0.4, -5, 0, 30)
            ConfirmBtn.Position = UDim2.new(0.05, 0, 0, 340)
            ConfirmBtn.BackgroundColor3 = Window.CurrentTheme.Accent
            ConfirmBtn.Text = "CONFIRMAR"
            ConfirmBtn.TextColor3 = Window.CurrentTheme.Main
            ConfirmBtn.Font = "GothamBold"
            ConfirmBtn.TextSize = 12
            ConfirmBtn.ZIndex = 21
            ConfirmBtn.AutoButtonColor = false
            Instance.new("UICorner", ConfirmBtn).CornerRadius = UDim.new(0, 6)
            
            local CancelBtn = Instance.new("TextButton", PickerFrame)
            CancelBtn.Size = UDim2.new(0.4, -5, 0, 30)
            CancelBtn.Position = UDim2.new(0.55, 0, 0, 340)
            CancelBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
            CancelBtn.Text = "CANCELAR"
            CancelBtn.TextColor3 = Color3.fromRGB(255,255,255)
            CancelBtn.Font = "GothamBold"
            CancelBtn.TextSize = 12
            CancelBtn.ZIndex = 21
            CancelBtn.AutoButtonColor = false
            Instance.new("UICorner", CancelBtn).CornerRadius = UDim.new(0, 6)
            
            -- Área de seleção de cor
            local ColorArea = Instance.new("Frame", PickerFrame)
            ColorArea.Size = UDim2.new(0, 220, 0, 220)
            ColorArea.Position = UDim2.new(0.5, -110, 0, 50)
            ColorArea.BackgroundColor3 = Color3.fromRGB(255,0,0)
            ColorArea.ZIndex = 21
            Instance.new("UICorner", ColorArea).CornerRadius = UDim.new(0, 8)
            
            -- Gradiente SV
            local SV_Gradient = Instance.new("ImageLabel", ColorArea)
            SV_Gradient.Size = UDim2.new(1, 0, 1, 0)
            SV_Gradient.BackgroundTransparency = 1
            SV_Gradient.Image = "rbxassetid://4155801252"
            SV_Gradient.ZIndex = 22
            
            -- BARRA RGB
            local RGBBar = Instance.new("Frame", PickerFrame)
            RGBBar.Size = UDim2.new(0, 280, 0, 30)
            RGBBar.Position = UDim2.new(0.5, -140, 0, 280)
            RGBBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
            RGBBar.ZIndex = 21
            RGBBar.ClipsDescendants = true
            Instance.new("UICorner", RGBBar).CornerRadius = UDim.new(1, 0)
            
            local UIGradient = Instance.new("UIGradient", RGBBar)
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 0))
            }
            UIGradient.Rotation = 0
            
            local Picker = Instance.new("Frame", RGBBar)
            Picker.Size = UDim2.new(0, 16, 0, 16)
            Picker.AnchorPoint = Vector2.new(0.5, 0.5)
            Picker.Position = UDim2.new(0, 0, 0.5, 0)
            Picker.BackgroundColor3 = Window.CurrentTheme.Text
            Picker.BorderSizePixel = 0
            Picker.ZIndex = 30
            Instance.new("UICorner", Picker).CornerRadius = UDim.new(1,0)
            Instance.new("UIStroke", Picker).Thickness = 2
            
            local ColorSelector = Instance.new("Frame", ColorArea)
            ColorSelector.Size = UDim2.new(0, 16, 0, 16)
            ColorSelector.Position = UDim2.new(1, -8, 0, -8)
            ColorSelector.BackgroundColor3 = Window.CurrentTheme.Text
            ColorSelector.ZIndex = 23
            ColorSelector.BorderSizePixel = 2
            ColorSelector.BorderColor3 = Color3.fromRGB(0,0,0)
            Instance.new("UICorner", ColorSelector).CornerRadius = UDim.new(1, 0)
            
            -- Lógica do Color Picker
            local h, s, v = Color3.toHSV(colorConfig.Color)
            s = s or 1
            v = v or 1
            h = h or 0
            
            local originalColor = colorConfig.Color
            local previewColor = colorConfig.Color
            
            local function updateHue(newH)
                h = newH
                ColorArea.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Picker.Position = UDim2.new(h, 0, 0.5, 0)
                previewColor = Color3.fromHSV(h, s, v)
                ColorDisplay.BackgroundColor3 = previewColor
            end
            
            local function updateSV(x, y)
                s = math.clamp(x / 220, 0, 1)
                v = 1 - math.clamp(y / 220, 0, 1)
                ColorSelector.Position = UDim2.new(s, -8, 1 - v, -8)
                previewColor = Color3.fromHSV(h, s, v)
                ColorDisplay.BackgroundColor3 = previewColor
            end
            
            ColorArea.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            Picker.Position = UDim2.new(h, 0, 0.5, 0)
            ColorSelector.Position = UDim2.new(s, -8, 1 - v, -8)
            
            local dragging = false
            local draggingRGB = false
            
            ColorArea.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local pos = ColorArea.AbsolutePosition
                    updateSV(input.Position.X - pos.X, input.Position.Y - pos.Y)
                end
            end)
            
            RGBBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingRGB = true
                    local pos = RGBBar.AbsolutePosition
                    updateHue(math.clamp((input.Position.X - pos.X) / 280, 0, 1))
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = ColorArea.AbsolutePosition
                    updateSV(input.Position.X - pos.X, input.Position.Y - pos.Y)
                elseif draggingRGB and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local pos = RGBBar.AbsolutePosition
                    updateHue(math.clamp((input.Position.X - pos.X) / 280, 0, 1))
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    draggingRGB = false
                end
            end)
            
            ConfirmBtn.MouseButton1Click:Connect(function()
                local newColor = previewColor
                ColorDisplay.BackgroundColor3 = newColor
                PickerFrame.Visible = false
                Window.Overlay.Visible = false
                Window.Blur.Enabled = true
                Libra:Notify("Cor", colorConfig.Name .. " atualizada!", 1, Window.Screen)
                pcall(colorConfig.Callback, newColor)
            end)
            
            CancelBtn.MouseButton1Click:Connect(function()
                ColorDisplay.BackgroundColor3 = originalColor
                PickerFrame.Visible = false
                Window.Overlay.Visible = false
                Window.Blur.Enabled = true
                Libra:Notify("Cor", "Alteração cancelada", 1, Window.Screen)
            end)
            
            PickBtn.MouseButton1Click:Connect(function()
                originalColor = ColorDisplay.BackgroundColor3
                previewColor = originalColor
                h, s, v = Color3.toHSV(originalColor)
                
                ColorArea.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                Picker.Position = UDim2.new(h, 0, 0.5, 0)
                ColorSelector.Position = UDim2.new(s, -8, 1 - v, -8)
                
                PickerFrame.Visible = true
                Window.Overlay.Visible = true
                Window.Blur.Enabled = false
            end)
            
            return ColorFrame
        end
        
        -- Criar label
        function Tab:CreateLabel(labelConfig)
            labelConfig = labelConfig or {}
            labelConfig.Text = labelConfig.Text or "Label"
            labelConfig.Style = labelConfig.Style or 1  -- 1: normal, 2: info, 3: warning
            
            local colors = {
                [1] = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(200,200,200), 0.5),
                [2] = Color3.fromRGB(100, 200, 255),
                [3] = Color3.fromRGB(255, 200, 100)
            }
            
            local Label = Instance.new("TextLabel", Tab.Page)
            Label.Size = UDim2.new(0.95, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = labelConfig.Text
            Label.TextColor3 = colors[labelConfig.Style] or colors[1]
            Label.Font = "GothamSemibold"
            Label.TextSize = 12
            Label.TextXAlignment = "Left"
            
            return Label
        end
        
        -- Criar parágrafo
        function Tab:CreateParagraph(paraConfig)
            paraConfig = paraConfig or {}
            paraConfig.Title = paraConfig.Title or "Título"
            paraConfig.Text = paraConfig.Text or "Texto..."
            
            local ParaFrame = Instance.new("Frame", Tab.Page)
            ParaFrame.Size = UDim2.new(0.95, 0, 0, 50)
            ParaFrame.BackgroundTransparency = 1
            ParaFrame.BackgroundColor3 = Window.CurrentTheme.Secondary
            ParaFrame.BackgroundTransparency = 0.9
            Instance.new("UICorner", ParaFrame).CornerRadius = UDim.new(0, 8)
            
            local Title = Instance.new("TextLabel", ParaFrame)
            Title.Size = UDim2.new(1, -20, 0, 20)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Text = paraConfig.Title
            Title.TextColor3 = Window.CurrentTheme.Accent
            Title.Font = "GothamBold"
            Title.TextSize = 14
            Title.TextXAlignment = "Left"
            
            local Text = Instance.new("TextLabel", ParaFrame)
            Text.Size = UDim2.new(1, -20, 0, 20)
            Text.Position = UDim2.new(0, 10, 0, 25)
            Text.BackgroundTransparency = 1
            Text.Text = paraConfig.Text
            Text.TextColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(170,170,170), 0.5)
            Text.Font = "Gotham"
            Text.TextSize = 11
            Text.TextXAlignment = "Left"
            Text.TextWrapped = true
            Text.TextYAlignment = "Top"
            
            -- Ajustar altura baseado no texto
            local function updateHeight()
                local textHeight = Text.TextBounds.Y
                ParaFrame.Size = UDim2.new(0.95, 0, 0, 30 + textHeight)
                Text.Size = UDim2.new(1, -20, 0, textHeight)
            end
            
            task.wait()
            updateHeight()
            
            return ParaFrame
        end
        
        -- Criar divisor
        function Tab:CreateDivider()
            local Div = Instance.new("Frame", Tab.Page)
            Div.Size = UDim2.new(0.95, 0, 0, 1)
            Div.BackgroundColor3 = Window.CurrentTheme.Text:Lerp(Color3.fromRGB(80,80,80), 0.5)
            Div.BorderSizePixel = 0
            return Div
        end
        
        return Tab
    end
    
    -- Função para criar home tab (executores e discord)
    function Window:CreateHomeTab(homeConfig)
        homeConfig = homeConfig or {}
        homeConfig.SupportedExecutors = homeConfig.SupportedExecutors or {
            "Synapse X", "Krnl", "Fluxus", "Script-Ware", "Delta"
        }
        homeConfig.DiscordInvite = homeConfig.DiscordInvite or ""
        homeConfig.Icon = homeConfig.Icon or 1
        
        local HomeTab = self:CreateTab({Name = "Início"})
        
        HomeTab:CreateParagraph({
            Title = "⚡ Executores Suportados",
            Text = table.concat(homeConfig.SupportedExecutors, ", ")
        })
        
        if homeConfig.DiscordInvite ~= "" then
            HomeTab:CreateButton({
                Name = "📱 Discord",
                Description = "Clique para copiar link do Discord",
                Callback = function()
                    setclipboard("https://discord.gg/" .. homeConfig.DiscordInvite)
                    Libra:Notify("Discord", "Link copiado!", 2, Window.Screen)
                end
            })
        end
        
        return HomeTab
    end
    
    -- Função para construir seção de temas (fixa)
    function Window:BuildThemeSection()
        -- Isso é fixo e não pode ser modificado pelo usuário
        local ThemeTab = self:CreateTab({Name = "Temas"})
        
        ThemeTab:CreateLabel({Text = "╔═══ TEMAS PREDEFINIDOS ═══╗", Style = 1})
        ThemeTab:CreateDivider()
        
        -- Dropdown de temas
        local ThemeOptions = {}
        for name, _ in pairs(self.Themes) do
            table.insert(ThemeOptions, name)
        end
        
        ThemeTab:CreateDropdown({
            Name = "Selecionar Tema",
            Description = "Escolha um tema predefinido",
            Options = ThemeOptions,
            CurrentOption = self.Settings.ThemeName,
            Callback = function(opt)
                self.CurrentTheme = self.Themes[opt]
                self.Settings.ThemeName = opt
                self.Main.BackgroundColor3 = self.CurrentTheme.Main
                self.TopBar.BackgroundColor3 = self.CurrentTheme.Secondary
                self.Title.TextColor3 = self.CurrentTheme.Accent
                self.OpenBtn.TextColor3 = self.CurrentTheme.Accent
                Libra:Notify("Tema", "Tema " .. opt .. " ativado!", 2, Window.Screen)
            end
        })
        
        ThemeTab:CreateLabel({Text = "╔═══ PERSONALIZAÇÃO ═══╗", Style = 1})
        ThemeTab:CreateDivider()
        
        -- Color Pickers
        ThemeTab:CreateColorPicker({
            Name = "PRINCIPAL",
            Description = "Cor de fundo principal",
            Color = self.CurrentTheme.Main,
            Callback = function(color)
                self.CurrentTheme.Main = color
                self.Main.BackgroundColor3 = color
                self.Settings.CustomColors.Main = color
            end
        })
        
        ThemeTab:CreateColorPicker({
            Name = "SECUNDÁRIA",
            Description = "Cor dos botões e abas",
            Color = self.CurrentTheme.Secondary,
            Callback = function(color)
                self.CurrentTheme.Secondary = color
                self.TopBar.BackgroundColor3 = color
                self.Settings.CustomColors.Secondary = color
            end
        })
        
        ThemeTab:CreateColorPicker({
            Name = "DESTAQUE",
            Description = "Cor dos toggles e setas",
            Color = self.CurrentTheme.Accent,
            Callback = function(color)
                self.CurrentTheme.Accent = color
                self.Title.TextColor3 = color
                self.OpenBtn.TextColor3 = color
                self.Settings.CustomColors.Accent = color
            end
        })
        
        ThemeTab:CreateColorPicker({
            Name = "TEXTO",
            Description = "Cor das letras",
            Color = self.CurrentTheme.Text,
            Callback = function(color)
                self.CurrentTheme.Text = color
                self.Settings.CustomColors.Text = color
            end
        })
    end
    
    -- Função para construir seção de configurações (fixa)
    function Window:BuildConfigSection()
        local ConfigTab = self:CreateTab({Name = "Configurações"})
        
        ConfigTab:CreateLabel({Text = "╔═══ CONFIGURAÇÕES ═══╗", Style = 1})
        ConfigTab:CreateDivider()
        
        -- Modo Compacto
        ConfigTab:CreateToggle({
            Name = "📏 MODO COMPACTO",
            Description = "Esconder descrições",
            CurrentValue = self.Settings.CompactMode,
            Callback = function(state)
                self.Settings.CompactMode = state
                for _, page in pairs(self.Container:GetChildren()) do
                    if page:IsA("ScrollingFrame") then
                        for _, elemento in pairs(page:GetChildren()) do
                            local desc = elemento:FindFirstChild("Desc")
                            if desc then
                                desc.Visible = not state
                            end
                        end
                    end
                end
                Libra:Notify("Modo Compacto", state and "Ativado" or "Desativado", 1, Window.Screen)
            end
        })
        
        -- Auto Carregar
        ConfigTab:CreateToggle({
            Name = "⚙ AUTO CARREGAR",
            Description = "Carregar configurações salvas",
            CurrentValue = self.Settings.AutoLoad,
            Callback = function(state)
                self.Settings.AutoLoad = state
                Libra:Notify("Auto Carregar", state and "Ativado" or "Desativado", 1, Window.Screen)
            end
        })
        
        -- Salvar Config
        ConfigTab:CreateButton({
            Name = "💾 SALVAR CONFIG",
            Description = "Salvar todas as configurações",
            Callback = function()
                local SaveData = {
                    Toggles = self.Settings.Toggles,
                    ThemeName = self.Settings.ThemeName,
                    AutoLoad = self.Settings.AutoLoad,
                    CompactMode = self.Settings.CompactMode,
                    CustomColors = self.Settings.CustomColors
                }
                local SavePath = self.ConfigSettings.RootFolder .. "/" .. self.ConfigSettings.ConfigFolder .. "/config.json"
                writefile(SavePath, HttpService:JSONEncode(SaveData))
                Libra:Notify("Config", "Configurações salvas!", 2, Window.Screen)
            end
        })
        
        -- Carregar Config
        ConfigTab:CreateButton({
            Name = "📂 CARREGAR CONFIG",
            Description = "Carregar configurações salvas",
            Callback = function()
                local SavePath = self.ConfigSettings.RootFolder .. "/" .. self.ConfigSettings.ConfigFolder .. "/config.json"
                if isfile(SavePath) then
                    local success, data = pcall(function()
                        return HttpService:JSONDecode(readfile(SavePath))
                    end)
                    if success then
                        self.Settings = data
                        self.CurrentTheme = self.Themes[data.ThemeName] or self.Themes.Dark
                        if data.CustomColors then
                            if data.CustomColors.Main then self.CurrentTheme.Main = data.CustomColors.Main end
                            if data.CustomColors.Secondary then self.CurrentTheme.Secondary = data.CustomColors.Secondary end
                            if data.CustomColors.Accent then self.CurrentTheme.Accent = data.CustomColors.Accent end
                            if data.CustomColors.Text then self.CurrentTheme.Text = data.CustomColors.Text end
                        end
                        
                        self.Main.BackgroundColor3 = self.CurrentTheme.Main
                        self.TopBar.BackgroundColor3 = self.CurrentTheme.Secondary
                        self.Title.TextColor3 = self.CurrentTheme.Accent
                        self.OpenBtn.TextColor3 = self.CurrentTheme.Accent
                        
                        Libra:Notify("Config", "Configurações carregadas!", 2, Window.Screen)
                    end
                end
            end
        })
    end
    
    -- Aplicar modo compacto inicial
    task.spawn(function()
        task.wait(0.1)
        for _, page in pairs(Window.Container:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                for _, elemento in pairs(page:GetChildren()) do
                    local desc = elemento:FindFirstChild("Desc")
                    if desc then
                        desc.Visible = not Window.Settings.CompactMode
                    end
                end
            end
        end
    end)
    
    -- Sistema de key (se ativado)
    if config.KeySystem then
        local KeyPassed = false
        local SavedKey = ""
        
        -- Verificar key salva
        if config.KeySettings.SaveKey then
            local KeyPath = self.ConfigSettings.RootFolder .. "/" .. self.ConfigSettings.ConfigFolder .. "/key.txt"
            if isfile(KeyPath) then
                SavedKey = readfile(KeyPath)
                for _, validKey in ipairs(config.KeySettings.Key) do
                    if SavedKey == validKey then
                        KeyPassed = true
                        break
                    end
                end
            end
        end
        
        if not KeyPassed then
            -- Criar tela de key
            local KeyFrame = Instance.new("Frame", Window.Screen)
            KeyFrame.Size = UDim2.new(0, 320, 0, 180)
            KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
            KeyFrame.BackgroundColor3 = Window.CurrentTheme.Main
            KeyFrame.Visible = true
            KeyFrame.ZIndex = 30
            Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
            
            local KeyTitle = Instance.new("TextLabel", KeyFrame)
            KeyTitle.Size = UDim2.new(1, 0, 0, 30)
            KeyTitle.Position = UDim2.new(0, 0, 0, 10)
            KeyTitle.BackgroundTransparency = 1
            KeyTitle.Text = config.KeySettings.Title
            KeyTitle.TextColor3 = Window.CurrentTheme.Accent
            KeyTitle.Font = "GothamBold"
            KeyTitle.TextSize = 16
            
            local KeySubtitle = Instance.new("TextLabel", KeyFrame)
            KeySubtitle.Size = UDim2.new(1, 0, 0, 20)
            KeySubtitle.Position = UDim2.new(0, 0, 0, 40)
            KeySubtitle.BackgroundTransparency = 1
            KeySubtitle.Text = config.KeySettings.Subtitle
            KeySubtitle.TextColor3 = Window.CurrentTheme.Text
            KeySubtitle.Font = "Gotham"
            KeySubtitle.TextSize = 12
            
            local KeyNote = Instance.new("TextLabel", KeyFrame)
            KeyNote.Size = UDim2.new(0.9, 0, 0, 30)
            KeyNote.Position = UDim2.new(0.05, 0, 0, 60)
            KeyNote.BackgroundTransparency = 1
            KeyNote.Text = config.KeySettings.Note
            KeyNote.TextColor3 = Color3.fromRGB(255, 200, 100)
            KeyNote.Font = "Gotham"
            KeyNote.TextSize = 10
            KeyNote.TextWrapped = true
            
            local KeyBox = Instance.new("TextBox", KeyFrame)
            KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
            KeyBox.Position = UDim2.new(0.1, 0, 0, 95)
            KeyBox.BackgroundColor3 = Window.CurrentTheme.Secondary
            KeyBox.TextColor3 = Window.CurrentTheme.Text
            KeyBox.PlaceholderText = "Insira sua key..."
            KeyBox.Font = "Gotham"
            KeyBox.Text = ""
            KeyBox.ClearTextOnFocus = false
            Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
            
            local KeySubmit = Instance.new("TextButton", KeyFrame)
            KeySubmit.Size = UDim2.new(0.4, -5, 0, 35)
            KeySubmit.Position = UDim2.new(0.3, 0, 0, 135)
            KeySubmit.BackgroundColor3 = Window.CurrentTheme.Accent
            KeySubmit.Text = "VERIFICAR"
            KeySubmit.TextColor3 = Window.CurrentTheme.Main
            KeySubmit.Font = "GothamBold"
            KeySubmit.AutoButtonColor = false
            Instance.new("UICorner", KeySubmit).CornerRadius = UDim.new(0, 6)
            
            KeySubmit.MouseButton1Click:Connect(function()
                local input = KeyBox.Text
                for _, validKey in ipairs(config.KeySettings.Key) do
                    if input == validKey then
                        KeyPassed = true
                        if config.KeySettings.SaveKey then
                            local KeyPath = self.ConfigSettings.RootFolder .. "/" .. self.ConfigSettings.ConfigFolder .. "/key.txt"
                            writefile(KeyPath, input)
                        end
                        KeyFrame:Destroy()
                        Window.Main.Visible = true
                        Window.Blur.Enabled = true
                        Libra:Notify("Key System", "Acesso liberado!", 3, Window.Screen)
                        break
                    end
                end
                if not KeyPassed then
                    Libra:Notify("Key System", "Key inválida!", 2, Window.Screen)
                end
            end)
            
            return Window
        end
    end
    
    -- Se não tem key system ou key já foi validada
    Window.Main.Visible = true
    Window.Blur.Enabled = true
    
    -- Adicionar à lista de libraries
    table.insert(Libraries, Window)
    
    return Window
end

return Libra