extends Node2D

const cost = 300
var dragging = false
var can_shoot = true
var hightlighted = false
var clicked = false

@export var bullet : PackedScene
var firingspeed = 5
var cooldown = 0.1

#modules
var bulletmodule_spin = true
var bulletmodule_homing = true
var bulletmodule_piercing = false
var bulletmodule_blade = true

func shoot():
	var prjctl = bullet.instantiate()
	prjctl.position = global_position
	prjctl._position = $AdvancedTargetingSystems.global_position
	
	if bulletmodule_spin:
		prjctl.module_spin = true
	if bulletmodule_homing:
		prjctl.module_homing = true
	if bulletmodule_piercing:
		prjctl.module_piercing = true
	if bulletmodule_blade:
		prjctl.module_blade = true
	
	get_tree().root.add_child(prjctl)

func _process(delta):
	if can_shoot:
		if cooldown <= 0:
			shoot()
			cooldown = firingspeed
		else:
			cooldown -= delta
	
	if dragging:
		var mouse_motion = InputEventMouseMotion
		if mouse_motion:
			global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("left_mouse"):
			dragging = false
		if Input.is_action_just_pressed("right_mouse"):
			GlobalInfo.money += cost
			queue_free()
		
		can_shoot = false
	else: can_shoot = true
	
	if hightlighted:
		$Outline.visible = true
		if Input.is_action_just_pressed("left_mouse"):
			clicked = true
	elif not hightlighted and not clicked:
		$Outline.visible = false
	
	if clicked:
		if (Input.is_action_just_pressed("left_mouse") and not hightlighted) or Input.is_action_just_pressed("right_mouse"):
			clicked = false
		$AdvancedTargetingSystems/Crosshairs.visible = true
	else:
		$AdvancedTargetingSystems/Crosshairs.visible = false


func _on_highligt_area_mouse_entered():
	hightlighted = true
func _on_highligt_area_mouse_exited():
	hightlighted = false
