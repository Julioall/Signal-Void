function game_bootstrap() {
    randomize();
    global.session_kills = 0;
    global.restart_cooldown = -1;
    global.enemy_attack_enabled = false;
    global.enemy_invulnerable = true;
    global.enemy_showcase_mode = true;
    global.enemy_roster_index = 0;
    global.enemy_last_spawned_id = "";
    global.enemy_last_spawned_index = -1;
}

function game_reset_room_state() {
    global.restart_cooldown = -1;
    global.enemy_attack_enabled = false;
    global.enemy_invulnerable = true;
    global.enemy_showcase_mode = true;
    global.enemy_roster_index = 0;
    global.enemy_last_spawned_id = "";
    global.enemy_last_spawned_index = -1;
}
