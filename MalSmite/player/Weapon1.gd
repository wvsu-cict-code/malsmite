extends Spatial


const DAMAGE = 15

var bullet_scene = preload("Bullet.tscn")
var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")

func fire_weapon():
	var clone = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)
	get_node("AnimationPlayer").play("Flash")

	clone.global_transform = self.global_transform
	clone.scale = Vector3(4, 4, 4)
	clone.BULLET_DAMAGE = DAMAGE

func collided(body):
	if hit_something == false:
		if body.has_method("damage"):
			body.damage(DAMAGE)
	get_node("AnimationPlayer").play("Hit")
	hit_something = true
	
