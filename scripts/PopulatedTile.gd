extends MeshInstance

export(String) var world := ""

func _ready():
  print("hello " + world);
