using Quaternions
using LinearAlgebra
using StaticArrays

"""
  Camera

Base camera class.

See also [`PerspectiveCamera`](@ref).
"""
abstract type Camera end

"""
    PerspectiveCamera::Camera

Data structure for a camera using a perspective projection.

# Arguments
- `Position::Vector3`: Initial position of camera in world space for calculating view matrix.
- `Rotation::Rotation`: Initial rotation of camera in world space for calculating view matrix
- `Fov::Float64`: Fov angle in degrees for projection matrix.
- `Near::Float64`: Near plane distance for projection matrix.
- `Far::Float64`: Far plane distance for projection matrix.

See also [`Camera`](@ref).
"""
mutable struct PerspectiveCamera <: Camera
  position::Vector3{Float64}
  rotation::Rotation

  fov::Float64
  near::Float64
  far::Float64

  forward::Vector3{Float64}
  right::Vector3{Float64}
  up::Vector3{Float64}

  viewMatrix::Matrix{GLfloat}
  rotationMatrix::Matrix{GLfloat}
  projectionMatrix::Matrix{GLfloat}
  quaternion::Quaternion{Float64}

  PerspectiveCamera(;
    Position::Vector3{Float64} = Vector3{Float64}(0.0, 0.0, 0.0),
    Rotation::Rotation = Rotation(Vector3{Float64}(0.0, 0.0, 0.0), 0.0),
    Fov::Float64 = 70.0, Near::Float64 = 0.1, Far::Float64 = 100.0,
    RotationMatrix = Matrix(I, 3, 3), ProjectionMatrix = Matrix(I, 4, 4), ViewMatrix = Matrix(I, 4, 4)) =
    CreateCamera(new(Position, Rotation, Fov, Near, Far, Vector3{Float64}(0.0, 0.0, -1.0), Vector3{Float64}(1.0, 0.0, 0.0), Vector3{Float64}(0.0, 1.0, 0.0), ViewMatrix, RotationMatrix, ProjectionMatrix, GetQuaternion(Rotation)))
end

"""
    CreateCamera(Camera)

Initializes a camera.

See also [`PerspectiveCamera`](@ref).
"""
function CreateCamera(camera::Camera)::Camera
  CalculatePerspectiveProjectionMatrix!(camera)
  setrotation!(camera, camera.rotation)
  Update!(camera)
  camera
end

"""
    setrotation!(Camera, rotation::Rotation)

Force sets rotation of camera object and updates camera view matrix.

See also [`rotate!`](@ref).
"""
function setrotation!(camera::Camera, rotation::Rotation)
  quaternion = GetQuaternion(rotation)
  CalculateRotationMatrix(camera, quaternion)
end

"""
    rotate!(Camera, delta::Rotation)

Apply rotation to camera object rotation by delta rotation.

See also [`setrotation!`](@ref).
"""
function rotate!(camera::Camera, rotation::Rotation)
  quaternion = GetQuaternion(rotation) * camera.quaternion    # incrementally update quaternion
  CalculateRotationMatrix(camera, quaternion)
end

"""
    setposition!(Camera, position::Vector3)

Force sets position of camera object and updates camera view matrix.

See also [`move!`](@ref).
"""
function setposition!(camera::Camera, x::Vector3{Float64})
  camera.position = x
end

"""
    move!(Camera, delta::Vector3)

Apply translation to camera object, moves by delta move vector.

See also [`setposition!`](@ref).
"""
function move!(camera::Camera, pos::Vector3{Float64})
  camera.position = camera.position + pos
end

"""
    reset!(Camera)

Resets camera position and rotation to zero values and re calculates view matrix.
"""
function reset!(camera::Camera)
  setposition!(camera, Vector3{Float64}(0, 0, 0))
  setrotation!(camera, Rotation(Vector3{Float64}(0.0, 0.0, 0.0), 0.0))
end

function Update!(camera::Camera)
  translation = Translate(camera.position)

  CalculateRotationMatrix(camera, camera.quaternion)
  rotation = convert(Matrix{GLfloat}, vcat([camera.rotationMatrix [0; 0; 0]], SMatrix{1,4,GLfloat,4}(0, 0, 0, 1)))

  camera.viewMatrix = rotation * translation
end

function CalculateViewMatrix(camera::Camera)
  camera.viewMatrix = inv(vcat([camera.rotationMatrix camera.position], SMatrix{1,4,GLfloat,4}(0, 0, 0, 1)))
end

function CalculateRotationMatrix(camera::Camera, x::Quaternion, fwd = [0, 0, -1], rgt = [1, 0, 0], up = [0, 1, 0])
  camera.quaternion = x
  camera.rotationMatrix = rotationmatrix(camera.quaternion)
  camera.forward = camera.rotationMatrix * fwd
  camera.right = camera.rotationMatrix * rgt
  camera.up = camera.rotationMatrix * up
  return camera.rotationMatrix
end

function CalculatePerspectiveProjectionMatrix!(camera::PerspectiveCamera)
  fov = deg2rad(camera.fov)
  width, height = GLFW.GetFramebufferSize(Window_Get().NativeWindow)
  aspect_ratio = width / height
  range = tan(0.5 * fov) * camera.near
  Sx = 2.0 * camera.near / (range * aspect_ratio + range * aspect_ratio)
  Sy = camera.near / range
  Sz = -(camera.far + camera.near) / (camera.far - camera.near)
  Pz = -(2.0 * camera.far * camera.near) / (camera.far - camera.near)

  camera.projectionMatrix = GLfloat[Sx 0.0 0.0 0.0
    0.0 Sy 0.0 0.0
    0.0 0.0 Sz Pz
    0.0 0.0 -1.0 0.0]
end

export Camera, PerspectiveCamera, setrotation!, rotate!, setposition!, move!, reset!