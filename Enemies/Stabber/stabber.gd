extends Enemy

var direction: float
var speed: float = 10
var acceleration: float = 300
var target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello, I'm a stabber")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null or player.is_dead:
		return
	speed += acceleration * delta
	self.position += Vector2.from_angle(direction - PI/2) * speed * delta
	self.rotation = direction


func spawn(player: Node) -> void:
	super.spawn(player)
	var angle: float = PI*2*randf()
	self.position = Vector2.from_angle(angle) * 700
	target = player.position
	direction = (target - self.position).angle() + PI/2
