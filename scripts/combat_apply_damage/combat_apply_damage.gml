function combat_apply_damage(target, amount) {
    if (!instance_exists(target)) {
        return false;
    }

    if (!variable_instance_exists(target, "hp")) {
        return false;
    }

    target.hp = max(0, target.hp - amount);

    if (target.hp > 0) {
        return false;
    }

    with (target) {
        instance_destroy();
    }

    return true;
}
