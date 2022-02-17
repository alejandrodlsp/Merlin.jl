include("Serializer.jl")
include("Parser.jl")

const EntityArray{T<:Transform} = Vector{T}

function LoadScene(scene_path::String)#todo return scene
  scene_resource = SceneResource_Load(scene_path)
  LoadScene(scene_resource)
end

function LoadScene(sceneResource::SceneResourceData)#todo return scene
  if haskey(sceneResource.scene_data, "entities")
    ParseEntities(sceneResource.scene_data["entities"])
  end
end

export LoadScene