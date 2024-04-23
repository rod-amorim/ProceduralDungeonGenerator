class_name Room

var width: int
var heigth: int
var centerPos: Vector3
var roomTileList: Array[RoomTile] = []

var neighbours = [Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]

func GetTilesThatCanBeDoors(gridMap:GridMap):
	var edgeTiles : Array[RoomTile] = []
	for roomTile in roomTileList:
		var roomTileType = gridMap.get_cell_item(roomTile.pos)
		for n in neighbours: 
			var sideTile = roomTile.pos + n
			var type = gridMap.get_cell_item(sideTile)
			var sideOfSideIsBorder = gridMap.get_cell_item(sideTile + n) == GridMapTileTypeEnum.BORDER_TILE 
			if type == GridMapTileTypeEnum.ROOM_BORDER and roomTileType != GridMapTileTypeEnum.DOOR_TILE and !IsCornerTile(roomTile) and !sideOfSideIsBorder:
					edgeTiles.append(roomTile)
				
	# for i in edgeTiles:
	# 	gridMap.set_cell_item(i.pos,3)
	return edgeTiles


func GetDoorInAdjacentTiles(gridMap:GridMap, currentTile:RoomTile):	
	for n in neighbours: 
		var sideTilePos = currentTile.pos + n
		var sideTileType = gridMap.get_cell_item(sideTilePos)

		if sideTileType == GridMapTileTypeEnum.DOOR_TILE:
			for tile in roomTileList:
				if tile.pos == sideTilePos: 
					return tile

		var sideOfSideTilePos = sideTilePos + n
		var sideOfSideType = gridMap.get_cell_item(sideOfSideTilePos)

		if sideOfSideType == GridMapTileTypeEnum.DOOR_TILE:
			for tile in roomTileList:
				if tile.pos == sideOfSideTilePos: 
					return tile

	
			
	return null

func IsCornerTile( tile:RoomTile):
	var is_top_left = tile.pos == roomTileList[0].pos
	#gridMap.set_cell_item(roomTileList[0].pos,3)
	var is_top_right = tile.pos == roomTileList[0].pos + Vector3(width-1,0,0)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(width-1,0,0),3)
	var is_bottom_left = tile.pos == roomTileList[0].pos + Vector3(0,0,heigth-1)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(0,0,heigth-1),3)
	var is_bottom_right = tile.pos == roomTileList[0].pos + Vector3(width -1,0,heigth-1)
	#gridMap.set_cell_item(roomTileList[0].pos + Vector3(width -1,0,heigth-1),3)
	
	return is_top_left or is_top_right or is_bottom_left or is_bottom_right
