mutable struct ResourcePoolData
  loaded_resources::Dict{String,ResourceData}
end

# Define application data only if not already defined
(@isdefined RESOURCE_POOL) || (RESOURCE_POOL = ResourcePoolData(Dict{String,ResourceData}()))

function ResourcePool_Get()::ResourcePoolData
  (@isdefined RESOURCE_POOL) || @error "Trying to access resource pool when it is not defined"
  RESOURCE_POOL
end

function ResourcePool_Exists(resource_path::String)
  haskey(ResourcePool_Get().loaded_resources, resource_path)
end

function ResourcePool_Register(resource_path::String, resource::ResourceData)
  if ResourcePool_Exists(resource_path)
    @info "Tried to re-register resource to resource pool: " resource_path " (" resource.type ")"
    return
  end

  @debug "Registering resource at (" resource_path ") in resource pool"
  ResourcePool_Get().loaded_resources[resource_path] = resource
end

function ResourcePool_GetElement(resource_path::String)::ResourceData
  if !ResourcePool_Exists(resource_path)
    @info "Tried to access resource in resource pool which did not exist: " resource_path " (" resource.type ")"
    return
  end
  @debug "Loaded resource from pool: " resource_path
  ResourcePool_Get().loaded_resources[resource_path]
end

function ResourcePool_Unregister(resource_path::String)
  @debug "Unloading resource at (" resource_path ") in resource pool"
  delete!(ResourcePool_Get().loaded_resources, resource_path)
end

function ResourcePool_Flush()
  ResourcePool_Get().loaded_resources = Dict{String,ResourceData}()
end