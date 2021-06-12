extends Node


onready var timelines = Globals.timelines


func _input(evt):
    if evt is InputEventKey and evt.scancode == KEY_1:
        # TODO create new timeline if needed (always do this for now)
        timelines.append(Timeline.new())
        Globals.live_timeline = len(timelines) - 1

        get_tree().change_scene("res://Main.tscn")
