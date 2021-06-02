extends KinematicBody2D

class_name Player

export var speed : float = 200

export (NodePath) var controllerPath
onready var playerController : Controller = get_node(controllerPath)


func _physics_process(_delta):
	if playerController and playerController.is_working:
		var _velocity = move_and_slide(playerController.output * speed)
		rotation = playerController.output.angle()
	
