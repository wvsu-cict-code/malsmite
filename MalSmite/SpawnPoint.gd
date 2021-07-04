extends Position3D


export var spawn_scene: PackedScene
export var wait_time = 5

func _ready():
	$Timer.wait_time = wait_time

func spawn(_spawn_scene := spawn_scene) -> void:
	var spawn := _spawn_scene.instance() as Spatial
	add_child(spawn)
	spawn.set_as_toplevel(true)
	spawn.transform.origin = transform.origin

func _on_Timer_timeout():
	spawn()
