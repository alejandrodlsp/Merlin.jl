# Roll about x axis
function GetRotX(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1]
end

# Pitch around y axis
function GetRotY(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [cos(theta) 0 sin(theta) 0; 0 1 0 0; -sin(theta) 0 cos(theta) 0; 0 0 0 1]
end

# Yaw around z axis
function GetRotZ(theta::Float64, angleInDeg = false)
  if (angleInDeg)
    theta = theta * pi / 180.0
  end
  return [cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0; 0 0 0 1]
end

# Calculate x4 indentity matrix
function Identity()
  GLfloat[1.0 0.0 0.0 0.0
    0.0 1.0 0.0 0.0
    0.0 0.0 1.0 0.0
    0.0 0.0 0.0 1.0]
end

# Calculate x4 scale matrix based on vector scale
function Scale(v::Vector3{Float64})
  GLfloat[v.x 0.0 0.0 0.0
    0.0 v.y 0.0 0.0
    0.0 0.0 v.z 0.0
    0.0 0.0 0.0 1.0]
end

# Calculate x4 translation matrix based on vector translation
function Translate(v::Vector3{Float64})
  GLfloat[1.0 0.0 0.0 v.x
    0.0 1.0 0.0 v.y
    0.0 0.0 1.0 v.z
    0.0 0.0 0.0 1.0]
end

# Calculate x4 rotation matrix based on rotation struct
function Rotate(r::Rotation)
  Rotate(r.axis, r.theta)
end

# Calculate x4 rotation matrix based on vector rotation and theta angle
function Rotate(r::Vector3{Float64}, t)
  GLfloat[(cosd(t)+(r.x*r.x)*(1-cosd(t))) (r.x*r.y*(1-cosd(t))-r.z*sind(t)) (r.x*r.z*(1-cosd(t))+r.y*sind(t)) 0.0
    (r.y*r.x*(1-cosd(t))+r.z*sind(t)) (cosd(t)+r.y*r.y*(1-cosd(t))) (r.y*r.z*(1-cosd(t))-r.x*sind(t)) 0.0
    (r.z*r.x*(1-cosd(t))-r.y*sind(t)) (r.z*r.y*(1-cosd(t))+r.x*sind(t)) (cosd(t)+r.z*r.z*(1-cosd(t))) 0.0
    0.0 0.0 0.0 1.0]
end

export Identity, Scale, Translate, Rotate