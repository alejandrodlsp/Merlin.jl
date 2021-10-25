using Base:String
using FileIO
using ColorTypes
using FixedPointNumbers

struct TextureResourceData <: ResourceData
    path::String
    data::Matrix{ColorTypes.RGBA{FixedPointNumbers.N0f8}}
end

function TextureResource_Load(texture_path)::TextureResourceData
    if (ResPool_Exists(texture_path))
        return ResPool_Get(texture_path)::TextureResourceData
    end

    data = load(texture_path)
    texture_data = TextureResourceData(texture_path, data)
    ResPool_Register(texture_path, texture_data)
    texture_data
end

function TextureResource_Unload(texture_path)
    ResPool_Unregister(texture_path)
end