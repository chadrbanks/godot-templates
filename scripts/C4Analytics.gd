extends Node

var https = [HTTPRequest.new(), HTTPRequest.new(), HTTPRequest.new()]

var base_url

func _ready():
	for i in [4,5]:
		https.push_back(HTTPRequest.new())
	
	for http in https:
		add_child(http)
	
	if C4Singleton.env == "prod":
		base_url = "https://3px0unf8c6.execute-api.us-east-2.amazonaws.com/prod/"
		print("Sending data to prod!")
	else:
		base_url = "https://cnuoan76v1.execute-api.us-east-2.amazonaws.com/beta/"
		print("Sending data to beta...")
		
	send_event("c4_boot")

func send_event(event):
	print("sending event: ", event)
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	var body = {
		"service":"IV",
		"event":event,
		"data":{
			"build":C4Singleton.build,
			"device":C4Singleton.device_id,
			"env":C4Singleton.env
		},
	}
	
	for http in https:
		if http.get_http_client_status() == 0:
			var error = http.request(base_url + "event", headers, true, method, JSON.print(body))
			if error != OK:
				push_error(" An error occured in the analytic send_event request!")
			return
	
	print("send_event issue!")

func send_event_obj(obj):
	if !"event" in obj:
		print("Error: event:String property is required!")
		return
	
	print("sending event: ", obj)
	var headers = ["Content-Type: application/json"]
	var method = HTTPClient.METHOD_POST
	obj.service = "OCT"
	obj.data.build = C4Singleton.build
	obj.data.device_id = C4Singleton.device_id
	obj.data.env = C4Singleton.env

	for http in https:
		if http.get_http_client_status() == 0:
			var error = http.request(base_url + "event", headers, true, method, JSON.print(obj))
			if error != OK:
				push_error(" An error occured in the analytic send_event_obj request!")
			return
	
	print("send_event_obj issue!")


func get_version():
	for http in https:
		var error = http.request(base_url + "version")
		if error != OK:
			push_error(" An error occured in the analytic get_version request!")
		return
	
	print("get_version issue!")

# Saving for get_version later
#func onHTTPRequestCompleted( _result, _response_code, _headers, body ):
#	var test_json_conv = JSON.new()
#	test_json_conv.parse(body.get_string_from_utf8())
#	var json = test_json_conv.get_data()
#	print(json.result)

