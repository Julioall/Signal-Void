function game_spawn_enemy(_enemy_id, _spawn_x, _spawn_y) {
    var roster = enemy_get_roster();
    var roster_count = array_length(roster);

    if (roster_count <= 0) {
        return noone;
    }

    var roster_index = global.enemy_roster_index mod roster_count;
    var enemy_id = _enemy_id;

    if (is_undefined(enemy_id) || enemy_id == "") {
        enemy_id = roster[roster_index];
    } else {
        for (var i = 0; i < roster_count; i++) {
            if (roster[i] == enemy_id) {
                roster_index = i;
                break;
            }
        }
    }

    var padding = 96;
    var spawn_x = _spawn_x;
    var spawn_y = _spawn_y;

    if (is_undefined(spawn_x)) {
        spawn_x = irandom_range(padding, room_width - padding);
    }

    if (is_undefined(spawn_y)) {
        spawn_y = irandom_range(96, max(96, room_height div 3));
    }

    var enemy = instance_create_layer(spawn_x, spawn_y, "Instances", obj_enemy_ship);

    enemy_ship_apply_profile(enemy, enemy_id);

    global.enemy_roster_index = (roster_index + 1) mod roster_count;
    global.enemy_last_spawned_id = enemy_id;
    global.enemy_last_spawned_index = roster_index;

    return enemy;
}

function game_get_enemy_roster_layout(_roster_count) {
    var columns = min(8, _roster_count);
    var rows = max(1, ceil(_roster_count / columns));
    var margin_x = 84;
    var margin_top = 124;
    var margin_bottom = 220;
    var available_width = max(1, room_width - (margin_x * 2));
    var available_height = max(1, room_height - margin_top - margin_bottom);
    var spacing_x = (columns > 1) ? (available_width / (columns - 1)) : 0;
    var spacing_y = (rows > 1) ? (available_height / (rows - 1)) : 0;

    return {
        columns: columns,
        rows: rows,
        margin_x: margin_x,
        margin_top: margin_top,
        spacing_x: spacing_x,
        spacing_y: spacing_y
    };
}

function game_get_enemy_roster_slot_position(_slot_index, _roster_count) {
    var layout = game_get_enemy_roster_layout(_roster_count);
    var column = _slot_index mod layout.columns;
    var row = _slot_index div layout.columns;

    return {
        x: layout.margin_x + (layout.spacing_x * column),
        y: layout.margin_top + (layout.spacing_y * row),
        spacing_x: layout.spacing_x,
        spacing_y: layout.spacing_y
    };
}

function game_apply_enemy_showcase_slot(_enemy, _slot_index, _roster_count) {
    if (!instance_exists(_enemy)) {
        return false;
    }

    var slot_position = game_get_enemy_roster_slot_position(_slot_index, _roster_count);

    _enemy.showcase_motion_enabled = true;
    _enemy.showcase_slot_index = _slot_index;
    _enemy.showcase_anchor_x = slot_position.x;
    _enemy.showcase_anchor_y = slot_position.y;
    _enemy.showcase_radius_x = clamp(slot_position.spacing_x * 0.22, 20, 72);
    _enemy.showcase_radius_y = clamp(max(40, slot_position.spacing_y) * 0.16, 16, 52);
    _enemy.showcase_speed_x = 0.022 + ((_slot_index mod 5) * 0.003);
    _enemy.showcase_speed_y = 0.017 + ((_slot_index mod 7) * 0.002);
    _enemy.showcase_phase_x = _slot_index * 23;
    _enemy.showcase_phase_y = _slot_index * 37;
    _enemy.showcase_timer = irandom(1200);
    _enemy.x = slot_position.x;
    _enemy.y = slot_position.y;

    return true;
}

function game_spawn_enemy_roster() {
    var roster = enemy_get_roster();
    var roster_count = array_length(roster);

    if (roster_count <= 0) {
        return 0;
    }

    for (var roster_index = 0; roster_index < roster_count; roster_index++) {
        var slot_position = game_get_enemy_roster_slot_position(roster_index, roster_count);
        var spawn_x = slot_position.x;
        var spawn_y = slot_position.y;
        var enemy = game_spawn_enemy(roster[roster_index], spawn_x, spawn_y);

        if (!instance_exists(enemy)) {
            continue;
        }

        game_apply_enemy_showcase_slot(enemy, roster_index, roster_count);
    }

    return roster_count;
}

function game_spawn_missing_enemy_roster_entries() {
    var roster = enemy_get_roster();
    var roster_count = array_length(roster);
    var spawned_count = 0;

    for (var roster_index = 0; roster_index < roster_count; roster_index++) {
        var enemy_id = roster[roster_index];
        var found = false;
        var enemy_count = instance_number(obj_enemy_ship);

        for (var enemy_index = 0; enemy_index < enemy_count; enemy_index++) {
            var enemy = instance_find(obj_enemy_ship, enemy_index);

            if (!instance_exists(enemy)) {
                continue;
            }

            if (variable_instance_exists(enemy, "enemy_id") && enemy.enemy_id == enemy_id) {
                found = true;
                break;
            }
        }

        if (found) {
            continue;
        }

        var slot_position = game_get_enemy_roster_slot_position(roster_index, roster_count);
        var spawned_enemy = game_spawn_enemy(enemy_id, slot_position.x, slot_position.y);

        if (instance_exists(spawned_enemy)) {
            game_apply_enemy_showcase_slot(spawned_enemy, roster_index, roster_count);
            spawned_count += 1;
        }
    }

    return spawned_count;
}
