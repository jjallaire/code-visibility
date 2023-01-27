local str = pandoc.utils.stringify
local p = quarto.log.output

-- remove any lines with the hide_line directive.
function CodeBlock(el)
  if el.classes:includes('cell-code') then
    el.text = filter_lines(el.text, function(line)
      return not line:match("#| ?hide_line%s*$")
    end)
    return el
  end
end

-- function to check whether a value exists in a table
function has_value(table, value)
  for k, v in ipairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

-- function for applying comment_directive
local function apply_cmnt_directives(comment_directive)
  local line_filter = {
    CodeBlock = function(cb)
      if cb.classes:includes('cell-code') then
        for k, cd in ipairs(comment_directive) do
          local cmnt_directive_tbl = {"#>", "//>"}
          if has_value(cmnt_directive_tbl, str(cd)) then
            local cmnt_directive_pattern = "^" .. str(cd)
            cb.text = filter_lines(cb.text, function(line)
              return not line:match(cmnt_directive_pattern)
              end)
          end
        end
        return cb
      end
    end
  }
  return line_filter
end

-- hide lines with comment directive
function Pandoc(doc)
  local meta = doc.meta
  local cd = meta['comment-directive']
  if cd then
    return doc:walk(apply_cmnt_directives(cd))
  end
end

-- apply filter_stream directive to cells
function Div(el)
  if el.classes:includes("cell") then
    local filters = el.attributes["filter_stream"]
    if filters then
      -- process cell-code
      return pandoc.walk_block(el, {
        CodeBlock = function(el)
          -- CodeBlock that isn't `cell-code` is output
          if not el.classes:includes("cell-code") then
            for filter in filters:gmatch("[^%s,]+") do
              el.text = filter_lines(el.text, function(line)
                return not line:find(filter, 1, true)
              end)
            end
            return el
          end
        end
      })
    end
  end
end


function filter_lines(text, filter)
  local lines = pandoc.List()
  local code = text .. "\n"
  for line in code:gmatch("([^\r\n]*)[\r\n]") do
    if filter(line) then
      lines:insert(line)
    end
  end
  return table.concat(lines, "\n")
end


