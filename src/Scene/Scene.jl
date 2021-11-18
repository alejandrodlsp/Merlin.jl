mutable struct Scene
    name::String
    entities::Vector{GameEntity}
end

function CreateScene(name::String)::Scene
    if (GetScene(name))
        @error "Trying to create a scene when another scene exists with the same name"
    end
    
    scene = Scene(name, Vector{GameEntity}())# , Vector{GameEntity}())
    push!(_MERLIN_SCENE_REGISTRY, scene)
    scene
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
    for entity in scene.entities
        GameEntity_OnRender(entity::GameEntity)
    end
end

function Scene_OnUpdate(scene::Scene)
    for entity in scene.entities
        GameEntity_OnUpdate(entity::GameEntity)
    end
end

function Instantiate(scene::Scene, game_entity::GameEntity)
    if game_entity in scene.entities
        return
    end
    push!(scene.entities, game_entity)
    IsActiveScene(scene) && GameEntity_OnCreate(game_entity)
end

function Destroy(scene::Scene, game_entity::GameEntity)
    if !(game_entity in scene.entities)
        return
    end
    remove!(scene.entities, game_entity)
    GameEntity_OnDestroy(game_entity)
end

export Scene, CreateScene, Instantiate, Destroy 