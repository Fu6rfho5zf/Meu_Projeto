# 📘 LIBRAYS UI: Guia Definitivo para Criação de Interfaces Modernas

Este guia abrangente explora a **LIBRAYS UI**, uma biblioteca poderosa e flexível projetada para facilitar a criação de interfaces de usuário (UI) modernas e funcionais para seus scripts. Com a LIBRAYS UI, desenvolvedores podem construir UIs intuitivas e visualmente atraentes com facilidade, integrando diversos elementos interativos e funcionalidades avançadas.

## ✨ Recursos Principais

*   **Criação de Janelas Personalizáveis**: Defina títulos, subtítulos, logos e botões de abertura.
*   **Sistema de Abas Flexível**: Organize seu conteúdo em abas de início, abas normais e abas fixas (temas e configurações).
*   **Componentes de UI Ricos**: Inclui botões, toggles, campos de entrada, dropdowns, sliders, keybinds, seletores de cor, labels e parágrafos.
*   **Sistema de Notificações Integrado**: Mantenha o usuário informado com notificações personalizáveis.
*   **Sistema de Chaves (Key System)**: Proteja seu script com um sistema de autenticação configurável.
*   **Configurações Persistentes**: Salve e carregue configurações de forma organizada em pastas dedicadas.

## ⚡ Instalação Rápida

Para começar a usar a LIBRAYS UI em seu projeto, basta carregar a biblioteca utilizando o seguinte código:

```lua
local Libra = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fu6rfho5zf/LIBRAYS-HUB/refs/heads/main/HUB%20LIBRAYS%20UI.lua"))()
```

## 🚀 Guia de Uso

### 1. Criando sua Primeira Janela

A janela é o contêiner principal para todos os elementos da sua UI. Configure-a com as opções desejadas:

```lua
local Window = Libra:CreateWindow({
    Name = "Meu Script",                    -- Título da janela
    Subtitle = "By: SeuNome",                -- Subtítulo
    LogoID = "123456789",                     -- ID da imagem (opcional) - Substitua pelo ID real da sua imagem
    OpenButtonName = "MENU",                   -- Nome do botão flutuante para abrir/fechar a UI
    OpenButtonPosition = {X = 350, Y = 30},    -- Posição inicial do botão flutuante {X, Y}
    
    ConfigSettings = {
        RootFolder = "LIBRAYS HUB",            -- Pasta principal para salvar configurações
        ConfigFolder = "Meu Script"            -- Subpasta específica para as configurações deste script
    },
    
    KeySystem = false,                          -- Ativar sistema de key? (true/false)
    KeySettings = {                             -- Configurações do sistema de key (apenas se KeySystem for true)
        Title = "Key System",
        Subtitle = "Insira sua key",
        Note = "Adquira sua key em nosso Discord",
        SaveKey = true,
        Key = {"1234", "5678"}                  -- Lista de keys válidas
    }
})
```

### 2. Organização de Abas

A LIBRAYS UI permite organizar o conteúdo em diferentes abas para uma melhor experiência do usuário.

#### Aba de Início (HomeTab)

Ideal para exibir informações gerais, executores suportados e links para o Discord.

```lua
local HomeTab = Window:CreateHomeTab({
    SupportedExecutors = {
        "Synapse X", "Krnl", "Fluxus", 
        "Script-Ware", "Delta", "Electron"
    },
    DiscordInvite = "seu_discord"  -- Apenas o código do convite, sem o discord.gg/
})
```

#### Criando Abas Normais

Crie abas personalizadas para categorizar suas funcionalidades.

```lua
local MainTab = Window:CreateTab({Name = "Principal"})
local ConfigTab = Window:CreateTab({Name = "Configurações"})
local PlayerTab = Window:CreateTab({Name = "Jogador"})
```

### 3. Elementos da Interface (UI Elements)

Adicione interatividade à sua UI com uma variedade de elementos.

#### 1. Seções Expansíveis

Organize seus elementos em seções colapsáveis para manter a UI limpa e organizada.

```lua
-- Criar uma seção dentro de uma aba (ex: MainTab)
local Section = MainTab:CreateSection("FUNÇÕES BÁSICAS")

-- Adicionar elementos à seção
local btn = MainTab:CreateButton({Name = "Meu Botão", Description = "Clique aqui"})
Section:AddElement(btn)

local toggle = MainTab:CreateToggle({Name = "Ativar", CurrentValue = false})
Section:AddElement(toggle)
```

#### 2. Botão (Button)

