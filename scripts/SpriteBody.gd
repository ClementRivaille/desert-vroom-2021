tool
extends Spatial
class_name SpriteBody

onready var back: MeshInstance = $Back
onready var front: MeshInstance = $Back/Front

func _ready():
  front.mesh = back.mesh
