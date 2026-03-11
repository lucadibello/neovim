local M = {}

local VENV_PATH = vim.fn.expand("~/.virtualenvs/neovim")
local PYTHON_PATH = VENV_PATH .. "/bin/python"
local PIP_PATH = VENV_PATH .. "/bin/pip"

local REQUIRED_PACKAGES = {
  "pynvim",
  "jupyter_client",
  "ipykernel",
  "cairosvg",
  "pnglatex",
  "plotly",
  "kaleido",
  "pyperclip",
  "nbformat",
}

-- Find a suitable Python 3.10+ executable
local function find_python3()
  local candidates = {
    -- nix path
    "/etc/profiles/per-user/lucadibello/bin/python3",

    -- homebrew paths
    "/opt/homebrew/opt/python@3.13/bin/python3.13",
    "/opt/homebrew/opt/python@3.12/bin/python3.12",
    "/opt/homebrew/opt/python@3.11/bin/python3.11",
    "/opt/homebrew/opt/python@3.10/bin/python3.10",
    "/usr/local/opt/python@3.13/bin/python3.13",
    "/usr/local/opt/python@3.12/bin/python3.12",
    "/usr/local/opt/python@3.11/bin/python3.11",
    "/usr/local/opt/python@3.10/bin/python3.10",

    -- system paths
    "/usr/bin/python3.13",
    "/usr/bin/python3.12",
    "/usr/bin/python3.11",
    "/usr/bin/python3.10",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.executable(path) == 1 then
      return path
    end
  end

  return nil
end

-- Check if virtualenv exists and is valid
local function venv_exists()
  return vim.fn.executable(PYTHON_PATH) == 1
end

-- Create the virtualenv
local function create_venv(python_path)
  vim.fn.mkdir(vim.fn.expand("~/.virtualenvs"), "p")
  local cmd = string.format("%s -m venv %s", python_path, VENV_PATH)
  local result = os.execute(cmd)
  return result == 0 or result == true
end

-- Install required packages
local function install_packages()
  local packages = table.concat(REQUIRED_PACKAGES, " ")
  local cmd = string.format("%s install -q %s", PIP_PATH, packages)
  local result = os.execute(cmd)
  return result == 0 or result == true
end

-- Register ipykernel so Jupyter/Molten can find it
local function register_kernel()
  local cmd =
    string.format("%s -m ipykernel install --user --name neovim --display-name 'Python (neovim)'", PYTHON_PATH)
  local result = os.execute(cmd)
  return result == 0 or result == true
end

-- Main setup function
-- Returns "ok" if venv already existed, "created" if it was just set up, "error" on failure
function M.ensure_venv()
  if venv_exists() then
    return "ok"
  end

  local python = find_python3()
  if not python then
    vim.notify("Python 3.10+ not found. Install with: brew install python@3.12", vim.log.levels.WARN)
    return "error"
  end

  vim.notify("Creating neovim virtualenv with Python: " .. python, vim.log.levels.INFO)

  if not create_venv(python) then
    vim.notify("Failed to create virtualenv", vim.log.levels.ERROR)
    return "error"
  end

  vim.notify("Installing Python dependencies...", vim.log.levels.INFO)

  if not install_packages() then
    vim.notify("Failed to install packages", vim.log.levels.ERROR)
    return "error"
  end

  if not register_kernel() then
    vim.notify("Failed to register Jupyter kernel", vim.log.levels.WARN)
  end

  return "created"
end

-- Get the python path for python3_host_prog
function M.get_python_path()
  return PYTHON_PATH
end

return M
