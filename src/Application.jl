include("Math/Math.jl")
include("Renderer/Renderer.jl")
include("Resource/Resource.jl")
include("Logger.jl")
include("Window.jl")

using ModernGL
using ConfigEnv

"""
    
"""
struct ApplicationParams
    window::WindowProps
    onEvent::Function
    onUpdate::Function
    onRender::Function
    ApplicationParams( ;
                        Window::WindowProps=WindowProps(),
                        OnEvent::Function=(e) -> (),
                        OnUpdate::Function=() -> (),
                        OnRender::Function=() -> (),
                        ) = new(
                          Window,
                          OnEvent,
                          OnUpdate,
                          OnRender
                        )
end

struct ApplicationData
    loggerData::LoggerData
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

    global APPLICATION_DATA = ApplicationData(loggerData, params.onUpdate, params.onRender)
end

function Application_Run()
    glClearColor(0.1, 0.1, 0.1, 1.0)

    while !Application_ShouldClose()
        Application_Get().onUpdate()

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        Application_Get().onRender()

        Window_Update()
    end
    
    Application_Shutdown()
end

function Application_Shutdown()
    Window_Shutdown()
    Logger_Shutdown(Application_Get().loggerData)
    ResourcePool_Flush()
end

function Application_ShouldClose()
    Window_ShouldClose()
end

export Application_Init, Application_Run, Application_ShouldClose, Application_Shutdown, ApplicationParams, ApplicationData, Application_Get
