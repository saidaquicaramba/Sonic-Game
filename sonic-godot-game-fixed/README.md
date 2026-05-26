# 🎮 Sonic Godot Game - Base Project

## 📋 Descrição
Projeto base para um jogo estilo Sonic em Godot 4.5 com:
- ✅ Personagem controlável por **WASD** + **ESPAÇO** para pulo
- ✅ **5 Fases** diferentes com variações de plataformas
- ✅ Sistema de **camadas de colisão** bem organizado
- ✅ Inimigos com comportamento de patrulha
- ✅ Blocos coloridos para facilitar identificação de elementos
- ✅ **Transição automática de fases** ao chegar ao final

---

## 🎮 Controles

| Tecla | Ação |
|-------|------|
| **A** | Mover para Esquerda |
| **D** | Mover para Direita |
| **W** | Mover para Cima (em desenvolvimento) |
| **S** | Mover para Baixo (em desenvolvimento) |
| **ESPAÇO** | Pular |

---

## 🏗️ Estrutura de Camadas (Layers)

### Camadas de Física:
| Layer | Nome | Descrição |
|-------|------|----------|
| 1 | **Player** | Personagem jogável (AZUL) |
| 2 | **Platform** | Plataformas e cenário (VERDE) |
| 3 | **Enemy** | Inimigos patrulhadores (VERMELHO) |
| 4 | **Hitbox** | Área de ataque do jogador |
| 5 | **Hurtbox** | Área de dano (recebe) |
| 6 | **Collectible** | Itens colecionáveis |

### Interações de Colisão:
```
Player (Layer 1) → Colide com:
  - Platform (Layer 2)
  - Enemy (Layer 3)

Platform (Layer 2) → Colide com:
  - Player (Layer 1)

Enemy (Layer 3) → Colide com:
  - Platform (Layer 2)
  - Player (Layer 1)
```

---

## 📂 Estrutura de Pastas

```
sonic-godot-game/
├── project.godot              # Configuração do projeto
├── README.md                  # Este arquivo
├── scripts/
│   ├── constants/
│   │   └── Layers.gd         # Constantes de camadas
│   ├── globals/
│   │   └── GameManager.gd    # Gerenciador do jogo
│   ├── player/
│   │   └── Player.gd         # Script do personagem
│   ├── enemies/
│   │   └── Enemy.gd          # Script do inimigo
│   ├── platforms/
│   │   └── Platform.gd       # Script da plataforma
│   └── levels/
│       └── LevelFinish.gd    # Script de término de fase
└── scenes/
    ├── player/
    │   └── Player.tscn       # Cena do personagem (AZUL)
    ├── enemies/
    │   └── Enemy.tscn        # Cena do inimigo (VERMELHO)
    ├── platforms/
    │   └── Platform.tscn     # Cena da plataforma (VERDE)
    └── levels/
        ├── LevelFinish.tscn  # Cena de término de fase (AMARELO)
        ├── Level1.tscn       # Fase 1 - Iniciante
        ├── Level2.tscn       # Fase 2 - Intermediária
        ├── Level3.tscn       # Fase 3 - Desafiadora
        ├── Level4.tscn       # Fase 4 - Muito Difícil
        └── Level5.tscn       # Fase 5 - Final
```

---

## 🎨 Cores dos Elementos

| Elemento | Cor | RGB |
|----------|-----|-----|
| **Player** | Azul Claro | (0.3, 0.6, 0.9) |
| **Platform** | Verde | (0.3, 0.9, 0.3) |
| **Enemy** | Vermelho | (1.0, 0.3, 0.3) |
| **LevelFinish** | Amarelo | (1.0, 0.84, 0.0) |

---

## 🚀 Como Usar

### 1. **Abrir o Projeto**
   - Abra o Godot 4.5
   - Clique em "Abrir Projeto"
   - Selecione a pasta `sonic-godot-game`

### 2. **Executar o Jogo**
   - Pressione **F5** ou clique em "Play"
   - Use **WASD** para se mover
   - Pressione **ESPAÇO** para pular

### 3. **Transitando entre Fases**
   - Chegue ao **bloco amarelo** (LevelFinish) no final da fase
   - O jogo automaticamente carregará a próxima fase
   - Após a Fase 5, volta para a Fase 1

### 4. **Alterar Fase Principal**
   - Abra `project.godot`
   - Na seção `[application]`, mude `run/main_scene` para a fase desejada

---

## 📝 Próximas Etapas

- [ ] Adicionar sprites e texturas aos elementos
- [ ] Implementar sistema de vidas/dano
- [ ] Adicionar sons e música
- [ ] Criar sistema de power-ups
- [ ] Implementar boss na fase 5
- [ ] Adicionar animações do personagem
- [ ] Sistema de pontuação
- [ ] Tela de menu principal

---

## 🔧 Personalização

### Alterar Velocidade do Personagem
Abra `scripts/player/Player.gd`:
```gdscript
@export var speed = 200.0        # Aumentar para mais rápido
@export var jump_force = -400.0  # Valores negativos = mais alto
```

### Alterar Dificuldade dos Inimigos
Abra `scripts/enemies/Enemy.gd`:
```gdscript
@export var speed = 100.0            # Velocidade da patrulha
@export var patrol_distance = 200.0  # Distância de movimentação
```

---

## 🛠️ Versão do Godot
- **Godot Engine**: 4.5
- **Linguagem**: GDScript
- **Tipo de Projeto**: 2D Platform

---

## 📞 Suporte

Para mais informações sobre Godot, visite:
- [Documentação Oficial Godot](https://docs.godotengine.org)
- [Godot Community](https://godotengine.org/community)

---

**Divirta-se desenvolvendo seu jogo Sonic! 🎮✨**
