abstract type Renderable end

# Abstract render function
Render(renderable::Renderable, transform::Transform) = ()

include("Shader.jl")
include("Program.jl")
include("Renderable/Triangle.jl")