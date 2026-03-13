function combat_apply_damage(target, amount) {
    if (!instance_exists(target)) {
        return false;
    }

    if (!variable_instance_exists(target, "hp")) {
        return false;
    }

    if (
        variable_instance_exists(target, "is_enemy_ship") &&
        target.is_enemy_ship &&
        global.enemy_invulnerable
    ) {
        return false;
    }

    if (variable_instance_exists(target, "invulnerability_timer") && target.invulnerability_timer > 0) {
        return false;
    }

    var remaining_damage = max(0, amount);

    if (
        remaining_damage > 0 &&
        variable_instance_exists(target, "shield_hp") &&
        variable_instance_exists(target, "shield_profile") &&
        is_struct(target.shield_profile) &&
        target.shield_hp > 0
    ) {
        var absorbed = min(target.shield_hp, remaining_damage);
        target.shield_hp = max(0, target.shield_hp - absorbed);
        remaining_damage -= absorbed;

        if (variable_instance_exists(target, "shield_recharge_timer")) {
            target.shield_recharge_timer = round(target.shield_profile.recharge_delay);
        }

        if (variable_instance_exists(target, "shield_flash")) {
            target.shield_flash = 1;
        }

        if (target.shield_profile.negates_hit && absorbed > 0) {
            remaining_damage = 0;

            if (variable_instance_exists(target, "invulnerability_timer")) {
                target.invulnerability_timer = max(target.invulnerability_timer, target.shield_profile.invulnerability_window);
            }
        }
    }

    if (remaining_damage <= 0) {
        return false;
    }

    target.hp = max(0, target.hp - remaining_damage);

    if (variable_instance_exists(target, "damage_flash")) {
        target.damage_flash = 1;
    }

    if (target.hp > 0) {
        return false;
    }

    with (target) {
        instance_destroy();
    }

    return true;
}
