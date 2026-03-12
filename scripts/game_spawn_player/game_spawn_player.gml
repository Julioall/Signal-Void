function game_spawn_player() {
    var spawn_x = room_width * 0.5;
    var spawn_y = room_height - 96;
    return instance_create_layer(spawn_x, spawn_y, "Instances", obj_player_ship);
}
