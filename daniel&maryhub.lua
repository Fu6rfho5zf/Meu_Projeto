-- LocalScript em StarterGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIGURAÇÕES ==================
local pasta = "DANIEL & MARY HUB"
local arquivo = pasta.."/save"
local temaSalvo = "Preto"

-- URLs da logo e versão
local logoURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/D%26M_logo.png"
local logoVersionURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/logo_version.txt"

-- Caminhos locais
local caminhoLogo = pasta.."/D&M_logo.png"
local versaoArquivo = pasta.."/logo_version.txt"
-- 🌟 ADMIN COMANDOS AJUSTADOS 🌟 --

-- Estado dos poderes dos jogadores
local playerStates = {}

-- Função que alterna um poder
local function toggleState(plr, stateName)
    if not playerStates[plr] then
        playerStates[plr] = {}
    end
    playerStates[plr][stateName] = not playerStates[plr][stateName]
    return playerStates[plr][stateName]
end

-- ================== FUNÇÃO ATUALIZAR LOGO ==================
local function atualizarLogo()
    local versaoOnline = "1"
    pcall(function() versaoOnline = game:HttpGet(logoVersionURL) end)

    local versaoLocal = "0"
    if isfile and isfile(versaoArquivo) then
        versaoLocal = readfile(versaoArquivo)
    end

    if versaoOnline ~= versaoLocal then
        warn("Atualizando logo para versão "..versaoOnline)
        local sucesso, img = pcall(function()
            return game:HttpGet(logoURL)
        end)
        if sucesso and img then
            writefile(caminhoLogo, img)
            writefile(versaoArquivo, versaoOnline)
        else
            warn("Falha ao baixar logo da URL!")
        end
    end
end

-- ================== PRIMEIRA EXECUÇÃO ==================
local primeiraVez = false
if writefile and makefolder then
    if not isfolder(pasta) then
        makefolder(pasta)
        primeiraVez = true
    end
    if not isfile(arquivo) then
        writefile(arquivo, "Tema="..temaSalvo)
        primeiraVez = true
    end
    atualizarLogo()
end

-- ================== FUNÇÃO ROUNDIFY ==================
local function roundify(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = obj
end

-- ================== TELA DE CARREGAMENTO ==================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Parent = playerGui
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true

-- FUNDO COM IMAGEM
local fundo = Instance.new("ImageLabel")
fundo.Size = UDim2.new(1,0,1,0)
fundo.Position = UDim2.new(0,0,0,0)
fundo.BackgroundTransparency = 100 -- remove cor do fundo
fundo.Image = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/FUNDO.jpg"
fundo.ScaleType = Enum.ScaleType.Stretch -- preenche toda a tela
fundo.Parent = loadingGui

-- FRAME DO LOADING
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0,350,0,280)
loadingFrame.Position = UDim2.new(0.5,-175,0.5,-140)
loadingFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
loadingFrame.Parent = fundo
roundify(loadingFrame, 18)

-- LOGO
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,130,0,130)
logo.Position = UDim2.new(0.5,-65,0,20)
logo.BackgroundTransparency = 1
logo.Image = logoURL -- seu logo
logo.Parent = loadingFrame

