function player_weapon_build_profile(_weapon_id) {
    var profile = {
        id: "auto_cannon",
        display_name: "Auto Cannon",
        sprite: spr_player_main_ship_weapon_auto_cannon,
        fps: 8,
        idle_frame: 0,
        charge_frame_end: 0,
        fire_animation_start_frame: 0,
        fire_animation_end_frame: -1,
        fire_animation_fps: 8,
        fire_release_offsets: [],
        fire_on_press_only: false,
        block_fire_until_animation_end: true,
        segment_length: 0,
        ready_charge_enabled: false,
        ready_charge_start_frame: 0,
        ready_charge_hold_frame: 0,
        ready_charge_fps: 8,
        beam_enabled: false,
        beam_length: 0,
        beam_width: 0,
        beam_fire_start_frame: -1,
        beam_fire_end_frame: -1,
        beam_tick_interval: 0,
        beam_damage: 0,
        projectile_sprite: spr_player_projectile,
        projectile_scale: 1,
        projectile_speed: 14,
        projectile_fps: 8,
        projectile_tracks_target: false,
        projectile_turn_speed: 0,
        projectile_acquire_range: 0,
        projectile_retarget_interval: 0,
        damage: 1,
        fire_interval: 8,
        charge_time: 0,
        cancel_charge_on_release: false,
        fire_pattern: "alternate",
        projectile_spawn_padding: 2,
        muzzle_offsets: [
            { x: -7, y: -19 },
            { x: 7, y: -19 }
        ]
    };

    profile.fire_animation_fps = 24;
    profile.fire_release_offsets = [1, 2];

    switch (_weapon_id) {
        case "big_space_gun":
            profile.id = "big_space_gun";
            profile.display_name = "Big Space Gun";
            profile.sprite = spr_player_main_ship_weapon_big_space_gun;
            profile.projectile_sprite = spr_player_main_ship_projectile_big_space_gun;
            profile.projectile_scale = 1.2;
            profile.projectile_speed = 12;
            profile.projectile_fps = 8;
            profile.damage = 2;
            profile.fire_interval = 18;
            profile.ready_charge_enabled = true;
            profile.ready_charge_start_frame = 0;
            profile.ready_charge_hold_frame = 5;
            profile.ready_charge_fps = 4;
            profile.fire_animation_start_frame = 6;
            profile.fire_release_offsets = [0];
            profile.block_fire_until_animation_end = true;
            profile.fire_pattern = "single";
            profile.projectile_spawn_padding = 4;
            profile.muzzle_offsets = [
                { x: 0, y: -18 }
            ];
            break;

        case "rockets":
            profile.id = "rockets";
            profile.display_name = "Rockets";
            profile.sprite = spr_player_main_ship_weapon_rockets;
            profile.projectile_sprite = spr_player_main_ship_projectile_rocket;
            profile.projectile_scale = 2;
            profile.projectile_speed = 9;
            profile.projectile_fps = 8;
            profile.damage = 3;
            profile.fire_interval = 24;
            profile.fire_release_offsets = [2];
            profile.fire_on_press_only = true;
            profile.block_fire_until_animation_end = true;
            profile.fire_pattern = "alternate";
            profile.segment_length = 6;
            profile.projectile_tracks_target = true;
            profile.projectile_turn_speed = 4;
            profile.projectile_acquire_range = point_distance(0, 0, room_width * 0.5, room_height * 0.5);
            profile.projectile_retarget_interval = 8;
            profile.projectile_spawn_padding = 3;
            profile.muzzle_offsets = [
                { x: -10, y: -17 },
                { x: 10, y: -17 }
            ];
            break;

        case "zapper":
            profile.id = "zapper";
            profile.display_name = "Zapper";
            profile.sprite = spr_player_main_ship_weapon_zapper;
            profile.projectile_sprite = spr_player_main_ship_projectile_zapper;
            profile.projectile_scale = 2.6;
            profile.projectile_speed = 18;
            profile.projectile_fps = 8;
            profile.damage = 1;
            profile.fire_interval = 4;
            profile.charge_time = 0;
            profile.cancel_charge_on_release = false;
            profile.charge_frame_end = 2;
            profile.fire_animation_start_frame = 0;
            profile.fire_animation_end_frame = 13;
            profile.fire_animation_fps = 4;
            profile.fire_release_offsets = [];
            profile.block_fire_until_animation_end = true;
            profile.fire_pattern = "dual";
            profile.beam_enabled = true;
            profile.beam_length = point_distance(0, 0, room_width, room_height);
            profile.beam_width = 13;
            profile.beam_fire_start_frame = 3;
            profile.beam_fire_end_frame = 7;
            profile.beam_tick_interval = 4;
            profile.beam_damage = 1;
            profile.projectile_spawn_padding = 2;
            profile.muzzle_offsets = [
                { x: -6, y: -18 },
                { x: 6, y: -18 }
            ];
            break;
    }

    return profile;
}

