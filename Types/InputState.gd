class_name InputState
extends Reference

var _state: int = 0

func _init(state: int) -> void:
    _state = state

func is_pressed(inputtype) -> bool:
    return (_state & inputtype) != 0
