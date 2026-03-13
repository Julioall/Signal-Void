function enemy_ship_draw_module_frame(_sprite, _frame, _draw_x, _draw_y, _alpha, _blend) {
    if (_sprite == noone) {
        return;
    }

    var frame_index = clamp(_frame, 0, max(0, sprite_get_number(_sprite) - 1));

    draw_sprite_ext(
        _sprite,
        frame_index,
        _draw_x,
        _draw_y,
        image_xscale,
        image_yscale,
        image_angle,
        _blend,
        _alpha
    );
}

function enemy_ship_draw_module(_sprite, _fps, _draw_x, _draw_y, _alpha, _blend, _time_offset) {
    if (_sprite == noone) {
        return;
    }

    var frame_count = max(1, sprite_get_number(_sprite));
    var frame_index = 0;

    if (frame_count > 1 && _fps > 0) {
        frame_index = floor(((current_time + _time_offset) * _fps / 1000)) mod frame_count;
    }

    enemy_ship_draw_module_frame(_sprite, frame_index, _draw_x, _draw_y, _alpha, _blend);
}

function enemy_ship_draw() {
    if (!is_struct(enemy_profile)) {
        draw_self();
        return;
    }

    var time_offset = animation_seed;
    var engine_profile = enemy_profile.engine;
    var engine_x = x + engine_profile.offset_x;
    var engine_y = y + engine_profile.offset_y;
    var engine_alpha = clamp(engine_profile.base_alpha + (sin((current_time + time_offset) / 180) * 0.08), 0.2, 1);

    enemy_ship_draw_module(
        engine_profile.sprite,
        engine_profile.fps,
        engine_x,
        engine_y,
        engine_alpha,
        c_white,
        time_offset
    );

    draw_sprite_ext(
        sprite_index,
        0,
        x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        merge_color(c_white, make_color_rgb(255, 104, 104), damage_flash),
        1
    );

    if (is_struct(weapon_profile) && weapon_profile.sprite != noone) {
        enemy_ship_draw_module(
            weapon_profile.sprite,
            weapon_profile.fps,
            x,
            y,
            clamp(weapon_profile.base_alpha + weapon_flash, 0, 1),
            c_white,
            time_offset div 2
        );
    }

    if (is_struct(shield_profile) && shield_profile.max_hp > 0 && shield_profile.sprite != noone) {
        var shield_ratio = clamp(shield_hp / shield_profile.max_hp, 0, 1);
        var shield_alpha = max(shield_ratio * shield_profile.base_alpha, shield_flash * 0.65);

        if (shield_alpha > 0.01) {
            enemy_ship_draw_module(
                shield_profile.sprite,
                shield_profile.fps,
                x,
                y,
                clamp(shield_alpha, 0, 1),
                merge_color(c_aqua, c_white, shield_flash),
                time_offset
            );
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}
