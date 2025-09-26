-- LocalScript em StarterGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIGURAÇÕES GLOBAIS ==================
local pasta = "DANIEL & MARY HUB"
local arquivo = pasta.."/save"
local temaSalvo = "NeonAzul"

-- Estados das configurações
local antiAFKAtivo = false
local antiLagAtivo = false
local visaoNorteAtiva = false
local salvarAtivo = true

-- Cores dinâmicas para texto e botões
local corTexto = Color3.fromRGB(255,255,255)
local corBotao = Color3.fromRGB(50,50,70)
local corBotaoGradiente = Color3.fromRGB(70,70,90)
-- ================== CONFIGURAÇÕES INICIAIS ==================
local logoURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/D%26M_logo.png"
local logoVersionURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/logo_version.txt"

-- Versão do Script
local scriptURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/daniel%26maryhub.lua"
local scriptVersionURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/script_version.txt"

local caminhoLogo = pasta.."/D&M_logo.png"
local versaoLogoArquivo = pasta.."/logo_version.txt"
local versaoScriptArquivo = pasta.."/script_version.txt"
local caminhoScript = pasta.."/script.lua"
local logArquivo = pasta.."/logs.txt"

-- Estados dos jogadores
local playerStates = {}

-- ================== SISTEMA DE LOG ==================
local function registrarLog(msg)
    local data = os.date("[%d/%m/%Y %H:%M:%S] ")
    if writefile and appendfile then
        appendfile(logArquivo, data..msg.."\n")
    end
    warn("[LOG] "..msg)
end

-- ================== FUNÇÃO DE NOTIFICAÇÃO ==================
local function notificarAtualizacao(titulo, texto)
    local plr = game:GetService("Players").LocalPlayer
    if plr then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = titulo,
                Text = texto,
                Duration = 6,
                Icon = "", -- Pode adicionar ícone se quiser
                Callback = function() end
            })
        end)
    end
end

-- ================== FUNÇÃO ROUNDIFY ==================
local function roundify(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 15)
    corner.Parent = obj
end

