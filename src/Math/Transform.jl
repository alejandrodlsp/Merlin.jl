using Printf

mutable struct Transform
    name::String
    position::Vector3{Float64}
    rotation::Vector3{Float64}
    scale::Vector3{Float64}
    parent
    children
end

Transform(  position::Vector3{Float64}; 
            rotation::Vector3{Float64}=Vector3(0.0, 0.0, 0.0), 
            scale::Vector3{Float64}=Vector3(1.0, 1.0, 1.0),
            name::String="Transform",
            parent=missing,
            children=missing) = Transform(name, position, rotation, scale, parent, children)

function SetParent(transform::Transform, parent::Transform)
    if !isnothing(transform.parent)
        remove!(transform.parent.children, transform)
    end

    transform.parent = parent
    push!(parent.children, transform)
end

function GetModelMatrix(transform::Transform)
    GLfloat[1.0 0.0 0.0 transform.position.x;
                    0.0 1.0 0.0 transform.position.y;
                    0.0 0.0 1.0 transform.position.z;
                    0.0 0.0 0.0 1.0]
end

export Transform, SetParent, GetModelMatrix