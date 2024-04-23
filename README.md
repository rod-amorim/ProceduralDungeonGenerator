# ProceduralDungeonGeneratorGodot

*Feel free to take, modify, or even create a complete game with this. Long live open source! \o/*

This project aims to implement a procedural dungeon generation algorithm using the Godot 4 game engine.

I used this project as a means to study both procedural dungeon generation and to learn (a bit) about using Godot because up until now, the only engine I've used is Unity (with around 6 years of experience), and I want to expand my skills.

# Play the final game here -> https://nilsera.itch.io/proceduraldungeongeneratorgodot4

The game is quite simple; it doesn't feature enemies, weapons, or collectibles. It's simply an endless sequence of dungeons floors generated for you to explore. It's literally a study project.

Like any normal human being, I followed a tutorial to create this project. I'll leave the link here in case anyone wants to check it out, and I highly recommend watching it. My hope is that you'll understand how this works, and I believe consuming as much information as possible can help.

# Tutorials used for the creation and understanding of this project:

## Tutorial explaining the basics of what was done here, but in a 3D version with rooms of different height levels and stairs between them though he initially explains the algorithm in 2D (this guy deserves more subscribers):
https://www.youtube.com/watch?v=rBY2Dzej03A

## Tutorial that I followed to understand how all this works (this guy also deserves more subscribers):
https://www.youtube.com/watch?v=h64U6j_sFgs

# The procedural dungeon

## How does the dungeon generation work?

I'll explain the algorithm used in a high-level overview; 

I won't delve into the details of how things are done, but in the code, I've left many comments explaining what each line of code is doing. If you want to learn, download the project and analyze the code, break it down, modify it; 

That's the best way to learn ;)

## First step (Generating the rooms)

Generate rooms at random positions and with random predefined sizes within a predefined perimeter (in my case, all parameters are exposed to be changed in the editor).

<img src="/_GithubAssets/ProceduralDungeonGeneratorGodot_GenerateRooms.gif" width="50%" height="50%"/>


In this case:

The white cubes represent the interiors of the rooms.

The light red/pink cubes represent the borders of these rooms.

The red cubes are the representation of the perimeter defined in the editor.

The green and red points inside the rooms are the start and end tiles of the dungeon (ignore this for now)

## Second step (Delaunay triangulation algorithm)

In this step, we'll use the Delaunay triangulation algorithm (https://en.wikipedia.org/wiki/Delaunay_triangulation). 

Godot already has a class that handles this for us. Since I'm not here to reinvent the wheel, and considering that my implementation of this algorithm probably wouldn't be very good, I chose to use Godot's class. (This has nothing to do with the fact that I spent about 4 hours trying to understand how it works and couldn't find a way to implement it myself, haha!)

```
var delaunay: Array = Array(Geometry2D.triangulate_delaunay(roomPosV2))
```
````
P.S.: To easily manipulate the generated graphs, I used Godot's built-in AStar2D class. 
It has everything we need for our Delaunay triangulation (and also for the MST! Spoilers!!!)
````
This will generate a graph where all rooms are interconnected.

Something like this:

<img src = "/_GithubAssets/Delaunay_triangulation_small.png" width="50%" height="50%"/>

P.S.:
In the previous step of generating the rooms, I've already precalculated the central point for each room.

## Third step (Applying MST)

The graph generated in the previous step establishes connections between all rooms, which isn't ideal for a dungeon.

For this reason, we apply the Minimum Spanning Tree (MST) algorithm to remove all connections and keep only one between each room, ensuring that all points are accessible in one way or another.

<img src = "/_GithubAssets/Mesh-nodes-localization-in-Delaunay-triangulation-using-MST.png" width="50%" height="50%"/>
PS: The red line is the MST for this graph.

In this case, for each point in the graph, I check its connections and calculate the distance between the current point and each connection. Then, I keep only the connection with the shortest distance.

## Fourth step (Undoing the MST slightly)

Dungeons need loops, rooms that loop back and bring you to a room you've already visited. The pure MST as it is would make the dungeon quite boring. That's why in this step, we iterate through the points again, and if they are disconnected, we reconnect them, but with the consideration of RNG (Random Number Generation).

Each connection has a percentage chance of being remade (this is defined in the parameters). In my case, I've set a 10% (0.1) chance for a connection to be added again.

## Fifth step (Selecting where the doors will be)

This step is simpler than it sounds. Remember when I mentioned that I precalculated the central point of each room? Now it's going to be useful.

To decide where the doors of the rooms will be placed, I basically take two rooms that are connected in the last graph generated (MST + adding back connections) and iterate over each tile within the room. Then, I compare the distance between each tile and the center of the connected room. The selected tile is the one with the shortest distance.

P.S.: In this step, I'm removing some tiles from this search, such as the corners, for example. In my case, the doors will never be generated in the corners of the rooms (to avoid bugs where the player opens a door and blocks another that was at the other end of the corner).

After doing this you will be able to generate something like this:

<img src = "/_GithubAssets/ProceduralDungeonGeneratorGodot_GenerateDoors.gif" width="50%" height="50%"/>

## Sixth step (Pathfinding for the Rescue)

Now that we have the rooms and the location of the doors, we need to create the corridors. To achieve this, I used Godot's built-in AStar algorithm (yes, another algorithm that I didn't make from scratch).

The plan here is to use the AStar pathfinding algorithm, passing the doors as point A and point B, and let it generate the path between them.

As obstacles, I set tiles marked as the interior of the rooms (white).

To ensure that the corridors look nicer and don't create thin walls, I add tiles with higher weight for the edges of the rooms. This higher weight encourages the algorithm to avoid creating corridors too close to the rooms.

In this case, we configure the algorithm as follows:

```
var astar: AStarGrid2D = AStarGrid2D.new()
astar.size = Vector2i.ONE * borderSize
astar.update()
astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVE
astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN 
```
With this configuration, the algorithm will never generate diagonal paths and will always ensure that the path follows 90-degree angles.

after doing that you will be able to generate this:

<img src = "/_GithubAssets/ProceduralDungeonGeneratorGodot_GenerateHallways.gif" width="50%" height="50%"/>

## Seventh step (Choosing entry and exit rooms)

For this step, I used the Depth First Search (DFS) algorithm with the aim of finding the two rooms farthest from each other.

In this case, I run the algorithm twice. First, I select the first point in the last graph generated (MST + connections added back). Running DFS, I can find the room farthest from the first one. Then, I run the algorithm again starting from this newly found room to find another room even farther away (with more connections between them).

Once the two rooms are found, I simply set the tile at their center as the entrance and exit of the dungeon.

This algorithm is responsible for setting the green and red points in the middle of the rooms mentioned at the very beginning of this readme.

## Final step


After following all these steps, you'll have a gridmap with all the information you need to generate your dungeon. Now, it's just a matter of instantiating the map pieces that form the scenario and clearing the gridmap so it doesn't appear to the player.

I highly recommend that if you're interested and have read this far, you clone this project and try to understand the code. I've added many comments while writing it to solidify in my mind how all this works.

The project contains artwork created by me for the textures, and everything is neatly separated into scenes for each cell of the map. It also includes a minimap that uses the same information generated by the gridmap to set the pixels.

Overall, I had a lot of fun with this project and learned a lot. I learned a great deal about how Godot works, and most importantly, I can apply this method to other engines now. So, I only see positives of having worked on this for the past 2 weeks.
