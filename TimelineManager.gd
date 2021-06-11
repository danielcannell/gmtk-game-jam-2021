extends Node


const Ship = preload("res://Ships/Ship.tscn")


var live_timeline: int = 0
var timelines: Array = []
var ships: Array = []
var frame_num: int = 0


func _ready() -> void:
    # TODO create new timeline if needed (always do this for now)
    timelines.append(Timeline.new())
    timelines.append(Timeline.new())

    # Spawn in a ship for each timeline
    ships = []
    for tl in timelines:
        var ship := Ship.instance()
        ships.append(ship)
        add_child(ship)


func _physics_process(delta: float) -> void:
    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    print("---")
    for i in range(len(timelines)):
        var tl: Timeline = timelines[i]
        var ship: Node2D = ships[i]

        # Get current input state for this ship and run tick
        var state = tl.get_state(frame_num)
        ship.run_step(state, delta)

    frame_num += 1
