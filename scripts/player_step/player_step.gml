function player_step() {
    var weapon_switch_locked = player_weapon_fire_is_locked();

    if (keyboard_check_pressed(ord("1"))) {
        player_movement_set_engine("base");
    }

    if (keyboard_check_pressed(ord("2"))) {
        player_movement_set_engine("big_pulse");
    }

    if (keyboard_check_pressed(ord("3"))) {
        player_movement_set_engine("burst");
    }

    if (keyboard_check_pressed(ord("4"))) {
        player_movement_set_engine("supercharged");
    }

    if (!weapon_switch_locked && keyboard_check_pressed(ord("Q"))) {
        player_set_weapon(player_cycle_option(weapon_id, weapon_ids, -1));
    }

    if (!weapon_switch_locked && keyboard_check_pressed(ord("E"))) {
        player_set_weapon(player_cycle_option(weapon_id, weapon_ids, 1));
    }

    if (keyboard_check_pressed(ord("R"))) {
        player_set_shield(player_cycle_option(shield_id, shield_ids, -1));
    }

    if (keyboard_check_pressed(ord("T"))) {
        player_set_shield(player_cycle_option(shield_id, shield_ids, 1));
    }

    var move_input = player_movement_get_input();
    player_movement_apply(move_input);

    fire_cooldown = max(0, fire_cooldown - 1);
    player_update_loadout_state();

    var weapon_fire_locked = player_weapon_fire_is_locked();
    var weapon_ready_to_fire = player_weapon_is_ready_to_fire();

    var fire_requested = keyboard_check(vk_space) || keyboard_check(ord("Z"));
    var fire_pressed = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));
    var fire_triggered = fire_requested;

    if (weapon_profile.fire_on_press_only) {
        fire_triggered = fire_pressed;
    }

    if (weapon_charge_timer > 0) {
        if (weapon_profile.cancel_charge_on_release && !fire_requested) {
            weapon_charge_timer = 0;
        } else {
            weapon_charge_timer = max(0, weapon_charge_timer - 1);
            weapon_flash = max(weapon_flash, 0.35);

            if (weapon_charge_timer <= 0) {
                player_fire_weapon();
            }
        }
    } else if (fire_triggered && fire_cooldown <= 0 && !weapon_release_pending && !weapon_fire_locked && weapon_ready_to_fire) {
        if (weapon_profile.charge_time > 0) {
            weapon_charge_timer = weapon_profile.charge_time;
            weapon_flash = 0.5;
        } else {
            player_fire_weapon();
        }
    }
}
