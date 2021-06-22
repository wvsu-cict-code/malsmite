extends KinematicBody

class_name Player

const MAX_SPEED = 3
const JUMP_SPEED = 5
const ACCELERATION = 2
const DECELERATION = 4
var velocity: Vector3
onready var camera = $Target/Camera
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
onready var start_position = translation

export (NodePath) var controllerPath
onready var playerController : Controller = get_node(controllerPath)


func _physics_process(_delta):
	velocity.y += _delta * gravity
	if playerController and playerController.is_working:
		var dir = Vector3()
		velocity.x = playerController.output.x
		velocity.z = playerController.output.y
		velocity = move_and_slide(velocity * MAX_SPEED)
	
