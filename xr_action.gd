extends Node
class_name XRAction

# This is a signal broker that will react to an action change on any tracker.
# This should really be build into OpenXRInterface but for now this will do.

signal button_pressed(tracker)
signal button_released(tracker)
signal input_float_changed(value, tracker)
signal input_vector2_changed(value, tracker)
signal pose_changed(pose, tracker)
signal pose_lost_tracking(pose, tracker)

@export_enum("bool","float","vector2","pose") var type : int = 0:
	set(value):
		if is_inside_tree():
			_unsubscribe_all()

		type = value

		if is_inside_tree():
			_subscribe_all()

@export var action : String

func _button_pressed(action_name : String, tracker : XRPositionalTracker):
	if action_name == action:
		button_pressed.emit(tracker)

func _button_released(action_name : String, tracker : XRPositionalTracker):
	if action_name == action:
		button_released.emit(tracker)

func _input_float_changed(action_name : String, value : float, tracker : XRPositionalTracker):
	if action_name == action:
		input_float_changed.emit(value, tracker)

func _input_vector2_changed(action_name : String, value : Vector2, tracker : XRPositionalTracker):
	if action_name == action:
		input_vector2_changed.emit(value, tracker)

func _pose_changed(pose : XRPose, tracker : XRPositionalTracker):
	if pose.name == action:
		pose_changed.emit(pose, tracker)

func _pose_lost_tracking(pose : XRPose, tracker : XRPositionalTracker):
	if pose.name == action:
		pose_lost_tracking.emit(pose, tracker)

# New tracker added
func _tracker_added(tracker_name, _tracker_type):
	var tracker : XRPositionalTracker = XRServer.get_tracker(tracker_name)
	if tracker:
		if (type == 0):
			tracker.button_pressed.connect(_button_pressed.bind(tracker))
			tracker.button_released.connect(_button_released.bind(tracker))
		elif (type == 1):
			tracker.input_float_changed.connect(_input_float_changed.bind(tracker))
		elif (type == 2):
			tracker.input_vector2_changed.connect(_input_vector2_changed.bind(tracker))
		elif (type == 3):
			tracker.pose_changed.connect(_pose_changed.bind(tracker))
			tracker.pose_lost_tracking.connect(_pose_lost_tracking.bind(tracker))

# tracker removed
func _tracker_removed(tracker_name, _tracker_type):
	var tracker : XRPositionalTracker = XRServer.get_tracker(tracker_name)
	if tracker:
		if (type == 0):
			tracker.button_pressed.disconnect(_button_pressed.bind(tracker))
			tracker.button_released.disconnect(_button_released.bind(tracker))
		elif (type == 1):
			tracker.input_float_changed.disconnect(_input_float_changed.bind(tracker))
		elif (type == 2):
			tracker.input_vector2_changed.disconnect(_input_vector2_changed.bind(tracker))
		elif (type == 3):
			tracker.pose_changed.disconnect(_pose_changed.bind(tracker))
			tracker.pose_lost_tracking.disconnect(_pose_lost_tracking.bind(tracker))

# Unsubscribe from all trackers
func _unsubscribe_all():
	var trackers = XRServer.get_trackers(XRServer.TRACKER_ANY)
	for tracker in trackers:
		_tracker_removed(tracker, XRServer.TRACKER_ANY)

# Subscribe to all trackers
func _subscribe_all():
	var trackers = XRServer.get_trackers(XRServer.TRACKER_ANY)
	for tracker in trackers:
		_tracker_added(tracker, XRServer.TRACKER_ANY)

# When we're added to the tree
func _enter_tree():
	_subscribe_all()
	XRServer.connect("tracker_added", _tracker_added)
	XRServer.connect("tracker_removed", _tracker_removed)

# When we get removed from the tree
func _remove_tree():
	XRServer.disconnect("tracker_added", _tracker_added)
	XRServer.disconnect("tracker_removed", _tracker_removed)
	_unsubscribe_all()
