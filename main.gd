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
	_update_vrs_buttons()

func _on_glow_button_button_toggled(is_pressed):
	print("Glow", "enabled" if is_pressed else "disabled")
	env.glow_enabled = is_pressed


func _on_msaa_button_button_toggled(is_pressed):
	print("MSAA", "enabled" if is_pressed else "disabled")
	vp.msaa_3d = Viewport.MSAA_4X if is_pressed else Viewport.MSAA_DISABLED


func _on_quit_button_button_toggled(is_pressed):
	get_tree().quit()


func _update_vrs_buttons():
	if vp.vrs_mode == Viewport.VRS_XR:
		$VRSOffButton.button_pressed = false
		$VRSLowButton.button_pressed = xr_interface.xr_vrs_strength == 1.0
		$VRSMidButton.button_pressed = xr_interface.xr_vrs_strength == 5.0
		$VRSHighButton.button_pressed = xr_interface.xr_vrs_strength == 10.0
	else:
		$VRSOffButton.button_pressed = true
		$VRSLowButton.button_pressed = false
		$VRSMidButton.button_pressed = false
		$VRSHighButton.button_pressed = false


func _on_vrs_off_button_button_toggled(is_pressed: Variant) -> void:
	vp.vrs_mode = Viewport.VRS_DISABLED
	_update_vrs_buttons()


func _on_vrs_low_button_button_toggled(is_pressed: Variant) -> void:
	vp.vrs_mode = Viewport.VRS_XR
	xr_interface.xr_vrs_strength = 1.0
	vp.vrs_update_mode = Viewport.VRS_UPDATE_ONCE
	_update_vrs_buttons()


func _on_vrs_mid_button_button_toggled(is_pressed: Variant) -> void:
	vp.vrs_mode = Viewport.VRS_XR
	xr_interface.xr_vrs_strength = 5.0
	vp.vrs_update_mode = Viewport.VRS_UPDATE_ONCE
	_update_vrs_buttons()


func _on_vrs_high_button_button_toggled(is_pressed: Variant) -> void:
	vp.vrs_mode = Viewport.VRS_XR
	xr_interface.xr_vrs_strength = 10.0
	vp.vrs_update_mode = Viewport.VRS_UPDATE_ONCE
	_update_vrs_buttons()
