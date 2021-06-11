extends Node


const Ship = preload("res://Ships/Ship.tscn")


var live_timeline: int = 0
var timelines: Array = []
var ships: Array = []
var frame_num: int = 0


func _ready() -> void:
    # TODO create new timeline if needed (always do this for now)
    timelines.append(Timeline.new())

    _create_ships()


func _create_ships() -> void:
    # Spawn in a ship for each timeline
    ships = []
    for tl in timelines:
        var ship := Ship.instance()
        ships.append(ship)
        add_child(ship)


func _physics_process(delta: float) -> void:
    # Test code for now:
    # Reset to time 0 and create a new timeline
    if Input.is_action_just_pressed("timeline"):
        frame_num = 0
        for ship in ships:
            remove_child(ship)
            ship.queue_free()
        timelines.append(Timeline.new())
        live_timeline = len(timelines) - 1
        _create_ships()

    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    for i in range(len(timelines)):
        var tl: Timeline = timelines[i]
        var ship: Node2D = ships[i]

        # Get current input state for this ship and run tick
        var state = tl.get_state(frame_num)
        ship.run_step(state, delta)

    frame_num += 1
