function projectile_player_get_target_anchor_x() {
    if (instance_exists(target_anchor_id)) {
        return target_anchor_id.x;
    }

    return target_anchor_x;
}

function projectile_player_get_target_anchor_y() {
    if (instance_exists(target_anchor_id)) {
        return target_anchor_id.y;
    }

    return target_anchor_y;
}

function projectile_player_find_target() {
    var anchor_x = projectile_player_get_target_anchor_x();
    var anchor_y = projectile_player_get_target_anchor_y();
    var target = instance_nearest(anchor_x, anchor_y, obj_enemy_ship_basic);

    if (!instance_exists(target)) {
        return noone;
    }

    if (point_distance(anchor_x, anchor_y, target.x, target.y) > acquire_range) {
        return noone;
    }

    return target;
}

function projectile_player_update_tracking() {
    if (!tracks_target || turn_speed <= 0 || acquire_range <= 0) {
        return;
    }

    retarget_cooldown = max(0, retarget_cooldown - 1);

    var anchor_x = projectile_player_get_target_anchor_x();
    var anchor_y = projectile_player_get_target_anchor_y();
    var target_valid = instance_exists(target_id);

    if (target_valid) {
        target_valid = point_distance(anchor_x, anchor_y, target_id.x, target_id.y) <= acquire_range;
    }

    if (!target_valid && retarget_cooldown <= 0) {
        target_id = projectile_player_find_target();
        retarget_cooldown = retarget_interval;
        target_valid = instance_exists(target_id);
    }

    if (!target_valid) {
        return;
    }

    var desired_direction = point_direction(x, y, target_id.x, target_id.y);
    var turn_amount = clamp(angle_difference(direction_angle, desired_direction), -turn_speed, turn_speed);

    direction_angle += turn_amount;
    image_angle = direction_angle - 90;
}

function projectile_player_step() {
    projectile_player_update_tracking();

    var frame_count = max(1, sprite_get_number(sprite_index));

    if (frame_count > 1 && animation_fps > 0) {
        animation_position += animation_fps / room_speed;

        while (animation_position >= frame_count) {
            animation_position -= frame_count;
        }

        image_index = floor(animation_position);
    }

    var next_x = x + lengthdir_x(move_speed, direction_angle);
    var next_y = y + lengthdir_y(move_speed, direction_angle);
    var enemy = collision_line(x, y, next_x, next_y, obj_enemy_ship_basic, true, true);

    if (instance_exists(enemy)) {
        if (combat_apply_damage(enemy, damage)) {
            global.session_kills += 1;
        }

        instance_destroy();
        return;
    }

    x = next_x;
    y = next_y;

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
}