function player_get_weapon_fire_end_frame(_profile) {
    if (!is_struct(_profile) || _profile.sprite == noone) {
        return 0;
    }

    var frame_count = max(1, sprite_get_number(_profile.sprite));
    var end_frame = _profile.fire_animation_end_frame;

    if (end_frame < _profile.fire_animation_start_frame || end_frame >= frame_count) {
        end_frame = frame_count - 1;
    }

    return max(_profile.fire_animation_start_frame, end_frame);
}

function player_weapon_fire_is_locked() {
    return (
        weapon_beam_active ||
        (
            is_struct(weapon_profile) &&
            weapon_profile.block_fire_until_animation_end &&
            weapon_anim_position >= 0
        )
    );
}

function player_weapon_has_ready_charge(_profile) {
    return is_struct(_profile) && _profile.ready_charge_enabled;
}

function player_weapon_has_beam(_profile) {
    return is_struct(_profile) && _profile.beam_enabled;
}

function player_weapon_clear_beam_segments() {
    weapon_beam_segments = [];
}

function player_weapon_add_beam_segment(_start_x, _start_y, _end_x, _end_y, _collided) {
    var segment_index = array_length(weapon_beam_segments);

    weapon_beam_segments[segment_index] = {
        start_x: _start_x,
        start_y: _start_y,
        end_x: _end_x,
        end_y: _end_y,
        collided: _collided
    };
}

function player_weapon_emit_beam_burst(_x, _y, _direction, _strength, _strong_hit, _is_origin) {
    var effect_depth = depth - 20;
    var impact_color = make_color_rgb(140 + irandom(40), 235 + irandom(20), 255);
    var spark_count = max(2, round((_is_origin ? 2 : 3) * _strength));
    var spread = (_is_origin ? 18 : 28) + (_strength * (_is_origin ? 8 : 20));
    var size_level = 0;
    var flare_color = c_white;
    var scatter_base_direction = _direction + (_is_origin ? 0 : 180);

    if (_strength >= 1.35) {
        size_level = 2;
    } else if (_strength >= 0.85) {
        size_level = 1;
    }

    if (_is_origin) {
        flare_color = merge_color(c_white, impact_color, 0.35);
    }

    effect_create_depth(effect_depth, ef_flare, _x, _y, max(0, size_level - (_is_origin ? 1 : 0)), flare_color);

    for (var i = 0; i < spark_count; i++) {
        var scatter_direction = scatter_base_direction + random_range(-spread, spread);
        var scatter_distance = random_range(0, (_is_origin ? 5 : 8) * _strength);
        var scatter_x = _x + lengthdir_x(scatter_distance, scatter_direction);
        var scatter_y = _y + lengthdir_y(scatter_distance, scatter_direction);
        var spark_size = (_strong_hit && !_is_origin && i >= spark_count - 2) ? max(1, size_level) : size_level;

        effect_create_depth(effect_depth, ef_spark, scatter_x, scatter_y, spark_size, impact_color);
    }

    if (_strong_hit && !_is_origin) {
        effect_create_depth(effect_depth, ef_ring, _x, _y, max(0, size_level - 1), merge_color(c_aqua, c_white, 0.25));
    }
}

function player_weapon_spawn_beam_origin_particles(_x, _y, _direction) {
    player_weapon_emit_beam_burst(_x, _y, _direction, 0.75, false, true);
}

function player_weapon_spawn_beam_particles(_x, _y, _direction, _strong_hit, _distance_from_origin) {
    var beam_length = max(1, weapon_profile.beam_length);
    var proximity = clamp(1 - (_distance_from_origin / beam_length), 0, 1);
    var impact_strength = lerp(0.75, 1.65, proximity);

    if (_strong_hit) {
        impact_strength += 0.1;
    }

    player_weapon_emit_beam_burst(_x, _y, _direction, impact_strength, _strong_hit, false);
}

