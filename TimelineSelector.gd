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
        hbox.add_child(p)


func _unhandled_key_input(evt):
    if evt is InputEventKey and evt.pressed and !evt.echo:
        if evt.scancode == KEY_N:
            timelines.append(Timeline.new())
            Globals.live_timeline = len(timelines) - 1
            get_tree().change_scene("res://Main.tscn")
        if evt.scancode == KEY_0:
            if len(timelines) > 0:
                Globals.live_timeline = 0
                get_tree().change_scene("res://Main.tscn")
        if evt.scancode == KEY_1:
            if len(timelines) > 1:
                Globals.live_timeline = 1
                get_tree().change_scene("res://Main.tscn")
        if evt.scancode == KEY_2:
            if len(timelines) > 2:
                Globals.live_timeline = 2
                get_tree().change_scene("res://Main.tscn")
