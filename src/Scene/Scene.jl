"""
  Scene

Base scene structure.

# Arguments
- `name::String`: Scene name for scene registry, must be a unique name.
- `camera::Camera`: Camera controller for scene.
- `entities::Vector{GameEntity}`: Optional, list of starting entities in scene.
"""
mutable struct Scene
  name::String
  camera::Camera
  entities::Vector{GameEntity}
end

function CreateScene(name::String, camera::Camera, entities::Vector{GameEntity} = Vector{GameEntity}())::Scene
  scene = Scene(name, camera, entities)
  push!(_MERLIN_SCENE_REGISTRY, scene)
  scene
end

"""
    Instantiate(Scene, GameEntity)

Instantiates a new game entity into scene.

See also [`Destroy`](@ref).
"""
function Instantiate(scene::Scene, game_entity::GameEntity)
  if game_entity in scene.entities
    return
  end
  push!(scene.entities, game_entity)
  IsActiveScene(scene) && GameEntity_OnCreate(game_entity)
end

"""
    Destroy(Scene, GameEntity)

Destroy instantiated game entity in scene.

See also [`Instantiate`](@ref).
"""
function Destroy(scene::Scene, game_entity::GameEntity)
  if !(game_entity in scene.entities)
    return
  end
  remove!(scene.entities, game_entity)
  GameEntity_OnDestroy(game_entity)
end

function Scene_OnLoad(scene::Scene)
  for entity in scene.entities
    GameEntity_OnCreate(entity::GameEntity)
  end
end

function Scene_OnUnload(scene::Scene)
  for entity in scene.entities
    GameEntity_OnDestroy(entity::GameEntity)
  end
end

function Scene_OnRender(scene::Scene)
  Update!(scene.camera)
  for entity in scene.entities
    GameEntity_OnRender(entity::GameEntity)
  end
end

function Scene_OnUpdate(scene::Scene)
  for entity in scene.entities
    GameEntity_OnUpdate(entity::GameEntity)
  end
end

export Scene, CreateScene, Instantiate, Destroy