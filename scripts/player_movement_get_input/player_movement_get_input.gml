function player_movement_get_input() {
    var turn_input = keyboard_check(vk_right) - keyboard_check(vk_left);
    turn_input += keyboard_check(ord("D")) - keyboard_check(ord("A"));
    turn_input = clamp(turn_input, -1, 1);
    var mouse_distance = point_distance(x, y, mouse_x, mouse_y);
    var mouse_aim_active = mouse_aim_enabled && mouse_distance > mouse_aim_deadzone;
    var target_direction = aim_direction;

    if (mouse_aim_active) {
        target_direction = point_direction(x, y, mouse_x, mouse_y);
    }

    return {
        turn: turn_input,
        mouse_aim_active: mouse_aim_active,
        target_direction: target_direction,
        thrust: clamp(
            keyboard_check(vk_up)
            + keyboard_check(ord("W"))
            - keyboard_check(vk_down)
            - keyboard_check(ord("S")),
            -1,
            1
        )
    };
}
