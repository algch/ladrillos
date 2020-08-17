extends KinematicBody2D

var graphical_repr_class = preload("res://graphicalRepr.tscn")
var explosion_class = preload("res://explosion.tscn")

signal player_shooted

var can_shoot = true
var aim_start = Vector2()
var is_aiming = false
var can_deal_damage = false
var dir = Vector2()
var original_speed_decrease = 10.0
var speed_decrease = original_speed_decrease
var dir_speed = 0
var damage = 0

var energy = 0.0
var max_energy = 1000.0
var charge_energy_time = 0.5
onready var energy_increase = max_energy / (charge_energy_time / $attackTimer.wait_time)

var original_gravity_speed = 200.0
var gravity_speed = original_gravity_speed
var gravity_motion = Vector2.DOWN * gravity_speed

var gradient = Gradient.new()
onready var arrow = get_node("../arrow")

enum STATE {IDLE, AIMING, ATTACK}
var current_state = STATE.IDLE

func set_state(state):
	match state:
		STATE.IDLE:
			current_state = STATE.IDLE
			can_shoot = true
			is_aiming = false
			can_deal_damage = false
			arrow.modulate.a = 0
			$graphics/tail.emitting = false
			$graphics/charge.emitting = false
		STATE.AIMING:
			current_state = STATE.AIMING
			can_shoot = false
			is_aiming = true
			aim_start = get_global_mouse_position()
			$chargeTimer.stop()
			$attackTimer.start()
			arrow.set_global_position(aim_start)
			$graphics/tail.emitting = false
			$graphics/charge.emitting = true
		STATE.ATTACK:
			current_state = STATE.ATTACK
			is_aiming = false
			can_deal_damage = true
			can_shoot = true
			var input_dir = (aim_start - get_global_mouse_position()).normalized()
			var resulting_motion = (dir * dir_speed) + (input_dir * energy)
			dir = resulting_motion.normalized()
			dir_speed = energy
			damage = energy / max_energy
			$speedDecreaseTimer.start()
			$chargeTimer.start()
			$attackTimer.stop()
			arrow.modulate.a = 0
			$graphics/tail.emitting = true
			$graphics/charge.emitting = false

func _ready():
	var _x  = connect("player_shooted", get_parent(), "_on_player_shooted")
	gradient.set_color(0, ColorPalette.BLUE)
	gradient.set_color(1, ColorPalette.PURPLE)
	set_state(STATE.IDLE)

func get_graphical_repr():
	var graphical_repr = graphical_repr_class.instance()
	graphical_repr.set_frames($graphics/AnimatedSprite.get_sprite_frames())
	graphical_repr.original = self
	graphical_repr.transform = transform
	graphical_repr.play($graphics/AnimatedSprite.get_animation(), $graphics/AnimatedSprite.get_frame())
	return graphical_repr

func get_repr_rotation():
	return $graphics.rotation

func destroy(_increase):
	var explosion = explosion_class.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	get_parent().deploy_new_player()
	queue_free()

func _input(event):
	# is idle ?
	if event.is_action_pressed("shoot") and can_shoot:
		set_state(STATE.AIMING)

	if event.is_action_released("shoot") and current_state == STATE.AIMING:
		# attack state
		set_state(STATE.ATTACK)

func _process(_delta):
	update()
	if current_state == STATE.AIMING:
		$graphics.rotation = (aim_start - get_global_mouse_position()).angle() + PI/2 - rotation
		arrow.rotation = $graphics.rotation
		arrow.modulate = gradient.interpolate(sin($graphics.rotation - PI/2))
		print("graphics rotation ", $graphics.rotation)
		arrow.modulate.a = energy/max_energy

func _physics_process(delta):
	var dir_motion = dir * dir_speed
	var total_motion = dir_motion + gravity_motion
	var collision = move_and_collide(total_motion * delta)
	if collision:
		var prev_dir_speed = dir_speed
		dir = dir.bounce(collision.normal).normalized()
		dir_speed *= 0.25
		if collision.collider.has_method("handle_collision"):
			collision.collider.handle_collision(-dir, prev_dir_speed)

		if collision.collider.has_method("deal_damage") and can_deal_damage:
			# refreshing state ?
			collision.collider.deal_damage(damage)
			set_state(STATE.IDLE)

func _on_speedDecreaseTimer_timeout():
	$speedDecreaseTimer.stop()
	dir_speed -= speed_decrease
	if dir_speed > 0:
		speed_decrease *= 1.05
		$speedDecreaseTimer.start()
	else:
		speed_decrease = original_speed_decrease
		dir = Vector2()
		can_deal_damage = false
		if current_state != STATE.AIMING:
			set_state(STATE.IDLE)

func _on_attackTimer_timeout():
	energy += energy_increase
	get_node("../fuelBar").value = get_node("../fuelBar").max_value - get_node("../fuelBar").max_value * (energy/max_energy)
	if energy < max_energy:
		$attackTimer.start()
	else:
		$attackTimer.stop()

func _on_chargeTimer_timeout():
	energy -= energy_increase
	get_node("../fuelBar").value = get_node("../fuelBar").max_value - get_node("../fuelBar").max_value * (energy/max_energy)
	if energy > 0:
		$chargeTimer.start()
	else:
		$chargeTimer.stop()
