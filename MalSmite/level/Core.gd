extends Spatial


export var health_max := 3

onready var current_health := health_max


func _ready():
	$Area.connect("body_entered", self, "collided")


func collided(body):
	if body.has_method("damage"):
		body.damage(100)
		current_health -= 1
		$CoreAnimation.play("Hit")
