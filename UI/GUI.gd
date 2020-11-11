extends MarginContainer
class_name GUI

onready var p1_action_indicator_container = $Container/P1ActionIndicator
onready var p2_action_indicator_container = $Container/P2ActionIndicator

func clear_actions():
	p1_action_indicator_container.clear_actions()
	p2_action_indicator_container.clear_actions()


func add_p1_action():
	p1_action_indicator_container.add_action()

func remove_p1_action():
	p1_action_indicator_container.remove_action()

func add_p2_action():
	p2_action_indicator_container.add_action()

func remove_p2_action():
	p2_action_indicator_container.remove_action()

