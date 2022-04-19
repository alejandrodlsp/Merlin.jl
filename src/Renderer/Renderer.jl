abstract type Renderable end

# Abstract render function
function Render(renderable::Renderable, transform::Transform) end

# Include all render modules
include("Texture.jl")
include("Shader.jl")
include("Program.jl")
include("Renderable/QuadRenderer.jl")
include("Renderable/MeshRenderer.jl")
include("Primitives.jl")

# Initializes rendering variables
function Renderer_Initialize()
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_ALPHA_TEST)
  glDepthFunc(GL_LESS)

  # enable cull face
  glEnable(GL_CULL_FACE)
  glCullFace(GL_BACK)
  glFrontFace(GL_CW)

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end

# Update tick for renderer
function Renderer_Update()
  glClearColor(0.1, 0.1, 0.1, 1.0)
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
end