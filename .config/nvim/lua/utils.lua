local Job = require('plenary.job')
local Path = require('plenary.path')

local context_manager = require('plenary.context_manager')
local with = context_manager.with
local open = context_manager.open

local function split_to_tab(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  return string.gmatch(inputstr, "([^"..sep.."]+)")
end

local function load_sftp_config(cwd)
  local path = Path:new(cwd .. "/.sftp")
  if not path:exists() then
      return nil
  end

  local result = with(open(path.filename), function (reader)
    return reader:read("*all")
  end)

  local config = {}
  for line in split(result, "\n") do
    local splitted_lines = split_to_tab(line, "=")

    local key = vim.trim(splitted_lines[1])
    local value = vim.trim(splitted_lines[2])

    config[key] = value
  end

  return config
end

local function validate_config(config)
  local errors = {}

  if not config then
    table.insert(errors, "No config")
    return errors
  end

  if not config.host then
    table.insert(errors, "No host")
  end
  if not config.user then
    table.insert(errors, "No user")
  end
  if not config.port then
    table.insert(errors, "No port")
  end
  if not config.target_path then
    table.insert(errors, "No target path")
  end

  return errors
end

local function build_sftp_cmd(config)
  local relative_file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local cwd = vim.fn.getcwd()
  local target_host = config.host
  local user = config.user
  local target_path = config.target_path .. relative_file

  local parent_path = Path:new(target_path):parent()

  local args = {user .. "@" .. target_host .. ":" .. parent_path .. "<<< $\'put " .. relative_file .. "\'"}

  return {
    command = "sftp",
    args = args,
    cwd = cwd,
  }
end

local function build_scp_cmd(config)
  local relative_file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local cwd = vim.fn.getcwd()
  local target_host = config.host
  local target_path = config.target_path .. relative_file
  local user = config.user
  local args = {relative_file, user .. "@" .. target_host .. ':' .. target_path}

  return {
    command = "scp",
    args = args,
    cwd = cwd,
  }
end

local function build_cmd(config)
  local mode = config.mode
  if mode == "scp" then
    return build_scp_cmd(config)
  else
    return build_sftp_cmd(config)
  end
end

local function perform_upload()
  local relative_file = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local cwd = vim.fn.getcwd()

  local config = load_sftp_config(cwd)

  local config_errors = validate_config(config)
  if next(config_errors) ~= nil then
    local errors = table.concat(config_errors, ",")
    print("[sftp] config errors: " .. errors)
    return
  end

  config.mode = config.mode or "scp"

  local cmd = build_cmd(config)
  cmd.on_exit = function(_, return_val)
    local result = (return_val == 0 and "success") or "error"
    print("[sftp] sending " .. relative_file .. " " .. result)
  end

  print(vim.inspect(cmd))

  Job:new(cmd):sync()
end

return {
  perform_upload = perform_upload
}
