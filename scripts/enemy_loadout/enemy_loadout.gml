function enemy_get_roster() {
    return [
        "klaed_scout"
    ];
}

function enemy_get_faction_id(_enemy_id) {
    var separator_index = string_pos("_", _enemy_id);

    if (separator_index <= 0) {
        return "klaed";
    }

    return string_copy(_enemy_id, 1, separator_index - 1);
}

function enemy_get_ship_slug(_enemy_id) {
    var separator_index = string_pos("_", _enemy_id);

    if (separator_index <= 0) {
        return _enemy_id;
    }

    return string_delete(_enemy_id, 1, separator_index);
}

function enemy_get_role_id(_ship_slug) {
    switch (_ship_slug) {
        case "support":
        case "support_ship":
            return "support";

        default:
            return _ship_slug;
    }
}

function enemy_get_faction_display_name(_faction_id) {
    switch (_faction_id) {
        case "nairan":
            return "Nairan";

        case "nautolan":
            return "Nautolan";

        default:
            return "Klaed";
    }
}

function enemy_get_role_display_name(_role_id) {
    switch (_role_id) {
        case "battlecruiser":
            return "Battlecruiser";

        case "bomber":
            return "Bomber";

        case "dreadnought":
            return "Dreadnought";

        case "fighter":
            return "Fighter";

        case "frigate":
            return "Frigate";

        case "support":
            return "Support Ship";

        case "torpedo_ship":
            return "Torpedo Ship";

        default:
            return "Scout";
    }
}

function enemy_get_optional_sprite(_sprite_name) {
    var sprite_id = asset_get_index(_sprite_name);

    if (!is_real(sprite_id) || sprite_id < 0) {
        return noone;
    }

    return sprite_id;
}

function enemy_get_optional_module_sprite(_enemy_id, _module_suffix) {
    return enemy_get_optional_sprite("spr_enemy_" + _enemy_id + "_" + _module_suffix);
}

function enemy_get_engine_sprite(_enemy_id) {
    var engine_sprite = enemy_get_optional_module_sprite(_enemy_id, "engine");

    if (engine_sprite != noone) {
        return engine_sprite;
    }

    return enemy_get_optional_module_sprite(_enemy_id, "engine_effect");
}

function enemy_get_projectile_suffix(_faction_id, _role_id) {
    switch (_faction_id) {
        case "nairan":
            switch (_role_id) {
                case "bomber":
                    return "rocket";

                case "torpedo_ship":
                    return "torpedo";

                case "frigate":
                case "battlecruiser":
                case "dreadnought":
                    return "ray";

                case "support":
                    return "";

                default:
                    return "bolt";
            }

        case "nautolan":
            switch (_role_id) {
                case "bomber":
                    return "bomb";

                case "fighter":
                    return "spinning_bullet";

                case "torpedo_ship":
                    return "rocket";

                case "frigate":
                case "battlecruiser":
                case "dreadnought":
                    return "wave";

                case "support":
                    return "";

                default:
                    return "bullet";
            }

        default:
            switch (_role_id) {
                case "bomber":
                    return "big_bullet";

                case "torpedo_ship":
                    return "torpedo";

                case "frigate":
                    return "ray";

                case "battlecruiser":
                case "dreadnought":
                    return "wave";

                case "support":
                    return "";

                default:
                    return "bullet";
            }
    }
}

function enemy_build_empty_shield_profile() {
    return {
        sprite: noone,
        fps: 0,
        max_hp: 0,
        recharge_delay: 0,
        recharge_rate: 0,
        base_alpha: 0,
        invulnerability_window: 0,
        negates_hit: false
    };
}

