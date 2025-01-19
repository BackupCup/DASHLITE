extends Node2D

const transition_speed = 0.05
const debugMode = false

@export var cameraSize: Vector2

var time_dict: Dictionary
var lerp_day_alpha: float = 0.0
var lerp_dusk_alpha: float = 0.0
var lerp_night_alpha: float = 0.0

# Debug Time Simulation Variables
var time_multiplier = 2.0
var simulated_time_of_day = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_real_time()
	update_textures()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if debugMode:
		simulate_fast_time(delta)
	else:
		update_real_time()
	update_textures()

func update_real_time():
	if OS.has_feature("JavaScript"):
		time_dict = JavaScriptBridge.eval("new Date().toISOString()")
	else:
		time_dict = Time.get_datetime_dict_from_system(false)
	
	if "hour" in time_dict:
		var hour = time_dict["hour"]
		var minute = time_dict["minute"]
		
		# Normalize time (use a value from 0 to 1 representing the full day cycle)
		var time_of_day = (hour + minute / 60.0) / 24.0
		
		# Use sine wave for smooth transitions between textures (day -> dusk -> night -> dusk -> day)
		var sine_wave = (sin((time_of_day - 0.25) * 2.0 * PI) + 1.0) / 2.0
		
		var day_strength = clamp(sine_wave * 2.0 - 1.0, 0.0, 1.0)
		var night_strength = clamp((1.0 - sine_wave) * 2.0 - 1.0, 0.0, 1.0)
		var dusk_strength = 1.0 - abs(sine_wave * 2.0 - 1.0)
		
		# Lerp alpha values based on the sine wave result
		lerp_day_alpha = lerp(lerp_day_alpha, day_strength, transition_speed)
		lerp_dusk_alpha = lerp(lerp_dusk_alpha, dusk_strength, transition_speed)
		lerp_night_alpha = lerp(lerp_night_alpha, night_strength, transition_speed)

func update_textures():
	$TextureDay.modulate.a = lerp_day_alpha
	$TextureDusk.modulate.a = lerp_dusk_alpha
	$TextureNight.modulate.a = lerp_night_alpha

func simulate_fast_time(delta):
	# Simulate the passage of time at a faster rate
	simulated_time_of_day += delta * time_multiplier / 60.0
	if simulated_time_of_day > 1.0:
		simulated_time_of_day = 0.0 # Reset the time after 1 full cycle (1 day)
	
	# Update the time based on the simulated fast time
	update_simulated_time(simulated_time_of_day)

func update_simulated_time(time_of_day):
	# Use the simulated time value for transitions
	var sine_wave = (sin(time_of_day * 2.0 * PI) + 1.0) / 2.0
	
	var day_strength = clamp(sine_wave * 2.0 - 1.0, 0.0, 1.0)
	var night_strength = clamp((1.0 - sine_wave) * 2.0 - 1.0, 0.0, 1.0)
	var dusk_strength = 1.0 - abs(sine_wave * 2.0 - 1.0)
	
	 # Lerp alpha values based on the simulated sine wave result
	lerp_day_alpha = lerp(lerp_day_alpha, day_strength, transition_speed)
	lerp_dusk_alpha = lerp(lerp_dusk_alpha, dusk_strength, transition_speed)
	lerp_night_alpha = lerp(lerp_night_alpha, night_strength, transition_speed)
