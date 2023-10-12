extends Node

func add_commas(number : String) -> String:
	var i : int = number.length() - 3
	while i > 0:
		number = number.insert(i, ",")
		i = i - 3
	return number

func roll(num):
	match(num):
		"d1":
			return 1
		"d2":
			return int(floor(rand_range(1, 3)))
		"d4":
			return int(floor(rand_range(1, 5)))
		"d6":
			return int(floor(rand_range(1, 7)))
		"d10":
			return int(floor(rand_range(1, 11)))
		"d12":
			return int(floor(rand_range(1, 13)))
		"d20":
			return int(floor(rand_range(1, 21)))
		"d100":
			var r  = int(floor(rand_range(1, 101)))
			return r
		"2d6":
			return [(int(floor(rand_range(1, 7)))),(int(floor(rand_range(1, 7))))]
	
	return int(floor(rand_range(1, 101)))
