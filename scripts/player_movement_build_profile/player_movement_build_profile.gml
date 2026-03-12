function player_movement_build_profile(_hull_id, _engine_id) {
    var hull = {
        id: _hull_id,
        max_speed: 4.6,
        acceleration: 0.18,
        braking: 0.22,
        idle_drag: 0.965,
        reverse_speed_ratio: 0.4,
        reverse_acceleration_ratio: 0.55,
        lateral_drag: 0.76,
        turn_speed: 3.6,
        engine_offset_x: 0,
        engine_offset_y: 0
    };

    switch (_hull_id) {
        case "main_ship":
            break;

        default:
            show_debug_message("Unknown hull_id: " + string(_hull_id) + ". Falling back to main_ship.");
            hull.id = "main_ship";
            break;
    }

    var engine = {
        id: _engine_id,
        speed_bonus: 0.5,
        acceleration_mult: 1.0,
        braking_mult: 1.0,
        idle_drag_bonus: 0.0,
        sprite: spr_player_ship_engine_base,
        fx_idle_sprite: spr_player_ship_engine_fx_base_idle,
        fx_powering_sprite: spr_player_ship_engine_fx_base_powering,
        fx_idle_fps: 8,
        fx_powering_fps: 16
    };

    switch (_engine_id) {
        case "base":
            break;

        case "big_pulse":
            engine.speed_bonus = 1.7;
            engine.acceleration_mult = 0.78;
            engine.braking_mult = 0.82;
            engine.idle_drag_bonus = 0.015;
            engine.sprite = spr_player_ship_engine_big_pulse;
            engine.fx_idle_sprite = spr_player_ship_engine_fx_big_pulse_idle;
            engine.fx_powering_sprite = spr_player_ship_engine_fx_big_pulse_powering;
            break;

        case "burst":
            engine.speed_bonus = 0.9;
            engine.acceleration_mult = 1.85;
            engine.braking_mult = 1.55;
            engine.idle_drag_bonus = -0.02;
            engine.sprite = spr_player_ship_engine_burst;
            engine.fx_idle_sprite = spr_player_ship_engine_fx_burst_idle;
            engine.fx_powering_sprite = spr_player_ship_engine_fx_burst_powering;
            break;

        case "supercharged":
            engine.speed_bonus = 2.4;
            engine.acceleration_mult = 1.15;
            engine.braking_mult = 0.7;
            engine.idle_drag_bonus = 0.025;
            engine.sprite = spr_player_ship_engine_supercharged;
            engine.fx_idle_sprite = spr_player_ship_engine_fx_supercharged_idle;
            engine.fx_powering_sprite = spr_player_ship_engine_fx_supercharged_powering;
            break;

        default:
            show_debug_message("Unknown engine_id: " + string(_engine_id) + ". Falling back to base.");
            engine.id = "base";
            break;
    }

    return {
        hull_id: hull.id,
        engine_id: engine.id,
        max_speed: hull.max_speed + engine.speed_bonus,
        max_reverse_speed: (hull.max_speed + engine.speed_bonus) * hull.reverse_speed_ratio,
        acceleration: hull.acceleration * engine.acceleration_mult,
        reverse_acceleration: (hull.acceleration * hull.reverse_acceleration_ratio) * engine.acceleration_mult,
        braking: hull.braking * engine.braking_mult,
        idle_drag: clamp(hull.idle_drag + engine.idle_drag_bonus, 0.0, 0.98),
        lateral_drag: hull.lateral_drag,
        turn_speed: hull.turn_speed,
        engine_sprite: engine.sprite,
        engine_fx_idle_sprite: engine.fx_idle_sprite,
        engine_fx_powering_sprite: engine.fx_powering_sprite,
        engine_fx_idle_fps: engine.fx_idle_fps,
        engine_fx_powering_fps: engine.fx_powering_fps,
        engine_offset_x: hull.engine_offset_x,
        engine_offset_y: hull.engine_offset_y
    };
}
