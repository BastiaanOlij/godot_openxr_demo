extends XRController3D

var trigger_was_pressed : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var trigger : float = get_float("trigger")
	var trigger_pressed : bool = trigger > (0.4 if trigger_was_pressed else 0.6)
	if trigger_pressed and !trigger_was_pressed:
		print("Trigger just pressed")
		trigger_haptic_pulse("haptic", 0.0, 1.0, 0.1, 0.0)

	trigger_was_pressed = trigger_pressed
