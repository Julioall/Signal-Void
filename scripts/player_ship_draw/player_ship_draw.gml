function player_ship_draw_module_frame(_sprite, _frame, _alpha, _blend) {
    var frame_index = clamp(_frame, 0, max(0, sprite_get_number(_sprite) - 1));

    draw_sprite_ext(
        _sprite,
        frame_index,
        x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        _blend,
        _alpha
    );
}

function player_ship_draw_module(_sprite, _fps, _alpha, _blend) {
    var frame_count = max(1, sprite_get_number(_sprite));
    var frame_index = 0;

    if (frame_count > 1 && _fps > 0) {
        frame_index = floor((current_time * _fps / 1000)) mod frame_count;
    }

    player_ship_draw_module_frame(_sprite, frame_index, _alpha, _blend);
}

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

    var hull_blend = merge_color(c_white, make_color_rgb(255, 96, 96), damage_flash);

    draw_sprite_ext(
        sprite_index,
        0,
        x,
        y,
        image_xscale,
        image_yscale,
        image_angle,
        hull_blend,
        1
    );

    if (is_struct(weapon_profile) && weapon_profile.sprite != noone) {
        var weapon_alpha = clamp(0.88 + (weapon_flash * 0.12), 0, 1);
        var weapon_blend = c_white;
        var weapon_frame = weapon_idle_frame;

        if (weapon_profile.charge_time > 0 && weapon_charge_timer > 0) {
            var charge_ratio = player_get_weapon_charge_ratio();
            var weapon_frame_count = max(1, sprite_get_number(weapon_profile.sprite));
            var charge_end_frame = clamp(weapon_profile.charge_frame_end, weapon_profile.idle_frame, weapon_frame_count - 1);

            weapon_frame = round(lerp(weapon_profile.idle_frame, charge_end_frame, charge_ratio));

            weapon_alpha = max(weapon_alpha, 0.95);
            weapon_blend = merge_color(c_white, make_color_rgb(160, 255, 255), charge_ratio);
        } else if (weapon_anim_position >= 0) {
            weapon_frame = clamp(
                weapon_anim_start_frame + floor(weapon_anim_position),
                weapon_anim_start_frame,
                weapon_anim_end_frame
            );
        }

        player_ship_draw_module_frame(weapon_profile.sprite, weapon_frame, weapon_alpha, weapon_blend);
    }

    if (player_weapon_has_beam(weapon_profile) && weapon_beam_active) {
        var beam_sprite = weapon_profile.projectile_sprite;
        var beam_frame_count = max(1, sprite_get_number(beam_sprite));
        var beam_frame = floor((current_time * weapon_profile.projectile_fps / 1000)) mod beam_frame_count;
        var beam_scale = max(abs(image_xscale), 1);
        var beam_alpha = 0.92;
        var beam_xscale = weapon_profile.projectile_scale * beam_scale * 0.375;
        var beam_glow_color = make_color_rgb(110, 255, 255);
        var beam_core_width = max(2, weapon_profile.beam_width * beam_scale * 0.165);
        var beam_glow_width = max(3, weapon_profile.beam_width * beam_scale * 0.4875);
        var segment_count = array_length(weapon_beam_segments);

        for (var beam_index = 0; beam_index < segment_count; beam_index++) {
            var segment = weapon_beam_segments[beam_index];
            var segment_length = point_distance(segment.start_x, segment.start_y, segment.end_x, segment.end_y);
            var beam_mid_x = (segment.start_x + segment.end_x) * 0.5;
            var beam_mid_y = (segment.start_y + segment.end_y) * 0.5;
            var beam_yscale = segment_length / max(1, sprite_get_height(beam_sprite));

            draw_set_alpha(0.18);
            draw_set_color(beam_glow_color);
            draw_line_width(segment.start_x, segment.start_y, segment.end_x, segment.end_y, beam_glow_width);

            draw_set_alpha(0.32);
            draw_set_color(c_white);
            draw_line_width(segment.start_x, segment.start_y, segment.end_x, segment.end_y, beam_core_width);

            draw_sprite_ext(
                beam_sprite,
                beam_frame,
                beam_mid_x,
                beam_mid_y,
                beam_xscale,
                beam_yscale,
                weapon_beam_direction - 90,
                c_white,
                beam_alpha
            );
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);

    if (is_struct(shield_profile) && shield_profile.sprite != noone && shield_profile.max_hp > 0) {
        var shield_ratio = clamp(shield_hp / shield_profile.max_hp, 0, 1);
        var shield_alpha = max(shield_ratio * shield_profile.base_alpha, shield_flash * 0.65);

        if (invulnerability_timer > 0) {
            shield_alpha = max(shield_alpha, 0.85);
        }

        if (shield_alpha > 0.01) {
            var shield_blend = c_aqua;

            if (invulnerability_timer > 0) {
                shield_blend = make_color_rgb(255, 250, 180);
            } else if (shield_flash > 0.01) {
                shield_blend = merge_color(c_aqua, c_white, shield_flash);
            }

            player_ship_draw_module(
                shield_profile.sprite,
                shield_profile.fps,
                clamp(shield_alpha, 0, 1),
                shield_blend
            );
        }
    }
}
