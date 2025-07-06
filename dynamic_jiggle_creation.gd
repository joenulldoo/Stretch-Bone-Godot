class_name PolyStretchJiggle2D
extends Node2D
@export var mass: float = 10
@export var stiffness: float = 2000
@export var damping: float = 10
@export var length: float = 100
@export var allow_stretch: bool = true
@export var allow_rotation: bool = true
var frame = 0
var spring1
var spring2
var spring3
var spring4
var static1
var static2
var static3
var static4
var physObj
var testimage
var container
var loaded = 0
var objects = {}

func _ready() -> void:
	for child in get_parent().get_children():
		if child is Bone2D:
			container = Node2D.new()
			child.get_parent().get_parent().call_deferred("add_child", container)
			container.position = child.position
			spring1 = DampedSpringJoint2D.new()
			spring2 = DampedSpringJoint2D.new()
			spring3 = DampedSpringJoint2D.new()
			spring4 = DampedSpringJoint2D.new()
			static1 = StaticBody2D.new()
			static2 = StaticBody2D.new()
			static3 = StaticBody2D.new()
			static4 = StaticBody2D.new()
			physObj = RigidBody2D.new()
			#testimage = Sprite2D.new()
			#testimage.texture = load("res://icon.svg")
			#testimage.scale = Vector2(0.05, 0.05)
			spring1.position = child.position
			spring1.length = length
			spring1.global_position.y -= length
			spring2.position = child.position
			spring2.length = length
			spring2.global_position.y += length
			spring2.rotation_degrees = 180
			spring3.position = child.position
			spring3.length = length
			spring3.global_position.x -= length
			spring3.rotation_degrees = -90
			spring4.position = child.position
			spring4.length = length
			spring4.global_position.x += length
			spring4.rotation_degrees = -270
			static1.position = spring1.position
			static2.position = spring2.position
			static3.position = spring3.position
			static4.position = spring4.position
			physObj.position = child.position
			spring1.stiffness = stiffness
			spring2.stiffness = stiffness
			spring3.stiffness = stiffness
			spring4.stiffness = stiffness
			spring1.damping = damping
			spring2.damping = damping
			spring3.damping = damping
			spring4.damping = damping
			physObj.mass = mass
			physObj.gravity_scale = 0
			container.call_deferred("add_child", spring1)
			container.call_deferred("add_child", spring2)
			container.call_deferred("add_child", spring3)
			container.call_deferred("add_child", spring4)
			container.call_deferred("add_child", static1)
			container.call_deferred("add_child", static2)
			container.call_deferred("add_child", static3)
			container.call_deferred("add_child", static4)
			container.call_deferred("add_child", physObj)
			#physObj.call_deferred("add_child", testimage)
			objects[child] = physObj

func _process(delta: float) -> void:
	frame += 1
	if frame == 1:
		spring1.node_a = static1.get_path()
		spring2.node_a = static2.get_path()
		spring3.node_a = static3.get_path()
		spring4.node_a = static4.get_path()
		spring1.node_b = physObj.get_path()
		spring2.node_b = physObj.get_path()
		spring3.node_b = physObj.get_path()
		spring4.node_b = physObj.get_path()
	for child in get_parent().get_children():
		#container.position = container.get_parent().to_local(child.global_position)
		#container.position = get_parent().get_parent().get_node("Bone2D").position
		if child is Bone2D:
			var bones = []
			for child2 in child.get_children():
				if child2 is Bone2D:
					bones.append(child2)
			if bones.is_empty():
				var newBone = Bone2D.new()
				var pos = child.global_position # starting vector
				var angle = deg_to_rad(child.global_rotation_degrees)
				var distance = child.get_length()
				var direction = Vector2(cos(angle), sin(angle)).normalized()
				var new_pos = pos + direction * distance
				newBone.global_position = new_pos
				child.add_child(newBone)
				bones.append(newBone)
			else:
				for bone in bones:
					if allow_stretch:
						bone.position = objects[child].position
					if allow_rotation:
						get_parent().rotation_degrees = 0
						get_parent().look_at(to_global(physObj.position))
