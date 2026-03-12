function player_step() {
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

    var move_input = player_movement_get_input();
    player_movement_apply(move_input);

    fire_cooldown = max(0, fire_cooldown - 1);

    var fire_requested = keyboard_check(vk_space) || keyboard_check(ord("Z"));

    if (fire_requested && fire_cooldown <= 0) {
        var ship_radius = max(
            sprite_get_width(sprite_index) * abs(image_xscale),
            sprite_get_height(sprite_index) * abs(image_yscale)
        ) * 0.5;
        var spawn_distance = ship_radius + 12;
        var spawn_x = x + lengthdir_x(spawn_distance, aim_direction);
        var spawn_y = y + lengthdir_y(spawn_distance, aim_direction);
        var projectile = instance_create_layer(spawn_x, spawn_y, "Instances", obj_projectile_player);
        projectile.owner_id = id;
        projectile.direction_angle = aim_direction;
        projectile.image_angle = aim_direction - 90;
        fire_cooldown = fire_interval;
    }
}
