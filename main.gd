extends Node2D

var can_shoot = true
var aim_start = null
var is_aiming = false
var dir = Vector2()

func _ready():
	randomize()
	spawn()

func _on_player_shooted():
	print("player shooted")

func _on_turnEnder_body_entered(body):
	if body.is_in_group("bullets"):
		$player.position.x = body.position.x
		body.destroy()
		spawn()
	if body.is_in_group("bricks"):
		get_tree().quit()

func spawn():
	var spawners = get_tree().get_nodes_in_group("spawners")
	spawners[ randi() % len(spawners) ].spawn()

func _draw():
	if not is_aiming:
		return
	var start = aim_start - position
	var end = get_global_mouse_position() - position
	draw_line(start, end, Color(1, 1, 1), 2)

func _process(delta):
	update()
	if is_aiming:
		$player/polygon.rotation = (aim_start - get_global_mouse_position()).angle() + PI/2 - $player.rotation

func _input(event):
	if event.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		is_aiming = true
		aim_start = get_global_mouse_position()

	if event.is_action_released("shoot") and not can_shoot:
		can_shoot = true
		is_aiming = false
		dir = (aim_start - get_global_mouse_position()).normalized()
		$player.dash(dir)
