include("Renderer/Renderer.jl")
include("Resource/Resource.jl")
include("Logger.jl")
include("Window.jl")

using ModernGL
using ConfigEnv

"""
    
"""
struct ApplicationParams
    windowSize::Tuple{Cint,Cint}
    maxWindowSize::Tuple{Cint,Cint}
    minWindowSize::Tuple{Cint,Cint}
    windowFullscreen::Bool
    windowName::String
    onEvent::Function
    onUpdate::Function
    onRender::Function
    ApplicationParams( ;WindowSize::Tuple{Cint,Cint}=(Cint(800), Cint(800)), 
                        MaxWindowSize::Tuple{Cint,Cint}=(Cint(0), Cint(0)),
                        MinWindowSize::Tuple{Cint,Cint}=(Cint(0), Cint(0)),
                        Fullscreen::Bool=false,
                        OnEvent::Function=(e) -> (),
                        OnUpdate::Function=() -> (),
                        OnRender::Function=() -> (),
                        Name::String="Merlin Engine application") = new(
                          WindowSize,
                          MaxWindowSize,
                          MinWindowSize,
                          Fullscreen, 
                          Name,
                          OnEvent,
                          OnUpdate,
                          OnRender
                        )
end

struct ApplicationData
    windowData::WindowData
    loggerData::LoggerData
    onUpdate::Function
    onRender::Function
end

function Application_Init(params::ApplicationParams)::ApplicationData
    dotenv()

    loggerData = Logger_Init()
    Resource_Init()

    windowData = Window_Init( WindowProps(
      params.windowSize,
      params.maxWindowSize,
      params.minWindowSize,
      params.windowFullscreen,
      params.windowName,
      params.onEvent
    ) )

    ApplicationData(windowData, loggerData, params.onUpdate, params.onRender)
end

function Application_Run(applicationData::ApplicationData)
    glClearColor(0.1, 0.1, 0.1, 1.0)

    while !Application_ShouldClose(applicationData)
        applicationData.onUpdate()

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        applicationData.onRender()

        Window_Update(applicationData.windowData)
    end
    
    Application_Shutdown(applicationData)
end

function Application_Shutdown(applicationData::ApplicationData)
    Window_Shutdown(applicationData.windowData)
    Logger_Shutdown(applicationData.loggerData)
    ResPool_Flush()
end

function Application_ShouldClose(applicationData::ApplicationData)
    Window_ShouldClose(applicationData.windowData)
end

export Application_Init, Application_Run, Application_ShouldClose, Application_Shutdown, ApplicationParams, ApplicationData
