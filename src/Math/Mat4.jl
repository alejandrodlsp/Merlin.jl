using LinearAlgebra

## roll: about x-axis
function GetRotX(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1]
end

## pitch: about y-axis
function GetRotY(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [cos(theta) 0 sin(theta) 0; 0 1 0 0; -sin(theta) 0 cos(theta) 0; 0 0 0 1]
end

## yaw: about z-axis
function GetRotZ(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0; 0 0 0 1]
end

function Identity()
  GLfloat[1.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 1.0]
end

function Scale(v::Vector3{Float64})
  GLfloat[v.x 0.0 0.0 0.0
    0.0 v.y 0.0 0.0
    0.0 0.0 v.z 0.0
    0.0 0.0 0.0 1.0]
end

function Translate(v::Vector3{Float64})
  GLfloat[1.0 0.0 0.0 v.x
    0.0 1.0 0.0 v.y
    0.0 0.0 1.0 v.z
    0.0 0.0 0.0 1.0]
end

function Rotate(r::Vector3{Float64}, t)
  GLfloat[(cosd(t)+(r.x*r.x)*(1-cosd(t))) (r.x*r.y*(1-cosd(t))-r.z*sind(t)) (r.x*r.z*(1-cosd(t))+r.y*sind(t)) 0.0
    (r.y*r.x*(1-cosd(t))+r.z*sind(t)) (cosd(t)+r.y*r.y*(1-cosd(t))) (r.y*r.z*(1-cosd(t))-r.x*sind(t)) 0.0
    (r.z*r.x*(1-cosd(t))-r.y*sind(t)) (r.z*r.y*(1-cosd(t))+r.x*sind(t)) (cosd(t)+r.z*r.z*(1-cosd(t))) 0.0
    0.0 0.0 0.0 1.0]
end

export Identity, Scale, Translate, Rotate