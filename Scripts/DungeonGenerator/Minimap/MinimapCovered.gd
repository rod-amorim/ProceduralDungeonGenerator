@tool
extends TileMap

class_name MiniMapCovered
@export var offset : Vector2
@export var viewAreaSize : int

func Reset(borderSize):
	for x in borderSize:
		for y in borderSize:
			set_cell(0, Vector2i(x,y), 0, Vector2i(1, 1), 0)
		pass
		

func GetViewArea(pos2d: Vector2i):
	var tilePosVector: PackedVector2Array = []
	for x in range(pos2d.x - viewAreaSize, pos2d.x + viewAreaSize + 1):
		for y in range(pos2d.y - viewAreaSize, pos2d.y + viewAreaSize + 1):
			var distance = abs(pos2d.x - x) + abs(pos2d.y - y)
			if distance <= viewAreaSize:
				tilePosVector.append(Vector2i(x, y))
	return tilePosVector
	
func _process(delta):
	if Engine.is_editor_hint():
		return
		
	var playerPos = PlayerManager.playerNode.global_position
	var pos2d = Vector2i(playerPos.x *offset.x ,playerPos.z*offset.y)
	var surroindingCells = GetViewArea(pos2d)
	
	for s_cell in surroindingCells:
		set_cell(0, s_cell)

