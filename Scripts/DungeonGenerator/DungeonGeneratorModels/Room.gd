class_name Room

var width: int
var heigth: int
var centerPos: Vector3
var roomTileList: Array[RoomTile] = []

var neighbours = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]

func GetEdgeTiles(gridMap:GridMap):
	var edgeTiles : Array[RoomTile] = []
	for roomTile in roomTileList:
		for n in neighbours: 
			var type = gridMap.get_cell_item(roomTile.pos + n)
			if type == GridMapTileTypeEnum.ROOM_BORDER:
				if !IsCornerTile(gridMap,roomTile):
					edgeTiles.append(roomTile)
	return edgeTiles


func HasDoorInAdjacentRooms(gridMap:GridMap,currentTile:RoomTile):
	for x in range(-1,2):
		for y in range(-1,2):
			if x == 0 and y == 0 :
				continue
			var adjacentType = gridMap.get_cell_item(Vector3(x,0,y)+ currentTile.pos) 
			if adjacentType == GridMapTileTypeEnum.DOOR_TILE:
				return true
			
	return false

func IsCornerTile(gridMap:GridMap, tile:RoomTile):
	var is_top_left = tile.pos == roomTileList[0].pos
	#gridMap.set_cell_item(roomTileList[0].pos,3)
	var is_top_right = tile.pos == roomTileList[0].pos + Vector3(width-1,0,0)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(width-1,0,0),3)
	var is_bottom_left = tile.pos == roomTileList[0].pos + Vector3(0,0,heigth-1)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(0,0,heigth-1),3)
	var is_bottom_right = tile.pos == roomTileList[0].pos + Vector3(width -1,0,heigth-1)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(width -1,0,heigth-1),3)
	
	return is_top_left or is_top_right or is_bottom_left or is_bottom_right
