function projectile_player_step() {
    y -= move_speed;

    if (y < -64) {
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