-- TEXTO DE LOADING
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,0,50)
loadingText.Position = UDim2.new(0,0,0.55,0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "📥 Iniciando..."
loadingText.TextColor3 = Color3.fromRGB(255,255,255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextScaled = true
loadingText.Parent = loadingFrame

-- BARRA DE PROGRESSO
local barraBG = Instance.new("Frame")
barraBG.Size = UDim2.new(0.8,0,0,24)
barraBG.Position = UDim2.new(0.1,0,0.82,0)
barraBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
barraBG.Parent = loadingFrame
roundify(barraBG, 12)

local barra = Instance.new("Frame")
barra.Size = UDim2.new(0,0,1,0)
barra.BackgroundColor3 = Color3.fromRGB(0,200,0)
barra.Parent = barraBG
roundify(barra, 12)

-- -- ================== MENSAGENS DE PROGRESSO ==================
local etapas
if primeiraVez then
    etapas = {
        "📥 🅑🅐🅘🅧🅐🅝🅓🅞 🅞🅢 🅢🅒🅡🅘🅟🅣🅢...!",
        "🖼️ 🅑🅐🅘🅧🅐🅝🅓🅞 🅐🅢 🅘🅜🅐🅖🅔🅝🅢...!",
        "📂 🅑🅐🅘🅧🅐🅝🅓🅞 🅞🅢 🅐🅡🅠🅤🅘🅥🅞🅢...!",
        "🔑 🅑🅐🅘🅧🅐🅝🅓🅞 🅐🅢 🅚🅔🅨...!",
        "✅ 🅓🅞🅦🅝🅛🅞🅐🅓 🅒🅞🅝🅒🅛🅤Í🅓🅞...!"
    }
else
    etapas = {
    "📝  CARREGANDO OS SCRIPTS... ✨",
    "🎨  CARREGANDO AS IMAGENS... 🖼️",
    "💾  CARREGANDO OS ARQUIVOS... 📂",
    "🗝️  CARREGANDO AS CHAVES... 🔑",
    "🎉  CONCLUÍDO COM SUCESSO...! ✅"
    }
end

-- ================== FUNÇÃO DE ANIMAÇÃO DO LOADING ==================
local function iniciarCarregamento()
    for i, msg in ipairs(etapas) do
        loadingText.TextTransparency = 1
        loadingText.Text = msg

        -- Fade in do texto
        for t=1,0,-0.1 do
            loadingText.TextTransparency = t
            task.wait(0.03)
        end

        -- Aumenta a barra proporcional
        local alvo = i / #etapas
        for p = barra.Size.X.Scale, alvo, 0.02 do
            barra.Size = UDim2.new(p,0,1,0)
            task.wait(0.03)
        end

        task.wait(0.8) -- espera antes da próxima etapa
    end

    -- Fade out
    for i=0,1,0.05 do
        fundo.BackgroundTransparency = i
        loadingFrame.BackgroundTransparency = i
        loadingText.TextTransparency = i
        logo.ImageTransparency = i
        barraBG.BackgroundTransparency = i
        barra.BackgroundTransparency = i
        task.wait(0.03)
    end

    loadingGui:Destroy()
end

-- ================== EXECUTAR CARREGAMENTO ==================
iniciarCarregamento()

-- ================== BAIXAR ARQUIVOS INICIAIS ==================
if primeiraVez and writefile and makefolder then
    if not isfolder(pasta) then makefolder(pasta) end
    writefile(arquivo, "Tema="..temaSalvo)
    if not isfile(caminhoLogo) then
        local img = game:HttpGet(logoURL)
        writefile(caminhoLogo, img)
    end
end

-- ================== LEITURA DE DADOS ==================
if isfile and readfile and isfile(arquivo) then
    local dados = readfile(arquivo)
    for k,v in string.gmatch(dados,"(%w+)=(%w+)") do
        if k == "Tema" then
            temaSalvo = v
        elseif k == "Salvar" then
            salvarAtivo = (v == "ON")
        end
    end
end

-- ================== GUI PRINCIPAL ==================
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeuHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Criando o Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 500, 1, -30)
mainFrame.Position = UDim2.new(0.5, 0, 0.38, 0) -- um pouco acima do centro
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui
roundify(mainFrame, 12)

-- ================== ARRASTAR PELA BARRA ==================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,35)
titleBar.BackgroundColor3 = Color3.fromRGB(45,45,45)
titleBar.Parent = mainFrame
roundify(titleBar, 12)

local dragging = false
local dragInput, mousePos, framePos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- ================== TÍTULO E BOTÕES ==================
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-70,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎈 DANIEL & MARY HUB  🤡  🤙"
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 18
titleText.TextColor3 = Color3.new(1,1,1)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-60,0.5,-12)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Parent = titleBar
roundify(minimizeBtn, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0.5,-12)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = titleBar
roundify(closeBtn, 6)

