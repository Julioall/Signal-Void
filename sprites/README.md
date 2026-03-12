# Estrutura de Sprites

Todos os arquivos de imagem em `sprites/` seguem o padrão do GameMaker Studio:

- todo sprite começa com `spr_`
- nomes em `snake_case`
- nomes descritivos com categoria, origem e função visual

Exemplos:

- `spr_player_main_ship_base_damaged.png`
- `spr_enemy_klaed_battlecruiser_base.png`
- `spr_pickup_weapon_zapper.png`

## Estrutura atual

```text
sprites/
  player/
    main_ship/
      base/
      engines/
      engine_effects/
      projectiles/
      shields/
      weapons/
  enemies/
    klaed/
      base/
      destruction/
      engines/
      projectiles/
      shields/
      weapons/
    nairan/
      base/
      destruction/
      engines/
      projectiles/
      shields/
      weapons/
    nautolan/
      base/
      destruction/
      engines/
      projectiles/
      shields/
      weapons/
  environment/
    asteroids/
    backgrounds/
      condensed/
      split_up/
    effects/
    planets/
  pickups/
    engines/
    shield_generators/
    weapons/
```

## Regras de organização

- `player/`: sprites do jogador principal
- `enemies/`: sprites de facções e naves inimigas
- `environment/`: elementos de cenário e ambientação
- `pickups/`: ícones e sprites de coletáveis

## Limpeza aplicada

- removidos arquivos-fonte do Aseprite
- removidas pastas e arquivos de preview
- removidas versões `spritesheet` quando já existiam versões separadas
