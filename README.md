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

O projeto ja saiu da fase puramente estrutural e entrou no primeiro prototipo jogavel.

- `rm_boot` e `rm_game` ja existem
- `obj_boot` e `obj_game_controller` ja controlam o fluxo inicial da partida
- `obj_player_ship`, `obj_enemy_ship_basic` e `obj_projectile_player` ja formam o loop basico de combate
- a nave do jogador ja possui movimento com inercia, rotacao por teclado, troca de motores e efeitos visuais de engine
- ja existe dano, perda de vida, destruicao basica e respawn simples de inimigo
- ainda faltam HUD de verdade, pickups, asteroides, progressao, faccoes completas e frontend

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

## Roadmap de desenvolvimento

O roadmap abaixo esta organizado por blocos de runtime e dependencias reais do projeto.

A ideia e fechar primeiro a base tecnica, depois a nave do jogador, depois combate, inimigos, mundo e progressao.

Cada fase prepara a proxima.

### Fase 0 - Base tecnica do runtime

Objetivo:

fechar a infraestrutura minima para o jogo iniciar, rodar e reiniciar sem improviso.

Entregas:

- `rm_boot` e `rm_game` estaveis
- `obj_boot` configurando estado global da sessao
- `obj_game_controller` controlando spawn, restart e acompanhamento da partida
- scripts utilitarios de bootstrap e spawn
- convencoes tecnicas fechadas para `objects/`, `scripts/` e `sprites/`
- documentacao basica alinhada com o estado real do projeto

### Fase 1 - Estrutura base da nave do jogador

Objetivo:

fechar `obj_player_ship` como o centro do gameplay.

Entregas:

- casco principal funcional com escala visual definida
- movimento com rotacao, inercia, aceleracao frontal e re limitada
- `movement_profile` separado por casco e motor
- troca de motores para testes e tuning
- draw em camadas para casco, motor e efeitos de engine
- pontos de extensao para armas, escudos e futuros upgrades

### Fase 2 - Combate basico do jogador

Objetivo:

fechar o pacote minimo de ataque do jogador antes de expandir inimigos e mundo.

Entregas:

- `obj_projectile_player` funcional
- disparo alinhado com a proa da nave
- cooldown de tiro e cadencia basica
- hit detection entre projetil e inimigo
- `combat_apply_damage` resolvendo dano e destruicao
- ciclo de vida da nave do jogador fechado para prototipo

### Fase 3 - Estrutura base dos inimigos

Objetivo:

fechar um inimigo jogavel de ponta a ponta antes de abrir variedade.

Entregas:

- `obj_enemy_ship_basic` com stats e comportamento simples
- perseguicao basica do jogador
- dano por contato ou por combate resolvido de forma clara
- destruicao e remocao corretas
- primeiro pipeline reutilizavel para futuros inimigos
- scripts isolando logica de AI e tuning

### Fase 4 - Loop principal de encounter

Objetivo:

transformar nave, tiro e inimigo em um loop repetivel de partida.

Entregas:

- regras de spawn e respawn de inimigos
- contagem de kills e estado simples de sessao
- reinicio de partida confiavel
- ritmo minimo de combate dentro de `rm_game`
- balanceamento inicial entre nave, inimigo e projetil
- base para arenas de teste e validacao rapida

### Fase 5 - Mundo e interacoes de gameplay

Objetivo:

adicionar elementos de cenario e recompensa ao redor do combate.

Entregas:

- asteroides como primeiros objetos de ambiente
- pickups basicos de motor, arma e escudo
- drops simples vindos de destruicao
- primeiros recursos coletaveis
- regras de colisao com elementos do cenario
- base para expansao de setores e exploracao

### Fase 6 - Progressao da nave do jogador

Objetivo:

dar persistencia e direcao ao crescimento do jogador.

Entregas:

- dinheiro e recursos de sessao
- sistema inicial de upgrades para motor, arma e escudo
- variacoes reais de loadout da nave
- tuning de custo, recompensa e progressao
- estrutura para dados persistentes da campanha
- preparacao para inventario e economia simples

### Fase 7 - Identidade das faccoes e conteudo inimigo

Objetivo:

fazer o universo comecar a ter personalidade real em combate.

Entregas:

- um inimigo representativo de cada faccao
- projeteis e comportamento distintos por faccao
- naves medias e pesadas
- primeiras regras de dominacao de setor
- diferencas reais de risco e recompensa entre encontros
- base para mini chefes e patrulhas especializadas

### Fase 8 - Frontend, UX e estrutura jogavel completa

Objetivo:

amarrar o prototipo em um jogo navegavel e apresentavel.

Entregas:

- `rm_frontend` e fluxo de entrada no jogo
- HUD jogavel de verdade
- telas de status, game over e retorno
- selecao basica de setor ou arena
- salvamento inicial
- organizacao geral para build de teste externa

### Fase 9 - Polimento e demo

Objetivo:

preparar uma versao pequena, estavel e com identidade suficiente para ser mostrada.

Entregas:

- efeitos visuais e sonoros coerentes
- melhor leitura visual de combate
- ajustes finos de controles e balanceamento
- limpeza tecnica de scripts e objetos
- build exportada
- demo curta, estavel e testavel

## Foco atual

O foco imediato do projeto e consolidar as fases iniciais que sustentam o resto do roadmap.

Prioridades:

- fechar bem `obj_player_ship` como base de movimentacao, combate e visual
- estabilizar `obj_projectile_player` e o fluxo de dano
- consolidar `obj_enemy_ship_basic` como primeiro inimigo valido
- manter `obj_game_controller` simples, mas confiavel para spawn e restart
- evitar abrir pickups, economia e multiplas faccoes antes do loop principal ficar solido

## Tecnologia

Desenvolvido em GameMaker.

IDE atual do projeto:

- GameMaker 2024.14.3.217

## Visao de longo prazo

Signal Void foi planejado como um projeto espacial escalavel:

comecando com combate arcade e progressao simples, evoluindo futuramente para sistemas maiores de economia, influencia e controle de rotas espaciais.
