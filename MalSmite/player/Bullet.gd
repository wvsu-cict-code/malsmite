extends Spatial


var BULLET_SPEED = 30
var BULLET_DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")


func _physics_process(delta):
	var forward_dir = global_transform.basis.y.normalized()
	global_translate(forward_dir * BULLET_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("damage"):
			body.damage(BULLET_DAMAGE)
	get_node("AnimationPlayer").play("Hit")
	hit_something = true


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
