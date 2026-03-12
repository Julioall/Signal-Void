function player_movement_get_input() {
    var turn_input = keyboard_check(vk_right) - keyboard_check(vk_left);
    turn_input += keyboard_check(ord("D")) - keyboard_check(ord("A"));
    turn_input = clamp(turn_input, -1, 1);

    return {
        turn: turn_input,
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
