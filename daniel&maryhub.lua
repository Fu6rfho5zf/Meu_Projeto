-- LocalScript em StarterGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CONFIGURAÇÕES ==================
local pasta = "DANIEL & MARY HUB"
local arquivo = pasta.."/save"
local temaSalvo = "Preto"

-- URLs da logo e versão
local logoURL = "https://raw.githubusercontent.com/Fu6rfho5zf/TvR/refs/heads/main/new_logo.png"
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

-- ================== GUI CARREGAMENTO ==================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Parent = playerGui
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0,300,0,260)
loadingFrame.Position = UDim2.new(0.5,-150,0.5,-130)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadingFrame.Parent = loadingGui
roundify(loadingFrame, 12)

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,0,40)
loadingText.Position = UDim2.new(0,0,0,10)
loadingText.BackgroundTransparency = 1
loadingText.Text = primeiraVez and "📥 Baixando arquivos iniciais..." or "🔄 Carregando HUB..."
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 18
loadingText.Parent = loadingFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0,120,0,120)
logo.Position = UDim2.new(0.5,-60,0.5,-40)
logo.BackgroundTransparency = 1
logo.Image = logoURL
logo.Parent = loadingFrame

local barraBG = Instance.new("Frame")
barraBG.Size = UDim2.new(0.8,0,0,20)
barraBG.Position = UDim2.new(0.1,0,1,-40)
barraBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
barraBG.Parent = loadingFrame
roundify(barraBG, 10)

local barra = Instance.new("Frame")
barra.Size = UDim2.new(0,0,1,0)
barra.BackgroundColor3 = Color3.fromRGB(0,200,0)
barra.Parent = barraBG
roundify(barra, 10)

spawn(function()
    for i=0,1,0.02 do
        barra.Size = UDim2.new(i,0,1,0)
        task.wait(0.05)
    end
end)

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
        if k == "Tema" then temaSalvo = v end
    end
end

task.wait(5)
loadingGui:Destroy()

-- ================== GUI PRINCIPAL ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeuHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
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
miniIcon.Size = UDim2.new(0,40,0,40)
miniIcon.Position = UDim2.new(0,50,0.8,0)
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

local gamesFrame = Instance.new("Frame")
gamesFrame.Size = UDim2.new(0.4,-5,1,0)
gamesFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
gamesFrame.Parent = contentFrame
roundify(gamesFrame,10)

local scriptsFrame = Instance.new("Frame")
scriptsFrame.Size = UDim2.new(0.6,-5,1,0)
scriptsFrame.Position = UDim2.new(0.4,5,0,0)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
scriptsFrame.Parent = contentFrame
roundify(scriptsFrame,10)

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
    btn.Position = UDim2.new(0,5,0,(#parent:GetChildren()-0)*40)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Parent = parent
    roundify(btn,8)
    btn.MouseButton1Click:Connect(callback)
end

-- ================== TEMAS ==================
local temas = {"Branco","Preto","Verde","Azul","Roxo","Ciano","VerdeClaro","AzulClaro","AzulEscuro","RoxoClaro","Cinza"}
local corTemas = {
    Branco = Color3.fromRGB(255,255,255),
    Preto = Color3.fromRGB(30,30,30),
    Verde = Color3.fromRGB(0,200,0),
    Azul = Color3.fromRGB(0,120,255),
    Roxo = Color3.fromRGB(120,0,255),
    Ciano = Color3.fromRGB(0,255,255),
    VerdeClaro = Color3.fromRGB(144,238,144),
    AzulClaro = Color3.fromRGB(173,216,230),
    AzulEscuro = Color3.fromRGB(0,0,139),
    RoxoClaro = Color3.fromRGB(216,191,216),
    Cinza = Color3.fromRGB(128,128,128)
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
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0

    -- Botão de tema
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
    end)
    y = y+40

    -- Botão de salvar dados
    local salvarBtn = Instance.new("TextButton")
    salvarBtn.Size = UDim2.new(1,-10,0,35)
    salvarBtn.Position = UDim2.new(0,5,0,y)
    salvarBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    salvarBtn.TextColor3 = Color3.new(1,1,1)
    salvarBtn.Text = "Salvar Dados: OFF"
    salvarBtn.Parent = scriptsFrame
    roundify(salvarBtn,8)
    local salvarAtivo = false
    salvarBtn.MouseButton1Click:Connect(function()
        salvarAtivo = not salvarAtivo
        salvarBtn.Text = "Salvar Dados: "..(salvarAtivo and "ON" or "OFF")
        if salvarAtivo and writefile and makefolder then
            if not isfolder(pasta) then makefolder(pasta) end
            writefile(arquivo,"Tema="..temaSalvo)
        end
    end)
    y = y+40

    -- Botão para abrir os textos de copiar
    local copiarMenuBtn = Instance.new("TextButton")
    copiarMenuBtn.Size = UDim2.new(1,-10,0,35)
    copiarMenuBtn.Position = UDim2.new(0,5,0,y)
    copiarMenuBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    copiarMenuBtn.TextColor3 = Color3.new(1,1,1)
    copiarMenuBtn.Text = "📋 Copiar Textos"
    copiarMenuBtn.Parent = scriptsFrame
    roundify(copiarMenuBtn,8)

    copiarMenuBtn.MouseButton1Click:Connect(function()
        -- limpa os botões atuais
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local textos = {
            {"Meu Discord","discord.gg/seulink"},
            {"Canal Youtube","youtube.com/@meucanal"},
            {"Meu Site","https://meusite.com"}
        }
        local y2 = 0
        for _,data in ipairs(textos) do
            local nome,conteudo=data[1],data[2]
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,35)
            btn.Position = UDim2.new(0,5,0,y2)
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = nome
            btn.Parent = scriptsFrame
            roundify(btn,8)
            btn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(conteudo)
                    btn.Text = "📋 Copiado!"
                    task.wait(1.5)
                    btn.Text = nome
                else
                    warn("setclipboard não disponível!")
                end
            end)
            y2 = y2 + 40
        end
    end)
end)
-- ================== JOGOS/SCRIPTS ==================
local jogos = {
    ["99 Noites na Floresta"] = { {"VOIDWARE", "https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua"} },
    ["Bola da Morte"] = { {"Script OP", "https://pastefy.app/4J0tYijA/raw"}, {"GodMode", "https://ads.luarmor.net/get_key?for=H4xScript__Linkvertise-fefhrreVBkfh"} }
}
for jogo,scripts in pairs(jogos) do
    createButton(gamesFrame,jogo.." Scripts",function()
        for _,child in ipairs(scriptsFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local y=0
        for _,scriptData in ipairs(scripts) do
            local scriptName,url,logo=scriptData[1],scriptData[2],scriptData[3]
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,35)
            btn.Position = UDim2.new(0,5,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = scriptName
            btn.Parent = scriptsFrame
            roundify(btn,8)
            btn.MouseButton1Click:Connect(function()
                btn.Text="Carregando..."
                spawn(function()
                    loadstring(game:HttpGet(url))()
                    btn.Text=scriptName
                    if logo then
                        if writefile and getcustomasset then
                            local caminho = pasta.."/"..jogo..".png"
                            if not isfile(caminho) then
                                local imagem = game:HttpGet(logo)
                                writefile(caminho, imagem)
                            end
                            miniIcon.Image = getcustomasset(caminho)
                        else
                            miniIcon.Image = logo
                        end
                    end
                end)
            end)
            y=y+40
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


