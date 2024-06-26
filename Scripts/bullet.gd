extends RigidBody2D

#Basic info
var _position
var speed = 100
var damage = 10
var lifespan = 10

#modules
var module_spin = false
var rotationspeed = 14

var module_homing = false
var homing_speed = 7
var closest_homing_target

var module_piercing = false
var max_pierce = 2
var current_pierce = 0

var module_blade = false
var blade_damage = 10
@export var bullet_blade : PackedScene

var module_seeking = false
var seeking_speed = 4
const max_seeking_speed = 300


func _ready():
	if module_blade:
		var blade = bullet_blade.instantiate()
		blade.damage = blade_damage
		add_child(blade)
	
	var direction = (_position-position).normalized()
	rotation = Vector2.RIGHT.angle_to(direction)+PI/2
	
	if module_seeking:
		linear_velocity = direction*speed/2
	else:
		linear_velocity = direction*speed

#homing
func _physics_process(delta):
	#homing
	if module_homing:
		for target in $"Homing area".get_overlapping_bodies():
			if target.is_in_group("enemies"):
				if closest_homing_target != null:
					if global_position.distance_to(target.global_position) < global_position.distance_to(closest_homing_target.global_position):
						closest_homing_target = target
				else:
					closest_homing_target = target
		if closest_homing_target != null:
			var direction = (closest_homing_target.global_position-global_position).normalized()
		
			linear_velocity += direction*homing_speed
	
	#seeking
	if module_seeking:
		var direction = (get_global_mouse_position()-global_position).normalized()
		
		if linear_velocity.length() <= max_seeking_speed:
			
			linear_velocity += direction*seeking_speed
		

#Spinning
func _process(delta):
	#Spinning woo!
	if module_spin and angular_velocity <= rotationspeed:
		angular_velocity += rotationspeed
	
	if lifespan <= 0:
		queue_free()
	else:
		lifespan -= delta

#bullet hit detection
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		if module_piercing:
			current_pierce += 1
			if current_pierce >= max_pierce:
				queue_free()
		else:
			queue_free()

