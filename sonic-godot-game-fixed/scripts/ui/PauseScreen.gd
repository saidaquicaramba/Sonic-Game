extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/resumeButton
@onready var leave_button: Button = $VBoxContainer/leaveButton

func _ready() -> void:
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_leave_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")
