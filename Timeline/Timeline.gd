class_name Timeline

var _events: Array = []
var _empty = InputState.new(0)

# caching
var _last_idx := 0
var _last_frame := 0
var _last_state: InputState = _empty

# Snapshot of the world state at the end of the timeline
var snapshot = null


func get_state(frame: int) -> InputState:
    if frame < _last_frame:
        _last_idx = 0
        _last_state = _empty
    _last_frame = frame

    for i in range(_last_idx, _events.size()):
        var event = _events[i]
        _last_idx = i
        if event[0] > frame:
            return _last_state
        _last_state = event[1]
    return _last_state


func set_state(frame: int, state: InputState) -> void:
    if len(_events) == 0 || _events[-1][1] != state:
        _events.append([frame, state])
