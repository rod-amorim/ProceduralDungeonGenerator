# ProceduralDungeonGenerator

This project aims to implement a procedural dungeon generation algorithm using the Godot 4 game engine.

I used this project as a means to study both procedural dungeon generation and to learn (a bit) about using Godot because up until now, the only engine I've used is Unity (with around 6 years of experience), and I want to expand my skills.

You can play the final game here -> https://nilsera.itch.io/proceduraldungeongeneratorgodot4

The game is quite simple; it doesn't feature enemies, weapons, or collectibles. It's simply an endless sequence of dungeons floors generated for you to explore. It's literally a study project.

# How does the dungeon generation work?

I'll explain the algorithm used in a high-level overview; 

I won't delve into the details of how things are done, but in the code, I've left many comments explaining what each line of code is doing. If you want to learn, download the project and analyze the code, break it down, modify it; 

That's the best way to learn ;)

# First step

Generate rooms at random positions and with random predefined sizes within a predefined perimeter (in my case, all parameters are exposed to be changed in the editor).

<img src="/_GithubAssets/ProceduralDungeonGeneratorGodot_GenerateRooms.gif" width="50%" height="50%"/>

In this case, 
The white cubes represent the interiors of the rooms.
The maroon cubes represent the borders of these rooms.
The red cubes represent the representation of the perimeter defined in the editor.
