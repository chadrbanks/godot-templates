extends Node2D

var global_timer = null
var time_orb = 0

var plyr = IdlePlayer.new()
var current_location = null
var save_file_path = "user://save" + str(C4Singleton.save_slot) + ".iv"

# Called when the node enters the scene tree for the first time.
func _ready():
	global_timer = Timer.new()
	add_child(global_timer)
	global_timer.connect("timeout", self, "_on_timer_tick")
	global_timer.set_wait_time(0.75)
	global_timer.set_one_shot(false) # Make sure it loops
	global_timer.start()
	
	for child in $Zones.get_children():
		child.get_engn(self)
	
	for i in 17:
		tout("")
	
	# Load/Start New to use plyr.zone
	var game_loaded = plyr.attempt_load(save_file_path)
	change_zone(plyr.zone)
	update_display()
	
	if game_loaded:
		tout("[color=yellow]Welcome back![/color]")
		if plyr.zlock < 1:
			current_location.show_nav()
	else:
		plyr.first_save = Time.get_datetime_string_from_system()
		tout("[color=yellow]Welcome to Idleverse![/color]")
		tout("")
		tout("[color=yellow]HOW TO PLAY:[/color]")
		tout("[color=#d3d3d3]  - Everytime all 10 idle orbs down to the right activate, an event happens for your character.[/color]")
		tout("[color=#d3d3d3]  - As events happen, your character does things and will discover new locations, quests, events, more.[/color]")
		tout("[color=#d3d3d3]  - These interactions/opportunities will all show up when discovered.[/color]")
		tout("[color=#d3d3d3]  - Your biggest impact is by choosing where to adventure.[/color]")
		tout("[color=#d3d3d3]  - Your game is saved after each event, so you can hit [Esc] to quit whenever.[/color]")
		#tout("[color=#d3d3d3]Those options .[/color]")
		tout("")

# Press Esc to quit to menu
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_ESCAPE || event.scancode == KEY_Q:
			C4Singleton.goto_scene("res://scenes/main_menu.tscn")
		if C4Singleton.env != "prod" && event.scancode == KEY_E:
			on_game_event()

# Called to Change Zone
func change_zone(z):
	for child in $Zones.get_children():
		child.hide()
		child.hide_nav()
	
	plyr.zone = z
	match plyr.zone:
		"dawnview":
			current_location = $Zones/Dawnview
		"dawnview_coast":
			current_location = $Zones/Dawnview
		"dawnview_road":
			current_location = $Zones/Dawnview
		"docks":
			current_location = $Zones/Docks
		"rat-town":
			current_location = $Zones/RatTown
		"fire-realm":
			current_location = $Zones/FireRealm
	
	time_orb = 0
	hide_orbs()
	current_location.show()
	update_display()

# Handle Game Events
func on_game_event():
	plyr.events.total += 1
	if plyr.zlock > 0:
		plyr.zlock -= 1
	if plyr.zlock < 1:
		current_location.show_nav()
	
	current_location.roll_event()
	update_display()

# Idle Timer Handler
func _on_timer_tick():
	time_orb += 1
	match time_orb:
		1:
			$TimeOrbs/Orb1/GreenBoxTick.show()
		2:
			$TimeOrbs/Orb2/GreenBoxTick.show()
		3:
			$TimeOrbs/Orb3/GreenBoxTick.show()
		4:
			$TimeOrbs/Orb4/GreenBoxTick.show()
		5:
			$TimeOrbs/Orb5/GreenBoxTick.show()
		6:
			$TimeOrbs/Orb6/GreenBoxTick.show()
		7:
			$TimeOrbs/Orb7/GreenBoxTick.show()
		8:
			$TimeOrbs/Orb8/GreenBoxTick.show()
		9:
			$TimeOrbs/Orb9/GreenBoxTick.show()
		10:
			$TimeOrbs/Orb10/GreenBoxTick.show()
		11:
			time_orb = 0
			on_game_event()
			hide_orbs()
			plyr.save(save_file_path)
		_:
			tout("_on_timer_tick err!")

func hide_orbs():
	$TimeOrbs/Orb1/GreenBoxTick.hide()
	$TimeOrbs/Orb2/GreenBoxTick.hide()
	$TimeOrbs/Orb3/GreenBoxTick.hide()
	$TimeOrbs/Orb4/GreenBoxTick.hide()
	$TimeOrbs/Orb5/GreenBoxTick.hide()
	$TimeOrbs/Orb6/GreenBoxTick.hide()
	$TimeOrbs/Orb7/GreenBoxTick.hide()
	$TimeOrbs/Orb8/GreenBoxTick.hide()
	$TimeOrbs/Orb9/GreenBoxTick.hide()
	$TimeOrbs/Orb10/GreenBoxTick.hide()
	
# Display
func update_display():
	$PlayerLabel.bbcode_text = "Commoner"
	
	if plyr.zlock > 0:
		$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\nTravelling: " + String(plyr.zlock)
	
	$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\nXP: " + String(plyr.xp)
	$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\n\n[color=red]VP: " + String(plyr.vp)
	$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + " / " + String(plyr.vpmax) + "[/color]"
	#$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\nItems: " + String(plyr.inv.size())
	$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\nSustenance: 5 / 5"
	$PlayerLabel.bbcode_text = $PlayerLabel.bbcode_text + "\n\nCoins: " + String(plyr.coins)


# Send text to screen
func tout(txt):
	$ColorRect/RichTextLabel.bbcode_text = $ColorRect/RichTextLabel2.bbcode_text
	$ColorRect/RichTextLabel2.bbcode_text = $ColorRect/RichTextLabel3.bbcode_text
	$ColorRect/RichTextLabel3.bbcode_text = $ColorRect/RichTextLabel4.bbcode_text
	$ColorRect/RichTextLabel4.bbcode_text = $ColorRect/RichTextLabel5.bbcode_text
	$ColorRect/RichTextLabel5.bbcode_text = $ColorRect/RichTextLabel6.bbcode_text
	$ColorRect/RichTextLabel6.bbcode_text = $ColorRect/RichTextLabel7.bbcode_text
	$ColorRect/RichTextLabel7.bbcode_text = $ColorRect/RichTextLabel8.bbcode_text
	$ColorRect/RichTextLabel8.bbcode_text = $ColorRect/RichTextLabel9.bbcode_text
	$ColorRect/RichTextLabel9.bbcode_text = $ColorRect/RichTextLabel10.bbcode_text
	$ColorRect/RichTextLabel10.bbcode_text = $ColorRect/RichTextLabel11.bbcode_text
	$ColorRect/RichTextLabel11.bbcode_text = $ColorRect/RichTextLabel12.bbcode_text
	$ColorRect/RichTextLabel12.bbcode_text = $ColorRect/RichTextLabel13.bbcode_text
	$ColorRect/RichTextLabel13.bbcode_text = $ColorRect/RichTextLabel14.bbcode_text
	$ColorRect/RichTextLabel14.bbcode_text = $ColorRect/RichTextLabel15.bbcode_text
	$ColorRect/RichTextLabel15.bbcode_text = $ColorRect/RichTextLabel16.bbcode_text
	$ColorRect/RichTextLabel16.bbcode_text = txt
