"""
    KeyEventData::EventData

Data structure for a key event

See also [`EventData`](@ref).
"""
struct KeyEventData <: EventData
  type::EventType
  code::Cint
  repeat::Cint

  KeyEventData(type::EventType, code::Cint, repeat::Cint) = new(type, code, repeat)
end

export KeyEventData
