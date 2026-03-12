function enemy_basic_step() {
    touch_cooldown = max(0, touch_cooldown - 1);

    var player = instance_find(obj_player_ship, 0);

    if (instance_exists(player)) {
        var move_direction = point_direction(x, y, player.x, player.y);
        x += lengthdir_x(move_speed, move_direction);
        y += lengthdir_y(move_speed, move_direction);

        if (touch_cooldown <= 0 && point_distance(x, y, player.x, player.y) < 40) {
            combat_apply_damage(player, contact_damage);
            touch_cooldown = room_speed div 2;
        }
    } else {
        y += move_speed;
    }

    if (y > room_height + 64) {
        instance_destroy();
    }
}
