function game_spawn_enemy() {
    var padding = 96;
    var spawn_x = irandom_range(padding, room_width - padding);
    var spawn_y = 96;
    return instance_create_layer(spawn_x, spawn_y, "Instances", obj_enemy_ship_basic);
}
