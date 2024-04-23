@tool
extends Node3D

class_name DungeonGenerator

@export var generateMesh: bool = false
@export var start: bool = false: set = SetStart
@export var clear: bool = false: set = SetClear
@export var borderSize: int;
@export var gridMap: GridMap;
@export var dungeonMeshGenerator: DungeonMeshGenerator;
@export var minimap: MiniMap;
@export var minimapCover: MiniMapCovered;

@export var roomNumber: int = 2;
@export var roomMargin: int = 1;
@export var minRoomSize: int = 2;
@export var maxRoomSize: int = 4;

@export var maxGenerateRoomOverlapRetryes: int = 15;
@export_range(0, 1) var mstSurvivalChange: float = .25
@export_multiline var customSeed: String = "": set = setSeed

func setSeed(val: String) -> void:
	customSeed = val
	seed(val.hash())

var roomList: Array[Room] = []

func SetStart(_val: bool):
	StartMapGeneration()

func SetClear(_val: bool):
	if roomList:
		roomList.clear()

	if gridMap:
		gridMap.clear()

	if dungeonMeshGenerator:
		dungeonMeshGenerator.ClearMesh()

	if minimap:
		minimap.ClearMinimap(borderSize)
		
	if minimapCover:
		minimapCover.Reset(borderSize)
		
func StartMapGeneration():
	if roomList:
		roomList.clear()

	if gridMap:
		gridMap.clear()

	if customSeed:
		setSeed(customSeed)

	DrawBorder()

	for i in roomNumber:
		GenerateRooms(maxGenerateRoomOverlapRetryes)

	generateConnectionsAndHallways()
func DrawBorder():
	for i in range( - 1, borderSize + 1):
		gridMap.set_cell_item(Vector3i(i, 0, -1), GridMapTileTypeEnum.BORDER_TILE) # back border
		gridMap.set_cell_item(Vector3i(i, 0, borderSize), GridMapTileTypeEnum.BORDER_TILE) # front border
		gridMap.set_cell_item(Vector3i(borderSize, 0, i), GridMapTileTypeEnum.BORDER_TILE) # left border
		gridMap.set_cell_item(Vector3i( - 1, 0, i), GridMapTileTypeEnum.BORDER_TILE) # right border

func GenerateRooms(retryCount):
	if retryCount < 0:
		return
		
	#determine w and h
	var w = randi() % (maxRoomSize - minRoomSize) + minRoomSize
	var h = randi() % (maxRoomSize - minRoomSize) + minRoomSize

	#Pick random start point inside border counting with the room size
	var startTilePos: Vector3i = Vector3i.ZERO
	startTilePos.x = randi() % (borderSize - w + 1)
	startTilePos.z = randi() % (borderSize - h + 1)

	#Check if any cell of this room overlaps with another room
	for r in range( - roomMargin, h + roomMargin):
		for c in range( - roomMargin, w + roomMargin):
			var currentCheckPos: Vector3i = Vector3i(c, 0, r) + startTilePos
			if gridMap.get_cell_item(currentCheckPos) == 0:
				GenerateRooms(retryCount - 1)
				return
	
	var thisRoomTileArray: Array[RoomTile] = []
	
	#draw complete room
	for r in h:
		for c in w:
			var currentTilePos: Vector3i = Vector3i(c, 0, r) + startTilePos
			gridMap.set_cell_item(currentTilePos, GridMapTileTypeEnum.ROOM_TILE)

			var roomTile: RoomTile = RoomTile.new()
			roomTile.pos = currentTilePos

			for i in range( - 1, 2):
				var right = Vector3i(1, 0, i) + currentTilePos
				roomTile.adjacentTiles.append(right)
				
				var up = Vector3i(i, 0, -1) + currentTilePos
				roomTile.adjacentTiles.append(up)
				
				var down = Vector3i(i, 0, 1) + currentTilePos
				roomTile.adjacentTiles.append(down)

				var left = Vector3i( - 1, 0, i) + currentTilePos
				roomTile.adjacentTiles.append(left)
			
			thisRoomTileArray.append(roomTile)
	
	#draw margins room
	for r in range( - 1, h + 1):
		var border_A = Vector3i( - 1, 0, r) + startTilePos
		var border_B = Vector3i(w, 0, r) + startTilePos
		if gridMap.get_cell_item(border_A) != 3:
			gridMap.set_cell_item(border_A, GridMapTileTypeEnum.ROOM_BORDER)
		if gridMap.get_cell_item(border_B) != 3:
			gridMap.set_cell_item(border_B, GridMapTileTypeEnum.ROOM_BORDER)

	for c in range( - 1, w + 1):
		var border_A = Vector3i(c, 0, -1) + startTilePos
		var border_B = Vector3i(c, 0, h) + startTilePos
		if gridMap.get_cell_item(border_A) != 3:
			gridMap.set_cell_item(border_A, GridMapTileTypeEnum.ROOM_BORDER)
		if gridMap.get_cell_item(border_B) != 3:
			gridMap.set_cell_item(border_B, GridMapTileTypeEnum.ROOM_BORDER)
	
	#get room middle point
	var middle_X = (float(w) / 2) + startTilePos.x
	var middle_Z = (float(h) / 2) + startTilePos.z

	#create room object and add to room list
	var room: Room = Room.new()
	room.centerPos = Vector3(middle_X, 0, middle_Z)
	room.roomTileList = thisRoomTileArray
	room.width = w
	room.heigth = h
	roomList.append(room)

