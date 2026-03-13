function player_movement_approach(_value, _target, _step) {
    if (_value < _target) {
        return min(_value + _step, _target);
    }

    return max(_value - _step, _target);
}

function player_movement_apply(_move_input) {
    var profile = movement_profile;
    image_angle += _move_input.turn * profile.turn_speed;
    aim_direction = image_angle + 90;
    engine_boost = player_movement_approach(engine_boost, max(_move_input.thrust, 0), 0.2);

    var forward_x = lengthdir_x(1, aim_direction);
    var forward_y = lengthdir_y(1, aim_direction);
    var side_x = lengthdir_x(1, aim_direction - 90);
    var side_y = lengthdir_y(1, aim_direction - 90);
    var forward_speed = (velocity_x * forward_x) + (velocity_y * forward_y);
    var side_speed = (velocity_x * side_x) + (velocity_y * side_y);

    if (_move_input.thrust > 0) {
        forward_speed += profile.acceleration * _move_input.thrust;
    } else if (_move_input.thrust < 0) {
        forward_speed += profile.reverse_acceleration * _move_input.thrust;
    } else {
        forward_speed = player_movement_approach(forward_speed, 0, profile.braking);
        forward_speed *= profile.idle_drag;
    }

    forward_speed = clamp(forward_speed, -profile.max_reverse_speed, profile.max_speed);
    side_speed *= profile.lateral_drag;

    if (abs(forward_speed) < 0.01) {
        forward_speed = 0;
    }

    if (abs(side_speed) < 0.01) {
        side_speed = 0;
    }

    velocity_x = (forward_x * forward_speed) + (side_x * side_speed);
    velocity_y = (forward_y * forward_speed) + (side_y * side_speed);

    x += velocity_x;
    y += velocity_y;

    var collision_sprite = sprite_index;

    if (mask_index != -1) {
        collision_sprite = mask_index;
    }

    var half_width = (sprite_get_width(collision_sprite) * abs(image_xscale)) * 0.5;
    var half_height = (sprite_get_height(collision_sprite) * abs(image_yscale)) * 0.5;

    x = clamp(x, half_width, room_width - half_width);
    y = clamp(y, half_height, room_height - half_height);

    current_speed = point_distance(0, 0, velocity_x, velocity_y);
    engine_load = clamp(max(abs(_move_input.thrust), current_speed / max(0.001, profile.max_speed)), 0, 1);
}
