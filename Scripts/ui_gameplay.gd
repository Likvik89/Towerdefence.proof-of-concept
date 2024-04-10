extends Control

@export var tower : PackedScene


func _process(delta):
	$HBoxContainer/Life.text = str(GlobalInfo.health)
	$HBoxContainer/Money.text = str(GlobalInfo.money)
	$HBoxContainer/Wave.text = str(GlobalInfo.current_wave+1)
	if GlobalInfo.wave_completed:
		$NextRound.visible = true
	else:
		$NextRound.visible = false
	
	if GlobalInfo.health <= 0:
		$HBoxContainer.visible = false
		$NextRound.visible = false
		$GameOver.visible = true


func _on_tower_pressed():
	var towr = tower.instantiate()
	towr.dragging = true
	if GlobalInfo.money >= towr.cost:
		get_tree().root.add_child(towr)
		GlobalInfo.money -= towr.cost

func _on_next_round_pressed():
	GlobalInfo.wave_completed = false
	GlobalInfo.current_wave += 1


func _on_retry_pressed():
	GlobalInfo.health = GlobalInfo.starting_health
	GlobalInfo.money = GlobalInfo.starting_money
	GlobalInfo.current_wave = 0
	get_tree().change_scene_to_file("res://Scenes/lvl.tscn")


func _on_quit_pressed():
	get_tree().quit()
	
