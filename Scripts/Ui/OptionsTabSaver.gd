extends TabContainer

func _ready() -> void:
	current_tab = GameManager.optionsLastSelectedTabIndex


func _on_tab_changed(tab: int) -> void:
	GameManager.optionsLastSelectedTabIndex = tab
