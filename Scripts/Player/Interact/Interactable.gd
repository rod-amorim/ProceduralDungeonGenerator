extends StaticBody3D
class_name Interactable

@export var promptMessage:String = "Interact";
@export var disableOnInteract:bool =  false;

signal Interacted(StaticBody3D)

var enabled : bool = true

func GetPrompt():
	var keyName = ""
	
	if !enabled:
		return keyName
		
	for action in InputMap.action_get_events("Use_Weapon"):
		if action is InputEventKey:
			keyName = OS.get_keycode_string(action.keycode)
			
		elif action is InputEventMouseButton:
			if action.button_index == 1:
				keyName = "Left Click"
				
	return promptMessage + "\n["+keyName+"]"

func Interact(body : StaticBody3D):
	if !enabled:
		return
		
	if disableOnInteract:
		enabled = false
	Interacted.emit(body)
