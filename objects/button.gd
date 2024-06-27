extends Node3D

signal button_toggled(is_pressed)

@export var button_pressed : bool = false:
	set(value):
		button_pressed = value
		if is_inside_tree():
			_update_button_pressed()

var bodies : Array = Array()
var timeout = false

func _update_button_pressed():
	$OffButton.visible = !button_pressed
	$OnButton.visible = button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_button_pressed()


func _on_hand_detector_body_entered(body):
	if bodies.size() == 0 and !timeout:
		button_pressed = !button_pressed
		button_toggled.emit(button_pressed)

	if !bodies.has(body):
		bodies.push_back(body)


func _on_hand_detector_body_exited(body):
	if bodies.has(body):
		bodies.erase(body)


	if bodies.size() == 0 and !timeout:
		timeout = true
		$Timeout.start()


func _on_timeout_timeout():
	timeout = false
