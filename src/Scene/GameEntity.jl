include("Components/Component.jl")

const ComponentArray{T<:BaseComponent} = Vector{T}

mutable struct GameEntity
  uuid::UInt
  transform::Transform
  renderable::Renderable
  components::ComponentArray
end

GameEntity(renderable::Renderable; transform::Transform = Transform(Vector3(0.0, 0.0, 0.0)), components::ComponentArray = ComponentArray{BaseComponent}(undef, 0)) =
  GameEntity(
    GameEntity_GetNextUUID(),
    transform,
    renderable,
    components
  )

(@isdefined _MERLIN_GAME_ENTITY_CURRENT_UUID) || (_MERLIN_GAME_ENTITY_CURRENT_UUID = 0)

function GameEntity_GetNextUUID()
  global _MERLIN_GAME_ENTITY_CURRENT_UUID = _MERLIN_GAME_ENTITY_CURRENT_UUID + 1
end

function AddComponent(game_entity::GameEntity, component::BaseComponent)
  push!(game_entity.components, component)
  component.entity = game_entity
  component.onStart(component)
  component.onActivate(component)
end

function GameEntity_OnCreate(game_entity::GameEntity)
  for component in game_entity.components
    component.entity = game_entity
    component.onStart(component)
    if component.is_active
      component.onActivate(component)
    end
  end
end

function GameEntity_OnDestroy(game_entity::GameEntity)
  for component in game_entity.components
    component.onDeactivate(component)
  end
end

function GameEntity_OnUpdate(game_entity::GameEntity)
  for component in game_entity.components
    if component.is_active
      component.onUpdate(component)
    end
  end
end

function GameEntity_OnRender(game_entity::GameEntity)
  Render(game_entity.renderable, game_entity.transform, GetCurrentScene())
end

export GameEntity, AddComponent