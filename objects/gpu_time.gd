extends Label3D

var vp : Viewport

var times : Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	vp = get_viewport()

	if RenderingServer.get_rendering_device():
		RenderingServer.viewport_set_measure_render_time(vp.get_viewport_rid(), true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var resolution : Vector2i = Vector2i()

	var openxr_interface : OpenXRInterface = XRServer.find_interface("OpenXR")
	if openxr_interface:
		resolution = openxr_interface.get_render_target_size()

	if RenderingServer.get_rendering_device():
		times.push_back(RenderingServer.viewport_get_measured_render_time_gpu(vp.get_viewport_rid()))
		if times.size() > 100:
			times.pop_front()

		var min_time : float = times[0]
		var max_time : float = times[0]
		var avg_time : float = 0.00

		for time in times:
			if time < min_time:
				min_time = time
			if time > max_time:
				max_time = time
			avg_time += time

		avg_time = avg_time / times.size()

		text = "Res: %d, %d
GPU time:
min: %0.3fms
max: %0.3fms
avg: %0.3fms" % [resolution.x, resolution.y, min_time, max_time, avg_time]
	else:
		text = "Res: %d, %d
FPS: %d" % [resolution.x, resolution.y, Engine.get_frames_per_second()]
