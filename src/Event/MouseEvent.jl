using Base: Float64

"""
    MouseMovedEventData::EventData

Data structure for a mouse moved event

See also [`EventData`](@ref).
"""
struct MouseMovedEventData <: EventData
  type::EventType
  posx::Float64
  posy::Float64

  MouseMovedEventData(posx::Float64, posy::Float64) = new(EventTypeMouseMoved, posx, posy)
end

"""
    MouseButtonEventData::EventData

Data structure for a mouse button press event

See also [`EventData`](@ref).
"""
struct MouseButtonEventData <: EventData
  type::EventType
  code::Cint

  MouseButtonEventData(type::EventType, code::Cint) = new(type, code)
end

"""
    MouseScrollEventData::EventData

Data structure for a mouse scroll event

See also [`EventData`](@ref).
"""
struct MouseScrollEventData <: EventData
  type::EventType
  scrollX::Float64
  scrollY::Float64

  MouseScrollEventData(scrollX::Float64, scrollY::Float64) = new(EventTypeMouseScrolled, scrollX, scrollY)
end

export MouseMovedEventData, MouseButtonEventData, MouseScrollEventData