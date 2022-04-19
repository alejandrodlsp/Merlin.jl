struct SceneResourceData <: ResourceData
  path::String
  scene_data::DataStructures.OrderedDict
end

# Load scene resource data
function SceneResource_Load(scene_path::AbstractString)::SceneResourceData
  if (ResourcePool_Exists(scene_path))
    return ResourcePool_GetElement(scene_path)::SceneResourceData
  end

  content = JSON.parsefile(scene_path; inttype = Int32, use_mmap = true) # dicttype = DataStructures.OrderedDict

  scene_data = SceneResourceData(scene_path, content)
  ResourcePool_Register(scene_path, scene_data)

  scene_data
end

# Unload scene resource data
function SceneResource_Unload(scene_path)
  ResourcePool_Unregister(scene_path)
end

export SceneResourceData, SceneResource_Load, SceneResource_Unload