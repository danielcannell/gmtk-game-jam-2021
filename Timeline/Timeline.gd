class_name Timeline

var _events: Array = []
var _empty = InputState.new(0)

# Snapshot of the world state at the end of the timeline
var snapshot = null

func get_state(frame: int) -> InputState:
    var last: InputState = _empty
    for event in _events:
        if event[0] > frame:
            return last
        last = event[1]
    return last

func set_state(frame: int, state: InputState) -> void:
    if len(_events) == 0 || _events[-1][1] != state:
        _events.append([frame, state])
