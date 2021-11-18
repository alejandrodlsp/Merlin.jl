using ModernGL
using CSyntax
using ConfigEnv
import GLFW

include("Math/Math.jl")
include("Renderer/Renderer.jl")
include("Resource/Resource.jl")
include("Logger.jl")
include("Window.jl")
include("Scene/SceneManager.jl")

"""
    
"""
struct ApplicationParams
    window::WindowProps
    onStart::Function
    onShutdown::Function
    onEvent::Function
    onUpdate::Function
    onRender::Function
    ApplicationParams( ;
                        Window::WindowProps=WindowProps(),
                        OnStart::Function=() -> (),
                        OnShutdown::Function=() -> (),
                        OnEvent::Function=(e) -> (),
                        OnUpdate::Function=() -> (),
                        OnRender::Function=() -> (),
                        ) = new(
                          Window,
                          OnStart,
                          OnShutdown,
                          OnEvent,
                          OnUpdate,
                          OnRender
                        )
end

struct ApplicationData
    loggerData::LoggerData
    onStart::Function
    onShutdown::Function
    onUpdate::Function
    onRender::Function
end

# Define application data only if not already defined
(@isdefined APPLICATION_DATA) || ( APPLICATION_DATA = nothing )

function Application_Get()::ApplicationData
    (@isdefined APPLICATION_DATA) ||  @error "Trying to access application when it is not defined"
    APPLICATION_DATA
end

function Application_Init(params::ApplicationParams)::ApplicationData
    dotenv()

    loggerData = Logger_Init()
    Resource_Init()

    Window_Init(params.window, params.onEvent)

    global APPLICATION_DATA = ApplicationData(loggerData, params.onStart, params.onShutdown, params.onUpdate, params.onRender)
end

function Application_Run()
    glEnable(GL_DEPTH_TEST);  
    glEnable(GL_BLEND);
    glEnable(GL_ALPHA_TEST);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

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
end

function Application_Shutdown()
    Application_Get().onShutdown()
    Window_Shutdown()
    Logger_Shutdown(Application_Get().loggerData)
    ResourcePool_Flush()
end

function Application_ShouldClose()
    Window_ShouldClose()
end

export Application_Init, Application_Run, Application_ShouldClose, Application_Shutdown, ApplicationParams, ApplicationData, Application_Get