-- ================== FUNÇÃO GRADIENTE ==================
local function addGradient(obj, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    gradient.Rotation = 45
    gradient.Parent = obj
end

-- ================== PRIMEIRA EXECUÇÃO ==================
local primeiraVez = false
if writefile and makefolder then
    if not isfolder(pasta) then
        makefolder(pasta)
        primeiraVez = true
    end
    if not isfile(arquivo) then
        writefile(arquivo, "Tema="..temaSalvo.."\nAntiAFK=OFF\nAntiLag=OFF\nVisaoNorte=OFF\nSalvar=ON")
        primeiraVez = true
    end
end

-- ================== TELA DE CARREGAMENTO ==================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Parent = playerGui
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true

local fundo = Instance.new("ImageLabel")
fundo.Size = UDim2.new(1,0,1,0)
fundo.Position = UDim2.new(0,0,0,0)
fundo.BackgroundTransparency = 1
fundo.Image = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/FUNDO.jpg"
fundo.ScaleType = Enum.ScaleType.Stretch
fundo.Parent = loadingGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0,380,0,300)
loadingFrame.Position = UDim2.new(0.5,-190,0.5,-150)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
loadingFrame.Parent = fundo
roundify(loadingFrame, 20)
addGradient(loadingFrame, Color3.fromRGB(20,20,30), Color3.fromRGB(35,35,50))

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,130,0,130)
logo.Position = UDim2.new(0.5,-65,0,20)
logo.BackgroundTransparency = 1
logo.Image = logoURL
logo.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,0,50)
loadingText.Position = UDim2.new(0,0,0.55,0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "📥 Iniciando..."
loadingText.TextColor3 = Color3.fromRGB(255,255,255)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextScaled = true
loadingText.Parent = loadingFrame

local loadingPercent = Instance.new("TextLabel")
loadingPercent.Size = UDim2.new(1,0,0,30)
loadingPercent.Position = UDim2.new(0,0,0.7,0)
loadingPercent.BackgroundTransparency = 1
loadingPercent.Text = "0%"
loadingPercent.TextColor3 = Color3.fromRGB(255,255,255)
loadingPercent.Font = Enum.Font.GothamBold
loadingPercent.TextScaled = true
loadingPercent.Parent = loadingFrame

local barraBG = Instance.new("Frame")
barraBG.Size = UDim2.new(0.8,0,0,28)
barraBG.Position = UDim2.new(0.1,0,0.82,0)
barraBG.BackgroundColor3 = Color3.fromRGB(40,40,60)
barraBG.Parent = loadingFrame
roundify(barraBG, 14)

local barra = Instance.new("Frame")
barra.Size = UDim2.new(0,0,1,0)
barra.BackgroundColor3 = Color3.fromRGB(100,200,255)
barra.Parent = barraBG
roundify(barra, 14)
addGradient(barra, Color3.fromRGB(100,200,255), Color3.fromRGB(150,100,255))

-- ================== MENSAGENS DE CARREGAMENTO ==================
local etapas
if primeiraVez then
    etapas = {
        "📥 Baixando scripts... ⏳",
        "🖼️ Baixando imagens... 🎨",
        "📂 Baixando arquivos... 💾",
        "🔑 Baixando chave... 🔐",
        "✅ Download finalizado com sucesso! 🎉"
    }
else
    etapas = {
        "📥 Carregando scripts... ⏳",
        "🖼️ Preparando imagens... 🎨",
        "📂 Lendo arquivos... 💾",
        "🔑 Validando key... 🔐",
        "✅ Finalizado com sucesso! 🎉"
    }
end

-- ================== FUNÇÃO DE ATUALIZAÇÃO E NOTIFICAÇÃO ==================
local function atualizarLogoEScriptDuranteLoading()
    -- Atualização da Logo
    local versaoOnlineLogo = "1"
    pcall(function() versaoOnlineLogo = game:HttpGet(logoVersionURL) end)
    local versaoLocalLogo = isfile(versaoLogoArquivo) and readfile(versaoLogoArquivo) or "0"
    if versaoOnlineLogo ~= versaoLocalLogo then
        loadingText.Text = "🖼️ Atualizando interface..."
        local sucesso, img = pcall(function() return game:HttpGet(logoURL) end)
        if sucesso and img and #img > 100 then
            writefile(caminhoLogo, img)
            writefile(versaoLogoArquivo, versaoOnlineLogo)
            notificarAtualizacao("INTERFACE ATUALIZADA", "A INTERFACE TEM UMA ATUALIZAÇÃO DA VERSÃO "..versaoOnlineLogo.." !")
        end
    end

    -- Atualização do Script
    local versaoOnlineScript = "1"
    pcall(function() versaoOnlineScript = game:HttpGet(scriptVersionURL) end)
    local versaoLocalScript = isfile(versaoScriptArquivo) and readfile(versaoScriptArquivo) or "0"
    if versaoOnlineScript ~= versaoLocalScript then
        loadingText.Text = "📥 Atualizando script..."
        local sucesso, novoScript = pcall(function() return game:HttpGet(scriptURL) end)
        if sucesso and novoScript and #novoScript > 100 then
            writefile(caminhoScript, novoScript)
            writefile(versaoScriptArquivo, versaoOnlineScript)
            notificarAtualizacao("SCRIPT ATUALIZADO", "O SCRIPT TEM UMA ATUALIZAÇÃO DA VERSÃO "..versaoOnlineScript.." !")
        end
    end
end

-- ================== FUNÇÃO DE ANIMAÇÃO DO LOADING ==================
local function iniciarCarregamento()
    for i, msg in ipairs(etapas) do
        loadingText.TextTransparency = 1
        loadingText.Text = msg
        loadingPercent.Text = math.floor((i-1)/#etapas*100).."%"

        for t=1,0,-0.1 do
            loadingText.TextTransparency = t
            task.wait(0.03)
        end

        atualizarLogoEScriptDuranteLoading() -- Atualiza e mostra notificações

        local alvo = i / #etapas
        for p = barra.Size.X.Scale, alvo, 0.02 do
            barra.Size = UDim2.new(p,0,1,0)
            loadingPercent.Text = math.floor(p*100).."%"
            task.wait(0.03)
        end

        task.wait(0.8)
    end

    loadingPercent.Text = "100%"

    for i=0,1,0.05 do
        fundo.BackgroundTransparency = i
        loadingFrame.BackgroundTransparency = i
        loadingText.TextTransparency = i
        loadingPercent.TextTransparency = i
        logo.ImageTransparency = i
        barraBG.BackgroundTransparency = i
        barra.BackgroundTransparency = i
        task.wait(0.03)
    end

    loadingGui:Destroy()
end

iniciarCarregamento()

-- ================== LEITURA DE DADOS ==================
if isfile and readfile and isfile(arquivo) then
    local dados = readfile(arquivo)
    for k,v in string.gmatch(dados,"(%w+)=(%w+)") do
        if k == "Tema" then
            temaSalvo = v
        elseif k == "AntiAFK" then
            antiAFKAtivo = (v == "ON")
        elseif k == "AntiLag" then
            antiLagAtivo = (v == "ON")
        elseif k == "VisaoNorte" then
            visaoNorteAtiva = (v == "ON")
        elseif k == "Salvar" then
            salvarAtivo = (v == "ON")
        end
    end
end

-- ================== FUNÇÃO SALVAR CONFIGURAÇÕES ==================
local function salvarConfiguracoes()
    if salvarAtivo and writefile then
        local dados = "Tema="..temaSalvo.."\n"..
                     "AntiAFK="..(antiAFKAtivo and "ON" or "OFF").."\n"..
                     "AntiLag="..(antiLagAtivo and "ON" or "OFF").."\n"..
                     "VisaoNorte="..(visaoNorteAtiva and "ON" or "OFF").."\n"..
                     "Salvar="..(salvarAtivo and "ON" or "OFF")
        writefile(arquivo, dados)
    end
end

-- ================== GUI PRINCIPAL ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeuHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 🎨 FRAME PRINCIPAL (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB abaixo (quanto menor, mais escuro)
local mainFrame = Instance.new("Frame")
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 520, 1, -30)  -- diminuí um pouco na largura e altura 
mainFrame.Position = UDim2.new(0.5, 0, 0.48, 0) -- mover pra cima ou pra baixo
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- 🔧 MODIFICADO: Cor original do seu código
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui
roundify(mainFrame, 15)

-- 🎨 GRADIENTE DO FRAME PRINCIPAL (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB do gradiente
addGradient(mainFrame, Color3.fromRGB(25,25,35), Color3.fromRGB(40,40,55)) -- 🔧 MODIFICADO: Gradiente original do seu código

-- ================== BARRA DE TÍTULO ==================
-- 🎨 BARRA DE TÍTULO (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB abaixo
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,50) -- 🔧 MODIFICADO: Cor original do seu código
titleBar.Parent = mainFrame
roundify(titleBar, 15)

-- 🎨 GRADIENTE DA BARRA DE TÍTULO (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB do gradiente
addGradient(titleBar, Color3.fromRGB(35,35,50), Color3.fromRGB(50,50,70)) -- 🔧 MODIFICADO: Gradiente original do seu código

-- ARRASTAR PELA BARRA
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.UserInputType.Touch then
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

-- TÍTULO E BOTÕES
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-70,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎈 DANIEL & MARY HUB  🤡  🤙"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextColor3 = Color3.fromRGB(255,255,255) -- 🔧 MODIFICADO: Cor original do texto
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,28,0,28)
minimizeBtn.Position = UDim2.new(1,-65,0.5,-14)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255) -- 🔧 MODIFICADO: Cor original do texto
minimizeBtn.Parent = titleBar
roundify(minimizeBtn, 8)

addGradient(minimizeBtn, Color3.fromRGB(70,130,180), Color3.fromRGB(90,150,200))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-32,0.5,-14)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255) -- 🔧 MODIFICADO: Cor original do texto
closeBtn.Parent = titleBar
roundify(closeBtn, 8)