function player_weapon_update_beam_particles() {
    weapon_beam_particles = [];
}

function player_weapon_is_ready_to_fire() {
    if (!is_struct(weapon_profile)) {
        return false;
    }

    return !player_weapon_has_ready_charge(weapon_profile) || weapon_ready;
}

function player_reset_weapon_ready_cycle() {
    weapon_ready = true;
    weapon_ready_charge_position = 0;
    weapon_idle_frame = weapon_profile.idle_frame;

    if (!player_weapon_has_ready_charge(weapon_profile) || weapon_profile.sprite == noone) {
        return;
    }

    var frame_count = max(1, sprite_get_number(weapon_profile.sprite));
    var start_frame = clamp(weapon_profile.ready_charge_start_frame, 0, frame_count - 1);
    var hold_frame = clamp(weapon_profile.ready_charge_hold_frame, start_frame, frame_count - 1);

    weapon_ready = false;
    weapon_ready_charge_position = start_frame;
    weapon_idle_frame = start_frame;
    weapon_anim_start_frame = max(hold_frame + 1, weapon_profile.fire_animation_start_frame);
}

function player_reset_weapon_animation() {
    weapon_anim_position = -1;
    weapon_release_pending = false;
    weapon_release_index = 0;
}

function player_reset_weapon_animation_state() {
    weapon_segment_step = 0;
    weapon_anim_start_frame = weapon_profile.fire_animation_start_frame;
    weapon_anim_end_frame = player_get_weapon_fire_end_frame(weapon_profile);
    weapon_release_offsets = weapon_profile.fire_release_offsets;
    weapon_release_index = 0;
    player_reset_weapon_ready_cycle();
}

function player_prepare_weapon_animation() {
    weapon_anim_start_frame = weapon_profile.fire_animation_start_frame;
    weapon_anim_end_frame = player_get_weapon_fire_end_frame(weapon_profile);
    weapon_release_offsets = weapon_profile.fire_release_offsets;
    weapon_release_index = 0;

    if (weapon_profile.segment_length <= 0 || weapon_profile.sprite == noone) {
        return;
    }

    var frame_count = max(1, sprite_get_number(weapon_profile.sprite));
    var segment_count = max(1, ceil(frame_count / weapon_profile.segment_length));

    if (weapon_segment_step >= segment_count) {
        weapon_segment_step = 0;
        weapon_idle_frame = weapon_profile.idle_frame;
    }

    weapon_anim_start_frame = weapon_segment_step * weapon_profile.segment_length;
    weapon_anim_end_frame = min(frame_count - 1, weapon_anim_start_frame + weapon_profile.segment_length - 1);
}

function player_start_weapon_animation() {
    weapon_anim_position = 0;
}

function player_get_weapon_charge_ratio() {
    if (!is_struct(weapon_profile) || weapon_profile.charge_time <= 0 || weapon_charge_timer <= 0) {
        return 0;
    }

    return clamp(1 - (weapon_charge_timer / max(1, weapon_profile.charge_time)), 0, 1);
}

function player_weapon_get_muzzle_world_position(_muzzle_offset, _direction, _forward_padding) {
    var side_x = lengthdir_x(1, _direction - 90);
    var side_y = lengthdir_y(1, _direction - 90);
    var forward_x = lengthdir_x(1, _direction);
    var forward_y = lengthdir_y(1, _direction);
    var offset_x = _muzzle_offset.x * abs(image_xscale);
    var offset_y = _muzzle_offset.y * abs(image_yscale);
    var forward_padding = _forward_padding * abs(image_yscale);

    return {
        x: x + (side_x * offset_x) - (forward_x * offset_y) + (forward_x * forward_padding),
        y: y + (side_y * offset_x) - (forward_y * offset_y) + (forward_y * forward_padding)
    };
}

function player_weapon_start_beam() {
    if (!player_weapon_has_beam(weapon_profile)) {
        return;
    }

    weapon_beam_active = false;
    weapon_beam_tick_timer = 0;
    weapon_beam_direction = aim_direction;
    player_weapon_clear_beam_segments();
}

