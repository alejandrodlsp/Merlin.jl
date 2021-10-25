mutable struct ResourcePoolData
    loaded_resources::Dict{String,ResourceData}
end

(@isdefined RESOURCE_POOL) || (RESOURCE_POOL = ResourcePoolData(Dict{String,ResourceData}()))
if isnothing(RESOURCE_POOL)
    global RESOURCE_POOL 
    RESOURCE_POOL = ResourcePoolData(Dict{String,ResourceData}())
end

function ResPool_Exists(resource_path::String)
    haskey(RESOURCE_POOL.loaded_resources, resource_path)
end

function ResPool_Register(resource_path::String, resource::ResourceData)
    if ResPool_Exists(resource_path)
        @info "Tried to re-register resource to resource pool: " resource_path " (" resource.type ")"
        return
    end
    
    @debug "Registering resource at (" resource_path ") in resource pool" 
    RESOURCE_POOL.loaded_resources[resource_path] = resource
end

function ResPool_Get(resource_path::String)::ResourceData
    if !ResPool_Exists(resource_path)
        @info "Tried to access resource in resource pool which did not exist: " resource_path " (" resource.type ")"
        return
    end
    @debug "Loaded resource from pool: " resource_path
    RESOURCE_POOL.loaded_resources[resource_path]
end

function ResPool_Unregister(resource_path::String)
    @debug "Unloading resource at (" resource_path ") in resource pool"
    delete!(RESOURCE_POOL.loaded_resources, resource_path)
end

function ResPool_Flush()
    global RESOURCE_POOL
    RESOURCE_POOL = nothing
end