function enemy_build_class_profile(_role_id) {
    var profile = {
        role_id: _role_id,
        display_name: enemy_get_role_display_name(_role_id),
        max_hp: 3,
        shield_hp: 1,
        contact_damage: 1,
        visual_scale: 1.35,
        move_speed: 2.6,
        acceleration: 0.14,
        turn_speed: 3.8,
        engine_alpha: 0.78,
        engine_fps: 10,
        weapon_enabled: true,
        weapon_display_name: "Light Battery",
        weapon_damage: 1,
        weapon_fire_interval: 12,
        weapon_projectile_speed: 12,
        weapon_projectile_scale: 1,
        weapon_alpha: 0.9,
        weapon_fps: 8,
        shield_recharge_delay: round(room_speed * 2.0),
        shield_recharge_rate: 0.03,
        shield_base_alpha: 0.18,
        shield_fps: 8
    };

    switch (_role_id) {
        case "fighter":
            profile.max_hp = 4;
            profile.shield_hp = 2;
            profile.visual_scale = 1.42;
            profile.move_speed = 2.9;
            profile.turn_speed = 4.1;
            profile.weapon_display_name = "Assault Cannons";
            profile.weapon_fire_interval = 10;
            break;

        case "bomber":
            profile.max_hp = 5;
            profile.shield_hp = 2;
            profile.visual_scale = 1.5;
            profile.move_speed = 2.2;
            profile.turn_speed = 2.8;
            profile.weapon_display_name = "Payload Rack";
            profile.weapon_damage = 3;
            profile.weapon_fire_interval = 22;
            profile.weapon_projectile_speed = 8;
            profile.weapon_projectile_scale = 1.25;
            profile.engine_alpha = 0.84;
            break;

        case "frigate":
            profile.max_hp = 7;
            profile.shield_hp = 3;
            profile.visual_scale = 1.65;
            profile.move_speed = 1.9;
            profile.turn_speed = 2.3;
            profile.contact_damage = 2;
            profile.weapon_display_name = "Frigate Battery";
            profile.weapon_damage = 2;
            profile.weapon_fire_interval = 18;
            profile.weapon_projectile_speed = 10;
            profile.engine_alpha = 0.74;
            break;

        case "support":
            profile.max_hp = 5;
            profile.shield_hp = 0;
            profile.visual_scale = 1.5;
            profile.move_speed = 2.1;
            profile.turn_speed = 2.9;
            profile.weapon_enabled = false;
            profile.weapon_display_name = "Support Emitter";
            profile.weapon_damage = 0;
            profile.weapon_fire_interval = 0;
            profile.shield_base_alpha = 0;
            profile.engine_alpha = 0.9;
            break;

        case "torpedo_ship":
            profile.max_hp = 6;
            profile.shield_hp = 2;
            profile.visual_scale = 1.55;
            profile.move_speed = 2.05;
            profile.turn_speed = 2.7;
            profile.contact_damage = 2;
            profile.weapon_display_name = "Torpedo Launcher";
            profile.weapon_damage = 3;
            profile.weapon_fire_interval = 26;
            profile.weapon_projectile_speed = 7;
            profile.weapon_projectile_scale = 1.35;
            break;

        case "battlecruiser":
            profile.max_hp = 10;
            profile.shield_hp = 4;
            profile.visual_scale = 1.08;
            profile.move_speed = 1.45;
            profile.turn_speed = 1.7;
            profile.contact_damage = 3;
            profile.weapon_display_name = "Heavy Broadside";
            profile.weapon_damage = 3;
            profile.weapon_fire_interval = 22;
            profile.weapon_projectile_speed = 9;
            profile.weapon_projectile_scale = 1.2;
            profile.engine_alpha = 0.7;
            break;

        case "dreadnought":
            profile.max_hp = 12;
            profile.shield_hp = 5;
            profile.visual_scale = 1.12;
            profile.move_speed = 1.25;
            profile.turn_speed = 1.45;
            profile.contact_damage = 4;
            profile.weapon_display_name = "Siege Array";
            profile.weapon_damage = 4;
            profile.weapon_fire_interval = 28;
            profile.weapon_projectile_speed = 8;
            profile.weapon_projectile_scale = 1.35;
            profile.shield_base_alpha = 0.24;
            profile.engine_alpha = 0.68;
            break;
    }

    return profile;
}

