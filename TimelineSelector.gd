extends Node


const Panel = preload("res://TimelinePanel.tscn")


onready var timelines = Globals.timelines
onready var hbox = $CanvasLayer/HBoxContainer


func _ready():
    for i in len(timelines):
        var tl = timelines[i] as Timeline
        var ss = tl.snapshot
        var p: Control = Panel.instance()
        p.set_snapshot(ss, i)
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