Um botão simples para executar ações.

```lua
MainTab:CreateButton({
    Name = "Meu Botão",
    Description = "Clique aqui para testar a funcionalidade",
    Callback = function()
        print("Botão clicado!")
        -- Sua função personalizada aqui
    end
})
```

#### 3. Toggle (Liga/Desliga)

Um interruptor para ativar ou desativar funcionalidades.

```lua
MainTab:CreateToggle({
    Name = "Ativar Função",
    Description = "Liga/desliga uma funcionalidade específica",
    CurrentValue = false,  -- Estado inicial: false = desligado, true = ligado
    Callback = function(state)
        if state then
            print("Função ativada!")
        else
            print("Função desativada!")
        end
        -- Lógica a ser executada quando o estado muda
    end
})
```

#### 4. Input (Caixa de Texto)

Campo para entrada de texto ou números pelo usuário.

```lua
MainTab:CreateInput({
    Name = "Digite seu nome",
    Description = "Campo de texto para inserir informações",
    PlaceholderText = "Escreva aqui...",
    Numeric = false,  -- true = aceita apenas números, false = aceita qualquer texto
    Callback = function(value)
        print("Você digitou:", value)
        -- Lógica para processar o valor inserido
    end
})
```

#### 5. Dropdown (Menu Suspenso)

Permite ao usuário selecionar uma opção de uma lista predefinida.

```lua
MainTab:CreateDropdown({
    Name = "Escolha uma opção",
    Description = "Selecione uma das opções disponíveis",
    Options = {"Opção 1", "Opção 2", "Opção 3", "Opção 4"},
    CurrentOption = "Opção 1",  -- Opção selecionada inicialmente
    Callback = function(option)
        print("Você escolheu:", option)
        -- Lógica para lidar com a opção selecionada
    end
})
```

#### 6. Slider (Controle Deslizante)

Um controle deslizante para ajustar valores numéricos dentro de um intervalo.

```lua
MainTab:CreateSlider({
    Name = "Velocidade",
    Description = "Ajuste a velocidade de um parâmetro",
    Range = {0, 100},        -- Valor mínimo e máximo do slider
    Increment = 5,            -- Incremento a cada passo do deslizamento
    CurrentValue = 50,        -- Valor inicial do slider
    Callback = function(value)
        print("Velocidade ajustada para:", value)
        -- Lógica para usar o valor ajustado
    end
})
```

#### 7. Keybind (Tecla de Atalho)

Permite ao usuário definir uma tecla de atalho para executar uma ação.

```lua
MainTab:CreateKeybind({
    Name = "Tecla de Atalho",
    Description = "Pressione a tecla para ativar uma função",
    CurrentBind = "G",         -- Tecla inicial predefinida
    HoldToInteract = false,    -- true = segurar a tecla, false = apenas pressionar
    Callback = function()
        print("Tecla pressionada!")
        -- Ação a ser executada quando a tecla é pressionada
    end,
    OnChangedCallback = function(bind)
        print("Tecla alterada para:", bind.Name)
        -- Lógica a ser executada quando a tecla de atalho é alterada
    end
})
```

#### 8. Color Picker (Seletor de Cor)

Um seletor de cor para escolher e aplicar cores.

```lua
MainTab:CreateColorPicker({
    Name = "Cor do Jogador",
    Description = "Escolha uma cor para o jogador ou elemento",
    Color = Color3.fromRGB(255, 0, 0),  -- Cor inicial (vermelho)
    Callback = function(color)
        print("Cor selecionada:", color)
        -- Aplique a cor onde for necessário no seu script
    end
})
```

#### 9. Label (Texto Informativo)

Exibe texto estático com diferentes estilos para informações, avisos ou alertas.

```lua
-- Label normal
MainTab:CreateLabel({
    Text = "Texto informativo normal",
    Style = 1  -- 1: normal, 2: informação, 3: aviso
})

-- Label de informação
MainTab:CreateLabel({
    Text = "Informação importante para o usuário",
    Style = 2
})

-- Label de aviso
MainTab:CreateLabel({
    Text = "Cuidado! Esta é uma ação irreversível.",
    Style = 3
})
```

#### 10. Parágrafo (Texto Longo)

Para exibir blocos de texto mais longos que se ajustam automaticamente.

```lua
MainTab:CreateParagraph({
    Title = "Sobre o Script",
    Text = "Este é um texto longo que se ajustará automaticamente ao tamanho da caixa. Você pode adicionar quantas linhas desejar, e ele se adaptará perfeitamente ao espaço disponível para fornecer informações detalhadas."
})
```

