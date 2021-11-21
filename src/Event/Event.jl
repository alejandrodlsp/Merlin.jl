using Base: UInt32

@enum EventType begin
  EventTypeNone
  EventTypeKeyPressed
  EventTypeKeyReleased
  EventTypeMouseButtonPressed
  EventTypeMouseButtonReleased
  EventTypeMouseMoved
  EventTypeMouseScrolled
  EventTypeWindowClose
  EventTypeWindowResize
  EventTypeWindowFocus
  EventTypeWindowLostFocus
  EventTypeWindowMoved
  EventTypeAppTick
  EventTypeAppUpdate
  EventTypeAppRender
end

abstract type EventData end

include("KeyEvent.jl")
include("MouseEvent.jl")
include("WindowEvent.jl")

function Event_Dispatch(eventData::EventData, eventType::EventType, fnc)
  if (eventData.type == eventType)
    fnc(eventData)
  end
end

export EventType, EventData, Event_Dispatch, EventTypeNone, EventTypeKeyPressed, EventTypeKeyReleased, EventTypeMouseButtonPressed, EventTypeMouseButtonReleased, EventTypeMouseMoved, EventTypeMouseScrolled, EventTypeWindowClose, EventTypeWindowResize, EventTypeWindowFocus, EventTypeWindowLostFocus, EventTypeWindowMoved, EventTypeAppTick, EventTypeAppUpdate, EventTypeAppRender