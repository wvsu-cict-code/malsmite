extends Spatial


onready var health_max:int = $"/root/Global".core_health

onready var current_health := health_max


func _ready():
	$Area.connect("body_entered", self, "collided")


func collided(body):
	if body.has_method("damage"):
		body.damage(100)
		current_health -= 10
		$"/root/Global".core_health = current_health
		$CoreAnimation.play("Hit")
