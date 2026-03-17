​📘 Guia Definitivo: LIBRAYS UI
​Aprenda a criar interfaces modernas e funcionais para seus scripts.
​⚡ Instalação Rápida
​Para começar a usar a LIBRAYS UI, basta fazer o download da biblioteca com o seguinte código:

local Libra = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/HUB%20LIBRAYS%20UI.lua"))()

🚀 Criando sua Primeira Janela
​Configuração Básica

local Window = Libra:CreateWindow({
    Name = "Meu Script",                    -- Título da janela
    Subtitle = "By: SeuNome",                -- Subtítulo
    LogoID = "123456789",                     -- ID da imagem (opcional)
    OpenButtonName = "MENU",                   -- Nome do botão flutuante
    OpenButtonPosition = {X = 350, Y = 30},    -- Posição do botão {X, Y}
    
    ConfigSettings = {
        RootFolder = "LIBRAYS HUB",            -- Pasta principal
        ConfigFolder = "Meu Script"            -- Pasta de configurações
    },
    
    KeySystem = false,                          -- Ativar sistema de key?
    KeySettings = {
        Title = "Key System",
        Subtitle = "Insira sua key",
        Note = "Adquira sua key em nosso Discord",
        SaveKey = true,
        Key = {"1234", "5678"}                  -- Keys válidas
    }
})

📌 Organização de Abas
​🏠 Aba de Início (com executores e Discord)

local HomeTab = Window:CreateHomeTab({
    SupportedExecutors = {
        "Synapse X", "Krnl", "Fluxus", 
        "Script-Ware", "Delta", "Electron"
    },
    DiscordInvite = "seu_discord"  -- Sem o discord.gg/
})

📂 Criando Abas Normais

local MainTab = Window:CreateTab({Name = "Principal"})
local ConfigTab = Window:CreateTab({Name = "Configurações"})
local PlayerTab = Window:CreateTab({Name = "Jogador"})

🎮 Elementos da Interface
​1️⃣ Seções Expansíveis (Organização)

-- Criar uma seção
local Section = MainTab:CreateSection("FUNÇÕES BÁSICAS")

-- Adicionar elementos à seção
local btn = MainTab:CreateButton({...})
Section:AddElement(btn)

local toggle = MainTab:CreateToggle({...})
Section:AddElement(toggle)


2️⃣ Botão

MainTab:CreateButton({
    Name = "Meu Botão",
    Description = "Clique aqui para testar",
    Callback = function()
        print("Botão clicado!")
        -- Sua função aqui
    end
})

3️⃣ Toggle (Liga/Desliga)

MainTab:CreateToggle({
    Name = "Ativar Função",
    Description = "Liga/desliga a função",
    CurrentValue = false,  -- false = desligado, true = ligado
    Callback = function(state)
        if state then
            print("Função ativada!")
        else
            print("Função desativada!")
        end
    end
})


4️⃣ Input (Caixa de Texto)

MainTab:CreateInput({
    Name = "Digite seu nome",
    Description = "Campo de texto",
    PlaceholderText = "Escreva aqui...",
    Numeric = false,  -- true = só números, false = qualquer texto
    Callback = function(value)
        print("Você digitou:", value)
    end
})


5️⃣ Dropdown (Menu Suspenso)

MainTab:CreateDropdown({
    Name = "Escolha uma opção",
    Description = "Selecione uma das opções",
    Options = {"Opção 1", "Opção 2", "Opção 3", "Opção 4"},
    CurrentOption = "Opção 1",  -- Opção inicial
    Callback = function(option)
        print("Você escolheu:", option)
    end
})

6️⃣ Slider (Controle Deslizante)

MainTab:CreateSlider({
    Name = "Velocidade",
    Description = "Ajuste a velocidade",
    Range = {0, 100},        -- Valor mínimo e máximo
    Increment = 5,            -- Incremento a cada passo
    CurrentValue = 50,        -- Valor inicial
    Callback = function(value)
        print("Velocidade ajustada para:", value)
    end
})


7️⃣ Keybind (Tecla de Atalho)

MainTab:CreateKeybind({
    Name = "Tecla de Atalho",
    Description = "Pressione para ativar",
    CurrentBind = "G",         -- Tecla inicial
    HoldToInteract = false,    -- true = segurar, false = apertar
    Callback = function()
        print("Tecla pressionada!")
    end,
    OnChangedCallback = function(bind)
        print("Tecla alterada para:", bind.Name)
    end
})

