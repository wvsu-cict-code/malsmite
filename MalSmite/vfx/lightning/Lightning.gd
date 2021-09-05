extends Node2D

var min_segment_size : float = 2
var max_segment_size : float = 10
var points : Array = []
var emitting = true
var final_goal : Vector2

export (float) var angle_var : float = 15
export (int) var thickness : int = 3
export (float) var wait_time : float = 2

onready var line : Line2D = $Line2D
onready var line2 : Line2D = $Line2D2

export (float) var position_offset_percent : float = 0

export (Color) var color: Color = Color(255,255,255)
export (Color) var outline_color: Color = Color(0,0,0)

export (NodePath) var start_position
export (NodePath) var end_position

onready var start = get_node(start_position)
onready var end = get_node(end_position)

func _ready():
	position = Vector2(get_viewport().get_visible_rect().size.x*position_offset_percent, position.y)
	final_goal = end.get_position() - global_position 
	set_line_width(thickness)
	line.modulate = color
	line2.modulate = outline_color
	$Timer.start(rand_range(0.1,0.5))

func update_wait_time():
	$Timer.wait_time = rand_range(1, wait_time)

func _on_Timer_timeout():
	print_debug($Timer.wait_time)
	if(points.size() > 0):
		points.pop_front()
		line.points = points	
		line2.points = points
		#Small variation for more organic look:
		$Timer.start(0.002 + rand_range(-0.001,0.001))
	elif(emitting):
		update_points()
		line.points = points
		line2.points = points
		$Timer.start(0.1 + rand_range(-0.02,0.5))
	
func update_points():
	final_goal = end.get_position() - global_position 
	var curr_line_len = 0
	
	var start_point = start.get_position()
	points = [start_point]
	min_segment_size = max(Vector2().distance_to(final_goal)/40,1)
	max_segment_size = min(Vector2().distance_to(final_goal)/20,10)
	while(curr_line_len < Vector2().distance_to(final_goal)):
		var move_vector = start_point.direction_to(final_goal) * rand_range(min_segment_size,max_segment_size)
		var new_point = start_point + move_vector
		var new_point_rotated = start_point + move_vector.rotated(deg2rad(rand_range(-angle_var,angle_var)))
		points.append(new_point_rotated)
		start_point = new_point
		curr_line_len = start_point.length()
		
	points.append(final_goal)

func set_line_width(amount):
	line.width = amount
	line2.width = amount+6
