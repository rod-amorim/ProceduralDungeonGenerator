extends Node

var gameStateMachine : GameStateMachine

var optionsLastSelectedTabIndex : int

func register_game_state_machine(gameStateMachineInstance : GameStateMachine):
	gameStateMachine = gameStateMachineInstance

func centerScreen():
	var screen_size = DisplayServer.screen_get_size()
	var win_size = get_window().get_size_with_decorations()
	var final_pos = screen_size / 2 - win_size/2
	get_window().set_position(final_pos)

func remapValue(origFrom: float, origTo: float, targetFrom: float, targetTo: float, value: float) -> float:
	var rel = (value - origFrom) / (origTo-origFrom)
	return lerp(targetFrom, targetTo, rel)
	
func fadeScreen(actionBetweenFades,timeBetweenFades:float):
	var tweenFadeIn = get_tree().create_tween()
	var fadeInOutColorRect : ColorRect = get_tree().current_scene.find_child("FadeInOutScreenLayer").find_child("FadeInOutScreen")
	tweenFadeIn.tween_property(fadeInOutColorRect, "color", Color(0,0,0,1), 1)
	
	await tweenFadeIn.finished
	await get_tree().create_timer(timeBetweenFades).timeout
	actionBetweenFades.call()
	var tweenFadeOut = get_tree().create_tween()
	tweenFadeOut.tween_property(fadeInOutColorRect, "color", Color(0,0,0,0), 1)