function player_weapon_get_beam_target_sprite(_target) {
    if (variable_instance_exists(_target, "mask_index")) {
        var mask_sprite_id = _target.mask_index;

        if (is_real(mask_sprite_id) && mask_sprite_id >= 0) {
            return mask_sprite_id;
        }
    }

    if (variable_instance_exists(_target, "sprite_index")) {
        var sprite_id = _target.sprite_index;

        if (is_real(sprite_id) && sprite_id >= 0) {
            return sprite_id;
        }
    }

    return noone;
}

function player_weapon_get_beam_target_collision_data(_target) {
    var target_sprite_id = player_weapon_get_beam_target_sprite(_target);

    if (target_sprite_id == noone) {
        return {
            center_x: _target.x,
            center_y: _target.y,
            radius: 0
        };
    }

    var sprite_bbox_left = sprite_get_bbox_left(target_sprite_id);
    var sprite_bbox_right = sprite_get_bbox_right(target_sprite_id);
    var sprite_bbox_top = sprite_get_bbox_top(target_sprite_id);
    var sprite_bbox_bottom = sprite_get_bbox_bottom(target_sprite_id);
    var bbox_center_x = ((sprite_bbox_left + sprite_bbox_right) * 0.5) - sprite_get_xoffset(target_sprite_id);
    var bbox_center_y = ((sprite_bbox_top + sprite_bbox_bottom) * 0.5) - sprite_get_yoffset(target_sprite_id);
    var half_width = ((sprite_bbox_right - sprite_bbox_left) + 1) * abs(_target.image_xscale) * 0.5;
    var half_height = ((sprite_bbox_bottom - sprite_bbox_top) + 1) * abs(_target.image_yscale) * 0.5;

    return {
        center_x: _target.x + (bbox_center_x * _target.image_xscale),
        center_y: _target.y + (bbox_center_y * _target.image_yscale),
        radius: max(half_width, half_height)
    };
}

function player_weapon_find_beam_collision(_start_x, _start_y, _direction, _max_distance) {
    var direction_x = lengthdir_x(1, _direction);
    var direction_y = lengthdir_y(1, _direction);
    var beam_end_x = _start_x + (direction_x * _max_distance);
    var beam_end_y = _start_y + (direction_y * _max_distance);
    var closest_hit = {
        target_id: noone,
        distance: _max_distance,
        x: beam_end_x,
        y: beam_end_y,
        collided: false
    };
    var enemy_count = instance_number(obj_enemy_ship);

    for (var enemy_index = 0; enemy_index < enemy_count; enemy_index++) {
        var enemy = instance_find(obj_enemy_ship, enemy_index);

        if (!instance_exists(enemy)) {
            continue;
        }

        var precise_hit = collision_line(_start_x, _start_y, beam_end_x, beam_end_y, enemy, true, true);
        var impact_distance = _max_distance;

        if (precise_hit == enemy) {
            var search_min = 0;
            var search_max = _max_distance;

            for (var refine_step = 0; refine_step < 10; refine_step++) {
                var mid_distance = (search_min + search_max) * 0.5;
                var mid_x = _start_x + (direction_x * mid_distance);
                var mid_y = _start_y + (direction_y * mid_distance);

                if (collision_line(_start_x, _start_y, mid_x, mid_y, enemy, true, true) == enemy) {
                    search_max = mid_distance;
                } else {
                    search_min = mid_distance;
                }
            }

            impact_distance = search_max;
        } else {
            var broad_hit = collision_line(_start_x, _start_y, beam_end_x, beam_end_y, enemy, false, true);

            if (broad_hit != enemy) {
                continue;
            }

            var collision_data = player_weapon_get_beam_target_collision_data(enemy);
            var target_radius = collision_data.radius;

            if (target_radius <= 0) {
                continue;
            }

            var to_target_x = collision_data.center_x - _start_x;
            var to_target_y = collision_data.center_y - _start_y;
            var projected_distance = (to_target_x * direction_x) + (to_target_y * direction_y);

            if (projected_distance < -target_radius || projected_distance > _max_distance + target_radius) {
                continue;
            }

            var clamped_projection = clamp(projected_distance, 0, _max_distance);
            var closest_x = _start_x + (direction_x * clamped_projection);
            var closest_y = _start_y + (direction_y * clamped_projection);
            var distance_to_center = point_distance(closest_x, closest_y, collision_data.center_x, collision_data.center_y);

            if (distance_to_center > target_radius) {
                continue;
            }

            var impact_offset = sqrt(max(0, sqr(target_radius) - sqr(distance_to_center)));
            impact_distance = clamp(projected_distance - impact_offset, 0, _max_distance);
        }

        if (impact_distance >= closest_hit.distance) {
            continue;
        }

        closest_hit = {
            target_id: enemy,
            distance: impact_distance,
            x: _start_x + (direction_x * impact_distance),
            y: _start_y + (direction_y * impact_distance),
            collided: true
        };
    }

    return closest_hit;
}

