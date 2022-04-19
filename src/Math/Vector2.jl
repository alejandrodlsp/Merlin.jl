using Printf

mutable struct Vector2{R<:Real} <: AbstractVector{2,R}
  x::R
  y::R
end

# Vector2 constructors
Vector2() = Vector2(0.0, 0.0)
Vector2(t::Tuple) = Vector2(promote(t...)...)
toArray(v::Vector2) = ([v.x; v.y])

# Print vector
Base.show(io::IO, a::Vector2) = @printf(io, "Vector2(%.4f, %.4f)", a.x, a.y)
Base.atan(a::Vector2) = atan(a.y, a.x)

# Return distance squared between two vectors
function distance2(a::Vector2, b::Vector2)
  dx = a.x - b.x
  dy = a.y - b.y
  (dx * dx + dy * dy)
end

# Return distance between two vectors
function distance(a::Vector2, b::Vector2)
  sqrt(distance2(a, b))
end

function lerp(a::Vector2, b::Vector2, t::Real)
  Vector2(lerp(a.x, b.x, t), lerp(a.y, b.y, t))
end

# Rotates counter-clockwise about origin
function rot(a::Vector2, θ::Vector2)
  c = cos(θ)
  s = sin(θ)

  VecE2(a.x * c - a.y * s, a.x * s + a.y * c)
end

export Vector2, distance2, distance, lerp, rot, toArray