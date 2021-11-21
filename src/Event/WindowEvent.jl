struct WindowCloseEventData <: EventData
  type::EventType

  WindowCloseEventData() = new(EventTypeWindowClose)
end

struct WindowSizeEventData <: EventData
  type::EventType
  sizex::Cint
  sizey::Cint

  WindowSizeEventData(sizex::Cint, sizey::Cint) = new(EventTypeWindowResize, sizex, sizey)
end

struct WindowMovedEventData <: EventData
  type::EventType
  posx::Cint
  posy::Cint

  WindowMovedEventData(posx::Cint, posy::Cint) = new(EventTypeWindowMoved, posx, posy)
end

export WindowClose, WindowSizeEventData, WindowMovedEventData