-- ================== MINI ÍCONE ==================
-- ================== MINI ICON ==================
local miniIcon = Instance.new("ImageButton")
-- Define o tamanho do ícone (largura: 40px, altura: 40px)
miniIcon.Size = UDim2.new(0,38,0,38)  
-- Define o ponto de ancoragem no canto superior esquerdo (0,0)
miniIcon.AnchorPoint = Vector2.new(0,0)  
--0,170, e. posição adicionar mas número e pra direita meno o número vai pra esquerda 
-- depois do 170,0,-44 e altura do icon
miniIcon.Position = UDim2.new(0, 210, 0, -44)  
-- Define a cor de fundo do ícone como um tom de cinza (RGB: 45,45,45)
miniIcon.BackgroundColor3 = Color3.fromRGB(45,45,45)
miniIcon.Visible = false -- começa invisível (menu aberto)
miniIcon.Parent = screenGui
miniIcon.Active = true
miniIcon.Draggable = true
roundify(miniIcon, 10)

-- Função para setar a imagem do ícone
local function setMiniIconImage()
    if isfile and getcustomasset and isfile(caminhoLogo) then
        miniIcon.Image = getcustomasset(caminhoLogo)
    else
        miniIcon.Image = logoURL
    end
end
setMiniIconImage()

-- ================== CONTEÚDO ==================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1,-10,1,-80)
contentFrame.Position = UDim2.new(0,5,0,40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- SCROLL DE JOGOS
local gamesFrame = Instance.new("ScrollingFrame")
gamesFrame.Size = UDim2.new(0.4,-5,1,0)
gamesFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
gamesFrame.Parent = contentFrame
gamesFrame.ScrollBarThickness = 6
gamesFrame.CanvasSize = UDim2.new(0,0,0,0)
roundify(gamesFrame,10)

local gameLayout = Instance.new("UIListLayout")
gameLayout.Parent = gamesFrame
gameLayout.Padding = UDim.new(0,5)
gameLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- SCROLL DE SCRIPTS
local scriptsFrame = Instance.new("ScrollingFrame")
scriptsFrame.Size = UDim2.new(0.6,-5,1,0)
scriptsFrame.Position = UDim2.new(0.4,5,0,0)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
scriptsFrame.Parent = contentFrame
scriptsFrame.ScrollBarThickness = 6
scriptsFrame.CanvasSize = UDim2.new(0,0,0,0)
roundify(scriptsFrame,10)

local scriptLayout = Instance.new("UIListLayout")
scriptLayout.Parent = scriptsFrame
scriptLayout.Padding = UDim.new(0,5)
scriptLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ================== FOOTER ==================
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1,0,0,40)
footer.Position = UDim2.new(0,0,1,-40)
footer.BackgroundColor3 = Color3.fromRGB(25,25,25)
footer.Parent = mainFrame
roundify(footer,12)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0,30,0,30)
avatar.Position = UDim2.new(0,5,0.5,-15)
avatar.BackgroundTransparency = 1
avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"
avatar.Parent = footer
roundify(avatar,15)

local playerName = Instance.new("TextLabel")
playerName.Size = UDim2.new(0.5,-40,1,0)
playerName.Position = UDim2.new(0,40,0,0)
playerName.BackgroundTransparency = 1
playerName.Text = player.Name
playerName.TextColor3 = Color3.new(1,1,1)
playerName.Font = Enum.Font.SourceSansBold
playerName.TextSize = 16
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = footer

local creditos = Instance.new("TextLabel")
creditos.Size = UDim2.new(0.5,-10,1,0)
creditos.Position = UDim2.new(0.5,0,0,0)
creditos.BackgroundTransparency = 1
creditos.Text = "Créditos: DANIEL ⚽  & MARY 📿 "
creditos.TextColor3 = Color3.fromRGB(200,200,200)
creditos.Font = Enum.Font.SourceSansItalic
creditos.TextSize = 14
creditos.TextXAlignment = Enum.TextXAlignment.Right
creditos.Parent = footer

