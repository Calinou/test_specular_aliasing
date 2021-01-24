extends Camera3D

# The factor to use for mega-resolution screenshots
# FIXME: This doesn't work due to not waiting for a frame before taking the screenshot.
const MEGA_RESOLUTION_FACTOR = 4


func _input(event):
	if Input.is_key_pressed(KEY_F12):
		var viewport := get_tree().root.get_viewport()

		var mega_resolution := false
		if Input.is_key_pressed(KEY_SHIFT):
			mega_resolution = true
			viewport.size *= MEGA_RESOLUTION_FACTOR

		RenderingServer.viewport_set_clear_mode(viewport.get_viewport_rid(), SubViewport.CLEAR_MODE_ONCE)
		var image := viewport.get_texture().get_data()
		RenderingServer.viewport_set_clear_mode(viewport.get_viewport_rid(), SubViewport.CLEAR_MODE_ALWAYS)

		if mega_resolution:
			# Don't check for pressed key as it may have been released since the screenshot was taken.
			viewport.size /= MEGA_RESOLUTION_FACTOR

		# Screenshot file name with ISO 8601-like date.
		var datetime := OS.get_datetime()
		for key in datetime:
			datetime[key] = str(datetime[key]).pad_zeros(2)

		var error := image.save_png(
				"user://{year}-{month}-{day}_{hour}.{minute}.{second}.png" \
						.format(datetime)
		)

		if error != OK:
			push_error("Couldn't save screenshot (error code %d)." % error)
