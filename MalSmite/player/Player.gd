extends KinematicBody

class_name Player

const MAX_SPEED = 15
const JUMP_SPEED = 5
const ACCELERATION = 3
const DECELERATION = 4
var velocity: Vector3
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
onready var start_position = translation
var isMoving:bool = false

export var health_max := 200

onready var current_health := health_max


export (NodePath) var controllerPath
onready var playerController : MovementController = $Joystick

func _ready():
	$Area.connect("body_entered", self, "collided")


func _physics_process(_delta):
	velocity.y += _delta * gravity
	get_node("Health/Viewport/TextureProgress").value = current_health
	if playerController and playerController.is_working:
		if isMoving:
			get_node("AnimationPlayer2").play("Moving")
			get_node("AnimationPlayer3").play("Full Rotate")
			isMoving = false
		velocity.x = playerController.output.x
		velocity.z = playerController.output.y
		velocity = move_and_slide(velocity * MAX_SPEED).normalized()
		rotation = Vector3(0, playerController.output.angle()*-1, 0)
		get_node("MainController/Root/BoosterFast").visible = true
		get_node("MainController/Root/BoosterFast2").visible = true
		get_node("MainController/Root/BoosterSlow").visible = false
		get_node("MainController/Root/BoosterSlow2").visible = false
		get_node("MainController/Root/MotionTrail").visible = true
		get_node("MainController/Root/MotionTrail2").visible = true
	else:
		if not isMoving:
			get_node("AnimationPlayer2").play("NotMoving")
			get_node("AnimationPlayer3").stop()
			isMoving = true
		
		get_node("MainController/Root/BoosterFast").visible = false
		get_node("MainController/Root/BoosterFast2").visible = false
		get_node("MainController/Root/BoosterSlow").visible = true
		get_node("MainController/Root/BoosterSlow2").visible = true
		get_node("MainController/Root/MotionTrail").visible = false
		get_node("MainController/Root/MotionTrail2").visible = false
	
func collided(body):
	if body.has_method("damage"):
		body.damage(100)
		current_health -= 20
		get_node("AnimationPlayer").play("Hit")
		if current_health == 0:
			$"/root/Global".goto_scene("res://GameOver.tscn")


func _on_ShootTimer_timeout():
	get_node("MainController/Root/the-sphere/Weapon1").fire_weapon()
	get_node("MainController/Root/the-sphere/Weapon2").fire_weapon()

func Shoot():
	get_node("ShootTimer").start()
	print("sssss")

func _on_ShootButton_gui_input(event):
	if event is InputEventScreenTouch:
		Shoot()
	else:
		$ShootTimer.stop()