func generateConnectionsAndHallways():
	dungeonMeshGenerator.ClearMesh()
	#convert room pos to vector2 and save in a array
	var roomPosV2: PackedVector2Array = []

	#delaunay triangulation and minimal spanning tree
	var del_graph: AStar2D = AStar2D.new()
	var mst_graph: AStar2D = AStar2D.new()
	
	initializeRoomPosV2DelGraphAndMstGraph(roomPosV2, del_graph, mst_graph)
	processDelauneyTriangulation(roomPosV2, del_graph)
	processMST(roomPosV2, mst_graph, del_graph)
	processAddConnectionsBackMST(del_graph, mst_graph)

	createHallways(mst_graph)
	SetStartEndTiles(mst_graph)

	minimap.DrawMinimap(gridMap,borderSize)
	minimapCover.Reset(borderSize)

	if generateMesh:
		dungeonMeshGenerator.createMapMesh()
		gridMap.clear()

func initializeRoomPosV2DelGraphAndMstGraph(roomPosV2: PackedVector2Array, del_graph: AStar2D, mst_graph: AStar2D):
	# this will add all the v2 point on the roomPosV2 and both del_graph and mst_graph in the same order, 
	#so with the same id we can access the same point on all structs
	for room: Room in roomList:
		var vector2pos: Vector2 = Vector2(room.centerPos.x, room.centerPos.z)
		
		roomPosV2.append(vector2pos)
		del_graph.add_point(del_graph.get_available_point_id(), vector2pos)
		mst_graph.add_point(mst_graph.get_available_point_id(), vector2pos)

func processDelauneyTriangulation(roomPosV2: PackedVector2Array, del_graph: AStar2D):
	#Execute the delaunayTriangulation algorithm on the roomPosV2
	var delaunay: Array = Array(Geometry2D.triangulate_delaunay(roomPosV2))

	#Connect the points manually, the Geometry2D.triangulate_delaunay will return a array of points in order to be conected
	#triangle 1 array pos 0,1,2
	#triangle 2 array pos 3,4,5 ...
	#will always return a number divisible by 3 because a triangle is made up of 3 vertices
	for i in delaunay.size() / 3:
		#triangle points
		var p1: int = delaunay.pop_front()
		var p2: int = delaunay.pop_front()
		var p3: int = delaunay.pop_front()
		#connections, this is made like this connects p1 to p2, p2 to p3 and p1 to p3 forming a triangle
		del_graph.connect_points(p1, p2)
		del_graph.connect_points(p2, p3)
		del_graph.connect_points(p1, p3)

func processMST(roomPosV2: PackedVector2Array, mst_graph: AStar2D, del_graph: AStar2D):
	var visitedPointsIds: PackedInt32Array = []

	#select first id from list randomly and add to list
	visitedPointsIds.append(randi() % roomList.size())

	#while not pass through all ids keep iterating
	while visitedPointsIds.size() != mst_graph.get_point_count():
		#this will create a array of intArray, 
		#the intent is to have a array of intArray where index 0 is the pointId and the index 1 is the connectionId
		#something like this:
		#visitedPoints[[pointId,ConnectionId],[pointId,ConnectionId],[pointId,ConnectionId]]
		var visitedPointConnectionIdArray: Array[PackedInt32Array] = []

		for pointId in visitedPointsIds:
			for connectecPointId in del_graph.get_point_connections(pointId):
				if !visitedPointsIds.has(connectecPointId):
					var pointConnectionArray: PackedInt32Array = [pointId, connectecPointId]
					visitedPointConnectionIdArray.append(pointConnectionArray)
					
		#select the pointConnection array with the shortest distance
		var currentPointConnectionId: PackedInt32Array = visitedPointConnectionIdArray.pick_random()

		for pointConArrayId in visitedPointConnectionIdArray:
			#basically checking if the currentPointArray point to connection distance is short than the currentPointConnectionId point to connection,
			#in if it is set the currentPointConnectionId to the one of the iteration
			if roomPosV2[pointConArrayId[0]].distance_squared_to(roomPosV2[pointConArrayId[1]]) < roomPosV2[currentPointConnectionId[0]].distance_squared_to(roomPosV2[currentPointConnectionId[1]]):
				currentPointConnectionId = pointConArrayId

		#add the point if the shortest pointCon Array to the list
		visitedPointsIds.append(currentPointConnectionId[1])
		#connect the points in the mst_graph
		mst_graph.connect_points(currentPointConnectionId[0], currentPointConnectionId[1])
		#disconnect the points in the del_graph
		del_graph.disconnect_points(currentPointConnectionId[0], currentPointConnectionId[1])

