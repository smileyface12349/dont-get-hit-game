extends Node

@export var enemies: Node

@export var acceleration: float = 250
@export var braking: float = 200
const reverse_delay: float = 0.2
@export var reverse_amount: float = 100
@export var turn_amount: float = 3

@export var boundary_top: int
@export var boundary_bottom: int
@export var boundary_left: int
@export var boundary_right: int

# Max speed is now controlled by air resistance alone
#const max_forwards_speed: float = 5
#const max_reverse_speed: float = 1

@export var air_resistance: float = 0.002 # multiplied by velocity squared, per second
@export var damping: float = 20.0 # does not scale with velocity, per second
var boundary_force_factor: float = 0.02

var speed: float
var direction: float
var reverse_delay_elapsed: float
var is_reversing: bool
var is_dead: bool

var stalker: PackedScene = preload("res://Enemies/Stalker/stalker.tscn")
var surrounder: PackedScene = preload("res://Enemies/Surrounder/surrounder.tscn")
var straight: PackedScene = preload("res://Enemies/Straight/straight.tscn")
var stationary: PackedScene = preload("res://Enemies/Stationary/stationary.tscn")
var stabber: PackedScene = preload("res://Enemies/Stabber/stabber.tscn")

var time_since_spawn: float = 0
@export var spawn_enemy_every: float = 2
@export var spawn_enemy_every_increase: float = 1.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 0
	reverse_delay_elapsed = 0
	is_reversing = false
	is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dead:
		return
		
	time_since_spawn += delta
	if time_since_spawn > spawn_enemy_every:
		spawn_new_enemy()
		time_since_spawn = 0
		spawn_enemy_every /= spawn_enemy_every_increase
		
	if Input.is_action_pressed("driving_accelerate"):
		# Attempting to accelerate
		if speed > 0:
			# Only switch from reverse after a delay
			if is_reversing:
				if reverse_delay_elapsed < reverse_delay:
					speed = 0
					reverse_delay_elapsed += delta
				else:
					is_reversing = false
					reverse_delay_elapsed = 0
					# will accelerate next frame
			else:
				speed += acceleration * delta
				#if speed > max_forwards_speed:
					#speed = max_forwards_speed
		# Attempting to brake
		else:
			speed += braking * delta
	if Input.is_action_pressed("driving_brake"):
		# Attempting to reverse
		if speed < 0:
			# Only reverse after a delay
			if not is_reversing:
				if reverse_delay_elapsed < reverse_delay:
					speed = 0
					reverse_delay_elapsed += delta
				else:
					is_reversing = true
					reverse_delay_elapsed = 0
					# will reverse next frame
			else:
				speed -= reverse_amount * delta
				#if speed < -max_reverse_speed:
					#speed = -max_reverse_speed
		# Attempting to brake
		else:
			speed -= braking * delta
	
	if Input.is_action_pressed("driving_left"):
		direction -= turn_amount * delta
	if Input.is_action_pressed("driving_right"):
		direction += turn_amount * delta
		
	# Air resistance (always against direction of travel, bigger for faster speeds)
	if speed > 0:
		speed -= air_resistance * delta * pow(speed, 2)
	elif speed < 0:
		speed += air_resistance * delta * pow(speed, 2)
		
	# Fixed damping (stops the car from rolling for too long at slower speeds, so that it comes to a complete stop instead)
	if speed > 0:
		speed -= damping * delta
		if speed < 0:
			speed = 0
	if speed < 0:
		speed += damping * delta
		if speed > 0:
			speed = 0
		
	#print("Speed: " + str(speed) + ", Direction: " + str(direction))
	self.position += Vector2.from_angle(direction - PI/2) * speed * delta
	self.rotation = direction
	
	# Stay within bounds
	if self.position.x > boundary_right:
		self.position.x -= (self.position.x - boundary_right) * boundary_force_factor
	if self.position.x < boundary_left:
		self.position.x += (boundary_left - self.position.x) * boundary_force_factor
	if self.position.y > boundary_bottom:
		self.position.y -= (self.position.y - boundary_bottom) * boundary_force_factor
	if self.position.y < boundary_top:
		self.position.y += (boundary_top - self.position.y) * boundary_force_factor
	
func body_entered(body: Area2D) -> void:
	is_dead = true

func spawn_new_enemy() -> void:
	var enemy: Node
	var n = randf()
	if n < 0.1:
		enemy = stalker.instantiate()
	elif n < 0.2:
		enemy = surrounder.instantiate()
	elif n < 0.4:
		enemy = straight.instantiate()
	elif n < 0.5:
		enemy = stabber.instantiate()
	else:
		enemy = stationary.instantiate()
		
	enemies.add_child(enemy)
	enemy.spawn(self)
