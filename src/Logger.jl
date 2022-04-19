using Logging

macro assert(ex, x)
  return :($ex ? nothing : @error x)
end

struct LoggerData
  logger
  io
end

function Logger_Init()::LoggerData
  io = nothing
  logger = nothing

  if haskey(ENV, "MERLIN_ENVIRONMENT") && ENV["MERLIN_ENVIRONMENT"] == "DEBUG"
    ENV["JULIA_DEBUG"] = Main
    if haskey(ENV, "MERLIN_LOG_PATH")
      io = open(ENV["MERLIN_LOG_PATH"], "w+")
      logger = SimpleLogger(io)
    else
      logger = ConsoleLogger()
    end
  else
    Logging.disable_logging(Logging.Error) # Disable warn, debug and info
    logger = NullLogger()
  end

  global_logger(logger)
  LoggerData(logger, io)
end

function Logger_Shutdown(loggerData::LoggerData)
  ismissing(loggerData.io) && flush(loggerData.io)
end