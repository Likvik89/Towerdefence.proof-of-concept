extends Control

@export var tower : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tower_pressed():
	var towr = tower.instantiate()
	towr.dragging = true
	
	if GlobalInfo.money >= towr.cost:
		get_tree().root.add_child(towr)
		GlobalInfo.money -= towr.cost
