# Arquitetura v1

Este documento define a arquitetura v1 de `Signal Void`.

O objetivo desta versao e ser simples, clara e suficiente para montar o primeiro prototipo jogavel sem criar complexidade cedo demais.

## Objetivo da v1

A v1 existe para entregar o nucleo do jogo com o menor atrito possivel.

Escopo principal:

- boot do projeto
- room principal de gameplay
- nave do jogador
- inimigo basico
- projeteis
- colisao
- vida e destruicao

Tudo que nao for necessario para esse loop fica para depois.

## Principios

- manter a estrutura pequena
- evitar muitas pastas vazias
- evitar heranca profunda
- colocar logica reutilizavel em scripts
- usar objetos como integracao com eventos do GameMaker
- adiar sistemas avancados ate o gameplay basico funcionar

## Estrutura v1

```text
Signal Void/
  README.md
  ARCHITECTURE.md
  rooms/
    rm_boot/
    rm_game/
  objects/
    controllers/
      obj_boot
      obj_game_controller
    player/
      obj_player_ship
    enemies/
      obj_enemy_ship_basic
    projectiles/
      obj_projectile_player
    pickups/
  scripts/
    core/
    player/
    enemies/
    combat/
  sprites/
    player/
    enemies/
    environment/
    pickups/
  datafiles/
  notes/
```

## O que cada parte faz

### `rooms/`

#### `rm_boot`

Responsavel por:

- inicializar o jogo
- configurar variaveis globais
- preparar a transicao para `rm_game`

#### `rm_game`

Responsavel por:

- rodar o loop principal
- conter player, inimigos, projeteis e pickups
- servir como base do primeiro prototipo

### `objects/`

#### `controllers/`

Objetos que organizam o fluxo do jogo.

- `obj_boot`: inicializacao
- `obj_game_controller`: controle geral da partida

#### `player/`

- `obj_player_ship`: nave controlada pelo jogador

#### `enemies/`

- `obj_enemy_ship_basic`: primeiro inimigo funcional

#### `projectiles/`

- `obj_projectile_player`: projetil basico do jogador

#### `pickups/`

Pode ficar vazio no inicio.

So criaremos objetos aqui quando pickups entrarem no prototipo.

### `scripts/`

#### `core/`

Scripts compartilhados e utilitarios.

Exemplos:

- inicializacao
- estados globais
- funcoes comuns

#### `player/`

Scripts do jogador.

Exemplos:

- movimento
- tiro
- dano

#### `enemies/`

Scripts dos inimigos.

Exemplos:

- movimento basico
- perseguicao
- comportamento simples

#### `combat/`

Scripts de combate.

Exemplos:

- projeteis
- colisao
- aplicacao de dano

## Fluxo de runtime v1

O fluxo inicial deve ser este:

1. `rm_boot` inicia o projeto
2. `obj_boot` configura o necessario
3. o jogo entra em `rm_game`
4. `obj_game_controller` cria e acompanha o estado da partida
5. `obj_player_ship` e `obj_enemy_ship_basic` interagem
6. `obj_projectile_player` resolve o combate basico

## Modelo de objetos v1

Na v1, vamos evitar uma arvore de heranca grande.

Modelo recomendado:

```text
obj_boot
obj_game_controller
obj_player_ship
obj_enemy_ship_basic
obj_projectile_player
```

Se surgir reutilizacao real, ai sim criamos uma base simples:

```text
obj_actor
  obj_player_ship
  obj_enemy_ship_basic
```

Mas isso deve acontecer so quando ficar claramente util.

## Convencoes de nomes

### Rooms

- `rm_boot`
- `rm_game`

### Objetos

- `obj_boot`
- `obj_game_controller`
- `obj_player_ship`
- `obj_enemy_ship_basic`
- `obj_projectile_player`

### Sprites

Todos os sprites seguem:

- prefixo `spr_`
- `snake_case`
- nome descritivo

Exemplos:

- `spr_player_main_ship_base_damaged`
- `spr_enemy_klaed_battlecruiser_base`
- `spr_pickup_weapon_zapper`

### Scripts

Arquivos em `snake_case`.

Funcoes com prefixo do modulo:

- `player_move()`
- `player_fire()`
- `enemy_basic_update()`
- `combat_apply_damage()`

## Regras para nao complicar cedo

- nao criar `ui/`, `fx/`, `debug/`, `audio/` e `data/` separados antes de precisar
- nao criar mais de duas rooms na v1
- nao criar mais de um inimigo se um ainda nao estiver fechado
- nao externalizar tuning para `datafiles/` antes do gameplay funcionar
- nao montar menu principal antes do loop basico existir

## O que fica para depois

Esses itens pertencem a uma v2 ou posterior:

- `rm_frontend`
- `rm_test_arena`
- HUD completo
- sistema de ondas
- multiplas faccoes ativas ao mesmo tempo
- pickups com comportamento completo
- sistema de dados em `datafiles/`
- arquitetura maior por feature
- controllers extras
- debug tools

## Ordem de implementacao v1

1. criar `rm_boot`
2. criar `rm_game`
3. criar `obj_boot`
4. criar `obj_game_controller`
5. criar `obj_player_ship`
6. criar `obj_enemy_ship_basic`
7. criar `obj_projectile_player`
8. implementar movimento
9. implementar tiro
10. implementar colisao e dano
11. validar o loop basico

## Evolucao futura

Quando a v1 estiver estavel, ai sim a arquitetura pode crescer para algo maior, com:

- mais rooms
- mais controllers
- mais tipos de inimigo
- `scripts/data/`
- `scripts/ui/`
- `scripts/waves/`
- `objects/fx/`
- `objects/ui/`

A regra e simples:

primeiro fazer o jogo funcionar;
depois organizar para escalar.
