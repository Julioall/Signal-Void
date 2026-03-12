# Signal Void

Signal Void e um jogo espacial 2D em visao superior focado em combate, coleta de recursos, progressao e sobrevivencia em um universo dominado por faccoes rivais.

## Visao geral

O jogador assume o papel de um contrabandista independente que opera entre rotas patrulhadas, zonas de conflito e setores disputados por diferentes nacoes espaciais.

Ao longo do jogo, o objetivo e acumular recursos, melhorar a nave, sobreviver a patrulhas hostis e expandir sua influencia em regioes cada vez mais perigosas do espaco.

## Conceito principal

O universo e controlado por tres grandes faccoes interestelares, cada uma com sua propria presenca militar, economia e dominio territorial.

O jogador nao pertence a nenhuma delas.

Sua sobrevivencia depende de:

- explorar setores hostis
- enfrentar patrulhas inimigas
- coletar recursos
- adquirir upgrades
- lucrar com oportunidades entre conflitos

No futuro, o jogador podera lucrar tanto ajudando quanto atrapalhando operacoes dessas faccoes.

## Faccoes

### Klaed

Faccao militar, agressiva e focada em forca bruta.

### Nairan

Faccao tecnologica, especializada em energia e precisao.

### Nautolan

Faccao expansiva, adaptativa e numerosa.

Cada faccao utiliza tipos proprios de nave, projeteis e comportamento de combate.

## Progressao do jogador

O jogador utiliza uma unica nave principal, que evolui por meio de melhorias em sistemas internos.

Sistemas de upgrade previstos:

- motor
- escudo
- armas
- radar
- capacidade de carga

A estrutura principal da nave permanece fixa.

## Recursos do jogo

Recursos principais previstos:

- minerio espacial
- sucata tecnologica
- energia

Esses recursos serao obtidos atraves de:

- asteroides
- destruicao de inimigos
- exploracao de setores

## Estado atual do projeto

Neste momento, o projeto ainda esta no inicio.

- existe apenas uma room principal: `Game`
- os sprites ja foram organizados por dominio em `sprites/`
- a arquitetura tecnica foi definida em `ARCHITECTURE.md`
- o runtime principal ainda nao foi implementado
- ainda nao existem `objects/`, `scripts/`, `sounds/` e `ui` de gameplay no projeto

## Estrutura visual atual

O projeto utiliza como base principal os assets Void de Foozle.

Estrutura atual de sprites:

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

## Convencao de nomes

Todos os arquivos de sprite seguem o padrao do GameMaker:

- prefixo `spr_`
- nomes em `snake_case`
- nomes descritivos por dominio e funcao

Exemplos:

- `spr_player_main_ship_base_damaged`
- `spr_enemy_klaed_battlecruiser_base`
- `spr_pickup_weapon_zapper`

## Arquitetura

A arquitetura alvo do projeto esta documentada em `ARCHITECTURE.md`.

Principios centrais:

- separar conteudo de runtime
- manter a logica principal em scripts e funcoes
- usar objetos como pontos de integracao do GameMaker
- manter tuning de gameplay fora de numeros magicos espalhados
- evoluir para um fluxo de rooms com `rm_boot`, `rm_frontend`, `rm_game` e `rm_test_arena`

## Roadmap planejado

As fases abaixo descrevem o planejamento do projeto. Elas nao representam features ja implementadas.

### Fase 0 - Pre-producao

Definicao da base do projeto.

Entregas:

- conceito principal
- faccoes definidas
- estrutura de sprites organizada
- convencoes de nomes
- documentacao inicial

### Fase 1 - Prototipo jogavel basico

Primeira versao funcional do nucleo do jogo.

Entregas:

- movimentacao da nave
- tiro principal
- inimigo basico
- colisao
- sistema de vida
- destruicao basica

### Fase 2 - Vertical slice de combate

Primeira versao pequena representando a experiencia real do jogo.

Entregas:

- nave com camadas visuais
- efeitos de motor
- pickups basicos
- um inimigo por faccao
- asteroides no cenario
- HUD inicial

### Fase 3 - Progressao inicial

Sistema de crescimento do jogador.

Entregas:

- dinheiro
- recursos
- upgrades basicos
- drops
- dificuldade crescente

### Fase 4 - Identidade das faccoes

Cada faccao passa a ter comportamento distinto.

Entregas:

- diferencas reais de combate
- projeteis diferentes
- naves medias e pesadas
- setores dominados por faccoes

### Fase 5 - Estrutura jogavel completa

Transformar o prototipo em jogo organizado.

Entregas:

- selecao de setores
- fluxo de progressao
- mini chefes
- salvamento basico

### Fase 6 - Economia e influencia

Primeiros sistemas de interacao economica com faccoes.

Entregas:

- contratos
- lucro por sabotagem ou ajuda
- reputacao simples
- rotas economicas

### Fase 7 - Polimento

Refinamento visual e tecnico.

Entregas:

- efeitos visuais
- sons
- menus
- balanceamento

### Fase 8 - Demo jogavel

Primeira versao publica.

Entregas:

- build exportada
- setores jogaveis
- progressao inicial completa
- versao estavel

## Foco atual

O foco imediato do projeto e montar o esqueleto de runtime e comecar o prototipo jogavel.

Prioridades:

- `rm_boot`
- `obj_boot`
- `obj_game_controller`
- `obj_player_ship`
- movimentacao
- combate
- inimigos
- colisao

## Tecnologia

Desenvolvido em GameMaker.

IDE atual do projeto:

- GameMaker 2024.14.3.217

## Visao de longo prazo

Signal Void foi planejado como um projeto espacial escalavel:

comecando com combate arcade e progressao simples, evoluindo futuramente para sistemas maiores de economia, influencia e controle de rotas espaciais.