-- ================== FUNÇÃO BOTÃO ==================
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = parent
    roundify(btn,8)
    btn.MouseButton1Click:Connect(callback)

    -- Atualiza rolagem
    if parent:IsA("ScrollingFrame") and parent:FindFirstChildOfClass("UIListLayout") then
        parent.CanvasSize = UDim2.new(0,0,0,parent.UIListLayout.AbsoluteContentSize.Y + 10)
    end
end

-- ================== TEMAS ==================
local temas = {
    "Branco","Preto","Vermelho","Verde","Azul","Amarelo","Magenta","Ciano","Laranja","Rosa","Roxo","Cinza","Marrom",
    "BrancoAntigo","VerdeClaro","AzulClaro","RosaClaro","LaranjaClaro","CinzaClaro",
    "VerdeEscuro","AzulEscuro","RoxoEscuro","MarromEscuro","CinzaEscuro",
    "PastelRosa","PastelVerde","PastelAzul","PastelAmarelo",
    "NeonVerde","NeonAzul","NeonRosa","NeonCiano"
}

local corTemas = {
    Branco = Color3.fromRGB(255,255,255),
    Preto = Color3.fromRGB(0,0,0),
    Vermelho = Color3.fromRGB(255,0,0),
    Verde = Color3.fromRGB(0,255,0),
    Azul = Color3.fromRGB(0,0,255),
    Amarelo = Color3.fromRGB(255,255,0),
    Magenta = Color3.fromRGB(255,0,255),
    Ciano = Color3.fromRGB(0,255,255),
    Laranja = Color3.fromRGB(255,165,0),
    Rosa = Color3.fromRGB(255,192,203),
    Roxo = Color3.fromRGB(128,0,128),
    Cinza = Color3.fromRGB(128,128,128),
    Marrom = Color3.fromRGB(139,69,19),

    -- Tons claros
    BrancoAntigo = Color3.fromRGB(250,235,215),
    VerdeClaro = Color3.fromRGB(144,238,144),
    AzulClaro = Color3.fromRGB(173,216,230),
    RosaClaro = Color3.fromRGB(255,182,193),
    LaranjaClaro = Color3.fromRGB(255,200,150),
    CinzaClaro = Color3.fromRGB(211,211,211),

    -- Tons escuros
    VerdeEscuro = Color3.fromRGB(0,100,0),
    AzulEscuro = Color3.fromRGB(0,0,139),
    RoxoEscuro = Color3.fromRGB(75,0,130),
    MarromEscuro = Color3.fromRGB(101,67,33),
    CinzaEscuro = Color3.fromRGB(64,64,64),

    -- Pastéis
    PastelRosa = Color3.fromRGB(255,209,220),
    PastelVerde = Color3.fromRGB(119,221,119),
    PastelAzul = Color3.fromRGB(174,198,207),
    PastelAmarelo = Color3.fromRGB(253,253,150),

    -- Neon/Brilho
    NeonVerde = Color3.fromRGB(57,255,20),
    NeonAzul = Color3.fromRGB(77,77,255),
    NeonRosa = Color3.fromRGB(255,20,147),
    NeonCiano = Color3.fromRGB(0,255,255),

    -- Transparente 30% (usar BackgroundTransparency = 0.7)
    Transparente30 = Color3.fromRGB(255,255,255)
}

-- Função para aplicar tema completo
-- Função para aplicar tema sem alterar barra de título e avatar
local function aplicarTema(cor)
    mainFrame.BackgroundColor3 = cor
    gamesFrame.BackgroundColor3 = cor
    scriptsFrame.BackgroundColor3 = cor
    -- footer.BackgroundColor3 = cor
    -- titleBar e avatar não serão alterados
end

if corTemas[temaSalvo] then aplicarTema(corTemas[temaSalvo]) end

