extends Node


const Ship = preload("res://Ships/Ship.tscn")

onready var bullet_manager = $"../BulletManager"


onready var timelines = Globals.timelines


var live_timeline: int = 0
var ships: Array = []
var frame_num: int = 0


func _ready() -> void:
    live_timeline = Globals.live_timeline

    _create_ships()

    if timelines[live_timeline].snapshot != null:
        _restore_snapshot(timelines[live_timeline].snapshot)
        timelines[live_timeline].snapshot = null


func _create_ships() -> void:
    # Spawn in a ship for each timeline
    ships = []
    for tl in timelines:
        var ship := Ship.instance()
        ship.connect("fire", bullet_manager, "spawn_bullet")
        ships.append(ship)
        add_child(ship)


func _make_snapshot():
    var ships_snapshot = []

    for s in ships:
        if is_instance_valid(s):
            ships_snapshot.append(s.make_snapshot())
        else:
            ships_snapshot.append(null)

    return {
        "ships": ships_snapshot,
        "frame_num": frame_num,
    }


func _restore_snapshot(snapshot):
    frame_num = snapshot["frame_num"]

    for i in snapshot["ships"].size():
        ships[i].restore_snaphot(snapshot["ships"][i])


func _physics_process(delta: float) -> void:
    # Test code for now:
    if Input.is_action_just_pressed("timeline"):
        timelines[live_timeline].snapshot = _make_snapshot()

        # TODO: Do we need to free all the ships, or do they get cleaned up?
        get_tree().change_scene("res://TimelineSelector.tscn")
        return

    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    for i in range(len(timelines)):
        var tl: Timeline = timelines[i]
        var ship: Node2D = ships[i]

        if !is_instance_valid(ship):
            continue

        # De-spawn ships when they reach the end of their timeline
        #
        # TODO: We also need to do this when a ship dies!
        if tl.snapshot != null:
            if frame_num > tl.snapshot["frame_num"]:
                tl.snapshot = _make_snapshot()
                ship.queue_free()

        # Get current input state for this ship and run tick
        var state = tl.get_state(frame_num)
        ship.run_step(state, delta)

    frame_num += 1
