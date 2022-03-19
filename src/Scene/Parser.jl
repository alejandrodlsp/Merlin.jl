function ParseEntities(entities_dict)::Vector{GameEntity}
  entities = Vector{GameEntity}(undef, 0)

  for entity in entities_dict
    e = ParseEntity(entity)
    push!(entities, e)
  end

  entities
end

function ParseCamera(camera_dict)::PerspectiveCamera
  rotation_dict = get(camera_dict, "rotation", nothing)
  if !isnothing(rotation_dict)
    rotation_dict = ParseRotation(rotation_dict)
  end

  position_dict = get(camera_dict, "position", nothing)
  if !isnothing(position_dict)
    position_dict = Vector3{Float64}(camera_dict["position"])
  end

  params = Dict(:Position => position_dict,
    :Rotation => rotation_dict,
    :Fov => get(camera_dict, "fov", nothing),
    :Near => get(camera_dict, "near", nothing),
    :Far => get(camera_dict, "far", nothing))

  filter!(p -> (!isnothing(last(p))), params)
  camera = PerspectiveCamera(; params...)
  CreateCamera(camera)
end

function ParseEntity(entity_dict)::GameEntity
  haskey(entity_dict, "transform") || @error "Reading scene: Transform must be an argument of a entity component."
  haskey(entity_dict, "renderable") || @error "Reading scene: Transform must be an argument of a entity component."

  transform = ParseTransform(entity_dict["transform"])
  renderable = ParseRenderable(entity_dict["renderable"])

  if haskey(entity_dict, "components")
    components = ComponentArray{BaseComponent}(undef, 0)
    for component in entity_dict["components"]
      push!(components, ParseComponent(component))
    end
    return GameEntity(renderable, transform = transform, components = components)
  end

  GameEntity(renderable, transform = transform)
end

function ParseComponent(component_dict)::BaseComponent
  haskey(component_dict, "file") || @error "Reading scene: File must be an argument of a component."
  haskey(component_dict, "data") || @error "Reading scene: Data must be an argument of a component."

  component_file = split(component_dict["file"], "/")[end] # Get filename
  component_name = split(component_file, ".")[1]   # Remove file extension
  component_symbol = Symbol(component_name) # Get module symbol

  isdefined(Main, component_symbol) || @error "Reading scene components: You must include component files."

  getfield(Main, component_symbol)(component_dict["data"])
end

function ParseRenderable(renderable_dict)::Renderable
  haskey(renderable_dict, "type") || @error "Reading scene: Type must be an argument of a renderable component."
  haskey(renderable_dict, "program") || @error "Reading scene: Program path must be an argument of a renderable component."

  if renderable_dict["type"] == "quad"
    haskey(renderable_dict, "texture") || @error "Reading scene: Texture path must be an argument of a quad renderer component."
    return Quad(TextureResource_Load(renderable_dict["texture"]).texture, renderable_dict["program"])
  elseif renderable_dict["type"] == "model"
    haskey(renderable_dict, "path") || @error "Reading scene: Path must be an argument of a model renderer component."
    return Model(renderable_dict["path"], renderable_dict["program"])
  else
    @error "Reading scene: renderable type not found"
  end
end

function ParseTransform(transform_dict)::Transform
  haskey(transform_dict, "position") || @error "Reading scene: Position must be an argument of a transform component."

  position = Vector3{Float64}(transform_dict["position"])
  transform = Transform(position)

  if haskey(transform_dict, "name")
    transform.name = transform_dict["name"]
  end
  if haskey(transform_dict, "rotation")
    transform.rotation = ParseRotation(transform_dict["rotation"])
  end
  if haskey(transform_dict, "scale")
    transform.scale = Vector3{Float64}(transform_dict["scale"])
  end

  transform
end

function ParseRotation(rotation_dict)::Rotation
  haskey(rotation_dict, "axis") || @error "Reading scene: Axis must be an argument of a rotation component."
  haskey(rotation_dict, "theta") || @error "Reading scene: Theta must be an argument of a rotation component."

  Rotation(Vector3{Float64}(rotation_dict["axis"]), rotation_dict["theta"])
end