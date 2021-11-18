using CSyntax
using STBImage.LibSTBImage

struct TextureResourceData <: ResourceData
    path::String
    texture::TextureData
end

function TextureResource_Load(texture_path)::TextureResourceData
    if (ResourcePool_Exists(texture_path))
        return ResourcePool_GetElement(texture_path)::TextureResourceData
    end

    x, y, n = Cint(0), Cint(0), Cint(0)
    force_channels = 4
    stbi_set_flip_vertically_on_load(true)
    tex_data = @c stbi_load(texture_path, &x, &y, &n, force_channels)
    
    if tex_data == C_NULL
        @error "could not load texture from $texture_path."
        return nothing
    end

    texture = Texture_Create(x, y, tex_data)
    
    texture_data = TextureResourceData(texture_path, texture)
    ResourcePool_Register(texture_path, texture_data)
    
    # stbi_image_free(tex_data)
    texture_data
end

function TextureResource_Unload(texture_path)
    ResourcePool_Unregister(texture_path)
end

export TextureResource_Load, TextureResource_Unload