function player_weapon_update_beam() {
    player_weapon_clear_beam_segments();

    if (!player_weapon_has_beam(weapon_profile)) {
        return;
    }

    weapon_beam_tick_timer = max(0, weapon_beam_tick_timer - 1);
    weapon_beam_active = false;

    if (weapon_anim_position < 0 || weapon_profile.sprite == noone) {
        return;
    }

    var current_frame = clamp(
        weapon_anim_start_frame + floor(weapon_anim_position),
        weapon_anim_start_frame,
        weapon_anim_end_frame
    );
    var beam_start_frame = max(weapon_anim_start_frame, weapon_profile.beam_fire_start_frame);
    var beam_end_frame = min(weapon_anim_end_frame, weapon_profile.beam_fire_end_frame);

    if (current_frame < beam_start_frame || current_frame > beam_end_frame) {
        return;
    }

    weapon_beam_active = true;
    weapon_beam_direction = aim_direction;
    weapon_flash = max(weapon_flash, 0.7);
    weapon_idle_frame = weapon_anim_end_frame;

    var can_apply_damage = (weapon_beam_tick_timer <= 0);
    var muzzle_offsets = weapon_profile.muzzle_offsets;
    var muzzle_count = array_length(muzzle_offsets);

    if (muzzle_count <= 0) {
        muzzle_offsets = [{ x: 0, y: -18 }];
        muzzle_count = 1;
    }

    for (var i = 0; i < muzzle_count; i++) {
        var beam_origin = player_weapon_get_muzzle_world_position(
            muzzle_offsets[i],
            weapon_beam_direction,
            weapon_profile.projectile_spawn_padding
        );

        player_weapon_spawn_beam_origin_particles(
            beam_origin.x,
            beam_origin.y,
            weapon_beam_direction
        );

        var collision = player_weapon_find_beam_collision(
            beam_origin.x,
            beam_origin.y,
            weapon_beam_direction,
            weapon_profile.beam_length
        );

        player_weapon_add_beam_segment(
            beam_origin.x,
            beam_origin.y,
            collision.x,
            collision.y,
            collision.collided
        );

        if (!collision.collided) {
            continue;
        }

        player_weapon_spawn_beam_particles(
            collision.x,
            collision.y,
            weapon_beam_direction,
            can_apply_damage,
            collision.distance
        );

        if (can_apply_damage && instance_exists(collision.target_id)) {
            if (combat_apply_damage(collision.target_id, weapon_profile.beam_damage)) {
                global.session_kills += 1;
            }
        }
    }

    if (can_apply_damage) {
        weapon_beam_tick_timer = weapon_profile.beam_tick_interval;
    }
}

function player_weapon_spawn_projectile(_muzzle_offset) {
    var spawn_position = player_weapon_get_muzzle_world_position(
        _muzzle_offset,
        aim_direction,
        weapon_profile.projectile_spawn_padding
    );
    var projectile = instance_create_layer(spawn_position.x, spawn_position.y, "Instances", obj_projectile_player);

    projectile.owner_id = id;
    projectile.sprite_index = weapon_profile.projectile_sprite;
    projectile.image_index = 0;
    projectile.image_speed = 0;
    projectile.animation_fps = weapon_profile.projectile_fps;
    projectile.animation_position = 0;
    projectile.move_speed = weapon_profile.projectile_speed;
    projectile.damage = weapon_profile.damage;
    projectile.direction_angle = aim_direction;
    projectile.image_angle = aim_direction - 90;
    projectile.image_xscale = weapon_profile.projectile_scale;
    projectile.image_yscale = weapon_profile.projectile_scale;
    projectile.tracks_target = weapon_profile.projectile_tracks_target;
    projectile.turn_speed = weapon_profile.projectile_turn_speed;
    projectile.acquire_range = weapon_profile.projectile_acquire_range;
    projectile.retarget_interval = weapon_profile.projectile_retarget_interval;
    projectile.retarget_cooldown = 0;
    projectile.target_id = noone;
    projectile.target_anchor_id = id;
    projectile.target_anchor_x = x;
    projectile.target_anchor_y = y;
}

