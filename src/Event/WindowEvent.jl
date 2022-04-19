"""
    WindowCloseEventData::EventData

Data structure for a window closed event

See also [`EventData`](@ref).
"""
struct WindowCloseEventData <: EventData
  type::EventType

  WindowCloseEventData() = new(EventTypeWindowClose)
end

"""
    WindowSizeEventData::EventData

Data structure for a window resized event

See also [`EventData`](@ref).
"""
struct WindowSizeEventData <: EventData
  type::EventType
  sizex::Cint
  sizey::Cint

  WindowSizeEventData(sizex::Cint, sizey::Cint) = new(EventTypeWindowResize, sizex, sizey)
end

"""
    WindowMovedEventData::EventData

Data structure for a window moved event

See also [`EventData`](@ref).
"""
struct WindowMovedEventData <: EventData
  type::EventType
  posx::Cint
  posy::Cint

  WindowMovedEventData(posx::Cint, posy::Cint) = new(EventTypeWindowMoved, posx, posy)
end

export WindowClose, WindowSizeEventData, WindowMovedEventData