function enemy_build_faction_profile(_faction_id) {
    var profile = {
        id: _faction_id,
        display_name: enemy_get_faction_display_name(_faction_id),
        hp_mult: 1,
        shield_mult: 1,
        speed_mult: 1,
        damage_mult: 1,
        recharge_delay_mult: 1,
        recharge_rate_mult: 1,
        engine_alpha_mult: 1
    };

    switch (_faction_id) {
        case "nairan":
            profile.hp_mult = 0.95;
            profile.shield_mult = 1.25;
            profile.recharge_delay_mult = 0.78;
            profile.recharge_rate_mult = 1.18;
            profile.engine_alpha_mult = 0.95;
            break;

        case "nautolan":
            profile.hp_mult = 1.05;
            profile.speed_mult = 1.08;
            profile.damage_mult = 0.95;
            profile.recharge_delay_mult = 0.9;
            profile.recharge_rate_mult = 1.08;
            break;

        default:
            profile.hp_mult = 1.2;
            profile.shield_mult = 0.85;
            profile.speed_mult = 0.92;
            profile.damage_mult = 1.2;
            profile.recharge_delay_mult = 1.12;
            profile.recharge_rate_mult = 0.88;
            profile.engine_alpha_mult = 1.08;
            break;
    }

    return profile;
}

function enemy_build_profile(_enemy_id) {
    var faction_id = enemy_get_faction_id(_enemy_id);
    var ship_slug = enemy_get_ship_slug(_enemy_id);
    var role_id = enemy_get_role_id(ship_slug);
    var class_profile = enemy_build_class_profile(role_id);
    var faction_profile = enemy_build_faction_profile(faction_id);
    var base_sprite = enemy_get_optional_module_sprite(_enemy_id, "base");
    var engine_sprite = enemy_get_engine_sprite(_enemy_id);
    var weapon_sprite = enemy_get_optional_module_sprite(_enemy_id, "weapons");
    var shield_sprite = enemy_get_optional_module_sprite(_enemy_id, "shield");
    var destruction_sprite = enemy_get_optional_module_sprite(_enemy_id, "destruction");
    var projectile_suffix = enemy_get_projectile_suffix(faction_id, role_id);
    var projectile_sprite = noone;
    var shield_max_hp = 0;
    var shield_recharge_delay = 0;
    var shield_recharge_rate = 0;
    var engine_fps = 0;
    var weapon_fps = 0;
    var shield_fps = 0;
    var weapon_enabled = class_profile.weapon_enabled;

    if (projectile_suffix != "") {
        projectile_sprite = enemy_get_optional_sprite("spr_enemy_" + faction_id + "_projectile_" + projectile_suffix);
    }

    if (base_sprite == noone) {
        show_debug_message("Missing enemy base sprite for " + string(_enemy_id) + ".");
        base_sprite = enemy_get_optional_sprite("spr_enemy_klaed_scout_base");
    }

    if (shield_sprite != noone && class_profile.shield_hp > 0) {
        shield_max_hp = max(1, round(class_profile.shield_hp * faction_profile.shield_mult));
        shield_recharge_delay = max(1, round(class_profile.shield_recharge_delay * faction_profile.recharge_delay_mult));
        shield_recharge_rate = class_profile.shield_recharge_rate * faction_profile.recharge_rate_mult;
    } else {
        shield_sprite = noone;
    }

    if (!weapon_enabled || projectile_sprite == noone) {
        weapon_enabled = false;
        projectile_sprite = noone;
    }

    if (engine_sprite != noone && sprite_get_number(engine_sprite) > 1) {
        engine_fps = max(1, class_profile.engine_fps);
    }

    if (weapon_sprite != noone && sprite_get_number(weapon_sprite) > 1) {
        weapon_fps = max(1, class_profile.weapon_fps);
    }

    if (shield_sprite != noone && sprite_get_number(shield_sprite) > 1) {
        shield_fps = max(1, class_profile.shield_fps);
    }

    return {
        id: _enemy_id,
        display_name: faction_profile.display_name + " " + class_profile.display_name,
        faction_id: faction_id,
        faction_display_name: faction_profile.display_name,
        ship_slug: ship_slug,
        role_id: role_id,
        base_sprite: base_sprite,
        destruction_sprite: destruction_sprite,
        max_hp: max(1, round(class_profile.max_hp * faction_profile.hp_mult)),
        contact_damage: max(1, round(class_profile.contact_damage * faction_profile.damage_mult)),
        visual_scale: class_profile.visual_scale,
        movement: {
            cruise_speed: class_profile.move_speed * faction_profile.speed_mult,
            acceleration: class_profile.acceleration * faction_profile.speed_mult,
            turn_speed: class_profile.turn_speed * faction_profile.speed_mult,
            engine_offset_x: 0,
            engine_offset_y: 0
        },
        engine: {
            sprite: engine_sprite,
            fps: engine_fps,
            base_alpha: clamp(class_profile.engine_alpha * faction_profile.engine_alpha_mult, 0, 1),
            offset_x: 0,
            offset_y: 0
        },
        weapon: {
            enabled: weapon_enabled,
            display_name: class_profile.weapon_display_name,
            sprite: weapon_sprite,
            fps: weapon_fps,
            base_alpha: class_profile.weapon_alpha,
            projectile_sprite: projectile_sprite,
            projectile_speed: class_profile.weapon_projectile_speed,
            projectile_scale: class_profile.weapon_projectile_scale,
            fire_interval: class_profile.weapon_fire_interval,
            damage: max(0, round(class_profile.weapon_damage * faction_profile.damage_mult))
        },
        shield: {
            sprite: shield_sprite,
            fps: shield_fps,
            max_hp: shield_max_hp,
            recharge_delay: shield_recharge_delay,
            recharge_rate: shield_recharge_rate,
            base_alpha: (shield_max_hp > 0) ? class_profile.shield_base_alpha : 0,
            invulnerability_window: 0,
            negates_hit: false
        }
    };
}

