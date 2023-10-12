extends Node

func save_encrypted_file(filepath, data, password):
	var fs = File.new()
	fs.open_encrypted_with_pass(filepath, fs.WRITE, password)
	fs.store_line(JSON.print(data))
	fs.close()

func load_encrypted_file(filepath, password):
	var fs = File.new()
	var loadfile = fs.open_encrypted_with_pass(filepath, fs.READ, password)
	if loadfile > 0:
		return {"error":true}

	var data = parse_json(fs.get_line())
	if data == null:
		return {"error":true}

	fs.close()
	return data


func save_json_to_file(filepath, data):
	var fs = File.new()
	var save_error = fs.open(filepath, fs.WRITE)
	
	if save_error:
		print("save_error: ", save_error)
	
	fs.store_line(JSON.print(data))
	fs.close()

func load_json_from_file(filepath):
	var fs = File.new()
	var open = fs.open(filepath, File.READ)
	if open > 0:
		return {"error":true}

	var data = JSON.parse(fs.get_line())
	fs.close()
	if data == null:
		return {"error":true}
	
	if data.result:
		return data.result
		
	return {"error":true}

func delete_file(filepath):
	var dir = Directory.new()
	return dir.remove(filepath)
