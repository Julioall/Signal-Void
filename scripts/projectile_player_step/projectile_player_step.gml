function projectile_player_step() {
    x += lengthdir_x(move_speed, direction_angle);
    y += lengthdir_y(move_speed, direction_angle);

    var bounds_padding = max(sprite_get_width(sprite_index) * abs(image_xscale), sprite_get_height(sprite_index) * abs(image_yscale));

    if (
        x < -bounds_padding ||
        x > room_width + bounds_padding ||
        y < -bounds_padding ||
        y > room_height + bounds_padding
    ) {
        instance_destroy();
        return;
    }

    var enemy_count = instance_number(obj_enemy_ship_basic);

    for (var i = 0; i < enemy_count; i++) {
        var enemy = instance_find(obj_enemy_ship_basic, i);

        if (!instance_exists(enemy)) {
            continue;
        }

        if (point_distance(x, y, enemy.x, enemy.y) < hit_radius) {
            if (combat_apply_damage(enemy, damage)) {
                global.session_kills += 1;
            }

            instance_destroy();
            return;
        }
    }
}
