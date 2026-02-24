extends Node2D

@onready var transition_fade: CanvasLayer = $TransitionFade

var player_in_exit := false
var transitioning := false


# =====================================================
# READY
# =====================================================
func _ready() -> void:
	# Start black and fade in
	transition_fade.color_rect.color.a = 1.0
	await transition_fade.fade_from_black(0.2)


# =====================================================
# INPUT CHECK (Reliable)
# =====================================================
func _process(_delta: float) -> void:
	if player_in_exit and not transitioning:
		if Input.is_action_just_pressed("accept"):
			change_to_area1()


# =====================================================
# EXIT AREA (Go back to Area 1)
# =====================================================
func _on_area_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player1":
		player_in_exit = true


func _on_area_exit_body_exited(body: Node2D) -> void:
	if body.name == "Player1":
		player_in_exit = false


func change_to_area1() -> void:
	if transitioning:
		return
	
	transitioning = true
	await transition_fade.fade_to_black(0.5)
	get_tree().change_scene_to_file("res://scenes/area/area_1.tscn")


# =====================================================
# INTERACTION ZONE (Go to Quiz)
# =====================================================
func _on_intearactionzone_body_entered(body: Node2D) -> void:
	if body.name != "Player1":
		return
	
	if transitioning:
		return
	
	# Freeze player if function exists
	if body.has_method("freeze"):
		body.freeze()
	
	transitioning = true
	call_deferred("_go_to_quiz")


func _go_to_quiz() -> void:
	await transition_fade.fade_to_black(0.5)
	get_tree().change_scene_to_file("res://editor/tasks/quizTask.tscn")
