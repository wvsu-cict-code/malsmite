extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PopupPanel.visible = false

func _process(delta):
	get_node("LabelFPS").text = str(Engine.get_frames_per_second())+" fps"
	$CoreTextureProgress.value = $"/root/Global".core_health
	$LabelScore.text = str($"/root/Global".player_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PauseTextureButton_pressed():
	$PopupPanel.visible = true
	get_tree().paused = true


func _on_Resume_pressed():
	get_tree().paused = false
	$PopupPanel.visible = false
	


func _on_Menu_pressed():
	get_tree().paused = false
	var location = "res://MainMenu.tscn"
	Global.goto_scene(location)
