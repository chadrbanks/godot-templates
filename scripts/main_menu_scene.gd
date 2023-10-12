extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 5:
		display_save_slot(i+1)

# Press Esc to quit to menu
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE:
			get_tree().quit()

# These 2 funcs display save slot data
func get_button_label(id):
	if id == 1:
		return $CanvasLayer/Slot1Button/ButtonLabel
	elif id == 2:
		return $CanvasLayer/Slot2Button/ButtonLabel
	elif id == 3:
		return $CanvasLayer/Slot3Button/ButtonLabel
	elif id == 4:
		return $CanvasLayer/Slot4Button/ButtonLabel
	elif id == 5:
		return $CanvasLayer/Slot5Button/ButtonLabel
	else:
		return $CanvasLayer/Slot1Button/ButtonLabel

func display_save_slot(id):
	var p = IdlePlayer.new()
	var result = p.attempt_load("user://save" + str(id) + ".iv")
	
	var temp_btn = get_button_label(id)
	if result:
		temp_btn.bbcode_text = "[center]Load Game[/center]"
	else:
		temp_btn.bbcode_text = "[center]Start New Game[/center]"

# Handle Buttons
func _on_SlotButton_pressed(extra_arg_0):
	if Input.is_action_pressed("shifty"):
		$Audio/Error.play()
		C4Files.delete_file("user://save" + str(extra_arg_0) + ".iv")
		display_save_slot(extra_arg_0)
		return
	
	C4Singleton.save_slot = extra_arg_0
	C4Singleton.goto_scene("res://scenes/main_game.tscn")

# Discord Button
func _on_DiscordButton_pressed():
	var _result = OS.shell_open("https://discord.gg/TZYpXWW5su")
	
#	if result > 0:
#		C4Analytics.send_event_obj({event="error_discord", data={error=result}})
#	else:
#		C4Analytics.send_event("view_discord")

func _on_QuitButton_pressed():
	get_tree().quit()
