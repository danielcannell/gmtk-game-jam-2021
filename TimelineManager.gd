extends Node


var live_timeline: int = 0
var timelines: Array = []
var frame_num: int = 0


func _ready() -> void:
    # TODO create new timeline if needed (always do this for now)
    timelines.append(Timeline.new())
    timelines.append(Timeline.new())
    # TODO spawn in a ship for each timeline


func _physics_process(_delta: float) -> void:
    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    print("---")
    for tl in timelines:
        # Get current input state for this ship
        var state = tl.get_state(frame_num)
        print(state.is_pressed(InputType.FIRE))

        # TODO poke current input state into this ship and run tick

    frame_num += 1
