extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.color = Color(0, 0, 0, 0) # fully transparent


# Fade OUT (to black)
func fade_to_black(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, duration)
	await tween.finished


# Fade IN (from black)
func fade_from_black(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, duration)
	await tween.finished
