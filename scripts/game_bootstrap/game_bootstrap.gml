function game_bootstrap() {
    randomize();
    global.session_kills = 0;
    global.restart_cooldown = -1;
}

function game_reset_room_state() {
    global.restart_cooldown = -1;
}
