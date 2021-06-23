extends KinematicBody

class_name Player

const MAX_SPEED = 20
const JUMP_SPEED = 5
const ACCELERATION = 3
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
		velocity.x = playerController.output.x
		velocity.z = playerController.output.y
		velocity = move_and_slide(velocity * MAX_SPEED)
		rotation = Vector3(0, playerController.output.angle()*-1, 0)
		get_node("Root/BoosterFast").visible = true
		get_node("Root/BoosterSlow").visible = false
	else:
		get_node("Root/BoosterFast").visible = false
		get_node("Root/BoosterSlow").visible = true
	


func _on_FireButton_pressed():
	get_node("Root/Weapon1").fire_weapon()
	get_node("Root/Weapon2").fire_weapon()
