extends Control


const LINE_Y = 50
const LINE_THICKNESS = 5
const CIRCLE_RADIUS = 16
var LINE_COLOR = Color(1,1,1)
var LINE_WIDTH = 200
var ALIVE_COLOR = Color(0,1,0)
var DEAD_COLOR = Color(1,0,0)
var FONT = null


func _ready():
    LINE_WIDTH = get_rect().size.x - 150
    FONT = load("res://Art/MediumFont.tres")


func _draw_centered_text(font: Font, pos: Vector2, text: String) -> void:
    var width = font.get_string_size(text).x
    draw_string(font, pos - Vector2(width/2, 0), text)


func _draw():
    var cx = get_rect().size.x / 2

    # main line
    var line_start = cx - LINE_WIDTH/2
    var line_end = cx + LINE_WIDTH/2
    draw_line(Vector2(line_start, LINE_Y), Vector2(line_end, LINE_Y), LINE_COLOR, LINE_THICKNESS)

    # scale from frame_num to line pos
    var scale = LINE_WIDTH / Globals.WAVES[-1]["start"]

    # show waves / boss
    # TODO

    # show old ships
    for i in len(Globals.timelines):
        var tl: Timeline = Globals.timelines[i]
        var ss = tl.snapshot
        var player_ship = ss["ships"][i]
        var dead: bool = player_ship == null || player_ship["dead"]

        # show ships position
        var ship_x = (scale * ss["frame_num"]) + line_start
        var color: Color = DEAD_COLOR if dead else ALIVE_COLOR
        draw_circle(Vector2(ship_x, LINE_Y), CIRCLE_RADIUS, color)
        _draw_centered_text(FONT, Vector2(ship_x, LINE_Y-CIRCLE_RADIUS), "Ship " + str(i))

        # show ship stats
        # TODO