-- ================== CATEGORIA CONFIGURAR ==================
createButton(gamesFrame,"⚙️ Configurar",function()
    for _,child in ipairs(scriptsFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
    end

    local selectedPlayer = nil

    ---------------------- [ LISTA DE PLAYERS ] ----------------------
    local playerBtn = Instance.new("TextButton")
    playerBtn.Size = UDim2.new(1,-10,0,35)
    playerBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    playerBtn.TextColor3 = Color3.new(1,1,1)
    playerBtn.Text = "🎮 Selecione Jogador"
    playerBtn.Parent = scriptsFrame
    roundify(playerBtn,8)

    playerBtn.MouseButton1Click:Connect(function()
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
        end
        for _,plr in ipairs(game.Players:GetPlayers()) do
            local plrBtn = Instance.new("TextButton")
            plrBtn.Size = UDim2.new(1,-10,0,35)
            plrBtn.BackgroundColor3 = Color3.fromRGB(90,90,90)
            plrBtn.TextColor3 = Color3.new(1,1,1)
            plrBtn.Text = "👤 "..plr.Name
            plrBtn.Parent = scriptsFrame
            roundify(plrBtn,8)

            plrBtn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                createAdminMenu()
            end)
        end
    end)

    ---------------------- [ SLIDER NUMÉRICO ] ----------------------
    local function createSlider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,-10,0,50)
        frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
        frame.Parent = scriptsFrame
        roundify(frame,8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4,0,1,0)
        label.Position = UDim2.new(0,5,0,0)
        label.BackgroundTransparency = 1
        label.Text = text..": "..default
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(0.6,-10,0,30)
        sliderBtn.Position = UDim2.new(0.4,5,0.5,-15)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        sliderBtn.Text = tostring(default)
        sliderBtn.TextColor3 = Color3.new(1,1,1)
        sliderBtn.Parent = frame
        roundify(sliderBtn,8)

        local currentValue = default
        sliderBtn.MouseButton1Click:Connect(function()
            currentValue = currentValue + 5
            if currentValue > max then currentValue = min end
            label.Text = text..": "..currentValue
            sliderBtn.Text = tostring(currentValue)
            callback(currentValue)
        end)
    end

    ---------------------- [ BOTÃO ADMIN ] ----------------------
    local function createAdminButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,35)
        btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Text = text
        btn.Parent = scriptsFrame
        roundify(btn,8)
        btn.MouseButton1Click:Connect(callback)
    end

    ---------------------- [ MENU DE ADMIN ] ----------------------
    function createAdminMenu()
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
        end
        if not selectedPlayer then return end

        -- Sliders
        createSlider("Velocidade",16,200,16,function(val)
            if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
                selectedPlayer.Character.Humanoid.WalkSpeed = val
            end
        end)

        createSlider("Super Pulo",50,300,50,function(val)
            if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
                selectedPlayer.Character.Humanoid.JumpPower = val
            end
        end)

        createSlider("Gravidade",50,300,196,function(val)
            workspace.Gravity = val
        end)

        createSlider("Vida",1,500,100,function(val)
            if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
                selectedPlayer.Character.Humanoid.Health = val
            end
        end)

        createSlider("Dano (Hit)",5,100,10,function(val)
            _G.hitDamage = val
        end)
        
        createAdminButton("🎯 Teleportar até ele",function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and target then
                root.CFrame = target.CFrame + Vector3.new(3,0,0)
            end
        end)

