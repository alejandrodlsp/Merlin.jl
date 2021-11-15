using Printf

mutable struct Transform
    position::Vector3{Float64}
    rotation::Vector3{Float64}
    scale::Vector3{Float64}
    parent::Transform
    children::Vector{Transform}

    Transform(  position, 
                rotation=Vector3(0.0, 0.0, 0.0), 
                scale=Vector3(1.0, 1.0, 1.0)
                ; parent=nothing) = Transform(position, rotation, scale, parent, Vector{Transform}())
end

function SetParent(transform::Transform, parent::Transform)
    if !isnothing(transform.parent)
        remove!(transform.parent.children, transform)
    end

    transform.parent = parent
    push!(parent.children, transform)
end

function GetModelMatrix()
end

export Transform, SetParent