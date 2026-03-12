# Player Movement v1

## Objetivo

Organizar a movimentacao da nave do jogador de um jeito que suporte evolucao de casco e motor sem espalhar numeros magicos pelo projeto.

## Estrutura

- `spr_player_ship`
  - casco base da nave
- `spr_player_ship_engine_base`
  - motor padrao
- `spr_player_ship_engine_big_pulse`
  - motor focado em velocidade final
- `spr_player_ship_engine_burst`
  - motor focado em aceleracao e resposta
- `spr_player_ship_engine_supercharged`
  - motor focado em velocidade alta com mais inercia

## Regras de montagem visual

- o casco continua sendo o `spriteId` do `obj_player_ship`
- o motor e desenhado como camada separada por `player_ship_draw()`
- offsets do motor ficam dentro do `movement_profile`
- efeitos de motor entram depois, usando:
  - `engine_fx_idle_sprite`
  - `engine_fx_powering_sprite`

## Regras de gameplay

- `hull_id` define o comportamento base da nave
- `engine_id` modifica aceleracao, frenagem, arrasto e velocidade maxima
- a movimentacao usa velocidade acumulada, nao deslocamento fixo por frame
- a rotacao da nave usa teclado apenas
- a aceleracao frontal e mais forte do que a re
- o tiro sai e viaja na direcao atual da nave

## Scripts principais

- `player_movement_build_profile`
- `player_movement_get_input`
- `player_movement_apply`
- `player_ship_draw`

## Estado atual

Na Fase 1, a nave inicia com:

- `hull_id = "main_ship"`
- `engine_id = "base"`
- `visual_scale = 2`

Para teste rapido na Fase 1:

- `1` troca para `base`
- `2` troca para `big_pulse`
- `3` troca para `burst`
- `4` troca para `supercharged`
- `A`/`D` ou setas esquerda/direita giram a nave
- `W`/`S` ou setas cima/baixo aceleram para frente e para tras
- `Espaco` ou `Z` atira
