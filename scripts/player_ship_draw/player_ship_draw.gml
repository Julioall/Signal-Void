function player_ship_draw() {
    var profile = movement_profile;
    var draw_x = x + profile.engine_offset_x;
    var draw_y = y + profile.engine_offset_y;
    var engine_alpha = clamp(0.75 + (engine_load * 0.4), 0, 1);
    var idle_alpha = clamp(0.35 + (engine_load * 0.3), 0.25, 0.75);
    var boost_alpha = clamp(engine_boost * (0.55 + (engine_load * 0.45)), 0, 1);

    if (profile.engine_fx_idle_sprite != noone) {
        var idle_frame_count = max(1, sprite_get_number(profile.engine_fx_idle_sprite));
        var idle_frame = floor((current_time * profile.engine_fx_idle_fps / 1000)) mod idle_frame_count;

        draw_sprite_ext(
            profile.engine_fx_idle_sprite,
            idle_frame,
            draw_x,
            draw_y,
            image_xscale,
            image_yscale,
            image_angle,
            c_white,
            idle_alpha
        );
    }

    if (profile.engine_fx_powering_sprite != noone && boost_alpha > 0.01) {
        var boosting_frame_count = max(1, sprite_get_number(profile.engine_fx_powering_sprite));
        var boosting_frame = floor((current_time * profile.engine_fx_powering_fps / 1000)) mod boosting_frame_count;

        draw_sprite_ext(
            profile.engine_fx_powering_sprite,
            boosting_frame,
            draw_x,
            draw_y,
            image_xscale,
            image_yscale,
            image_angle,
            c_white,
            boost_alpha
        );
    }

    if (profile.engine_sprite != noone) {
        draw_sprite_ext(
            profile.engine_sprite,
            0,
            draw_x,
            draw_y,
            image_xscale,
            image_yscale,
            image_angle,
            image_blend,
            engine_alpha
        );
    }

    draw_self();
}
