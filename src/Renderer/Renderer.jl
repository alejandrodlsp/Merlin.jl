abstract type Renderable end

# Abstract render function
function Render(renderable::Renderable, transform::Transform) 
end

include("Texture.jl")
include("Shader.jl")
include("Program.jl")
include("Renderable/QuadRenderer.jl")