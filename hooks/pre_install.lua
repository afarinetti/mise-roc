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

-- local function fetch_checksum(version)
--   local http = require("http")
--   local json = require("json")
-- end

function PLUGIN:PreInstall(ctx)
  local version = ctx.version
  -- ctx.runtimeVersion contains the full version string if needed

  -- print(getmetatable(ctx))
  -- print(ctx.runtimeVersion)
  -- print(ctx.addition.assets)

  -- Example 1: Simple binary download
  -- local url = "https://github.com/<GITHUB_USER>/<GITHUB_REPO>/releases/download/v" .. version .. "/<TOOL>-linux-amd64"

  -- Example 2: Platform-specific binary
  -- local platform = get_platform() -- Uncomment the helper function above
  -- local url = "https://github.com/roc-lang/roc/releases/download/" .. version .. "/<TOOL>-" .. platform

  -- Example 3: Archive (tar.gz, zip) - mise will extract automatically
  local platform = get_platform() -- Uncomment the helper function above
  local url = "https://github.com/roc-lang/roc/releases/download/" ..
      version .. "/roc-" .. platform .. "-" .. version .. ".tar.gz"

  -- Example 4: Raw file from repository
  -- local url = "https://raw.githubusercontent.com/<GITHUB_USER>/<GITHUB_REPO>/" .. version .. "/bin/<TOOL>"

  -- Replace with your actual download URL pattern
  -- local url = "https://example.com/<TOOL>/releases/download/" .. version .. "/<TOOL>"

  -- Optional: Fetch checksum for verification
  -- local sha256 = fetch_checksum(version) -- Implement if checksums are available

  return {
    version = version,
    url = url,
    -- sha256 = sha256, -- Optional but recommended for security
    note = "Downloading roc " .. version,
    -- addition = { -- Optional: download additional components
    --     {
    --         name = "component",
    --         url = "https://example.com/component.tar.gz"
    --     }
    -- }
  }
end
