-- hooks/env_keys.lua
-- Configures environment variables for the installed tool
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#envkeys-hook

function PLUGIN:EnvKeys(ctx)
  -- Available context:
  -- ctx.path - Main installation path
  -- ctx.runtimeVersion - Full version string
  -- ctx.sdkInfo[PLUGIN.name] - SDK information

  local mainPath = ctx.path
  -- local sdkInfo = ctx.sdkInfo[PLUGIN.name]
  -- local version = sdkInfo.version

  -- Example: Platform-specific configuration
  local env_vars = {
    {
      key = "PATH",
      value = mainPath .. "/bin",
    },
  }

  -- RUNTIME object is provided by mise/vfox
  if RUNTIME.osType == "Darwin" then
    table.insert(env_vars, {
      key = "DYLD_LIBRARY_PATH",
      value = mainPath .. "/lib",
    })
  elseif RUNTIME.osType == "Linux" then
    table.insert(env_vars, {
      key = "LD_LIBRARY_PATH",
      value = mainPath .. "/lib",
    })
  end
  -- Windows doesn't use these library path variables

  return env_vars
end
