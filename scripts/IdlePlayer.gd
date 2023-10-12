class_name IdlePlayer
extends Node

var coins = 0
var events = {"total":0}
var inv = []
var invmax = 3
var first_save
var last_save
var sus = 5
var susmax = 5
var vp = 5
var vpmax = 5
var world = {}
var xp = 0
var zlock = 2
var zone = "dawnview"

func save(filepath):
	var time_dict = Time.get_datetime_string_from_system()
	var savedata = {
		coins=coins,
		events=events,
		inv=inv,
		invmax=invmax,
		vp=vp,
		vpmax=vpmax,
		world=world,
		xp=xp,
		zlock=zlock,
		zone=zone,
		first_save=first_save,
		last_save=time_dict
	}
	#print("Saving data: ", savedata)
	C4Files.save_encrypted_file(filepath, savedata, "C4Studios-IV-Player")

func attempt_load(filepath):
	var data = C4Files.load_encrypted_file(filepath, "C4Studios-IV-Player")
	if data == null:
		return false
	
	#print(data)
	if "error" in data:
		return false
	
	coins = data.coins
	events = data.events
	inv = data.inv
	invmax = data.invmax
	first_save = data.first_save
	last_save = data.last_save
	vp = data.vp
	vpmax = data.vpmax
	world = data.world
	xp = data.xp
	zlock = data.zlock
	zone = data.zone
	return true


func add_coins(amt:int):
	coins += amt

func add_inv(item: Dictionary):
	if inv.size() >= invmax:
		return false
	
	inv.push_back(item)
	return true

func add_vp(amt:int):
	vp += amt
	if vp > vpmax:
		vp = vpmax

func add_xp(amt:int):
	xp += amt

func subtract_coins(amt:int):
	coins -= amt
	if coins < 0:
		coins = 0
		return false
	return true
	
func subtract_vp(amt:int):
	vp -= amt
	if vp < 0:
		vp = 0
	return vp
	
