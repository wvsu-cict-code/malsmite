extends Spatial

onready var target := GSAIAgentLocation.new()
onready var target_node = get_parent().get_parent().get_node("Player")

func _physics_process(delta: float) -> void:
	target.position = target_node.transform.origin
	look_at(target.position, Vector3.UP)
