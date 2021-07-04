extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.text = "Your Score: " + str($"/root/Global".player_score)


func _on_Button_pressed():
	$"/root/Global".core_health = 100
	$"/root/Global".player_score = 0
	$"/root/Global".goto_scene("res://Main.tscn")