addGradient(closeBtn, Color3.fromRGB(220,60,60), Color3.fromRGB(240,80,80))

-- ================== MINI ÍCONE COM COR NORMAL ==================
local miniIcon = Instance.new("ImageButton")
miniIcon.Size = UDim2.new(0,42,0,42)
miniIcon.AnchorPoint = Vector2.new(0,0)
miniIcon.Position = UDim2.new(0, 210, 0, -44)
miniIcon.BackgroundColor3 = Color3.fromRGB(255,255,255) -- COR NORMAL BRANCA
miniIcon.Visible = false
miniIcon.Parent = screenGui
miniIcon.Active = true
miniIcon.Draggable = true
roundify(miniIcon, 12)

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

-- 🎨 SCROLL DE JOGOS (CATEGORIAS) (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB abaixo
local gamesFrame = Instance.new("ScrollingFrame")
gamesFrame.Size = UDim2.new(0.4,-5,1,0)
gamesFrame.BackgroundColor3 = Color3.fromRGB(30,30,45) -- 🔧 MODIFICADO: Cor original do seu código
gamesFrame.Parent = contentFrame
gamesFrame.ScrollBarThickness = 8
gamesFrame.ScrollBarImageColor3 = Color3.fromRGB(100,150,200)
gamesFrame.CanvasSize = UDim2.new(0,0,0,0)
roundify(gamesFrame,12)

-- 🎨 GRADIENTE DO FRAME DE JOGOS (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB do gradiente
addGradient(gamesFrame, Color3.fromRGB(30,30,45), Color3.fromRGB(45,45,65)) -- 🔧 MODIFICADO: Gradiente original do seu código

local gameLayout = Instance.new("UIListLayout")
gameLayout.Parent = gamesFrame
gameLayout.Padding = UDim.new(0,8)
gameLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 🎨 SCROLL DE SCRIPTS (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB abaixo
local scriptsFrame = Instance.new("ScrollingFrame")
scriptsFrame.Size = UDim2.new(0.6,-5,1,0)
scriptsFrame.Position = UDim2.new(0.4,5,0,0)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(25,25,40) -- 🔧 MODIFICADO: Cor original do seu código
scriptsFrame.Parent = contentFrame
scriptsFrame.ScrollBarThickness = 8
scriptsFrame.ScrollBarImageColor3 = Color3.fromRGB(100,150,200)
scriptsFrame.CanvasSize = UDim2.new(0,0,0,0)
roundify(scriptsFrame,12)

-- 🎨 GRADIENTE DO FRAME DE SCRIPTS (COR ORIGINAL) 🎨
-- Para modificar: altere os valores RGB do gradiente
addGradient(scriptsFrame, Color3.fromRGB(25,25,40), Color3.fromRGB(40,40,60)) -- 🔧 MODIFICADO: Gradiente original do seu código

local scriptLayout = Instance.new("UIListLayout")
scriptLayout.Parent = scriptsFrame
scriptLayout.Padding = UDim.new(0,8)
scriptLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ================== FOOTER ==================
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1,0,0,40)
footer.Position = UDim2.new(0,0,1,-40)
footer.BackgroundColor3 = Color3.fromRGB(20,20,30)
footer.Parent = mainFrame
roundify(footer,15)

addGradient(footer, Color3.fromRGB(20,20,30), Color3.fromRGB(35,35,50))

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
playerName.TextColor3 = Color3.fromRGB(255,255,255) -- 🔧 MODIFICADO: Cor original do texto
playerName.Font = Enum.Font.GothamBold
playerName.TextSize = 16
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = footer

local creditos = Instance.new("TextLabel")
creditos.Size = UDim2.new(0.5,-10,1,0)
creditos.Position = UDim2.new(0.5,0,0,0)
creditos.BackgroundTransparency = 1
creditos.Text = "Créditos: DANIEL ⚽  & MARY 📿 "
creditos.TextColor3 = Color3.fromRGB(255,255,255) -- 🔧 MODIFICADO: Cor original do texto
creditos.Font = Enum.Font.GothamSemibold
creditos.TextSize = 14
creditos.TextXAlignment = Enum.TextXAlignment.Right
creditos.Parent = footer

-- ================== FUNÇÃO BOTÃO MELHORADA ==================
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,38)
    btn.BackgroundColor3 = corBotao
    btn.TextColor3 = corTexto
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = parent
    roundify(btn,10)
    
    addGradient(btn, corBotao, corBotaoGradiente)
    
    btn.MouseButton1Click:Connect(callback)

    if parent:IsA("ScrollingFrame") and parent:FindFirstChildOfClass("UIListLayout") then
        parent.CanvasSize = UDim2.new(0,0,0,parent.UIListLayout.AbsoluteContentSize.Y + 10)
    end
end

-- ================== FUNÇÃO BOTÃO VOLTAR ==================
local function createBackButton()
    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(1,-10,0,38)
    backBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    backBtn.TextColor3 = Color3.fromRGB(255,255,255) -- Sempre branco para contraste com vermelho
    backBtn.Text = "🔙 VOLTAR"
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 16
    backBtn.Parent = scriptsFrame
    roundify(backBtn,10)
    
    addGradient(backBtn, Color3.fromRGB(180,70,70), Color3.fromRGB(200,90,90))
    
    backBtn.MouseButton1Click:Connect(function()
        -- Limpa TODOS os elementos (botões, frames, caixas de texto, etc.)
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") 
            or child:IsA("Frame") 
            or child:IsA("TextBox") 
            or child:IsA("ScrollingFrame") 
            or child:IsA("ImageLabel") 
            or child:IsA("ImageButton") then
                child:Destroy()
            end
        end
        scriptsFrame.CanvasSize = UDim2.new(0,0,0,0)
    end)
    
    scriptsFrame.CanvasSize = UDim2.new(0,0,0,scriptLayout.AbsoluteContentSize.Y + 10)
end

-- ================== FUNÇÃO TOGGLE SWITCH ==================
function createToggleSwitch(parent, text, estadoInicial, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 38)
    frame.BackgroundColor3 = corBotao
    frame.Parent = parent
    roundify(frame, 10)
    addGradient(frame, corBotao, corBotaoGradiente)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = corTexto
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.25, -10, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.75, 5, 0.2, 0)
    toggleBtn.BackgroundColor3 = estadoInicial and Color3.fromRGB(50,200,100) or Color3.fromRGB(200,50,50)
    toggleBtn.Text = estadoInicial and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.Parent = frame
    roundify(toggleBtn, 8)

    toggleBtn.MouseButton1Click:Connect(function()
        estadoInicial = not estadoInicial
        toggleBtn.BackgroundColor3 = estadoInicial and Color3.fromRGB(50,200,100) or Color3.fromRGB(200,50,50)
        toggleBtn.Text = estadoInicial and "ON" or "OFF"
        if callback then
            callback(estadoInicial)
        end
    end)

    -- Atualiza o CanvasSize do ScrollFrame
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

    BrancoAntigo = Color3.fromRGB(250,235,215),
    VerdeClaro = Color3.fromRGB(144,238,144),
    AzulClaro = Color3.fromRGB(173,216,230),
    RosaClaro = Color3.fromRGB(255,182,193),
    LaranjaClaro = Color3.fromRGB(255,200,150),
    CinzaClaro = Color3.fromRGB(211,211,211),

    VerdeEscuro = Color3.fromRGB(0,100,0),
    AzulEscuro = Color3.fromRGB(0,0,139),
    RoxoEscuro = Color3.fromRGB(75,0,130),
    MarromEscuro = Color3.fromRGB(101,67,33),
    CinzaEscuro = Color3.fromRGB(64,64,64),

    PastelRosa = Color3.fromRGB(255,209,220),
    PastelVerde = Color3.fromRGB(119,221,119),
    PastelAzul = Color3.fromRGB(174,198,207),
    PastelAmarelo = Color3.fromRGB(253,253,150),

    NeonVerde = Color3.fromRGB(57,255,20),
    NeonAzul = Color3.fromRGB(77,77,255),
    NeonRosa = Color3.fromRGB(255,20,147),
    NeonCiano = Color3.fromRGB(0,255,255),

    Transparente30 = Color3.fromRGB(255,255,255)
}

