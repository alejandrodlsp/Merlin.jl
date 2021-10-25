abstract type ResourceData end

include("ResourcePool.jl")
include("TextureResource.jl")
include("ProgramResource.jl")

function Resource_Init(resource_file_path::String=Resource_ResFilePath())
  # TODO: parse resource file to create resources
end

function Resource_ResFilePath()::String
    if !haskey(ENV, "MERLIN_RESOURCE_FILE_PATH")
        @error "No resource file was declared, did you declare ENV[\"MERLIN_RESOURCE_FILE_PATH\"] ?"
    end
    return resource_file_path = ENV["MERLIN_RESOURCE_FILE_PATH"]
end