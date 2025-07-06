extends Polygon2D
var stiff = 2000
var damp = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"1".stiffness = stiff
	$"2".stiffness = stiff
	$"3".stiffness = stiff
	$"4".stiffness = stiff
	$"1".damping = damp
	$"2".damping = damp
	$"3".damping = damp
	$"4".damping = damp
	var size = DisplayServer.window_get_size()
	var points = PackedVector2Array([
		Vector2(0, 0),
		Vector2(size.x, 0),
		Vector2(size.x, size.y),
		Vector2(0, size.y)
	])
	DisplayServer.window_set_mouse_passthrough(points)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../Polygon2D".global_position = get_global_mouse_position()
	$".".global_position = get_global_mouse_position()
	$Skeleton2D/Bone2D.look_at($RigidBody2D.global_position)
	$Skeleton2D/Bone2D/Bone2D2.global_position = $RigidBody2D.global_position
	$"../Polygon2D3".global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("1"):
		$"../Polygon2D".show()
		$"../Polygon2D3".hide()
		$".".hide()
	if Input.is_action_just_pressed("2"):
		$".".show()
		$"../Polygon2D3".hide()
		$"../Polygon2D".hide()
	if Input.is_action_just_pressed("3"):
		$"../Polygon2D3".show()
		$"../Polygon2D".hide()
		$".".hide()
	pass
