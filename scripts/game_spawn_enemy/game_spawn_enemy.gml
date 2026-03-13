function game_spawn_enemy() {
    var roster = enemy_get_roster();
    var roster_count = array_length(roster);

    if (roster_count <= 0) {
        return noone;
    }

    var roster_index = global.enemy_roster_index mod roster_count;
    var enemy_id = roster[roster_index];
    var padding = 96;
    var spawn_x = irandom_range(padding, room_width - padding);
    var spawn_y = irandom_range(96, max(96, room_height div 3));
    var enemy = instance_create_layer(spawn_x, spawn_y, "Instances", obj_enemy_ship);

    enemy_ship_apply_profile(enemy, enemy_id);

    global.enemy_roster_index = (roster_index + 1) mod roster_count;
    global.enemy_last_spawned_id = enemy_id;
    global.enemy_last_spawned_index = roster_index;

    return enemy;
}
