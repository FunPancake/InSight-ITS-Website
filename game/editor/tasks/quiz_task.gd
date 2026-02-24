extends Control

var questions = []
var current_index = 0
var selected_answers = []
var score = 0
#var font = preload("res://sprite/font/PressStart2P-Regular.ttf")

@onready var question_label = $QuestionPanel/QuestionContainer/QuestionLabel
@onready var options_container = $QuestionPanel/QuestionContainer/OptionsContainer
@onready var score_label = $QuestionPanel/QuestionContainer/Score


func _ready():
	load_quiz()
	print("Questions loaded: ", questions.size())
	show_question()


# =========================
# LOAD JSON
# =========================
func load_quiz():
	var file = FileAccess.open("res://editor/data/quiz.json", FileAccess.READ)
	if file == null:
		print("Failed to open quiz file")
		return
		
	var text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var result = json.parse(text)

	if result != OK:
		print("JSON Parse Error")
		return

	questions = json.get_data()["questions"]
	questions.shuffle()  # Randomize order


# =========================
# SHOW QUESTION
# =========================
func show_question():
	if current_index >= questions.size():
		finish_quiz()
		return

	selected_answers.clear()

	var q = questions[current_index]
	question_label.text = q["question"]

	clear_options()

	match q["type"]:
		"multiple_choice":
			create_multiple_choice(q)

		"true_false":
			create_true_false(q)

		"check_all":
			create_check_all(q)

	update_score_label()


func clear_options():
	for child in options_container.get_children():
		child.queue_free()


# =========================
# MULTIPLE CHOICE
# =========================
func create_multiple_choice(q):
	for i in range(q["options"].size()):
		var btn = Button.new()
		btn.text = q["options"][i]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(func(): check_single_answer(i))
		options_container.add_child(btn)


# =========================
# TRUE FALSE
# =========================
func create_true_false(_q):
	var true_btn = Button.new()
	true_btn.text = "True"
	true_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	true_btn.pressed.connect(func(): check_single_answer(true))

	var false_btn = Button.new()
	false_btn.text = "False"
	false_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	false_btn.pressed.connect(func(): check_single_answer(false))

	options_container.add_child(true_btn)
	options_container.add_child(false_btn)


# =========================
# CHECK ALL THAT APPLY
# =========================
func create_check_all(q):
	for i in range(q["options"].size()):
		var cb = CheckBox.new()
		cb.text = q["options"][i]
		cb.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		cb.toggled.connect(func(pressed):
			if pressed:
				if i not in selected_answers:
					selected_answers.append(i)
			else:
				selected_answers.erase(i)
		)

		options_container.add_child(cb)

	var submit_btn = Button.new()
	submit_btn.text = "Submit"
	submit_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	submit_btn.pressed.connect(check_multiple_answers)

	options_container.add_child(submit_btn)


# =========================
# CHECK ANSWERS
# =========================
func check_single_answer(value):
	var q = questions[current_index]

	if value == q["answer"]:
		score += 1
		print("Correct ✅")
	else:
		print("Wrong ❌")

	next_question()


func check_multiple_answers():
	var q = questions[current_index]

	var correct = q["answers"].duplicate()
	correct.sort()
	selected_answers.sort()

	if selected_answers == correct:
		score += 1
		print("Correct ✅")
	else:
		print("Wrong ❌")

	next_question()


# =========================
# NEXT QUESTION
# =========================
func next_question():
	current_index += 1
	show_question()


# =========================
# FINISH QUIZ
# =========================
func finish_quiz():
	clear_options()
	question_label.text = "Quiz Finished! 🎉"
	score_label.text = "Final Score: %d / %d" % [score, questions.size()]

	# Wait 2 seconds then return to area2
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/area/area_2.tscn")


# =========================
# UPDATE SCORE LABEL
# =========================
func update_score_label():
	score_label.text = "Score: %d" % score
