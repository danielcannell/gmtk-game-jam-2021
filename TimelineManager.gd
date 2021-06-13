extends Node


const Ship = preload("res://Ships/Ship.tscn")
const Explosion = preload("res://Effects/Explosion.tscn")

onready var bullet_manager = $"../BulletManager"
onready var enemy_manager = $"../EnemyManager"


onready var timelines = Globals.timelines


var live_timeline: int = 0
var ships: Array = []
var frame_num: int = 0


func _on_player_death(position):
    var effect = Explosion.instance()
    add_child(effect)
    effect.position = position
    effect.run()


func _ready() -> void:
    live_timeline = Globals.live_timeline

    _create_ships()

    if timelines[live_timeline].snapshot != null:
        _restore_snapshot(timelines[live_timeline].snapshot)
        timelines[live_timeline].snapshot = null


func _create_ships() -> void:
    # Spawn in a ship for each timeline
    ships = []
    for i in timelines.size():
        var ship := Ship.instance()
        ship.connect("fire", bullet_manager, "spawn_bullet")
        ship.connect("death", self, "_on_player_death")
        ships.append(ship)
        add_child(ship)
        ship.set_label(str(i))


func _remove_ship(idx) -> void:
    var ship = ships[idx]
    remove_child(ship)
    ship.queue_free()
    ships[idx] = null


func _make_snapshot():
    var ships_snapshot = []

    for s in ships:
        if is_instance_valid(s):
            ships_snapshot.append(s.make_snapshot())
        else:
            ships_snapshot.append(null)

    var bullets_snapshot = bullet_manager.make_snapshot()

    var enemies_snapshot = enemy_manager.make_snapshot()

    return {
        "ships": ships_snapshot,
        "frame_num": frame_num,
        "bullets": bullets_snapshot,
        "enemies": enemies_snapshot,
    }


func _restore_snapshot(snapshot):
    frame_num = snapshot["frame_num"]

    bullet_manager.restore_snapshot(snapshot["bullets"])

    for i in snapshot["ships"].size():
        ships[i].restore_snapshot(snapshot["ships"][i])

        # Early cleanup of dead ships, so the don't get snapshots
        if ships[i].dead:
            _remove_ship(i)

    enemy_manager.restore_snapshot(snapshot["enemies"])


func _physics_process(delta: float) -> void:
    # Test code for now:
    if Input.is_action_just_pressed("timeline"):
        timelines[live_timeline].snapshot = _make_snapshot()

        # TODO: Do we need to free all the ships, or do they get cleaned up?
        get_tree().change_scene("res://TimelineSelector.tscn")
        return

    # Get inputs and append to 'live' timeline if changed
    timelines[live_timeline].set_state(frame_num, InputManager.get_state())

    # Tick all ships
    for i in range(len(timelines)):
        var tl: Timeline = timelines[i]
        var ship: Node2D = ships[i]

        if ship == null || !is_instance_valid(ship):
            continue

        # De-spawn ships when they die or reach the end of their timeline
        if ship.dead || (tl.snapshot != null && frame_num > tl.snapshot["frame_num"]):
            print("saving ", i)
            tl.snapshot = _make_snapshot()
            _remove_ship(i)
            continue

        # Get current input state for this ship and run tick
        var state = tl.get_state(frame_num)
        ship.run_step(state, delta)

    enemy_manager.run_tick(delta, frame_num)
    bullet_manager.run_tick(delta, frame_num)

    frame_num += 1
