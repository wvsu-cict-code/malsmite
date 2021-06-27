extends TextureButton

onready var time_label = $Counter/Value

export var cooldown = 1.0

export (Texture) var icon_texture_normal
export (Texture) var icon_texture_disabled

func _ready():
	texture_normal = icon_texture_normal
	texture_disabled = icon_texture_disabled
	$Timer.wait_time = cooldown
	time_label.hide()
	$Sweep.texture_progress = texture_normal
	$Sweep.value = 0
	
	set_process(false)

func _process(delta):
	$Sweep.rect_scale = Vector2(0.62,0.62)
	time_label.text = "%3.1f" % $Timer.time_left
	$Sweep.value = int(($Timer.time_left / cooldown) * 100)

func _on_Timer_timeout():
	print("ability ready")
	$Sweep.value = 0
	disabled = false
	time_label.hide()
	set_process(false)


#func _on_AbilityButton_pressed():


func _on_AbilityButton_gui_input(event):
	if event is InputEventScreenTouch and $Sweep.value == 0:
		disabled = true
		set_process(true)
		$Timer.start()
		time_label.show()
