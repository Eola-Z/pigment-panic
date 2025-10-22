/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 54A39C4F
/// @DnDArgument : "code" "/// @description Execute Code$(13_10)// obj_input : Global Left Pressed$(13_10)var mx = mouse_x, my = mouse_y;$(13_10)var brush_type = brush.current_brush$(13_10)$(13_10)// Drops first (they win)$(13_10)var d = collision_point(mx, my, obj_drop, false, true);$(13_10)// If using the knife, then skip this block of code$(13_10)if (d != noone) and brush_type < 3 {$(13_10)    with (d) {$(13_10)        global.curr_color = drop_color;   // <-- move the hand-off here$(13_10)        instance_destroy();$(13_10)    }$(13_10)    exit;$(13_10)}$(13_10)$(13_10)// Then tiles$(13_10)// TODO: Include separate logic for knife$(13_10)var t = collision_point(mx, my, obj_tile_new, false, true);$(13_10)$(13_10)if (t != noone) {$(13_10)    with (t) {$(13_10)        // if the tile is already colored and not damaged, exit immediately$(13_10)		if (fill_status != -1 and tile_health > 0) exit;$(13_10)		$(13_10)		// must be holding a color$(13_10)        if (global.curr_color == Color.NONE) exit;$(13_10)$(13_10)        // tile only accepts its own required color$(13_10)        if (desired_color != global.curr_color) {$(13_10)            global.mistakes += 1;$(13_10)			audio_play_sound(snd_mistake, 0, false);$(13_10)			if global.timer_active {$(13_10)				global.time_left = max(0, global.time_left - 5);$(13_10)			}$(13_10)            exit;$(13_10)        }$(13_10)$(13_10)        // correct color → paint once$(13_10)		// we set an alarm to delay the painting of the tile if needed$(13_10)		if (brush_type == 1) {$(13_10)			alarm[0] = 30$(13_10)			tile_health = 2$(13_10)		} else {$(13_10)			alarm[0] = 1$(13_10)			tile_health = 1$(13_10)		}$(13_10)$(13_10)        // increment level counters (the sidebar is `other` here)$(13_10)        global.filled_tiles += 1;$(13_10)		$(13_10)		// If using the fan brush, calculate if we need to paint$(13_10)		// adjacent tiles$(13_10)		if brush_type == 2 {$(13_10)			for (var i = -1; i <= 1; i++) {$(13_10)				var u = collision_point($(13_10)					mx + (i * sprite_width), my - sprite_height, $(13_10)					obj_tile_new, false, true$(13_10)				);$(13_10)				if ($(13_10)					u != noone $(13_10)					and not (u.fill_status != -1 and u.tile_health > 0)$(13_10)					and u.desired_color == global.curr_color$(13_10)				) {$(13_10)					u.alarm[0] = 1$(13_10)					u.tile_health = 1$(13_10)					global.filled_tiles += 1$(13_10)				}$(13_10)			}$(13_10)		}$(13_10)$(13_10)        // recompute percentage to 2dp$(13_10)        if (global.total_tiles > 0) {$(13_10)            global.tiles_cleared = (global.filled_tiles / global.total_tiles) * 100;$(13_10)            // keep as a number; format to 2dp only when drawing:$(13_10)            // string_format(global.tiles_cleared, 0, 2)$(13_10)        }$(13_10)$(13_10)        // consume held color$(13_10)        global.curr_color = Color.NONE;$(13_10)    }$(13_10)}"
/// @description Execute Code
// obj_input : Global Left Pressed
var mx = mouse_x, my = mouse_y;
var brush_type = brush.current_brush

// Drops first (they win)
var d = collision_point(mx, my, obj_drop, false, true);
// If using the knife, then skip this block of code
if (d != noone) and brush_type < 3 {
    with (d) {
        global.curr_color = drop_color;   // <-- move the hand-off here
        instance_destroy();
    }
    exit;
}

// Then tiles
// TODO: Include separate logic for knife
var t = collision_point(mx, my, obj_tile_new, false, true);

if (t != noone) {
    with (t) {
        // if the tile is already colored and not damaged, exit immediately
		if (fill_status != -1 and tile_health > 0) exit;
		
		// must be holding a color
        if (global.curr_color == Color.NONE) exit;

        // tile only accepts its own required color
        if (desired_color != global.curr_color) {
            global.mistakes += 1;
			audio_play_sound(snd_mistake, 0, false);
			if global.timer_active {
				global.time_left = max(0, global.time_left - 5);
			}
            exit;
        }

        // correct color → paint once
		// we set an alarm to delay the painting of the tile if needed
		if (brush_type == 1) {
			alarm[0] = 30
			tile_health = 2
		} else {
			alarm[0] = 1
			tile_health = 1
		}

        // increment level counters (the sidebar is `other` here)
        global.filled_tiles += 1;
		
		// If using the fan brush, calculate if we need to paint
		// adjacent tiles
		if brush_type == 2 {
			for (var i = -1; i <= 1; i++) {
				var u = collision_point(
					mx + (i * sprite_width), my - sprite_height, 
					obj_tile_new, false, true
				);
				if (
					u != noone 
					and not (u.fill_status != -1 and u.tile_health > 0)
					and u.desired_color == global.curr_color
				) {
					u.alarm[0] = 1
					u.tile_health = 1
					global.filled_tiles += 1
				}
			}
		}

        // recompute percentage to 2dp
        if (global.total_tiles > 0) {
            global.tiles_cleared = (global.filled_tiles / global.total_tiles) * 100;
            // keep as a number; format to 2dp only when drawing:
            // string_format(global.tiles_cleared, 0, 2)
        }

        // consume held color
        global.curr_color = Color.NONE;
    }
}