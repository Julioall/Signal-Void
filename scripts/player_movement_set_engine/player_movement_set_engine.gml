function player_movement_set_engine(_engine_id) {
    if (engine_id == _engine_id) {
        return;
    }

    engine_id = _engine_id;
    movement_profile = player_movement_build_profile(hull_id, engine_id);
}
