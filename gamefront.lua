dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}
local addedtolist = {}

for ignore in io.open("ignore-list", "r"):lines() do
  downloaded[ignore] = true
end

read_file = function(file)
  if file then
    local f = assert(io.open(file))
    local data = f:read("*all")
    f:close()
    return data
  else
    return ""
  end
end

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]
  
  if downloaded[url] == true or addedtolist[url] == true then
    return false
  end
  
  if (downloaded[url] ~= true or addedtolist[url] ~= true) then
    if (downloaded[url] ~= true and addedtolist[url] ~= true) and ((((item_type == "file" and string.match(url, "[^0-9]"..item_value.."[0-9]") and not string.match(url, "[^0-9]"..item_value.."[0-9][0-9]")) or (item_type == "singlefile" and string.match(url, "[^0-9]"..item_value) and not string.match(url, "[^0-9]"..item_value.."[0-9]"))) and not string.match(url, "/window%.open%('https?://")) or html == 0) then
      addedtolist[url] = true
      return true
    else
      return false
    end
  end
end


wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil
  
  local function check(url)
    if (downloaded[url] ~= true and addedtolist[url] ~= true) and ((((item_type == "file" and string.match(url, "[^0-9]"..item_value.."[0-9]") and not string.match(url, "[^0-9]"..item_value.."[0-9][0-9]")) or (item_type == "singlefile" and string.match(url, "[^0-9]"..item_value) and not string.match(url, "[^0-9]"..item_value.."[0-9]"))) and not (string.match(url, "[^0-9]"..item_value.."[0-9][0-9]") or string.match(url, "/window%.open%('https?://"))) or string.match(url, "media[0-9]+%.gamefront%.com") or string.match(url, "uploads%.gamefront%.com")) then
      if string.match(url, "&amp;") then
        table.insert(urls, { url=string.gsub(url, "&amp;", "&") })
        addedtolist[url] = true
        addedtolist[string.gsub(url, "&amp;", "&")] = true
      else
        table.insert(urls, { url=url })
        addedtolist[url] = true
      end
    end
  end

  local function checknewurl(newurl)
    if string.match(newurl, "^https?://") then
      check(newurl)
    elseif string.match(newurl, "^//") then
      check("http:"..newurl)
    elseif string.match(newurl, "^/") then
      check(string.match(url, "^(https?://[^/]+)")..newurl)
    end
  end
  
  if (item_type == "file" and string.match(url, "[^0-9]"..item_value.."[0-9]") and not string.match(url, "[^0-9]"..item_value.."[0-9][0-9]")) or
    (item_type == "singlefile" and string.match(url, "[^0-9]"..item_value) and not string.match(url, "[^0-9]"..item_value.."[0-9]")) then
    html = read_file(file)
    for newurl in string.gmatch(html, '([^"]+)') do
      checknewurl(newurl)
    end
    for newurl in string.gmatch(html, "([^']+)") do
      checknewurl(newurl)
    end
  end
  
  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()

  if (status_code >= 200 and status_code <= 399) then
    if string.match(url.url, "https://") then
      local newurl = string.gsub(url.url, "https://", "http://")
      downloaded[newurl] = true
    else
      downloaded[url.url] = true
    end
  end

  if string.match(url["url"], "^https?://[^/]*gamefront%.com/files/service/thankyou%?id=[0-9]+") then
    if status_code ~= 200 then
      return wget.actions.ABORT
    end
    io.stdout:write("Waiting 120 seconds to make sure the link to download the file works.\n")
    io.stdout:flush()
    os.execute("sleep 120")
  end

  if string.match(url["url"], "media[0-9]+%.gamefront%.com") and status_code ~= 200 then
    io.stdout:write("The link to the download did not return status code 200. Are you banned? (This error might also be due to a problem on GameFront's side.)\n")
    io.stdout:flush()
    return wget.actions.ABORT
  end
  
  if status_code >= 500 or
    (status_code >= 400 and status_code ~= 404 and status_code ~= 403) then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()
    os.execute("sleep 1")
    tries = tries + 1
    if tries >= 5 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  elseif status_code == 0 then
    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()
    os.execute("sleep 10")
    tries = tries + 1
    if tries >= 5 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      return wget.actions.ABORT
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  local sleep_time = 0

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end
