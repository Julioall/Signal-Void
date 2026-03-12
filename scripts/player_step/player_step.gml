function player_step() {
    var input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
    input_x += keyboard_check(ord("D")) - keyboard_check(ord("A"));

    var input_y = keyboard_check(vk_down) - keyboard_check(vk_up);
    input_y += keyboard_check(ord("S")) - keyboard_check(ord("W"));

    input_x = clamp(input_x, -1, 1);
    input_y = clamp(input_y, -1, 1);

    if (input_x != 0 && input_y != 0) {
        input_x *= 0.70710678118;
        input_y *= 0.70710678118;
    }

    x += input_x * move_speed;
    y += input_y * move_speed;

    x = clamp(x, 24, room_width - 24);
    y = clamp(y, 24, room_height - 24);

    fire_cooldown = max(0, fire_cooldown - 1);

    var fire_requested = keyboard_check(vk_space) || keyboard_check(ord("Z")) || mouse_check_button(mb_left);

    if (fire_requested && fire_cooldown <= 0) {
        var projectile = instance_create_layer(x, y - 28, "Instances", obj_projectile_player);
        projectile.owner_id = id;
        fire_cooldown = fire_interval;
    }
}
