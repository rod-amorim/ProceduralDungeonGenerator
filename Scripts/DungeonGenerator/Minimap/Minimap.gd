@tool
extends TileMap

class_name MiniMap

func ClearMinimap(borderSize:int):
	for x in borderSize:
		for y in borderSize:
			set_cell(0, Vector2i(x,y), 0, Vector2i(1, 1), 0)
		pass

func DrawMinimap(gridMap: GridMap, borderSize:int):
	ClearMinimap(borderSize)
	DrawHallwayBorders(gridMap)
	DrawRoomsAndHallways(gridMap)
	FixDoorPositions(gridMap)
		
func DrawHallwayBorders(gridMap: GridMap):
	for currentGridPos in gridMap.get_used_cells():
		var currentTileType = gridMap.get_cell_item(currentGridPos)
		
		if currentTileType == GridMapTileTypeEnum.BORDER_TILE or currentTileType == GridMapTileTypeEnum.ROOM_BORDER:
			continue
			
		for x in range( - 1, 2):
			for y in range( - 1, 2):
				var currentTilePos = currentGridPos + Vector3i(y,0,x)
				var cellType = gridMap.get_cell_item(currentTilePos)
				if cellType == GridMapTileTypeEnum.UNDEFINED:
					var pos_2d = Vector2i(currentTilePos.x, currentTilePos.z)
					set_cell(0, pos_2d, 0, Vector2i(0, 0), 0)

func DrawRoomsAndHallways(gridMap: GridMap):
	for grid in gridMap.get_used_cells():
		var tileType = gridMap.get_cell_item(grid)

		var pos_2d = Vector2i(grid.x, grid.z)
		if tileType == GridMapTileTypeEnum.BORDER_TILE:
			set_cell(0, pos_2d, 0, Vector2i(2, 1), 0)
		if tileType == GridMapTileTypeEnum.ROOM_TILE or tileType == GridMapTileTypeEnum.HALLWAY_TILE:
			set_cell(0, pos_2d, 0, Vector2i(1, 0), 0)
		if tileType == GridMapTileTypeEnum.ROOM_BORDER:
			set_cell(0, pos_2d, 0, Vector2i(0, 0), 0)
		if tileType == GridMapTileTypeEnum.DOOR_TILE:
			set_cell(0, pos_2d, 0, Vector2i(2, 0), 0)
		if tileType == GridMapTileTypeEnum.ENTRY_POINT:
			set_cell(0, pos_2d, 0, Vector2i(2, 1), 0)
		if tileType == GridMapTileTypeEnum.EXIT_POINT:
			set_cell(0, pos_2d, 0, Vector2i(0, 1), 0)


func FixDoorPositions(gridMap: GridMap):
	for grid in gridMap.get_used_cells():	
		if gridMap.get_cell_item(grid) != GridMapTileTypeEnum.DOOR_TILE:
			continue
		
		var topTile = get_neighbor_cell(Vector2i(grid.x,grid.z),TileSet.CELL_NEIGHBOR_TOP_SIDE)
		var downTile = get_neighbor_cell(Vector2i(grid.x,grid.z),TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
		var leftTile = get_neighbor_cell(Vector2i(grid.x,grid.z),TileSet.CELL_NEIGHBOR_LEFT_SIDE)
		var rightTile = get_neighbor_cell(Vector2i(grid.x,grid.z),TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
		
		if gridMap.get_cell_item(Vector3(topTile.x,0,topTile.y)) == GridMapTileTypeEnum.HALLWAY_TILE:
			var currentTilePos_2d = Vector2i(grid.x,grid.z)
			set_cell(0, topTile, 0, Vector2i(2, 0), 0)
			set_cell(0, currentTilePos_2d, 0, Vector2i(1, 0), 0)
			
		elif gridMap.get_cell_item(Vector3(downTile.x,0,downTile.y)) == GridMapTileTypeEnum.HALLWAY_TILE:
			var currentTilePos_2d = Vector2i(grid.x,grid.z)
			set_cell(0, downTile, 0, Vector2i(2, 0), 0)
			set_cell(0, currentTilePos_2d, 0, Vector2i(1, 0), 0)
			
		elif gridMap.get_cell_item(Vector3(leftTile.x,0,leftTile.y)) == GridMapTileTypeEnum.HALLWAY_TILE:
			var currentTilePos_2d = Vector2i(grid.x,grid.z)
			set_cell(0, leftTile, 0, Vector2i(2, 0), 0)
			set_cell(0, currentTilePos_2d, 0, Vector2i(1, 0), 0)
			
		elif gridMap.get_cell_item(Vector3(rightTile.x,0,rightTile.y)) == GridMapTileTypeEnum.HALLWAY_TILE:
			var currentTilePos_2d = Vector2i(grid.x,grid.z)
			set_cell(0, rightTile, 0, Vector2i(2, 0), 0)
			set_cell(0, currentTilePos_2d, 0, Vector2i(1, 0), 0)
			

