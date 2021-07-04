extends KinematicBody

onready var agent := GSAIKinematicBody3DAgent.new(self)
onready var target := GSAIAgentLocation.new()
onready var accel := GSAITargetAcceleration.new()
onready var blend := GSAIBlend.new(agent)
onready var face := GSAIFace.new(agent, target, true)
onready var arrive := GSAIArrive.new(agent, target)
onready var target_node = get_parent().get_parent().get_parent().get_node("Player")
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")

export (float, 0, 100, 5) var linear_speed_max := 10.0 setget set_linear_speed_max
export (float, 0, 100, 0.1) var linear_acceleration_max := 1.0 setget set_linear_acceleration_max
export (float, 0, 50, 0.1) var arrival_tolerance := 0.5 setget set_arrival_tolerance
export (float, 0, 50, 0.1) var deceleration_radius := 5.0 setget set_deceleration_radius
export (int, 0, 1080, 10) var angular_speed_max := 270 setget set_angular_speed_max
export (int, 0, 2048, 10) var angular_accel_max := 45 setget set_angular_accel_max
export (int, 0, 178, 2) var align_tolerance := 5 setget set_align_tolerance
export (int, 0, 180, 2) var angular_deceleration_radius := 45 setget set_angular_deceleration_radius

export var health_max := 100

onready var current_health := health_max

func _ready() -> void:
	setup(
		deg2rad(align_tolerance),
		deg2rad(angular_deceleration_radius),
		deg2rad(angular_accel_max),
		deg2rad(angular_speed_max),
		deceleration_radius,
		arrival_tolerance,
		linear_acceleration_max,
		linear_speed_max,
		target_node
	)
	$Area.connect("body_entered", self, "collided")
	


func _physics_process(delta: float) -> void:
	target.position = target_node.transform.origin
	target.position.y = delta * gravity
	look_at(target.position, Vector3.UP)
	blend.calculate_steering(accel)
	agent._apply_steering(accel, delta)
	get_node("Health/Viewport/TextureProgress").value = current_health
	get_node("Health/Viewport/Label").text = str(round($Timer.time_left))+"s"
	
func setup(
	align_tolerance: float,
	angular_deceleration_radius: float,
	angular_accel_max: float,
	angular_speed_max: float,
	deceleration_radius: float,
	arrival_tolerance: float,
	linear_acceleration_max: float,
	linear_speed_max: float,
	_target: Spatial
) -> void:
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = 0.05
	agent.angular_acceleration_max = angular_accel_max
	agent.angular_speed_max = angular_speed_max
	agent.angular_drag_percentage = 0.1

	arrive.arrival_tolerance = arrival_tolerance
	arrive.deceleration_radius = deceleration_radius

	face.alignment_tolerance = align_tolerance
	face.deceleration_radius = angular_deceleration_radius

	target_node = _target
	self.target.position = target_node.transform.origin
	blend.add(arrive, 1)
	blend.add(face, 1)

func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if not is_inside_tree():
		return

	self.face.alignment_tolerance = deg2rad(value)


func set_angular_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	self.face.deceleration_radius = deg2rad(value)


func set_angular_accel_max(value: int) -> void:
	angular_accel_max = value
	if not is_inside_tree():
		return

	self.agent.angular_acceleration_max = deg2rad(value)


func set_angular_speed_max(value: int) -> void:
	angular_speed_max = value
	if not is_inside_tree():
		return

	self.agent.angular_speed_max = deg2rad(value)


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return

	self.arrive.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	self.arrive.deceleration_radius = value


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	self.agent.linear_speed_max = value


func set_linear_acceleration_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return

	self.agent.linear_acceleration_max = value



func damage(amount: int) -> void:
	current_health -= amount
	$AnimationPlayer.play("hit")
	$"/root/Global".player_score += 1
	if current_health <= 0:
		$AnimationPlayer.play("Death")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()


func _on_Timer_timeout():
	# Kill virus after timout
	$AnimationPlayer.play("Death")
