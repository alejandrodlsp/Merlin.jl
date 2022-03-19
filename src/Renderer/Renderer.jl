abstract type Renderable end

# Abstract render function
function Render(renderable::Renderable, transform::Transform) end

include("Renderable/QuadRenderer.jl")
include("Renderable/ModelRenderer.jl")

function Renderer_Initialize()
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_BLEND)
  glDepthFunc(GL_LESS)
  glEnable(GL_ALPHA_TEST)

  glEnable(GL_CULL_FACE)
  glCullFace(GL_BACK)
  glFrontFace(GL_CCW)

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
end

function Renderer_Tick()
  glClearColor(0.1, 0.1, 0.1, 1.0)
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
end