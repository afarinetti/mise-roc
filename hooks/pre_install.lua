-- hooks/pre_install.lua
-- Returns download information for a specific version
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

-- Helper function for platform detection (uncomment and modify as needed)
local function get_platform()
  -- RUNTIME object is provided by mise/vfox
  -- RUNTIME.osType: "Windows", "Linux", "Darwin"
  -- RUNTIME.archType: "amd64", "386", "arm64", etc.

  local os_name = RUNTIME.osType:lower()
  local arch = RUNTIME.archType

  -- Map to your tool's platform naming convention
  -- Adjust these mappings based on how your tool names its releases
  local platform_map = {
    ["darwin"] = {
      ["amd64"] = "macos_x86_64",
      ["arm64"] = "macos_apple_silicon",
    },
    ["linux"] = {
      ["amd64"] = "linux_x86_64",
      ["arm64"] = "linux_arm64",
    },
  }

  local os_map = platform_map[os_name]
  if os_map then
    return os_map[arch] or "linux_x86_64" -- fallback
  end

  -- Default fallback
  return "linux_x86_64"
end

function PLUGIN:PreInstall(ctx)
  local version = ctx.version
  -- ctx.runtimeVersion contains the full version string if needed

  -- base roc download URL
  local download_url = "https://github.com/roc-lang/roc/releases/download/"

  -- build roc platform specific tar.gz URL (mise will extract automatically)
  local platform = get_platform()
  local url = download_url .. version .. "/roc-" .. platform .. "-" .. version .. ".tar.gz"

  -- build roc docs URL
  local docs_url = download_url .. version .. "/docs.tar.gz"

  -- file checksum handled by mise github backend

  return {
    version = version,
    url = url,
    -- sha256 = sha256, -- handled by mise github backend
    note = "Downloading roc " .. version,
    addition = { -- Optional: download additional components
      {
        name = "roc-docs",
        url = docs_url,
      }
    }
  }
end
