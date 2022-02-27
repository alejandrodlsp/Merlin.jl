function Serialize(v::Vector3)
  "[$(v.x), $(v.y), $(v.z)]"
end

function Serialize(v::Vector2)
  "[$(v.x), $(v.y)]"
end

function Serialize(r::Rotation)
  "{ \"axis\" : $(Serialize(r.axis)), \"theta\" : $(r.theta) }"
end

function Serialize(t::Transform)
  v = "{ \"name\" : $(t.name), \"position\" : $(Serialize(t.position)), \"rotation\" : $(Serialize(t.rotation)), \"scale\" : $(Serialize(t.scale))"
  if !ismissing(t.parent)
    v * "\"parent\":" * Serialize(t.parent)
  end
  if !ismissing(t.children) && size(t.children) > 0
    v * "\"children\": ["
    for (index, child) in t.children
      v * Serialize(child) * ", "
    end
    v * "]"
  end
  v * "}"
end

export Serialize