func processAddConnectionsBackMST(del_graph: AStar2D, mst_graph: AStar2D):
	#Add some points back based on survival chance
	#for each remaining point in the del_graph iterate through the connected points and add it back if supass the survival chance
	for pointId in del_graph.get_point_ids():
		for connectedPointId in del_graph.get_point_connections(pointId):
			if connectedPointId > pointId:
				#generate number between 0 and 1
				var kill: float = randf()
				if mstSurvivalChange > kill:
					mst_graph.connect_points(pointId, connectedPointId)

func createHallways(mstGraph: AStar2D):
	var fromToTilesPoints: Array[PackedVector3Array] = []
	
	#iterate on all points and connections for each point
	for pointId in mstGraph.get_point_ids():
		for pointConnectionId in mstGraph.get_point_connections(pointId):
			if pointConnectionId > pointId:
				# get the from room cell list
				var roomFrom: Room = roomList[pointId]
				# get the cell with shortest distance to the connected room center point
				# compares all the distances between all the cells in the current room to the center of the connected room and get the closest one
				var tileFrom: RoomTile = roomFrom.roomTileList[1]
				for tile in roomFrom.GetEdgeTiles(gridMap):
					var connectedRoomCenterPos: Vector3 = roomList[pointConnectionId].centerPos
					
					var distanceShorter = tile.pos.distance_squared_to(connectedRoomCenterPos) < tileFrom.pos.distance_squared_to(connectedRoomCenterPos)
					if distanceShorter:
						tileFrom = tile

				# get the room to cell, this is the other room connected to the "from room"			
				var roomTo: Room = roomList[pointConnectionId]

				#get the cell from the other connected room with the shortes distance to the current room center point
				# compares all the distances between all the cells in the other connected room to the center of the current room and get the closest one
				var tileTo: RoomTile = roomTo.roomTileList[1]
				for tile in roomTo.GetEdgeTiles(gridMap):
					var currentRoomCenterPos: Vector3 = roomList[pointId].centerPos
					var distanceShorter = tile.pos.distance_squared_to(currentRoomCenterPos) < tileTo.pos.distance_squared_to(currentRoomCenterPos)
					if distanceShorter:
						tileTo = tile

				#create a vector 3 array that will contain the door tile from current room in index 0 and the other door tile in the index 1
				var hallway: PackedVector3Array = [tileFrom.pos, tileTo.pos]
				#Add to the list that will be processed by the AStar
				fromToTilesPoints.append(hallway)
				#Add visualizarion tiles to the grid map, this will add the 
				gridMap.set_cell_item(tileFrom.pos, GridMapTileTypeEnum.DOOR_TILE)
				tileFrom.isDoorTile = true
				gridMap.set_cell_item(tileTo.pos, GridMapTileTypeEnum.DOOR_TILE)
				tileTo.isDoorTile = true

	#Execute the Astar to create connections between the marked door tiles

	#configure astar
	var astar: AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * borderSize
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN

	#set all the used points in the grid map on the AStar graph
	for tile in gridMap.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(tile.x, tile.z))

	#set room margins
	for tile in gridMap.get_used_cells_by_item(4):
		astar.set_point_weight_scale(Vector2i(tile.x, tile.z), 2)

	#Execute the AStart to all the points in the list of connected door tiles to get the hallways
	for doorConnectionSet in fromToTilesPoints:
		var posFrom: Vector2i = Vector2i(doorConnectionSet[0].x, doorConnectionSet[0].z)
		var posTo: Vector2i = Vector2i(doorConnectionSet[1].x, doorConnectionSet[1].z)

		#get path from origin to target as a list of vector2
		var pathTileList: PackedVector2Array = astar.get_point_path(posFrom, posTo)

		for tile in pathTileList:
			#convert vector 2 to vector 3 by setting the y to the z axis
			var pos: Vector3i = Vector3i(tile.x, 0, tile.y)
			#if the there is no cell item in the pos set the item with index 1 (hallway)
			if gridMap.get_cell_item(pos) == - 1 or gridMap.get_cell_item(pos) == 4:
				gridMap.set_cell_item(pos, GridMapTileTypeEnum.HALLWAY_TILE)

func SetStartEndTiles(mstGraph: AStar2D):
	var targetRoomId: int = Dfs(mstGraph, 0)
	var startRoomId: int = Dfs(mstGraph, targetRoomId)

	var startRoom: Room = roomList[startRoomId]
	var targetRoom: Room = roomList[targetRoomId]

	gridMap.set_cell_item(startRoom.centerPos, GridMapTileTypeEnum.ENTRY_POINT)
	gridMap.set_cell_item(targetRoom.centerPos, GridMapTileTypeEnum.EXIT_POINT)

func Dfs(mstGraph: AStar2D, pointId: int) -> int:
	var visited: Array[int] = []
	var stack: Array[int] = []

	visited.append(pointId)
	stack.append(pointId)

	var furtestRoomId: int = pointId;
	while stack.size() != 0:
		var currentPointId = stack.pop_back()
		
		for connectionId in mstGraph.get_point_connections(currentPointId):
			if connectionId not in visited:
				visited.append(connectionId)
				stack.append(connectionId)
				furtestRoomId = connectionId

	return furtestRoomId
