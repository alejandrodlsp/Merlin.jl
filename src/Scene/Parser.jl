function ParseEntities(entities_dict)::Vector{Transform}
  entities = Vector{Transform}(undef, 0)

  for (key, entity) in enumerate(entities_dict)
    e = ParseEntity(entity)
    push!(entities, e)
  end

  entities
end

function ParseEntity(entity_dict)::GameEntity
  @assert haskey(entity_dict, "transform") "Reading scene: Transform must be an argument of a entity component."
  @assert haskey(entity_dict, "renderable") "Reading scene: Transform must be an argument of a entity component."

  transform = ParseTransform(entity_dict["transform"])
  renderable = ParseRenderable(entity_dict["renderable"])

  if haskey(entity_dict, "components")
    components = []
    for (index, component) in enumerate(entity_dict.components)
      push!(components, ParseComponent(component))
    end
    return GameEntity(renderable, transform = transform, components = components)
  end

  GameEntity(renderable, transform = transform)
end

function ParseComponent(component_dict)::BaseComponent
  @assert haskey(component_dict, "file") "Reading scene: File must be an argument of a component."
  @assert haskey(component_dict, "data") "Reading scene: Data must be an argument of a component."
  
  component_file = split(component_dict["file"], "/")[end] # Get filename
  component_name = split(component_file, ".")[0]   # Remove file extension
  component_symbol = Symbol(component_name) # Get module symbol

  if !isdefined(Main, component_symbol)  # If symbol is not defined import module
    include(component_file)
    @debug "Loading module..."
  end

  @assert isdefined(component_symbol, :initialize) "Trying to load component without initialize function"

  component_symbol.initialize(component_dict["data"])
end

function ParseRenderable(renderable_dict)::Renderable 
  @assert haskey(renderable_dict, "type") "Reading scene: Transform must be an argument of a renderable component."

  if renderable_dict["type"] == "Quad"
    @assert haskey(renderable_dict, "texture") "Reading scene: Texture path must be an argument of a quad renderer component."
    
    return Quad(TextureResource_Load(renderable_dict["texture"]))
  end
end

function ParseTransform(transform_dict)::Transform
  @assert haskey(transform_dict, "position") "Reading scene: Position must be an argument of a transform component."

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
  @assert haskey(rotation_dict, "axis") "Reading scene: Axis must be an argument of a rotation component."
  @assert haskey(rotation_dict, "theta") "Reading scene: Theta must be an argument of a rotation component."

  Rotation(Vector3{Float64}(rotation_dict["axis"]), rotation_dict["theta"])
end

export ParseEntity, ParseRenderable, ParseTransform, ParseRotation