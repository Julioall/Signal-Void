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

    var player = instance_find(obj_player_ship, 0);

    if (!instance_exists(player)) {
        return;
    }

    aim_direction = point_direction(x, y, player.x, player.y);
    image_angle = aim_direction - 90;

    if (!global.enemy_attack_enabled) {
        return;
    }

    var touched_player = instance_place(x, y, obj_player_ship);

    if (touch_cooldown <= 0 && instance_exists(touched_player)) {
        combat_apply_damage(touched_player, contact_damage);
        weapon_flash = 0.2;
        touch_cooldown = room_speed div 2;
    }
}
