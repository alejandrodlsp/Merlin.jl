struct ModelResourceData <: ResourceData
  path::String
  raw
  data
  pos
  pos_bv
  indices
  idx_bv
  texcoords
  tex_bv
  normals
  normal_bv
end

function ModelResource_Load(model_path::AbstractString)::ModelResourceData
  if (ResourcePool_Exists(model_path))
    return ResourcePool_GetElement(model_path)::ModelResourceData
  end

  gltf_raw = GLTF.load(model_path)
  gltf_data = [read(b.uri) for b in gltf_raw.buffers]

  search(x, keyword) = x[findfirst(x -> occursin(keyword, x.name), x)]

  pos = search(gltf_raw.accessors, "positions")
  pos_bv = gltf_raw.bufferViews[pos.bufferView]

  indices = search(gltf_raw.accessors, "indices")
  idx_bv = gltf_raw.bufferViews[indices.bufferView]

  texcoords = search(gltf_raw.accessors, "texcoords")
  tex_bv = gltf_raw.bufferViews[texcoords.bufferView]

  normals = search(gltf_raw.accessors, "normals")
  normal_bv = gltf_raw.bufferViews[normals.bufferView]

  model_data = ModelResourceData(model_path, gltf_raw, gltf_data, pos, pos_bv, indices, idx_bv, texcoords, tex_bv, normals, normal_bv)
  ResourcePool_Register(model_path, model_data)

  model_data
end

function ModelResource_Unload(model_path)
  ResourcePool_Unregister(model_path)
end

export ModelResourceData, ModelResource_Load, ModelResource_Unload