8️⃣ Color Picker (Seletor de Cor)

MainTab:CreateColorPicker({
    Name = "Cor do Jogador",
    Description = "Escolha uma cor",
    Color = Color3.fromRGB(255, 0, 0),  -- Cor inicial
    Callback = function(color)
        print("Cor selecionada:", color)
        -- Aplique a cor onde quiser
    end
})

9️⃣ Label (Texto Informativo)

-- Label normal
MainTab:CreateLabel({
    Text = "Texto normal",
    Style = 1  -- 1: normal, 2: info, 3: aviso
})

-- Label de informação
MainTab:CreateLabel({
    Text = "Informação importante",
    Style = 2
})

-- Label de aviso
MainTab:CreateLabel({
    Text = "Cuidado!",
    Style = 3
})

🔟 Parágrafo (Texto Longo)

MainTab:CreateParagraph({
    Title = "Sobre o Script",
    Text = "Este é um texto longo que vai se ajustar automaticamente ao tamanho da caixa. Você pode colocar quantas linhas quiser que ele vai se adaptar perfeitamente ao espaço disponível."
})


1️⃣1️⃣ Divisor (Linha Separadora)

MainTab:CreateDivider()

📢 Sistema de Notificações

Libra:Notify(
    "Título",           -- Título da notificação
    "Descrição aqui",   -- Descrição
    3,                  -- Duração em segundos
    Window.Screen       -- Tela onde vai aparecer
)

🎨 Abas Fixas (Opcional)

-- Adiciona aba de temas (personalização de cores)
Window:BuildThemeSection()

-- Adiciona aba de configurações (modo compacto, auto carregar)
Window:BuildConfigSection()

⚙️ Configurações Avançadas
Sistema de Key

local Window = Libra:CreateWindow({
    -- ... outras configurações ...
    KeySystem = true,
    KeySettings = {
        Title = "Sistema de Key",
        Subtitle = "Insira sua key de acesso",
        Note = "Adquira sua key em nosso Discord",
        SaveKey = true,  -- Salva a key para não precisar digitar sempre
        Key = {"1234", "abcd", "minhakey"}  -- Lista de keys válidas
    }
})

Configurações de Pasta

ConfigSettings = {
    RootFolder = "MEU_HUB",        -- Pasta principal
    ConfigFolder = "Meu Script"     -- Subpasta para este script
}
-- As configurações serão salvas em: MEU_HUB/Meu Script/config.json

Posição do Botão OPEN MENU

OpenButtonPosition = {X = 350, Y = 30}  -- X = posição horizontal, Y = posição vertical
-- Valores maiores de Y = mais para baixo
-- Valores menores de Y = mais para cima


💡 Exemplo Completo para Teste
Aqui está um modelo pronto para copiar e executar:

-- Carregar a biblioteca
local Libra = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fu6rfho5zf/Meu_Projeto/refs/heads/main/HUB%20LIBRAYS%20UI.lua"))()

-- Criar janela
local Window = Libra:CreateWindow({
    Name = "Meu Super Script",
    Subtitle = "By: Dnxm200",
    OpenButtonName = "MENU",
    OpenButtonPosition = {X = 350, Y = 30},
    ConfigSettings = {
        RootFolder = "LIBRAYS HUB",
        ConfigFolder = "Meu Script"
    }
})

-- Criar home tab
local HomeTab = Window:CreateHomeTab({
    SupportedExecutors = {"Synapse X", "Krnl", "Fluxus", "Delta"},
    DiscordInvite = "meudiscord"
})

-- Criar aba principal
local MainTab = Window:CreateTab({Name = "Principal"})

-- Criar seção
local Section = MainTab:CreateSection("FUNÇÕES")

-- Adicionar botão
local btn = MainTab:CreateButton({
    Name = "Testar",
    Description = "Clique para testar",
    Callback = function()
        Libra:Notify("Teste", "Funcionou!", 2, Window.Screen)
    end
})
Section:AddElement(btn)

-- Adicionar toggle
local toggle = MainTab:CreateToggle({
    Name = "Ativar",
    Description = "Liga/Desliga",
    CurrentValue = false,
    Callback = function(state)
        print("Estado:", state)
    end
})
Section:AddElement(toggle)

-- Adicionar abas fixas
Window:BuildThemeSection()
Window:BuildConfigSection()

-- Notificação inicial
Libra:Notify("Bem-vindo", "Script carregado!", 3, Window.Screen)







