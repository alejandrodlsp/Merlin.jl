struct KeyEventData <: EventData
    type::EventType
    code::Cint
    repeat::Cint

    KeyEventData(type::EventType, code::Cint, repeat::Cint) = new(type, code, repeat)
end

export KeyEventData