function player_weapon_emit_projectiles() {
    if (!is_struct(weapon_profile)) {
        return;
    }

    if (player_weapon_has_beam(weapon_profile)) {
        player_weapon_start_beam();
        weapon_flash = 1;
        return;
    }

    var muzzle_offsets = weapon_profile.muzzle_offsets;
    var muzzle_count = array_length(muzzle_offsets);

    if (muzzle_count <= 0) {
        muzzle_offsets = [{ x: 0, y: -18 }];
        muzzle_count = 1;
    }

    switch (weapon_profile.fire_pattern) {
        case "single":
            player_weapon_spawn_projectile(muzzle_offsets[0]);
            break;

        case "dual":
            for (var i = 0; i < muzzle_count; i++) {
                player_weapon_spawn_projectile(muzzle_offsets[i]);
            }
            break;

        default:
            var muzzle_index = weapon_barrel_index mod muzzle_count;
            player_weapon_spawn_projectile(muzzle_offsets[muzzle_index]);
            weapon_barrel_index = (weapon_barrel_index + 1) mod muzzle_count;
            break;
    }

    weapon_flash = 1;
}

function player_fire_weapon() {
    if (!is_struct(weapon_profile)) {
        return;
    }

    weapon_charge_timer = 0;
    weapon_ready = false;
    player_prepare_weapon_animation();
    player_start_weapon_animation();
    fire_cooldown = weapon_profile.fire_interval;

    if (array_length(weapon_release_offsets) > 0) {
        weapon_release_pending = true;
        return;
    }

    weapon_release_pending = false;
    player_weapon_emit_projectiles();
}

function player_shield_build_profile(_shield_id) {
    var profile = {
        id: "round",
        display_name: "Round Shield",
        sprite: spr_player_main_ship_shield_round,
        fps: 8,
        max_hp: 4,
        recharge_delay: round(room_speed * 2.25),
        recharge_rate: 0.03,
        base_alpha: 0.22,
        invulnerability_window: 0,
        negates_hit: false
    };

    switch (_shield_id) {
        case "front":
            profile.id = "front";
            profile.display_name = "Front Shield";
            profile.sprite = spr_player_main_ship_shield_front;
            profile.max_hp = 2;
            profile.recharge_delay = round(room_speed * 1.75);
            profile.recharge_rate = 0.05;
            profile.base_alpha = 0.18;
            break;

        case "front_and_side":
            profile.id = "front_and_side";
            profile.display_name = "Front and Side Shield";
            profile.sprite = spr_player_main_ship_shield_front_and_side;
            profile.max_hp = 3;
            profile.recharge_delay = round(room_speed * 2.0);
            profile.recharge_rate = 0.04;
            profile.base_alpha = 0.2;
            break;

        case "invincibility":
            profile.id = "invincibility";
            profile.display_name = "Invincibility Shield";
            profile.sprite = spr_player_main_ship_shield_invincibility;
            profile.max_hp = 1;
            profile.recharge_delay = round(room_speed * 3.5);
            profile.recharge_rate = 0.015;
            profile.base_alpha = 0.32;
            profile.invulnerability_window = round(room_speed * 0.35);
            profile.negates_hit = true;
            break;
    }

    return profile;
}

function player_cycle_option(_current_id, _options, _direction) {
    var option_count = array_length(_options);

    if (option_count <= 0) {
        return _current_id;
    }

    var current_index = 0;

    for (var i = 0; i < option_count; i++) {
        if (_options[i] == _current_id) {
            current_index = i;
            break;
        }
    }

    return _options[(current_index + _direction + option_count) mod option_count];
}

function player_set_weapon(_weapon_id) {
    var new_profile = player_weapon_build_profile(_weapon_id);

    weapon_id = new_profile.id;
    weapon_profile = new_profile;
    fire_interval = weapon_profile.fire_interval;
    fire_cooldown = min(fire_cooldown, fire_interval);
    weapon_charge_timer = 0;
    weapon_barrel_index = 0;
    weapon_beam_active = false;
    weapon_beam_tick_timer = 0;
    weapon_beam_direction = aim_direction;
    player_weapon_clear_beam_segments();
    player_reset_weapon_animation_state();
    player_reset_weapon_animation();
    weapon_flash = 1;
}

