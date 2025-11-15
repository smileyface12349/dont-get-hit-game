extends Enemy

@export var player: Node

var direction: float
var speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player == null or player.is_dead:
		return
	direction = (player.position - self.position).angle()
	self.position += Vector2.from_angle(direction - PI/2) * speed * delta
	self.rotation = direction
	
func body_entered(other: Area2D) -> void:
	print("Body entered")
	self.queue_free()