function enemy_ship_apply_profile(_target, _enemy_id) {
    if (!instance_exists(_target)) {
        return false;
    }

    var profile = enemy_build_profile(_enemy_id);

    _target.enemy_id = profile.id;
    _target.faction_id = profile.faction_id;
    _target.ship_role_id = profile.role_id;
    _target.display_name = profile.display_name;
    _target.enemy_profile = profile;
    _target.movement_profile = profile.movement;
    _target.weapon_profile = profile.weapon;
    _target.shield_profile = profile.shield;
    _target.destruction_sprite = profile.destruction_sprite;
    _target.sprite_index = profile.base_sprite;
    _target.mask_index = profile.base_sprite;
    _target.image_index = 0;
    _target.image_speed = 0;
    _target.image_angle = 0;
    _target.visual_scale = profile.visual_scale;
    _target.image_xscale = profile.visual_scale;
    _target.image_yscale = profile.visual_scale;
    _target.max_hp = profile.max_hp;
    _target.hp = profile.max_hp;
    _target.contact_damage = profile.contact_damage;
    _target.move_speed = profile.movement.cruise_speed;
    _target.turn_speed = profile.movement.turn_speed;
    _target.shield_hp = profile.shield.max_hp;
    _target.shield_recharge_timer = 0;
    _target.shield_flash = 0;
    _target.damage_flash = 0;
    _target.touch_cooldown = 0;
    _target.invulnerability_timer = 0;
    _target.weapon_flash = 0;
    _target.aim_direction = 90;
    _target.animation_seed = irandom(100000);

    return true;
}
