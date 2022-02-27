include("Serializer.jl")
include("Parser.jl")

function LoadScene(scene_path::String)::Scene
  scene_resource = SceneResource_Load(scene_path)
  LoadScene(scene_resource)
end

function LoadScene(sceneResource::SceneResourceData)::Scene
  entities = Vector{GameEntity}()
  if haskey(sceneResource.scene_data, "entities")
    entities = ParseEntities(sceneResource.scene_data["entities"])
  end

  haskey(sceneResource.scene_data, "camera") || @error "Reading scene: Must define scene."
  camera = ParseCamera(sceneResource.scene_data["camera"])

  scene_file = split(sceneResource.path, "/")[end] # Get filename

  scene = Scene(scene_file, camera, entities)

  scene
end

export LoadScene