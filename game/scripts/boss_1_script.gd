class_name Boss1 extends CharacterBody2D

@onready var anim = $animation/AnimatedSprite2D

func _physics_process(_delta):
	anim.play("idle")
