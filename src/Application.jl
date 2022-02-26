using ModernGL
using CSyntax
using ConfigEnv
import GLFW
import DataStructures
import JSON
import FileIO

include("Math/Math.jl")
include("Renderer/Renderer.jl")
include("Resource/Resource.jl")
include("Logger.jl")
include("Window.jl")
include("Scene/SceneManager.jl")

# Application data singleton definition
(@isdefined APPLICATION_DATA) || (APPLICATION_DATA = nothing)

"""
    ApplicationParams

Data structure defining application startup parameters.
"""
struct ApplicationParams
  window::WindowParams
  onStart::Function
  onShutdown::Function
  onEvent::Function
  onUpdate::Function
  onRender::Function
  ApplicationParams(;
    Window::WindowParams = WindowParams(),
    OnStart::Function = () -> (),
    OnShutdown::Function = () -> (),
    OnEvent::Function = (e) -> (),
    OnUpdate::Function = () -> (),
    OnRender::Function = () -> ()
  ) = new(
    Window,
    OnStart,
    OnShutdown,
    OnEvent,
    OnUpdate,
    OnRender
  )
end

"""
    ApplicationData

Data structure containing the current data (state) of the Application running
```
"""
struct ApplicationData
  loggerData::LoggerData
  onStart::Function
  onShutdown::Function
  onUpdate::Function
  onRender::Function
end

"""
    Application_Get()::ApplicationData

Return the current application data (state).

Application data is a singleton, given there can only be one application instance running at the same time.
```
"""
function Application_Get()::ApplicationData
  (@isdefined APPLICATION_DATA) || @error "Trying to access application when it is not defined"
  APPLICATION_DATA
end

"""
    Application_Init(params::ApplicationParams)::ApplicationData

Initialize a new application given a set of starting application params, return new application state.

If `y` is unspecified, compute the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> Application_Init(ApplicationParams())
{ApplicationData}
```
"""
function Application_Init(params::ApplicationParams)::ApplicationData
  dotenv()

  loggerData = Logger_Init()
  Resource_Init()

  Window_Init(params.window, params.onEvent)

  global APPLICATION_DATA = ApplicationData(loggerData, params.onStart, params.onShutdown, params.onUpdate, params.onRender)
end

"""
    Application_Run()

Execute the current application state.

Enters the application loop, must be exited with a proper shutdown within the application loop.

See also [`Application_Shutdown`](@ref).
```
"""
function Application_Run()
  glEnable(GL_DEPTH_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_ALPHA_TEST)
  glDepthFunc(GL_LESS)

  # enable cull face
  glEnable(GL_CULL_FACE)
  glCullFace(GL_BACK)
  glFrontFace(GL_CW)

  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  Application_Get().onStart()

  while !Application_ShouldClose()
    glClearColor(0.1, 0.1, 0.1, 1.0)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    Application_Get().onUpdate()
    SceneManager_OnUpdate()

    Application_Get().onRender()
    SceneManager_OnRender()

    Window_Update()
  end

  Application_Shutdown()
  "Merlin Engine"
end

"""
    Application_Shutdown()

Terminates and cleansup execution of the application loop.
```
"""
function Application_Shutdown()
  Application_Get().onShutdown()
  Window_Shutdown()
  Logger_Shutdown(Application_Get().loggerData)
  ResourcePool_Flush()
end

"""
    Application_ShouldClose()::Bool

Return true if window close event is enqueued.
```
"""
function Application_ShouldClose()::Bool
  Window_ShouldClose()
end

export Application_Init, Application_Run, Application_ShouldClose, Application_Shutdown, ApplicationParams, ApplicationData, Application_Get
