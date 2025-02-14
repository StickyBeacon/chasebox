extends Node
class_name Utils

enum Team {
	Chaser,
	Runner
}

enum GameMode {
	Hunter, # 1 Chaser, de rest runners. Basic gamemode.
	Prey # 1 Runner, de rest chasers. De enge gamemode.
}

enum Handicap { # Momenteel niet in gebruik! 
	None,
	Slowdown, # Chaser speed is dezelfde als die van runners
	Speedup, # Hunter speed is een pak sneller dan die van runners
	BiggerSaw,
	SmallerSaw
}
