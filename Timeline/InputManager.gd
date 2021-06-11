class_name InputManager

static func get_state() -> InputState:
    var state: int = 0

    if Input.is_action_pressed("up"):
        state |= InputType.UP

    if Input.is_action_pressed("down"):
        state |= InputType.DOWN

    if Input.is_action_pressed("left"):
        state |= InputType.LEFT

    if Input.is_action_pressed("right"):
        state |= InputType.RIGHT

    if Input.is_action_pressed("fire"):
        state |= InputType.FIRE

    return InputState.new(state)
