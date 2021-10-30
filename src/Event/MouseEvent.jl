using Base:Float64

struct MouseMovedEventData <: EventData
    type::EventType
    posx::Float64
    posy::Float64

    MouseMovedEventData(posx::Float64, posy::Float64) = new(EventTypeMouseMoved, posx, posy)
end

struct MouseButtonEventData <: EventData
    type::EventType
    code::Cint

    MouseButtonEventData(type::EventType, code::Cint) = new(type, code)
end

struct MouseScrollEventData <: EventData
    type::EventType
    scrollX::Float64
    scrollY::Float64

    MouseScrollEventData(scrollX::Float64, scrollY::Float64) = new(EventTypeMouseScrolled, scrollX, scrollY)
end

export MouseMovedEventData, MouseButtonEventData, MouseScrollEventData