-- LocalScript em StarterGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIGURAÇÕES ==================
local pasta = "DANIEL & MARY HUB"
local arquivo = pasta.."/save"
local temaSalvo = "Preto"

-- URLs da logo e versão
local logoURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/DeM.jpg"
local logoVersionURL = "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/logo_version.txt"

-- Caminhos locais
local caminhoLogo = pasta.."/D&M_logo.png"
local versaoArquivo = pasta.."/logo_version.txt"

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
        "📥 BAIXANDO OS SCRIPTS...!",
        "🖼️ BAIXANDO AS IMAGENS...!",
        "📂 BAIXANDO OS ARQUIVOS...!",
        "🔑 BAIXANDO AS KEY...!",
        "✅ DOWNLOAD CONCLUÍDO...!"
    }
else
    etapas = {
        "📝 CARREGANDO OS SCRIPTS...!",
        "🎨 CARREGANDO AS IMAGENS...!",
        "💾 CARREGANDO OS ARQUIVOS...!",
        "🗝️ CARREGANDO AS KEY...!",
        "🎉 CONCLUÍDO COM SUCESSO...!"
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

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.25, 0, 0.10, 0) -- Subindo o menu um pouco mais
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
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
titleText.Text = "📰 DANIEL & MARY HUB"
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
local miniIcon = Instance.new("ImageButton")
miniIcon.Size = UDim2.new(0,40,0,40)  -- <--- Mude aqui para aumentar/diminuir
miniIcon.AnchorPoint = Vector2.new(0.5, 0) -- Centraliza horizontalmente
miniIcon.Position = UDim2.new(0.5, 0, 0, 0) -- Topo centralizado, margem 10px
miniIcon.BackgroundColor3 = Color3.fromRGB(45,45,45)
miniIcon.Visible = false
miniIcon.Parent = screenGui
miniIcon.Active = true
miniIcon.Draggable = true
roundify(miniIcon, 10)

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
creditos.Text = "Créditos: DANIEL & MARY HUB"
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
    -- Limpa os botões atuais
    for _,child in ipairs(scriptsFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0

    -- Botão Tema
    local temaBtn = Instance.new("TextButton")
    temaBtn.Size = UDim2.new(1,-10,0,35)
    temaBtn.Position = UDim2.new(0,5,0,y)
    temaBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    temaBtn.TextColor3 = Color3.new(1,1,1)
    temaBtn.Text = "Tema: "..temaSalvo
    temaBtn.Parent = scriptsFrame
    roundify(temaBtn,8)
    local atual = table.find(temas,temaSalvo) or 1
    temaBtn.MouseButton1Click:Connect(function()
        atual = (atual % #temas)+1
        temaBtn.Text = "Tema: "..temas[atual]
        temaSalvo = temas[atual]
        aplicarTema(corTemas[temas[atual]])
        if salvarAtivo and writefile and makefolder then
            if not isfolder(pasta) then makefolder(pasta) end
            writefile(arquivo,"Tema="..temaSalvo.."\nSalvar="..(salvarAtivo and "ON" or "OFF"))
        end
    end)
    y = y + 40

    -- Botão Salvar Dados
    local salvarBtn = Instance.new("TextButton")
    salvarBtn.Size = UDim2.new(1,-10,0,35)
    salvarBtn.Position = UDim2.new(0,5,0,y)
    salvarBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    salvarBtn.TextColor3 = Color3.new(1,1,1)
    salvarBtn.Text = "SALVAR OS SEUS DADOS: " .. (salvarAtivo and "ON" or "OFF")
    salvarBtn.Parent = scriptsFrame
    roundify(salvarBtn,8)
    salvarBtn.MouseButton1Click:Connect(function()
        salvarAtivo = not salvarAtivo
        salvarBtn.Text = "Salvar Dados: " .. (salvarAtivo and "ON" or "OFF")
        if writefile and makefolder then
            if not isfolder(pasta) then makefolder(pasta) end
            writefile(arquivo,"Tema="..temaSalvo.."\nSalvar="..(salvarAtivo and "ON" or "OFF"))
        end
    end)
    y = y + 40

    -- Botão Copiar Key (abre menu de jogos)
    local copiarKeyBtn = Instance.new("TextButton")
    copiarKeyBtn.Size = UDim2.new(1,-10,0,35)
    copiarKeyBtn.Position = UDim2.new(0,5,0,y)
    copiarKeyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    copiarKeyBtn.TextColor3 = Color3.new(1,1,1)
    copiarKeyBtn.Text = "📋 KEY AQUI, CASO SUA KEY NÃO FUNCIONA"
    copiarKeyBtn.Parent = scriptsFrame
    roundify(copiarKeyBtn,8)
    y = y + 40

    copiarKeyBtn.MouseButton1Click:Connect(function()
        -- Limpa botões atuais
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local y2 = 0

        -- Lista de Jogos e Scripts
        local jogos = {
            ["99 Noite na Floresta"] = {
                {nome="99 NOTS", keys={
                    {"Key 1", {{"Meu Canal","youtube.com/@meucanal1"}, {"Meu DC","discord.gg/seulink1"}, {"YT","youtube.com/@meucanal1"}}},
                    {"Key 2", {{"Meu Canal","youtube.com/@meucanal2"}, {"Meu DC","discord.gg/seulink2"}, {"YT","youtube.com/@meucanal2"}}},
                }},
                {nome="Segundo Script", keys={
                    {"Key 1", {{"Meu Canal","youtube.com/@meucanal3"}, {"Meu DC","discord.gg/seulink3"}, {"YT","youtube.com/@meucanal3"}}},
                }},
            },
            ["Bola da Morte"] = {
                {nome="BOLAA SA MORTW SH", keys={
                    {"Key 1", {{"Meu Canal","youtube.com/@meucanal4"}, {"Meu DC","discord.gg/seulink4"}, {"YT","youtube.com/@meucanal4"}}},
                }},
                {nome="BOLA SA MORTE SCRU2", keys={
                    {"Key 1", {{"Meu Canal","youtube.com/@meucanal5"}, {"Meu DC","discord.gg/seulink5"}, {"YT","youtube.com/@meucanal5"}}},
                }},
            },
        }

        -- Cria botões dos jogos
        for jogoNome, scripts in pairs(jogos) do
            local jogoBtn = Instance.new("TextButton")
            jogoBtn.Size = UDim2.new(1,-10,0,35)
            jogoBtn.Position = UDim2.new(0,5,0,y2)
            jogoBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            jogoBtn.TextColor3 = Color3.new(1,1,1)
            jogoBtn.Text = jogoNome
            jogoBtn.Parent = scriptsFrame
            roundify(jogoBtn,8)

            jogoBtn.MouseButton1Click:Connect(function()
                -- Limpa botões atuais
                for _,child in ipairs(scriptsFrame:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                local y3 = 0
                -- Cria botões dos scripts
                for _, scriptData in ipairs(scripts) do
                    local scriptBtn = Instance.new("TextButton")
                    scriptBtn.Size = UDim2.new(1,-10,0,35)
                    scriptBtn.Position = UDim2.new(0,5,0,y3)
                    scriptBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                    scriptBtn.TextColor3 = Color3.new(1,1,1)
                    scriptBtn.Text = scriptData.nome
                    scriptBtn.Parent = scriptsFrame
                    roundify(scriptBtn,8)

                    scriptBtn.MouseButton1Click:Connect(function()
                        -- Limpa botões atuais
                        for _,child in ipairs(scriptsFrame:GetChildren()) do
                            if child:IsA("TextButton") then child:Destroy() end
                        end
                        local y4 = 0
                        -- Cria botões das keys
                        for _, keyData in ipairs(scriptData.keys) do
                            local keyNome, links = keyData[1], keyData[2]
                            local keyBtn = Instance.new("TextButton")
                            keyBtn.Size = UDim2.new(1,-10,0,35)
                            keyBtn.Position = UDim2.new(0,5,0,y4)
                            keyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                            keyBtn.TextColor3 = Color3.new(1,1,1)
                            keyBtn.Text = keyNome
                            keyBtn.Parent = scriptsFrame
                            roundify(keyBtn,8)

                            keyBtn.MouseButton1Click:Connect(function()
                                -- Limpa botões atuais
                                for _,child in ipairs(scriptsFrame:GetChildren()) do
                                    if child:IsA("TextButton") then child:Destroy() end
                                end
                                local y5 = 0
                                -- Cria botões dos links
                                for _, linkData in ipairs(links) do
                                    local nome, conteudo = linkData[1], linkData[2]
                                    local linkBtn = Instance.new("TextButton")
                                    linkBtn.Size = UDim2.new(1,-10,0,35)
                                    linkBtn.Position = UDim2.new(0,5,0,y5)
                                    linkBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
                                    linkBtn.TextColor3 = Color3.new(1,1,1)
                                    linkBtn.Text = nome
                                    linkBtn.Parent = scriptsFrame
                                    roundify(linkBtn,8)

                                    linkBtn.MouseButton1Click:Connect(function()
                                        if setclipboard then
                                            setclipboard(conteudo)
                                            linkBtn.Text = "📋 Copiado!"
                                            task.wait(1.5)
                                            linkBtn.Text = nome
                                        else
                                            warn("setclipboard não disponível!")
                                        end
                                    end)
                                    y5 = y5 + 40
                                end
                            end)
                            y4 = y4 + 40
                        end
                    end)
                    y3 = y3 + 40
                end
            end)
            y2 = y2 + 40
        end
    end)
end)

-- ================== SISTEMA DE KEYS ==================
-- ================== SISTEMA DE KEYS ==================
local jogos = {
    ["99 Noite na Floresta"] = {
        {"SOLUNA 🟢 ON", "https://raw.githubusercontent.com/endoverdosing/Soluna-API/refs/heads/main/99-Nights-in-the-Forest.lua", "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/99nights_key_validation.txt", "/storage/emulated/0/Delta/Workspace/"},
        {"VOIDWARE 🟢 ON", "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"}, -- sem key
        {"H4xScripts 🔴 OFF", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua", "https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/99nights_key_validation.txt", "/storage/emulated/0/Delta/Workspace/H4xScripts/"}
    }
}

-- Armazena keys já usadas por este jogador
local usedKeys = {}

-- Função auxiliar para extrair o nome do arquivo da URL
local function getFileNameFromUrl(url)
    return url:match("^.+/(.+)$")
end

-- Função para pegar uma key aleatória do arquivo
local function getRandomKey(keyFolder, keyFileName, scriptName)
    -- Se o jogador já tem key para esse script, retorna ela
    if usedKeys[scriptName] then
        return usedKeys[scriptName]
    end

    local path = keyFolder..keyFileName
    if not isfile(path) then
        return nil
    end

    local allKeys = {}
    for line in readfile(path):gmatch("[^\r\n]+") do
        table.insert(allKeys, line)
    end

    -- Pega uma key aleatória
    if #allKeys > 0 then
        local index = math.random(1, #allKeys)
        local key = allKeys[index]

        -- Remove a key usada do arquivo para que ninguém mais pegue
        table.remove(allKeys, index)
        writefile(path, table.concat(allKeys, "\n"))

        -- Salva em memória para este jogador
        usedKeys[scriptName] = key

        return key
    end

    return nil
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
            local scriptName, url, keyUrl, keyFolder = data[1], data[2], data[3], data[4]
            
            createButton(scriptsFrame, scriptName, function()
                if keyUrl and keyFolder then
                    -- Cria a pasta da key, se não existir
                    if not isfolder(keyFolder) then
                        makefolder(keyFolder)
                    end

                    -- Extrai o nome do arquivo da URL
                    local keyFileName = getFileNameFromUrl(keyUrl)

                    -- Baixa e salva a key se ainda não tiver
                    if not isfile(keyFolder..keyFileName) then
                        local keyOnline = game:HttpGet(keyUrl)
                        writefile(keyFolder..keyFileName, keyOnline)
                        warn("Key baixada e salva em: "..keyFolder..keyFileName)
                    end

                    -- Pega a key (uma por jogador)
                    local key = getRandomKey(keyFolder, keyFileName, scriptName)
                    if key then
                        warn("Usando key: "..key)
                        loadstring(game:HttpGet(url))(key)
                        return
                    else
                        warn("Não há keys disponíveis!")
                        return
                    end
                end

                -- Executa o script direto se não tiver key
                loadstring(game:HttpGet(url))()
            end)
        end
    end)
end

-- ================== MINIMIZAR E FECHAR ==================
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minimized=false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    mainFrame.Visible=not minimized
    miniIcon.Visible=minimized
end)
miniIcon.MouseButton1Click:Connect(function()
    minimized=false
    mainFrame.Visible=true
    miniIcon.Visible=false

end)
