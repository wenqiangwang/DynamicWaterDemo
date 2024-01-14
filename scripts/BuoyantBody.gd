extends RigidBody3D

@onready var probes = get_node("Probes")
@onready var collision_mesh = get_node("CollisionMesh")

@export var buoyancy : float = 5.0:
    get:
        return buoyancy
    set(value):
        if is_inside_tree():
            for i in range(probes.get_child_count()):
                probes.get_child(i).buoyancy = value
        buoyancy =  value       
        
@export var created_waves_amplitude = 0.1 # Is multiplied with the linear velocity and controls height of created waves
@export var water_node_path : NodePath


func _ready():
    collision_mesh.set_surface_override_material(0, collision_mesh.get_surface_override_material(0))
    for i in range(probes.get_child_count()):
        probes.get_child(i).water_node = get_node(water_node_path)
        probes.get_child(i).buoyancy = buoyancy

func _physics_process(delta):
    collision_mesh.get_surface_override_material(0).set_shader_parameter("speed", created_waves_amplitude * linear_velocity.length())
    for i in range(probes.get_child_count()):
        if probes.get_child(i).force > 0.0:
            apply_force(Vector3(0.0, probes.get_child(i).force, 0.0) / probes.get_child_count(), probes.get_child(i).global_transform.origin - global_transform.origin)
            pass
