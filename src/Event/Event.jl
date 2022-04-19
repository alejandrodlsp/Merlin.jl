using Base: UInt32

"""
    EventType::Enum

Enumeration of event types
"""
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

"""
    Event_Dispatch

Dispatches an event function based if the event data type is of the specified type

See also [`EventData`](@ref).
"""
function Event_Dispatch(eventData::EventData, eventType::EventType, fnc)
  if (eventData.type == eventType)
    fnc(eventData)
  end
end

export EventType, EventData, Event_Dispatch, EventTypeNone, EventTypeKeyPressed, EventTypeKeyReleased, EventTypeMouseButtonPressed, EventTypeMouseButtonReleased, EventTypeMouseMoved, EventTypeMouseScrolled, EventTypeWindowClose, EventTypeWindowResize, EventTypeWindowFocus, EventTypeWindowLostFocus, EventTypeWindowMoved, EventTypeAppTick, EventTypeAppUpdate, EventTypeAppRender