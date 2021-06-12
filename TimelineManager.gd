extends Node


const Ship = preload("res://Ships/Ship.tscn")


onready var timelines = Globals.timelines


var live_timeline: int = 0
var ships: Array = []
var frame_num: int = 0


func _ready() -> void:
    live_timeline = Globals.live_timeline

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
    if Input.is_action_just_pressed("timeline"):
        # TODO: Do we need to free all the ships, or do they get cleaned up?
        get_tree().change_scene("res://TimelineSelector.tscn")
        return

    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    for i in range(len(timelines)):
        var tl: Timeline = timelines[i]
        var ship: Node2D = ships[i]

        # Get current input state for this ship and run tick
        var state = tl.get_state(frame_num)
        ship.run_step(state, delta)

    frame_num += 1