--------------------------------------------------------
-- NEON ON/OFF
--------------------------------------------------------
createAdminButton("🌈 Neon ON/OFF",function()
    local enabled = toggleState(selectedPlayer,"Neon")
    if selectedPlayer.Character then
        for _,p in pairs(selectedPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") then
                if enabled then
                    p.Material = Enum.Material.Neon
                    p.Color = Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
                else
                    p.Material = Enum.Material.Plastic
                    p.Color = Color3.fromRGB(255,255,255)
                end
            end
        end
    end
end)

--------------------------------------------------------
-- SEGUIR JOGADOR ON/OFF
--------------------------------------------------------
createAdminButton("📡 Seguir Jogador ON/OFF",function()
    local enabled = toggleState(selectedPlayer,"Seguir")
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")

    if root and target then
        if enabled then
            local bp = Instance.new("BodyPosition",root)
            bp.Name = "FollowBP"
            bp.MaxForce = Vector3.new(5000,5000,5000)
            game:GetService("RunService").Heartbeat:Connect(function()
                if bp.Parent and target then
                    bp.Position = target.Position
                end
            end)
        else
            if root:FindFirstChild("FollowBP") then
                root.FollowBP:Destroy()
            end
        end
    end
end)

--------------------------------------------------------
-- TAMANHO: GIGANTE, GRANDE, NORMAL, MINI, PEQUENO
--------------------------------------------------------
createAdminButton("🌌 Muito Gigante",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(5)
    end
end)

createAdminButton("👹 Gigante",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(3)
    end
end)

createAdminButton("💪 Grande",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(2)
    end
end)

createAdminButton("🙂 Normal",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(1)
    end
end)

createAdminButton("👶 Mini",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(0.75)
    end
end)

createAdminButton("🐜 Pequeno",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(0.5)
    end
end)

createAdminButton("⚫ Super Pequeno",function()
    if selectedPlayer.Character then
        selectedPlayer.Character:ScaleTo(0.25)
    end
end)

--------------------------------------------------------
-- FOGO INFINITO ON/OFF
--------------------------------------------------------
createAdminButton("🔥 Pegar Fogo ON/OFF",function()
    local enabled = toggleState(selectedPlayer,"Fogo")
    if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if enabled then
            local fire = Instance.new("Fire")
            fire.Name = "InfiniteFire"
            fire.Parent = selectedPlayer.Character.HumanoidRootPart
        else
            if selectedPlayer.Character.HumanoidRootPart:FindFirstChild("InfiniteFire") then
                selectedPlayer.Character.HumanoidRootPart.InfiniteFire:Destroy()
            end
        end
    end
end)

--------------------------------------------------------
-- ESPIAR JOGADOR ON/OFF
--------------------------------------------------------
-- Botão Espiar Jogador
createAdminButton("👀 Espiar Jogador ON/OFF",function()
local enabled = toggleState(player,"Espiar")
if player == game.Players.LocalPlayer then
if enabled and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Head
else
if player.Character and player.Character:FindFirstChild("Humanoid") then
workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
end
end
end
end)

createAdminButton("🔓 Soltar Fixação",function()
if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
selectedPlayer.Character.HumanoidRootPart.Anchored = false
end
end)
end
end)

-- 🔧 FIX PARA ROLAGEM FUNCIONAR 🔧
scriptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
scriptsFrame.CanvasSize = UDim2.new(0,0,0,scriptLayout.AbsoluteContentSize.Y + 10)
end)

gameLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
gamesFrame.CanvasSize = UDim2.new(0,0,0,gameLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== SISTEMA DE KEYS ==================
-- ================== SISTEMA DE KEYS ==================
local jogos = {
    ["99 Noite na Floresta"] = {
        -- Formato: {Nome Script, URL Script, URL Key, Caminho Local da Key, Download Automático (true/false)}
        {"VOIDWARE |STATUS|  🔵 PERFEITO", "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"}, -- sem key
        {"RAYFIELD |STATUS|  🔵 PERFEITO", "https://raw.githubusercontent.com/Iliankytb/Iliankytb/main/Best99NightsInTheForest"}, -- sem key
        {"H4xSCRIPTS |STATUS|  🟣 MONITORANDO", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", "https://raw.githubusercontent.com/Fu6rfho5zf/GET-KEY-/refs/heads/main/H4xScripts.txt", "/storage/emulated/0/Delta/Workspace/H4xScripts/Key.txt", true},
        {"SOLUNA |STATUS|  🟢 ESTÁVEL", "https://raw.githubusercontent.com/endoverdosing/Soluna-API/refs/heads/main/99-Nights-in-the-Forest.lua", "https://raw.githubusercontent.com/Fu6rfho5zf/GET-KEY-/refs/heads/main/99nights_key_validation.txt", "/storage/emulated/0/Delta/Workspace/99nights_key_validation.txt", true},              
        {"RINGTA |STATUS|   🟢 ESTÁVEL", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua"}, -- sem key        
    }
}

-- Armazena keys já usadas por este jogador
local usedKeys = {}

-- Função auxiliar para extrair o nome do arquivo da URL
local function getFileNameFromUrl(url)
    return url:match("^.+/(.+)$")
end

-- Função para pegar uma key aleatória do arquivo
local function getRandomKey(keyUrlPath, localSavePath, scriptName)
    if usedKeys[scriptName] then
        return usedKeys[scriptName]
    end

    if not isfile(keyUrlPath) then
        return nil
    end

    local allKeys = {}
    for line in readfile(keyUrlPath):gmatch("[^\r\n]+") do
        table.insert(allKeys, line)
    end

    if #allKeys > 0 then
        local index = math.random(1, #allKeys)
        local key = allKeys[index]

        -- Remove a key usada do arquivo remoto
        table.remove(allKeys, index)
        writefile(keyUrlPath, table.concat(allKeys, "\n"))

        -- Salva em memória
        usedKeys[scriptName] = key

        -- Salva no arquivo local
        if localSavePath then
            local folder = localSavePath:match("(.+)/[^/]+$")
            if folder and not isfolder(folder) then
                makefolder(folder)
            end
            writefile(localSavePath, key)
            warn("Key salva em: "..localSavePath)
        end

        return key
    end

    return nil
end

-- Função para verificar se o arquivo da key existe e pegar ou baixar
local function handleKey(keyUrl, localSavePath, scriptName, autoDownload)
    if localSavePath and isfile(localSavePath) then
        local key = readfile(localSavePath)
        usedKeys[scriptName] = key
        return key
    elseif keyUrl and autoDownload then
        -- Extrai nome do arquivo remoto
        local keyFileName = getFileNameFromUrl(keyUrl)
        local keyFolder = localSavePath:match("(.+)/[^/]+$")
        if keyFolder and not isfolder(keyFolder) then
            makefolder(keyFolder)
        end
        local keyUrlPath = keyFolder..keyFileName
        if not isfile(keyUrlPath) then
            local keyOnline = game:HttpGet(keyUrl)
            writefile(keyUrlPath, keyOnline)
            warn("Key baixada e salva temporariamente em: "..keyUrlPath)
        end
        return getRandomKey(keyUrlPath, localSavePath, scriptName)
    else
        warn("Arquivo da key não encontrado e download automático desativado para "..scriptName)
        return nil
    end
end

-- Criar botões
for jogo, scripts in pairs(jogos) do
    createButton(gamesFrame, jogo.." Scripts", function()
        -- Limpa botões antigos
        for _, c in ipairs(scriptsFrame:GetChildren()) do
            if c:IsA("TextButton") then
                c:Destroy()
            end
        end

        for _, data in ipairs(scripts) do
            local scriptName, url, keyUrl, localSavePath, autoDownload = data[1], data[2], data[3], data[4], data[5]

            createButton(scriptsFrame, scriptName, function()
                local key = nil
                if keyUrl and localSavePath then
                    key = handleKey(keyUrl, localSavePath, scriptName, autoDownload)
                    if not key then
                        warn("Não foi possível executar o script "..scriptName.." sem a key!")
                        return
                    end
                end

                -- Executa o script
                if key then
                    loadstring(game:HttpGet(url))(key)
                else
                    loadstring(game:HttpGet(url))()
                end
            end)
        end
    end)
end

-- ================== MINIMIZAR E FECHAR ==================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minimized = false

-- Botão de minimizar
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Visible = not minimized
    miniIcon.Visible = minimized
end)

-- Botão de restaurar pelo mini ícone
miniIcon.MouseButton1Click:Connect(function()
    minimized = false
    mainFrame.Visible = true
    miniIcon.Visible = false
end)
