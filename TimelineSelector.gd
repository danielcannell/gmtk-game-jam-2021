extends Node


onready var timelines = Globals.timelines


func _input(evt):
    if evt is InputEventKey and evt.scancode == KEY_N:
        timelines.append(Timeline.new())
        Globals.live_timeline = len(timelines) - 1
        get_tree().change_scene("res://Main.tscn")
    if evt is InputEventKey and evt.scancode == KEY_0:
        if len(timelines) > 0:
            Globals.live_timeline = 0
            get_tree().change_scene("res://Main.tscn")
    if evt is InputEventKey and evt.scancode == KEY_1:
        if len(timelines) > 1:
            Globals.live_timeline = 1
            get_tree().change_scene("res://Main.tscn")
    if evt is InputEventKey and evt.scancode == KEY_2:
        if len(timelines) > 2:
            Globals.live_timeline = 2
            get_tree().change_scene("res://Main.tscn")
