class_name Player
extends CharacterBody2D

@export var speed = 10.0
@export var run_multiplier = 1.8
@export var jump_H = 10.0

var speed_mult = 30
var jump_mult = -30
var is_interacting = false
var locked := false

@onready var anim = $animation/AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if locked:
		# Stop all movement when locked
		velocity.x = 0
		move_and_slide()
		return  # skip normal movement

	# Apply gravity if in air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_H * jump_mult

	# Running and horizontal movement
	var is_running = Input.is_action_pressed("run")
	var direction := Input.get_axis("move_left", "move_right")

	# Interaction animation
	if Input.is_action_just_pressed("accept") and not is_interacting:
		is_interacting = true
		anim.play("interaction")
		await anim.animation_finished
		is_interacting = false

	if direction:
		var current_speed = speed * speed_mult
		if is_running:
			current_speed *= run_multiplier
		velocity.x = direction * current_speed
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_mult)

	# Animations
	if not is_interacting:
		if not is_on_floor():
			if velocity.x != 0:
				anim.play("jumping")
			else:
				anim.play("jumping front")
		elif direction != 0:
			if is_running:
				anim.play("running")
			else:
				anim.play("walking")
		else:
			anim.play("idle")
	
	move_and_slide()

# =====================================================
# Freeze player for interaction / scene transitions
# =====================================================
func freeze():
	locked = true
	velocity = Vector2.ZERO
	anim.play("idle")  # optional, reset animation

# Optional: Unlock player (after returning from quiz)
func unfreeze():
	locked = false
