using Printf
using CoordinateTransformations, Rotations

"""
    Rotation

Data structure for a rotation value. Given rotation axis and theta angle.
"""
mutable struct Rotation
  axis::Vector3{Float64}
  theta::Float64
end

"""
    Transform

Data structure for a transform component. Includes transform name, position, rotation, scale and parent and children.

See also [`Vector3`](@ref).
See also [`Rotation`](@ref).
"""
mutable struct Transform
  name::String
  position::Vector3{Float64}
  rotation::Rotation
  scale::Vector3{Float64}
  parent
  children
end

"""
    Transform::Transform

Creates a transform based on a position
"""
Transform(position::Vector3{Float64};
  rotation::Rotation = Rotation(Vector3(0.0, 0.0, 0.0), 0.0),
  scale::Vector3{Float64} = Vector3(1.0, 1.0, 1.0),
  name::String = "Transform",
  parent = missing,
  children = missing) = Transform(name, position, rotation, scale, parent, children)

"""
    SetParent(transform::Transform, parent::Transform)

Sets the base parent of transform and assings children.
"""
function SetParent(transform::Transform, parent::Transform)
  if !isnothing(transform.parent)
    remove!(transform.parent.children, transform)
  end

  transform.parent = parent
  push!(parent.children, transform)
end

"""
    GetModelMatrix(transform::Transform)::MatrixX4

Calculates model matrix of transform based on rotation, scale and translation.
"""
function GetModelMatrix(transform::Transform)
  id = Identity()
  scale = Scale(transform.scale)
  translate = Translate(transform.position)
  rot = Rotate(transform.rotation.axis, transform.rotation.theta)
  id * translate * rot * scale
end

# Gets quaternion based on rotation
function GetQuaternion(rotation::Rotation)
  qrotation(Vector(rotation.axis), deg2rad(rotation.theta))
end

export Transform, Rotation, SetParent, GetModelMatrix, GetQuaternion