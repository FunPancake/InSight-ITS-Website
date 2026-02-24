extends Node2D
@onready var transition_fade: CanvasLayer = $TransitionFade


var player_inside := false
var transitioning := false

func _ready() -> void:
	transition_fade.color_rect.color.a = 1.0
	await transition_fade.fade_from_black(3.0)

func _on_area_exit_body_entered(_body: Node2D) -> void:
	if _body.name != "Player1":
		return
	
	player_inside = true
	$areaExit.set_deferred("monitoring", false)
	
func _unhandled_input(event: InputEvent) -> void:
	if player_inside and not transitioning:
		if event.is_action_pressed("accept"):
			
			change_area()


func change_area() -> void:
	transitioning = true
	
	await transition_fade.fade_to_black(0.5)
	get_tree().change_scene_to_file("res://scenes/area/area_2.tscn")
