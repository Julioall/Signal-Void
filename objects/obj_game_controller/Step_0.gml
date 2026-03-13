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

if (keyboard_check_pressed(ord("0"))) {
    global.enemy_attack_enabled = !global.enemy_attack_enabled;
}

if (keyboard_check_pressed(ord("9"))) {
    global.enemy_invulnerable = !global.enemy_invulnerable;
}

if (!instance_exists(obj_enemy_ship)) {
    enemy_respawn_timer = max(0, enemy_respawn_timer - 1);

    if (enemy_respawn_timer <= 0) {
        game_spawn_enemy();
        enemy_respawn_timer = room_speed;
    }
} else {
    enemy_respawn_timer = room_speed;
}

var caption = "Signal Void | Fase 1";
var active_enemy = instance_find(obj_enemy_ship, 0);

if (instance_exists(player_id)) {
    caption += " | HP " + string(player_id.hp) + "/" + string(player_id.max_hp);
    caption += " | Escudo " + string_format(player_id.shield_hp, 1, 1) + "/" + string_format(player_id.shield_profile.max_hp, 1, 1);
    caption += " | Arma " + string(player_id.weapon_profile.display_name);
    if (player_id.weapon_id == "zapper" && player_id.weapon_beam_active) {
        caption += " (laser ativo)";
    } else if (player_id.weapon_charge_timer > 0 || (player_id.weapon_id == "big_space_gun" && !player_id.weapon_ready)) {
        caption += " (carregando)";
    }
    caption += " | Motor " + string(player_id.engine_id);
    caption += " | Vel " + string_format(player_id.current_speed, 1, 2);
} else {
    caption += " | Reiniciando";
}

if (instance_exists(active_enemy) && is_struct(active_enemy.enemy_profile)) {
    var roster_count = array_length(enemy_get_roster());

    caption += " | Alvo " + string(active_enemy.enemy_profile.display_name);
    caption += " | HP alvo " + string(active_enemy.hp) + "/" + string(active_enemy.max_hp);

    if (roster_count > 0 && global.enemy_last_spawned_index >= 0) {
        caption += " | Roster " + string(global.enemy_last_spawned_index + 1) + "/" + string(roster_count);
    }
}

caption += " | Contato " + (global.enemy_attack_enabled ? "Ativo" : "Parado");
caption += " | Imortal " + (global.enemy_invulnerable ? "Sim" : "Nao");
caption += " | Kills " + string(global.session_kills);
caption += " | Mouse mira | W/S acelera | 1-4 motor | 0 contato | 9 imortal | Q/E arma | R/T escudo";
window_set_caption(caption);