local function aplicarTema(cor)
    mainFrame.BackgroundColor3 = cor
    gamesFrame.BackgroundColor3 = cor
    scriptsFrame.BackgroundColor3 = cor

    -- Remove o gradiente antigo para evitar sobreposição
    if mainFrame:FindFirstChildOfClass("UIGradient") then mainFrame:FindFirstChildOfClass("UIGradient"):Destroy() end
    if gamesFrame:FindFirstChildOfClass("UIGradient") then gamesFrame:FindFirstChildOfClass("UIGradient"):Destroy() end
    if scriptsFrame:FindFirstChildOfClass("UIGradient") then scriptsFrame:FindFirstChildOfClass("UIGradient"):Destroy() end

    -- Adiciona o novo gradiente com base na cor do tema
    addGradient(mainFrame, cor, cor:Lerp(Color3.new(0,0,0), 0.3))
    addGradient(gamesFrame, cor, cor:Lerp(Color3.new(0,0,0), 0.3))
    addGradient(scriptsFrame, cor, cor:Lerp(Color3.new(0,0,0), 0.3))

    -- Calcula a luminância da cor para determinar se é clara ou escura
    local r, g, b = cor.R, cor.G, cor.B
    local luminancia = 0.299 * r + 0.587 * g + 0.114 * b

    -- Define cores de texto e botões com base na luminância
    if luminancia > 0.5 then
        -- Tema claro - texto e botões escuros
        corTexto = Color3.fromRGB(0, 0, 0)
        corBotao = Color3.fromRGB(125, 200, 255)
        corBotaoGradiente = Color3.fromRGB(60, 60, 60)
    else
        -- Tema escuro - texto e botões claros
        corTexto = Color3.fromRGB(255, 255, 255)
        corBotao = Color3.fromRGB(125, 200, 255)
        corBotaoGradiente = Color3.fromRGB(100, 100, 120)
    end

    -- Atualiza as cores dos textos existentes
    titleText.TextColor3 = corTexto
    playerName.TextColor3 = corTexto
    creditos.TextColor3 = corTexto

    -- Atualiza as cores dos botões existentes
    for _, child in ipairs(gamesFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.TextColor3 = corTexto
            child.BackgroundColor3 = corBotao
            if child:FindFirstChildOfClass("UIGradient") then child:FindFirstChildOfClass("UIGradient"):Destroy() end
            addGradient(child, corBotao, corBotaoGradiente)
        end
    end

    for _, child in ipairs(scriptsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.TextColor3 = corTexto
            child.BackgroundColor3 = corBotao
            if child:FindFirstChildOfClass("UIGradient") then child:FindFirstChildOfClass("UIGradient"):Destroy() end
            addGradient(child, corBotao, corBotaoGradiente)
        end
    end
end

if corTemas[temaSalvo] then aplicarTema(corTemas[temaSalvo]) end

-- ================== FUNÇÕES DE CONFIGURAÇÃO ==================
-- Anti-AFK
local antiAFKConnection
local function toggleAntiAFK(estado)
    antiAFKAtivo = estado
    if antiAFKAtivo then
        antiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        warn("Anti-AFK Ativado ✅")
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
        warn("Anti-AFK Desativado ❌")
    end
    salvarConfiguracoes()
end

-- Anti-Lag
local function toggleAntiLag(estado)
    antiLagAtivo = estado
    if antiLagAtivo then
        settings().Rendering.QualityLevel = 1
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end
        warn("Anti-Lag Ativado ✅")
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        warn("Anti-Lag Desativado ❌")
    end
    salvarConfiguracoes()
end

-- Visão Norte
-- Visão Norte + Iluminação Ótima (cores naturais)
local Lighting = game:GetService("Lighting")
local northConnection
local visaoNorteAtiva = false
local efeitoIluminacao

local function toggleVisaoNorte(estado)
    visaoNorteAtiva = estado
    if visaoNorteAtiva then
        -- cria efeito de iluminação se não existir
        if not efeitoIluminacao then
            efeitoIluminacao = Instance.new("ColorCorrectionEffect")
            efeitoIluminacao.Name = "EfeitoIluminacao"
            efeitoIluminacao.Brightness = 0.5   -- deixa bem claro
            efeitoIluminacao.Contrast = 0.1     -- contraste leve
            efeitoIluminacao.Saturation = 0     -- mantém cores naturais
            efeitoIluminacao.TintColor = Color3.fromRGB(255, 255, 255) -- sem cor extra
            efeitoIluminacao.Parent = Lighting
        end

        northConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.CameraOffset = Vector3.new(0,0,0)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0,0,0)
            end
        end)

        warn("Visão Norte (Iluminação Ótima) Ativada ✅")
    else
        -- remove efeito quando desativa
        if efeitoIluminacao then
            efeitoIluminacao:Destroy()
            efeitoIluminacao = nil
        end

        if northConnection then
            northConnection:Disconnect()
            northConnection = nil
        end
        warn("Visão Norte Desativada ❌")
    end
    salvarConfiguracoes()
