function enemy_ship_update_showcase_motion() {
    if (!showcase_motion_enabled) {
        return false;
    }

    showcase_timer += 1;

    var previous_x = x;
    var previous_y = y;
    var target_x = showcase_anchor_x + sin((showcase_timer * showcase_speed_x) + showcase_phase_x) * showcase_radius_x;
    var target_y = showcase_anchor_y + cos((showcase_timer * showcase_speed_y) + showcase_phase_y) * showcase_radius_y;

    x = target_x;
    y = target_y;

    if (point_distance(previous_x, previous_y, x, y) > 0.1) {
        aim_direction = point_direction(previous_x, previous_y, x, y);
        image_angle = aim_direction - 90;
    }

    return true;
}

function enemy_ship_step() {
    touch_cooldown = max(0, touch_cooldown - 1);
    damage_flash = max(0, damage_flash - 0.08);
    shield_flash = max(0, shield_flash - 0.08);
    weapon_flash = max(0, weapon_flash - 0.05);
    invulnerability_timer = max(0, invulnerability_timer - 1);

    if (is_struct(shield_profile) && shield_profile.max_hp > 0) {
        shield_recharge_timer = max(0, shield_recharge_timer - 1);

        if (shield_recharge_timer <= 0 && shield_hp < shield_profile.max_hp) {
            shield_hp = min(shield_profile.max_hp, shield_hp + shield_profile.recharge_rate);
        }
    }

    var showcase_active = global.enemy_showcase_mode && enemy_ship_update_showcase_motion();
    var player = instance_find(obj_player_ship, 0);

    if (!global.enemy_attack_enabled) {
        return;
    }

    if (!showcase_active) {
        if (!instance_exists(player)) {
            return;
        }

        aim_direction = point_direction(x, y, player.x, player.y);
        image_angle = aim_direction - 90;
    }

    var touched_player = instance_place(x, y, obj_player_ship);

    if (touch_cooldown <= 0 && instance_exists(touched_player)) {
        combat_apply_damage(touched_player, contact_damage);
        weapon_flash = 0.2;
        touch_cooldown = room_speed div 2;
    }
}