#### 11. Divisor (Linha Separadora)

Uma linha horizontal para separar visualmente os elementos da UI.

```lua
MainTab:CreateDivider()
```

### 4. Sistema de Notificações

Envie notificações personalizadas para o usuário.

```lua
Libra:Notify(
    "Título da Notificação",           -- Título breve da notificação
    "Descrição detalhada da mensagem aqui",   -- Conteúdo da notificação
    3,                  -- Duração em segundos que a notificação ficará visível
    Window.Screen       -- A tela onde a notificação será exibida
)
```

### 5. Abas Fixas (Opcional)

Adicione abas pré-construídas para temas e configurações gerais.

```lua
-- Adiciona uma aba de temas para personalização de cores da UI
Window:BuildThemeSection()

-- Adiciona uma aba de configurações gerais (ex: modo compacto, auto carregar)
Window:BuildConfigSection()
```

## ⚙️ Configurações Avançadas

Detalhes sobre as opções de configuração da janela.

### Sistema de Key

Ative e configure o sistema de chaves para restringir o acesso ao seu script.

```lua
local Window = Libra:CreateWindow({
    -- ... outras configurações ...
    KeySystem = true,  -- Ativa o sistema de chaves
    KeySettings = {
        Title = "Sistema de Key",
        Subtitle = "Insira sua key de acesso",
        Note = "Adquira sua key em nosso Discord",
        SaveKey = true,  -- Se true, a key será salva para futuras sessões
        Key = {"1234", "abcd", "minhakey"}  -- Lista de chaves válidas
    }
})
```

### Configurações de Pasta

Defina onde as configurações do seu script serão salvas.

```lua
ConfigSettings = {
    RootFolder = "MEU_HUB",        -- Pasta principal onde todas as configurações serão armazenadas
    ConfigFolder = "Meu Script"     -- Subpasta específica para as configurações deste script
}
-- Exemplo: As configurações serão salvas em: MEU_HUB/Meu Script/config.json
```

### Posição do Botão OPEN MENU

Personalize a posição do botão flutuante que abre e fecha a UI.

```lua
OpenButtonPosition = {X = 350, Y = 30}  -- X = posição horizontal, Y = posição vertical
-- Valores maiores de Y movem o botão para baixo.
-- Valores menores de Y movem o botão para cima.
-- Valores maiores de X movem o botão para a direita.
-- Valores menores de X movem o botão para a esquerda.
```

## 💡 Exemplo Completo para Teste

Este é um exemplo completo e funcional que demonstra a criação de uma janela, abas, seções e alguns elementos de UI, incluindo um sistema de notificação.

```lua
-- Carregar a biblioteca LIBRAYS UI
local Libra = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fu6rfho5zf/LIBRAYS-HUB/refs/heads/main/HUB%20LIBRAYS%20UI.lua"))()

-- Criar a janela principal da UI
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

-- Criar a aba de início (HomeTab)
local HomeTab = Window:CreateHomeTab({
    SupportedExecutors = {"Synapse X", "Krnl", "Fluxus", "Delta"},
    DiscordInvite = "meudiscord" -- Substitua pelo seu código de convite do Discord
})

-- Criar uma aba principal para funcionalidades
local MainTab = Window:CreateTab({Name = "Principal"})

-- Criar uma seção expansível dentro da aba principal
local Section = MainTab:CreateSection("FUNÇÕES")

-- Adicionar um botão à seção
local btn = MainTab:CreateButton({
    Name = "Testar Notificação",
    Description = "Clique para testar o sistema de notificações",
    Callback = function()
        Libra:Notify("Teste", "Funcionou! Notificação exibida.", 2, Window.Screen)
    end
})
Section:AddElement(btn)

-- Adicionar um toggle à seção
local toggle = MainTab:CreateToggle({
    Name = "Ativar Recurso",
    Description = "Liga/Desliga um recurso específico",
    CurrentValue = false,
    Callback = function(state)
        print("Estado do recurso:\n", state)
    end
})
Section:AddElement(toggle)

-- Adicionar abas fixas para temas e configurações
Window:BuildThemeSection()
Window:BuildConfigSection()

-- Exibir uma notificação inicial quando o script é carregado
Libra:Notify("Bem-vindo", "Script carregado com sucesso!", 3, Window.Screen)
```

---

**Desenvolvido por @zx.danielz.01**
