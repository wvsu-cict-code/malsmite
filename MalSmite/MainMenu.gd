extends Control


var location = "res://Main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_PlayButton_pressed():
	location = "res://Main.tscn";
	$Click.play()	


func _on_LoreButton_pressed():
	location = "res://Lore.tscn";
	$Click.play()


func _on_AboutButton_pressed():
	$Click.play()


func _on_Click_finished():
	Global.goto_scene(location)
