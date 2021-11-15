using Base:String
using FileIO
using ColorTypes
using FixedPointNumbers

struct TextureResourceData <: ResourceData
    path::String
    data::Matrix{ColorTypes.RGBA{FixedPointNumbers.N0f8}}
end

function TextureResource_Load(texture_path)::TextureResourceData
    if (ResourcePool_Exists(texture_path))
        return ResourcePool_GetElement(texture_path)::TextureResourceData
    end

    data = load(texture_path)
    texture_data = TextureResourceData(texture_path, data)
    ResourcePool_Register(texture_path, texture_data)
    texture_data
end

function TextureResource_Unload(texture_path)
    ResourcePool_Unregister(texture_path)
end

export TextureResource_Load, TextureResource_Unload