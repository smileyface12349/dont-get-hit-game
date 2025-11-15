extends Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello, I'm stationary")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn(player: Node) -> void:
	super.spawn(player)
	var direction: float = PI*2*randf()
	self.position = Vector2.from_angle(direction) * 700
	self.rotation = PI*2*randf()
