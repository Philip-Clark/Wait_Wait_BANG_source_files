extends HBoxContainer

var points = 0
func addPoint(color):
	get_child(points).modulate = color
	points += 1
