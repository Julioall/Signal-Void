if (!instance_exists(player_id)) {
    if (restart_cooldown < 0) {
        restart_cooldown = room_speed;
    }

    restart_cooldown = max(0, restart_cooldown - 1);

    if (restart_cooldown <= 0) {
        room_restart();
    }
} else {
    restart_cooldown = -1;
}

if (!instance_exists(obj_enemy_ship_basic)) {
    enemy_respawn_timer = max(0, enemy_respawn_timer - 1);

    if (enemy_respawn_timer <= 0) {
        game_spawn_enemy();
        enemy_respawn_timer = room_speed;
    }
} else {
    enemy_respawn_timer = room_speed;
}

var caption = "Signal Void | Fase 1";

if (instance_exists(player_id)) {
    caption += " | HP " + string(player_id.hp) + "/" + string(player_id.max_hp);
    caption += " | Motor " + string(player_id.engine_id);
    caption += " | Vel " + string_format(player_id.current_speed, 1, 2);
} else {
    caption += " | Reiniciando";
}

caption += " | Kills " + string(global.session_kills);
caption += " | 1-4 trocam motor";
window_set_caption(caption);