end

-- Inicializar configurações salvas
if antiAFKAtivo then toggleAntiAFK(true) end
if antiLagAtivo then toggleAntiLag(true) end
if visaoNorteAtiva then toggleVisaoNorte(true) end

-- ================== MENU PRINCIPAL REESTRUTURADO ==================
-- JOGO 1
-- JOGO VIP
createButton(gamesFrame, "🎮  SCRIPTS VIP & PAGOS 👑", function()
    for _, c in ipairs(scriptsFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then 
            c:Destroy() 
        end
    end
    
    createBackButton()
    
    local scriptsVip = {
        {"GERADO 99 NORTE |STATUS| 🔵 PERFEITO", 
            "https://raw.githubusercontent.com/hellattexyss/autofarmdiamonds/main/overhubaurofarm.lua"},
        -- Aqui você pode adicionar mais scripts VIP, exemplo:
        -- {"NOME DO SCRIPT |STATUS| 🟢 ESTÁVEL", "URL_DO_SCRIPT"},
    }
    
    for _, data in ipairs(scriptsVip) do
        local scriptName, url = data[1], data[2]
        createButton(scriptsFrame, scriptName, function()
            loadstring(game:HttpGet(url))()
        end)
    end
end)

-- JOGO 1
createButton(gamesFrame, "🎮 99 NOITE NA FLORESTA", function()
    for _, c in ipairs(scriptsFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    
    createBackButton()
    
    local scripts99 = {
        {"VOIDWARE |STATUS|  🔵 PERFEITO", 
            "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"},
        {"RAYFIELD |STATUS|  🔵 PERFEITO", 
            "https://raw.githubusercontent.com/Iliankytb/Iliankytb/main/Best99NightsInTheForest"},
        {"H4xSCRIPTS |STATUS|  🟣 MONITORANDO", 
            "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", 
            "https://raw.githubusercontent.com/Fu6rfho5zf/GET-KEY-/refs/heads/main/H4xScripts.txt", 
            "/storage/emulated/0/Delta/Workspace/H4xScripts/Key.txt", 
            true, "arg", 30},
        {"SOLUNA |STATUS|  🟢 ESTÁVEL", 
            "https://raw.githubusercontent.com/endoverdosing/Soluna-API/refs/heads/main/99-Nights-in-the-Forest.lua", 
            "https://raw.githubusercontent.com/Fu6rfho5zf/GET-KEY-/refs/heads/main/99nights_key_validation.txt", 
            "/storage/emulated/0/Delta/Workspace/99nights_key_validation.txt", 
            true, "arg", 60},
        {"RINGTA |STATUS| 🟢 ESTÁVEL", 
            "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua"},
        {"GETNATIVE |STATUS| 🔴 KEY VARIÁVEL", 
            "https://getnative.cc/script/loader",
            "https://raw.githubusercontent.com/Fu6rfho5zf/GET-KEY-/refs/heads/main/getnative_keys.txt",
            "/storage/emulated/0/Delta/Workspace/GetNative/Key.txt",
            true, "var", 15},
    }
    
    for _, data in ipairs(scripts99) do
        local scriptName, url = data[1], data[2]
        createButton(scriptsFrame, scriptName, function()
            loadstring(game:HttpGet(url))()
        end)
    end
end)

-- JOGO 2 FUJA DA INSTALAÇÃO
createButton(gamesFrame, "🎮 FUJA DA INSTALAÇÃO", function()
    for _, c in ipairs(scriptsFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then 
            c:Destroy() 
        end
    end
    
    createBackButton()
    
    local scriptsFUJA = {
        {"YARHM |STATUS| 🔵 PERFEITO", 
            "https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/source/yarhm/1.19/yarhm.lua"},
        -- Aqui você pode adicionar mais scripts VIP, exemplo:
        -- {"NOME DO SCRIPT |STATUS| 🟢 ESTÁVEL", "URL_DO_SCRIPT"},
    }
    
    for _, data in ipairs(scriptsFUJA) do
        local scriptName, url = data[1], data[2]
        createButton(scriptsFrame, scriptName, function()
            loadstring(game:HttpGet(url))()
        end)
    end
end)

-- JOGO bola da Morte 
createButton(gamesFrame, "🎮 BOLA DAMORTE", function()
    for _, c in ipairs(scriptsFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    
    createBackButton()
    createButton(scriptsFrame, "EM BETA", function()
        warn("Script Exemplo 2 executado!")
    end)
end)

-- ================== CONFIGURAÇÕES ==================
createButton(gamesFrame, "⚙️ CONFIG", function()
    for _, c in ipairs(scriptsFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    
    createBackButton()
    
    -- TEMA
    createButton(scriptsFrame, "🎨 TEMA", function()
        for _, c in ipairs(scriptsFrame:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
        end
        
        createBackButton()
        
        for _, tema in ipairs(temas) do
            createButton(scriptsFrame, "🎨 "..tema, function()
                temaSalvo = tema
                if corTemas[tema] then
                    aplicarTema(corTemas[tema])
                end
                salvarConfiguracoes()
                warn("Tema alterado para: "..tema)
            end)
        end
    end)
    
    -- ANTI-AFK
    createToggleSwitch(scriptsFrame, "ANTI-AFK", antiAFKAtivo, toggleAntiAFK)
    
    -- ANTI-LAG
    createToggleSwitch(scriptsFrame, "⚡ ANTI-LAG", antiLagAtivo, toggleAntiLag)
    
    -- VISÃO NORTE
    createToggleSwitch(scriptsFrame, "🧭 VISÃO NORTE OFF", visaoNorteAtiva, toggleVisaoNorte)
    
    -- SALVAR
    createToggleSwitch(scriptsFrame, "💾 SALVAR", salvarAtivo, function(estado)
        salvarAtivo = estado
        salvarConfiguracoes()
        warn("Sistema de salvamento: "..(estado and "ATIVADO" or "DESATIVADO"))
    end)
end)


-- 🔧 FIX PARA ROLAGEM FUNCIONAR 🔧
scriptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scriptsFrame.CanvasSize = UDim2.new(0,0,0,scriptLayout.AbsoluteContentSize.Y + 10)
end)

gameLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    gamesFrame.CanvasSize = UDim2.new(0,0,0,gameLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== MINIMIZAR E FECHAR ==================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Visible = not minimized
    miniIcon.Visible = minimized
end)

miniIcon.MouseButton1Click:Connect(function()
    minimized = false
    mainFrame.Visible = true
    miniIcon.Visible = false
end)


