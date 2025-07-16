local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

-- Function to find composer.json recursively
local function find_composer_json(start_path, max_depth)
  max_depth = max_depth or 10
  local current_path = start_path or vim.fn.expand '%:p:h'
  local depth = 0

  while depth < max_depth do
    local composer_path = current_path .. '/composer.json'
    local file = io.open(composer_path, 'r')

    if file then
      file:close()
      return composer_path
    end

    -- Move up one directory
    local parent = vim.fn.fnamemodify(current_path, ':h')
    if parent == current_path then
      break
    end
    current_path = parent
    depth = depth + 1
  end

  return nil
end

-- Function to extract namespace from composer.json
local function get_namespace_from_composer_json()
  local composer_file = find_composer_json()
  if not composer_file then
    return 'App'
  end

  local file = io.open(composer_file, 'r')
  if not file then
    return 'App'
  end

  local content = file:read '*all'
  file:close()

  -- Extract PSR-4 namespace
  local namespace = content:match '"psr%-4"%s*:%s*{%s*"([^"]+)"%s*:'

  if namespace then
    namespace = namespace:gsub('/$', ''):gsub('/', '\\')
  else
    namespace = 'App'
  end

  return namespace
end

-- Function to get class name from filename
local function get_class_name_from_filename()
  local filename = vim.fn.expand '%:t:r'
  return filename
end

-- PHP Snippets
return {
  -- Class snippet with auto-generated namespace
  s('class', {
    f(function()
      return '<?php\n\nnamespace ' .. get_namespace_from_composer_json() .. ';\n\n'
    end),
    t 'class ',
    f(get_class_name_from_filename),
    t ' {\n    ',
    i(0),
    t '\n}',
  }),

  -- Interface snippet
  s('interface', {
    f(function()
      return '<?php\n\ndeclare(strict_types=1);\n\n' .. 'namespace ' .. get_namespace_from_composer_json() .. ';\n\n'
    end),
    t 'interface ',
    f(get_class_name_from_filename),
    t ' {\n    ',
    i(0),
    t '\n}',
  }),

  -- Constructor snippet
  s('construct', {
    t 'public function __construct(',
    i(1),
    t ') {\n    ',
    i(0),
    t '\n}',
  }),

  -- PHP 8 constructor property promotion
  s('constructpm', {
    t 'public function __construct(',
    c(1, {
      t 'private ',
      t 'public ',
      t 'protected ',
    }),
    i(2, 'type'),
    t ' ',
    i(3, 'paramName'),
    t ') {\n}',
  }),

  -- Method snippet
  s('method', {
    c(1, {
      t 'public ',
      t 'private ',
      t 'protected ',
    }),
    t 'function ',
    i(2, 'methodName'),
    t '(',
    i(3),
    t ') {\n    ',
    i(0),
    t '\n}',
  }),
}
