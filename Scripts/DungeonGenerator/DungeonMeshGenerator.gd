@tool
extends Node3D
class_name DungeonMeshGenerator

@export var gridMap: GridMap;
@export var entryExitPointsParentNode: Node3D;

var mapCellScene = preload ("res://Scenes/Cell_Tile/World_Cell_00.tscn")
var mapExitCellScene = preload ("res://Scenes/Cell_Tile/Exit_Cell_00.tscn")
var mapEntryCellScene = preload ("res://Scenes/Cell_Tile/Entry_Cell_00.tscn")

var directions: Dictionary = {
	"Up": Vector3i.FORWARD,
	"Down": Vector3i.BACK,
	"Left": Vector3i.LEFT,
	"Right": Vector3i.RIGHT
}

var actions: Dictionary = {
	GridMapTileTypeEnum.ROOM_TILE: {
		GridMapTileTypeEnum.UNDEFINED: ["RemoveDoor"],
		GridMapTileTypeEnum.BORDER_TILE: ["RemoveDoor"],
		GridMapTileTypeEnum.ROOM_BORDER: ["RemoveDoor"],

		GridMapTileTypeEnum.ROOM_TILE: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.HALLWAY_TILE: ["RemoveDoor"],
		GridMapTileTypeEnum.DOOR_TILE: ["RemoveWall", "RemoveDoor"],

		GridMapTileTypeEnum.ENTRY_POINT: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.EXIT_POINT: ["RemoveWall", "RemoveDoor"],
	},
	GridMapTileTypeEnum.HALLWAY_TILE: {
		GridMapTileTypeEnum.UNDEFINED: ["RemoveDoor"],
		GridMapTileTypeEnum.BORDER_TILE: ["RemoveDoor"],
		GridMapTileTypeEnum.ROOM_BORDER: ["RemoveDoor"],

		GridMapTileTypeEnum.HALLWAY_TILE: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.DOOR_TILE: ["RemoveWall", "RemoveDoor"],

		GridMapTileTypeEnum.ENTRY_POINT: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.EXIT_POINT: ["RemoveWall", "RemoveDoor"],
	},
	GridMapTileTypeEnum.DOOR_TILE: {
		GridMapTileTypeEnum.UNDEFINED: ["RemoveDoor"],
		GridMapTileTypeEnum.BORDER_TILE: ["RemoveDoor"],
		GridMapTileTypeEnum.ROOM_BORDER: ["RemoveDoor"],

		GridMapTileTypeEnum.ROOM_TILE: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.HALLWAY_TILE: ["RemoveWall"],
		GridMapTileTypeEnum.DOOR_TILE: ["RemoveWall", "RemoveDoor"],

		GridMapTileTypeEnum.ENTRY_POINT: ["RemoveWall", "RemoveDoor"],
		GridMapTileTypeEnum.EXIT_POINT: ["RemoveWall", "RemoveDoor"],
	}
}

func ClearMesh():
	for children in get_children():
		remove_child(children)
		children.queue_free()

func createMapMesh():
	ClearMesh()
	for cell in gridMap.get_used_cells():
		var currentCellIdType: int = gridMap.get_cell_item(cell)

		#if invalid cell type skip
		if currentCellIdType == GridMapTileTypeEnum.UNDEFINED or \
				currentCellIdType == GridMapTileTypeEnum.BORDER_TILE or \
				currentCellIdType == GridMapTileTypeEnum.ROOM_BORDER:
			continue
		
		var mapCellInstance: Node3D

		if currentCellIdType == GridMapTileTypeEnum.EXIT_POINT:
			mapCellInstance = mapExitCellScene.instantiate()
		elif currentCellIdType == GridMapTileTypeEnum.ENTRY_POINT:
			mapCellInstance = mapEntryCellScene.instantiate()
		else:
			mapCellInstance = mapCellScene.instantiate()

		mapCellInstance.position = Vector3(cell) * gridMap.cell_scale + Vector3(gridMap.cell_scale / 2, 0, gridMap.cell_scale / 2)

		add_child(mapCellInstance)
	
		for i in 4:
			var direction = directions.values()[i]
			var directionKey = directions.keys()[i]

			#Get the cell adjacent in the direction got above (current cell + Up get the cell item in the above pos from the current cell)
			var adjacentCellIdType: int = gridMap.get_cell_item(cell + direction)

			var currentRoomActions = actions.get(currentCellIdType)

			if !currentRoomActions:
				continue

			var adjacentRoomActions = currentRoomActions.get(adjacentCellIdType)

			if !adjacentRoomActions:
				continue

			for action in adjacentRoomActions:
				mapCellInstance.call(action + directionKey)
