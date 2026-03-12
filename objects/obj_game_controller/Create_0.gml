game_reset_room_state();
player_id = game_spawn_player();
game_spawn_enemy();
enemy_respawn_timer = room_speed;
restart_cooldown = -1;
