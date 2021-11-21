include("Camera.jl")
include("GameEntity.jl")
include("Scene.jl")

# Define current scene only if not already defined
(@isdefined _MERLIN_CURRENT_SCENE) || (_MERLIN_CURRENT_SCENE = nothing)
# Define scene registry only if not already defined
(@isdefined _MERLIN_SCENE_REGISTRY) || (_MERLIN_SCENE_REGISTRY = Vector{Scene}())

function GetCurrentScene()::Scene
  (!isnothing(_MERLIN_CURRENT_SCENE)) || @error "Trying to access current scene when it is not defined"
  _MERLIN_CURRENT_SCENE
end

function IsActiveScene(scene::Scene)::Bool
  if (isnothing(_MERLIN_CURRENT_SCENE))
    return false
  end
  GetCurrentScene() === scene
end

function GetScene(name::String)
  scenes = findall(x -> x.name == name, _MERLIN_SCENE_REGISTRY)
  if length(scenes) > 1
    return scenes[0]
  end
  return false
end

function LoadScene(scene::Scene)
  if (_MERLIN_CURRENT_SCENE !== nothing)
    Scene_OnUnload(_MERLIN_CURRENT_SCENE)
  end
  global _MERLIN_CURRENT_SCENE = scene
  Scene_OnLoad(scene)
end

function SceneManager_OnRender()
  isnothing(_MERLIN_CURRENT_SCENE) && return
  Scene_OnRender(GetCurrentScene())
end

function SceneManager_OnUpdate()
  isnothing(_MERLIN_CURRENT_SCENE) && return
  Scene_OnUpdate(GetCurrentScene())
end

export GetCurrentScene, GetScene, LoadScene