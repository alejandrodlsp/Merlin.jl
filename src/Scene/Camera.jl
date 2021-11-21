using Base: Float64
abstract type Camera end

mutable struct PerspectiveCamera <: Camera
  position::Vector3{Float64}
  rotation::Rotation

  fov::Float64
  nearPlane::Float64
  farPlane::Float64

  PerspectiveCamera(; Position::Vector3{Float64} = Vector3{Float64}(0.0, 0.0, 0.0), Rotation::Rotation = Rotation(Vector3{Float64}(0.0, 0.0, 0.0), 0.0),
    Fov::Float64 = 70.0, NearPlane::Float64 = 0.1, FarPlane::Float64 = 100.0) = new(Position, Rotation, Fov, NearPlane, FarPlane)
end

mutable struct OrthographicCamera <: Camera
  position::Vector3{Float64}
  rotation::Rotation

  left::Float64
  right::Float64
  top::Float64
  bottom::Float64
  far::Float64
  near::Float64
end

function ViewMatrix(camera::Camera)
  rot = Rotate(camera.rotation.axis, camera.rotation.theta)
  trans = Translate(camera.position)
  rot * trans
end

function ProjectionMatrix(camera::Camera)
  if camera isa PerspectiveCamera
    PerspectiveProjectionMatrix(camera)
  elseif camera isa OrthographicCamera
    OrtographicProjectionMatrix(camera)
  else
    @error "Invalid camera type! Camera must be either ortographic camera or perspective camera"
  end
end

function PerspectiveProjectionMatrix(camera::PerspectiveCamera)
  fov = deg2rad(camera.fov)
  width, height = GLFW.GetFramebufferSize(Window_Get().NativeWindow)
  aspect_ratio = width / height
  range = tan(0.5 * fov) * camera.nearPlane
  Sx = 2.0 * camera.nearPlane / (range * aspect_ratio + range * aspect_ratio)
  Sy = camera.nearPlane / range
  Sz = -(camera.farPlane + camera.nearPlane) / (camera.farPlane - camera.nearPlane)
  Pz = -(2.0 * camera.farPlane * camera.nearPlane) / (camera.farPlane - camera.nearPlane)

  GLfloat[Sx 0.0 0.0 0.0
    0.0 Sy 0.0 0.0
    0.0 0.0 Sz Pz
    0.0 0.0 -1.0 0.0]
end

function OrtographicProjectionMatrix(camera::OrthographicCamera)
  [
    (2.0/(camera.right-camera.left)) 0 0 (-((camera.right + camera.left) / (camera.right - camera.left)))
    0 (2.0/(camera.top-camera.bottom)) 0 (-((camera.top + camera.bottom) / (camera.top - camera.bottom)))
    0 0 (2.0/(camera.far-camera.near)) (-((camera.far + camera.near) / (camera.far - camera.near)))
    0 0 0 1.0
  ]
end

export Camera, PerspectiveCamera, OrthographicCamera