function player_set_shield(_shield_id) {
    var new_profile = player_shield_build_profile(_shield_id);

    shield_id = new_profile.id;
    shield_profile = new_profile;
    shield_hp = shield_profile.max_hp;
    shield_recharge_timer = 0;
    shield_flash = 1;
    invulnerability_timer = 0;
}

function player_get_hull_sprite(_hp_ratio) {
    if (_hp_ratio > 0.66) {
        return spr_player_ship;
    }

    if (_hp_ratio > 0.4) {
        return spr_player_main_ship_base_slight_damage;
    }

    if (_hp_ratio > 0.15) {
        return spr_player_main_ship_base_damaged;
    }

    return spr_player_main_ship_base_very_damaged;
}

function player_update_loadout_state() {
    var hp_ratio = 0;

    if (max_hp > 0) {
        hp_ratio = hp / max_hp;
    }

    sprite_index = player_get_hull_sprite(hp_ratio);

    if (is_struct(weapon_profile)) {
        fire_interval = weapon_profile.fire_interval;

        if (weapon_anim_position >= 0 && weapon_profile.sprite != noone) {
            var fire_frame_count = max(1, (weapon_anim_end_frame - weapon_anim_start_frame) + 1);

            weapon_anim_position += weapon_profile.fire_animation_fps / room_speed;

            while (
                weapon_release_pending &&
                weapon_release_index < array_length(weapon_release_offsets) &&
                weapon_anim_position >= weapon_release_offsets[weapon_release_index]
            ) {
                player_weapon_emit_projectiles();
                weapon_release_index += 1;
            }

            if (weapon_release_index >= array_length(weapon_release_offsets)) {
                weapon_release_pending = false;
            }

            if (weapon_anim_position >= fire_frame_count) {
                if (weapon_profile.segment_length > 0 && weapon_profile.sprite != noone) {
                    var weapon_frame_count = max(1, sprite_get_number(weapon_profile.sprite));
                    var segment_count = max(1, ceil(weapon_frame_count / weapon_profile.segment_length));

                    weapon_segment_step = min(segment_count, weapon_segment_step + 1);
                    weapon_idle_frame = weapon_anim_end_frame;
                } else if (player_weapon_has_ready_charge(weapon_profile)) {
                    player_reset_weapon_ready_cycle();
                } else if (player_weapon_has_beam(weapon_profile) && weapon_beam_active) {
                    weapon_idle_frame = weapon_anim_end_frame;
                } else {
                    weapon_idle_frame = weapon_profile.idle_frame;
                }

                player_reset_weapon_animation();
            }
        } else if (player_weapon_has_ready_charge(weapon_profile) && weapon_profile.sprite != noone && !weapon_ready) {
            var charge_frame_count = max(1, sprite_get_number(weapon_profile.sprite));
            var charge_start_frame = clamp(weapon_profile.ready_charge_start_frame, 0, charge_frame_count - 1);
            var charge_hold_frame = clamp(weapon_profile.ready_charge_hold_frame, charge_start_frame, charge_frame_count - 1);

            weapon_ready_charge_position = min(
                charge_hold_frame,
                weapon_ready_charge_position + (weapon_profile.ready_charge_fps / room_speed)
            );
            weapon_idle_frame = clamp(floor(weapon_ready_charge_position), charge_start_frame, charge_hold_frame);

            if (weapon_ready_charge_position >= charge_hold_frame) {
                weapon_idle_frame = charge_hold_frame;
                weapon_ready = true;
            }
        }

        player_weapon_update_beam();
    }

    player_weapon_update_beam_particles();
    weapon_flash = max(0, weapon_flash - 0.12);
    damage_flash = max(0, damage_flash - 0.08);
    shield_flash = max(0, shield_flash - 0.08);
    invulnerability_timer = max(0, invulnerability_timer - 1);

    if (is_struct(shield_profile) && shield_profile.max_hp > 0) {
        shield_recharge_timer = max(0, shield_recharge_timer - 1);

        if (shield_recharge_timer <= 0 && shield_hp < shield_profile.max_hp) {
            shield_hp = min(shield_profile.max_hp, shield_hp + shield_profile.recharge_rate);
        }
    }
}
