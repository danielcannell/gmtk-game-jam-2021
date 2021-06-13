extends Node


const Panel = preload("res://TimelinePanel.tscn")


onready var timelines = Globals.timelines
onready var hbox = $CanvasLayer/MarginContainer/HBoxContainer
onready var margins = $CanvasLayer/MarginContainer


func _ready():
    var MAX_BOX_SIZE := 400.0
    var SEP := 50.0
    var needed_size = len(timelines) * (MAX_BOX_SIZE + SEP)
    var half_margin := SEP
    if needed_size < margins.rect_size.x:
        half_margin = (margins.rect_size.x - needed_size) / 2
    margins.set("custom_constants/margin_left", half_margin)
    margins.set("custom_constants/margin_right", half_margin)

    for i in len(timelines):
        var tl = timelines[i] as Timeline
        var ss = tl.snapshot
        var player_ship = ss["ships"][i]
        var dead: bool = player_ship == null || player_ship["dead"]

        var p = Panel.instance()
        p.set_snapshot(ss, i)
        p.disabled = dead
        p.connect("pressed", self, "start_timeline", [i])
        hbox.add_child(p)


func start_timeline(idx: int) -> void:
    if len(timelines) > idx:
        Globals.live_timeline = idx
        get_tree().change_scene("res://Main.tscn")


func _unhandled_key_input(evt):
    var KEYS = {
        KEY_0: 0,
        KEY_1: 1,
        KEY_2: 2,
        KEY_3: 3,
        KEY_4: 4,
        KEY_5: 5,
        KEY_6: 6,
        KEY_7: 7,
        KEY_8: 8,
        KEY_9: 9,
    }

    if evt is InputEventKey and evt.pressed and !evt.echo:
        if evt.scancode == KEY_N:
            timelines.append(Timeline.new())
            Globals.live_timeline = len(timelines) - 1
            get_tree().change_scene("res://Main.tscn")
        else:
            for key in KEYS:
                if evt.scancode == key:
                    start_timeline(KEYS[key])
