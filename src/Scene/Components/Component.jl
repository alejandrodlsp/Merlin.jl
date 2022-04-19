abstract type Component end

struct ComponentReference
  file::String
  constructor::String
end

# Base component type
mutable struct BaseComponent <: Component
  entity
  data
  onActivate::Function
  onDeactivate::Function
  onStart::Function
  onUpdate::Function
  is_active::Bool

  BaseComponent(; Data = Dict(),
    Is_active::Bool = true,
    OnActivate::Function = (c) -> (),
    OnDeactivate::Function = (c) -> (),
    OnStart::Function = (c) -> (),
    OnUpdate::Function = (c) -> ()) = new(nothing, Data, OnActivate, OnDeactivate, OnStart, OnUpdate, Is_active)
end

# Activate component
function setActive(component::BaseComponent, active::Bool)
  if (component.is_active && !active)
    component.is_active = false
    component.onDeactivate(component)
  elseif (!component.is_active && active)
    component.is_active = true
    component.onActivate(component)
  end
end

export Component, BaseComponent, setActive