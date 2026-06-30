extends Node

func _process(_delta: float) -> void:
	# Only print once per second (every 60 frames) to avoid console lag
	if Engine.get_process_frames() % 60 != 0:
		return
		
	print("--- VMC Tracker Debug [", Time.get_ticks_msec(), "] ---")
	
	# In Godot 4, this returns a Dictionary of all active trackers 
	# (Keys = Tracker Names, Values = XRTracker objects)
	var trackers: Dictionary = XRServer.get_trackers(XRServer.TRACKER_ANY)
	
	if trackers.is_empty():
		print("No XR trackers found. Is the plugin enabled and Waidayo sending to port 39539?")
		return
		
	for tracker_name in trackers:
		var tracker = trackers[tracker_name]
		print("Active Tracker: ", tracker_name, " (Class: ", tracker.get_class(), ")")
		
		# Check for facial blendshape data
		if tracker is XRFaceTracker:
			# Godot 4.3+ has standard built-in enums for the 52 ARKit blendshapes
			var jaw_val = tracker.get_blend_shape(XRFaceTracker.FT_JAW_OPEN)
			print("  -> Jaw Open Value: ", jaw_val)
			
		# Check for body/head bone data
		if tracker is XRBodyTracker:
			# Check the head joint's location in 3D space
			var head_transform = tracker.get_joint_transform(XRBodyTracker.JOINT_HEAD)
			print("  -> Head Position: ", head_transform.origin)
			head_transform = tracker.get_joint_transform(XRBodyTracker.JOINT_HEAD)
			# rotation in radians (X, Y, Z)
			print("  -> Head Rotation: ", head_transform.basis.get_euler())
			# Skeleton root position
			var hips_transform = tracker.get_joint_transform(XRBodyTracker.JOINT_HIPS)
			print("  -> Hips Position: ", hips_transform.origin)
			var l_shoulder_transform = tracker.get_joint_transform(XRBodyTracker.JOINT_LEFT_SHOULDER)
			var r_shoulder_transform = tracker.get_joint_transform(XRBodyTracker.JOINT_RIGHT_SHOULDER)
			print("  -> Shoulder Transforms: ")
			print("     -> L:", l_shoulder_transform)
			print("     -> R:", r_shoulder_transform)
