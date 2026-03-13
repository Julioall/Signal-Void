enemy_id = "";
faction_id = "";
ship_role_id = "";
display_name = "";
enemy_profile = undefined;
movement_profile = {
    cruise_speed: 0,
    acceleration: 0,
    turn_speed: 0,
    engine_offset_x: 0,
    engine_offset_y: 0
};
weapon_profile = {
    enabled: false,
    display_name: "",
    sprite: noone,
    fps: 0,
    base_alpha: 0,
    projectile_sprite: noone,
    projectile_speed: 0,
    projectile_scale: 1,
    fire_interval: 0,
    damage: 0
};
shield_profile = enemy_build_empty_shield_profile();
destruction_sprite = noone;
is_enemy_ship = true;
visual_scale = 1;
move_speed = 0;
turn_speed = 0;
contact_damage = 1;
hp = 1;
max_hp = 1;
shield_hp = 0;
shield_recharge_timer = 0;
shield_flash = 0;
damage_flash = 0;
touch_cooldown = 0;
invulnerability_timer = 0;
weapon_flash = 0;
aim_direction = 90;
animation_seed = irandom(100000);
image_speed = 0;
image_angle = 0;
image_xscale = visual_scale;
image_yscale = visual_scale;
