extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30

const ray_length = 1000
onready var cam = $Camera

export (NodePath) var playerPath
onready var player:Spatial = get_node(playerPath)

func _process(delta):
	var player_pos = get_node("Camera").unproject_position(player.translation)
	calc_move(player_pos, delta)

func calc_move(player_pos, delta):
	var v_size = get_viewport().size
	var margin_x = 100
	var margin_y = 130
	var move_vec = Vector3()

#	if player_pos.x-margin_x < MOVE_MARGIN:
#		move_vec.x -= 1
#	if player_pos.y-margin_y*2 < MOVE_MARGIN:
#		move_vec.z -= 1
#	if player_pos.x+margin_x*2 > v_size.x - MOVE_MARGIN:
#		move_vec.x += 1
#	if player_pos.y+margin_y > v_size.y - MOVE_MARGIN:
#		move_vec.z += 1

	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)

	var fps = Engine.get_frames_per_second()

	if fps > 30:
		set_as_toplevel(true)
	else:
		global_transform = global_transform
		set_as_toplevel(false)
	
	global_translate(move_vec * delta * MOVE_SPEED)
	
	
	
