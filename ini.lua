function parse (pfile, NCOMM)
  local tbl = {}
  local stbl = {}
  local fcomm, pcomm, sec, key, val, pattSec
  
  if NCOMM then
    pattSec = "([;]?)[[]([^;]+)[]][;]?(.*)"
  else 
    pattSec = "([;]?)[[]([^;]+)[]]"
  end
  for line in io.lines(pfile) do
    if string.find(line, "[[].+[]]") then
      fcomm, sec, pcomm = string.match(line, pattSec)
      if fcomm and fcomm==";" then break end
      tbl[sec] = {}
      if NCOMM and pcomm and string.len(pcomm) > 0 then
        tbl[sec][';'] = pcomm
      end
    elseif string.find(line, ".+[=].-") then
      fcomm, key, val = string.match(line, "([;]?)%s*(.+)%s*=%s*(.+)")
      if fcomm and fcomm==";" then break end
      key = string.match(key, "%S+")
      val, pcomm = string.match(val, "([^;]+)[;]?(.*)") 
      if not tbl[sec][key] then tbl[sec][key] = {} end
      if NCOMM and pcomm and string.len(pcomm) > 0 then
        tbl[sec][tostring(key)] = {val, [';'] = pcomm} 
      else
        tbl[sec][tostring(key)] = val
      end
      pcomm = false 
    elseif string.find(line, "%S") then 
      fcomm, val = string.match(line, "(;?)(.+)") 
      if (not val) or (fcomm and fcomm==";") then break end
      val, pcomm = string.match(val, "([^;]+)[;]?(.*)") 
      val = string.match(val, "%S+") 
      if NCOMM and pcomm and string.len(pcomm) > 0 then
        table.insert(tbl[sec], {val, [';'] = pcomm})
      else
        table.insert(tbl[sec], val)
      end
    end
  end
  return tbl
end

function write(tbl, pfile, mode)
local str = ""
  for k, v in pairs(tbl) do 
    str = string.format("%s\n[%s]; %s", str, k, v[';'] or "") 
    
    for key, val in pairs(v) do 
      if type(val) == 'table' and key ~= ";" then 
        if type(key) == "number" and key ~= ";" then
          str = string.format("%s\n%s; %s", str, val[1], val[';'] or "")  
        elseif type(key) == "string" and key ~= ";" then 
          str = string.format("%s\n%s = %s; %s", str, key, val[1], val[';'] or "") 
        end
      else
        if type(key) == "number" and key ~= ";" then
          str = string.format("%s\n%s", str, val)  
        elseif type(key) == "string" and key ~= ";" then 
          str = string.format("%s\n%s = %s; %s", str, key, val, val[';'] or "") 
        end
      end
    end 
  end
  if pfile then
    local file = io.open(pfile, mode or "a")
    file:write(str)
    file:flush()
    file:close()
    return str, file
  else
    return str
  end
end

local a = parse("C:\\test.ini", true)
for k,v in pairs(a.sec2) do
  print (k, v)
end