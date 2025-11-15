extends Enemy

var direction: float
var speed: float = 350

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello, I go straight")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null or player.is_dead:
		return
	self.position += Vector2.from_angle(direction - PI/2) * speed * delta
	self.rotation = direction


func spawn(player: Node) -> void:
	super.spawn(player)
	var n = randf()
	if n < 0.25:
		self.position = player.position + Vector2(randf_range(-1, 1) * 300, 800)
		direction = 0
	elif n < 0.5:
		self.position = player.position + Vector2(randf_range(-1, 1) * 300, -800)
		direction = PI
	elif n < 0.75:
		self.position = player.position + Vector2(-1000, randf_range(-1, 1) * 300)
		direction = PI/2
	else:
		self.position = player.position + Vector2(1000, randf_range(-1, 1) * 300)
		direction = 3 * PI/2
