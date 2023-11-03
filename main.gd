extends "res://start_vr.gd"

var vp : Viewport
var env : Environment

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

	vp = get_viewport()
	env = $World/WorldEnvironment.environment

	$GlowButton.button_pressed = env.glow_enabled
	$MSAAButton.button_pressed = vp.msaa_3d != Viewport.MSAA_DISABLED

func _on_glow_button_button_toggled(is_pressed):
	print("Glow", "enabled" if is_pressed else "disabled")
	env.glow_enabled = is_pressed


func _on_msaa_button_button_toggled(is_pressed):
	print("MSAA", "enabled" if is_pressed else "disabled")
	vp.msaa_3d = Viewport.MSAA_4X if is_pressed else Viewport.MSAA_DISABLED


func _on_quit_button_button_toggled(is_pressed):
	get_tree().quit()
