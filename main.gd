extends "res://start_vr.gd"

var vp : Viewport
var env : Environment

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

	vp = get_xr_viewport()
	env = $World/WorldEnvironment.environment

	$Player/GPUTime.set_viewport(vp)

	$GlowButton.button_pressed = env.glow_enabled
	$MSAAButton.button_pressed = vp.msaa_3d != Viewport.MSAA_DISABLED

	if xr_interface:
		$RenderSize/Label3D.text = "Render size
%0.1f" % [xr_interface.render_target_size_multiplier]

		$Passthrough.button_pressed = xr_interface.environment_blend_mode != XRInterface.XR_ENV_BLEND_MODE_OPAQUE
		$World.floor_visible = not $Passthrough.button_pressed

	$VRS.button_pressed = vp.vrs_mode == Viewport.VRS_XR

func _on_glow_button_button_toggled(is_pressed):
	print("Glow", "enabled" if is_pressed else "disabled")
	env.glow_enabled = is_pressed


func _on_msaa_button_button_toggled(is_pressed):
	print("MSAA", "enabled" if is_pressed else "disabled")
	vp.msaa_3d = Viewport.MSAA_4X if is_pressed else Viewport.MSAA_DISABLED


func _on_quit_button_button_toggled(_is_pressed):
	get_tree().quit()


func _on_render_size_button_toggled(_is_pressed: Variant) -> void:
	if xr_interface:
		if xr_interface.render_target_size_multiplier == 1.0:
			xr_interface.render_target_size_multiplier = 2.0
		elif xr_interface.render_target_size_multiplier == 2.0:
			xr_interface.render_target_size_multiplier = 0.5
		else:
			xr_interface.render_target_size_multiplier = 1.0

		$RenderSize/Label3D.text = "Render size
%0.1f" % [xr_interface.render_target_size_multiplier]

		print("Render target size multiplier set to ", xr_interface.render_target_size_multiplier)


func _on_passthrough_button_toggled(_is_pressed: Variant) -> void:
	if xr_interface:
		if xr_interface.environment_blend_mode == XRInterface.XR_ENV_BLEND_MODE_OPAQUE:
			# TODO: switch between ALPHA_BLEND and ADDITIVE depending on what is available...
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
			vp.transparent_bg = true
			env.background_mode = Environment.BG_CLEAR_COLOR
			env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
			$World.floor_visible = false
		else:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_OPAQUE
			vp.transparent_bg = false
			env.background_mode = Environment.BG_SKY
			env.ambient_light_source = Environment.AMBIENT_SOURCE_BG
			$World.floor_visible = true

		$Passthrough.button_pressed = xr_interface.environment_blend_mode != XRInterface.XR_ENV_BLEND_MODE_OPAQUE


func _on_vrs_button_toggled(is_pressed):
	print("VRS", "enabled" if is_pressed else "disabled")
	vp.vrs_mode = Viewport.VRS_XR if is_pressed else Viewport.VRS_DISABLED
