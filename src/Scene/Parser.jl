function ParseComponents(components_dict)::EntityArray{BaseComponent}

end

function ParseEntities(entities_dict)::EntityArray{Transform}
  entities = EntityArray{Transform}(undef, 0)

  for (key, entity) in enumerate(entities_dict)
    e = ParseEntity(entity)
    push!(entities, e)
  end

  entities
end

function ParseEntity(entity_dict)::GameEntity
  if !haskey(entity_dict, "transform")
    @error "Reading scene: Transform must be an argument of a entity component."
  end
  if !haskey(entity_dict, "renderable")
    @error "Reading scene: Transform must be an argument of a entity component."
  end

  transform = ParseTransform(entity_dict["transform"])
  renderable = ParseRenderable(entity_dict["renderable"])

  if haskey(entity_dict, "components")
    components = [] # Todo parse components
    return GameEntity(renderable, transform = transform, components = components)
  end

  GameEntity(renderable, transform = transform)
end

function ParseRenderable(renderable_dict)::Renderable 
  if !haskey(renderable_dict, "type")
    @error "Reading scene: Transform must be an argument of a renderable component."
  end

    
end

function ParseTransform(transform_dict)::Transform
  if !haskey(transform_dict, "position")
    @error "Reading scene: Position must be an argument of a transform component."
  end

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
  if !haskey(rotation_dict, "axis")
    @error "Reading scene: Axis must be an argument of a rotation component."
  end
  if !haskey(rotation_dict, "theta")
    @error "Reading scene: Theta must be an argument of a rotation component."
  end

  Rotation(Vector3{Float64}(rotation_dict["axis"]), rotation_dict["theta"])
end
