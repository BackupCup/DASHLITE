extends TextureRect

var time_dict: Dictionary
var hour = 00
var minute = 00

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_time()
	update_text()
	

func update_time():
	if OS.has_feature("JavaScript"):
		time_dict = JavaScriptBridge.eval("new Date().toISOString()")
	else:
		time_dict = Time.get_datetime_dict_from_system(false)
	
	if "hour" in time_dict:
		hour = time_dict["hour"]
		minute = time_dict["minute"]

func update_text():
	if hour > 12:
		$TimeOfDay.text = "PM"
	else:
		$TimeOfDay.text = "AM"
	
	if hour > 12:
		hour -= 12
	if hour < 10:
		$Hour.text = "0" + str(hour)
	else:
		$Hour.text = str(hour)
	
	
	if minute < 10:
		$Minute.text = "0" + str(minute)
	else:
		$Minute.text = str(minute)
