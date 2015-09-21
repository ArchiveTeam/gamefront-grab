dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}
local addedtolist = {}

-- Do not download these urls:
downloaded["http://www.gamefront.com/files/css/video.css"] = true
downloaded["http://www.gamefront.com/files/js/download.min.js"] = true
downloaded["http://cdn.optimizely.com/js/482870567.js"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style-alt.css?=a"] = true
downloaded["http://www.gamefront.com/blank/feed/"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/css/Black_Minimalism.css?ver=1.0.0"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/shutter/shutter-reloaded.css?ver=1.3.2"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/wp-pagenavi/pagenavi-css.css?ver=2.70"] = true
downloaded["http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/shutter/shutter-reloaded.js?ver=1.3.2"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/js/jquery.cycle.all.min.js?ver=2.88"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/js/ngg.slideshow.min.js?ver=1.05"] = true
downloaded["http://www.gamefront.com/xmlrpc.php?rsd"] = true
downloaded["http://www.gamefront.com/wp-includes/wlwmanifest.xml"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/xml/media-rss.php"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/scripts/jquery.cookie.js"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/functions.js"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/scripts/jquery.colorbox-min.js"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/css/colorbox.css"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/google-publisher-tags/brktrkr.js?cda6c1"] = true
downloaded["http://www.gamefront.com/wp-content/uploads/2012/08/breaking-app2.png"] = true
downloaded["http://www.gamefront.com/files/gamefront/style/images/search_field.png"] = true
downloaded["http://www.gamefront.com/files/gamefront/style/images/search_button.png"] = true
downloaded["http://www.gamefront.com/files/images/gamefront_survey.png"] = true
downloaded["http://www.gamefront.com/files/images/gamefront_thankyou_bg.png"] = true
downloaded["http://static.ak.fbcdn.net/connect.php/js/FB.Share"] = true
downloaded["http://platform.twitter.com/widgets.js"] = true
downloaded["http://www.gamefront.com/files/images/hr-advertisement.png"] = true
downloaded["http://www.gamefront.com/wp-content/uploads/2014/01/torchlight2.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/uploads/2011/02/descent-21-e1297453516296.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/uploads/2011/12/Multi-Theft-Auto-San-Andreas.jpg"] = true
downloaded["http://www.gamefront.com/files/images/file-policy-300.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/images/gf_social_logo.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/images/social_twitter.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/images/social_youtube.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/images/social_rss.jpg"] = true
downloaded["http://www.gamefront.com/files/images/upload.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/logo-trans-gray-185-68.png"] = true
downloaded["http://secure-us.imrworldwide.com/cgi-bin/m?ci=us-103628h&cg=0&cc=1&ts=noscript"] = true
downloaded["http://secure-us.imrworldwide.com/cgi-bin/m?ci=us-103628h&cg=0&cc=1&ts=noscript&ja=1"] = true
downloaded["http://b.scorecardresearch.com/b?c1=2&c2=4000003&c3=4000003&c4=&c5=&c6=&c15=&cv=1.3&cj=1"] = true
downloaded["http://b.scorecardresearch.com/b2?c1=2&c2=4000003&c3=4000003&c4=&c5=&c6=&c15=&cv=1.3&cj=1"] = true
downloaded["http://preferences.truste.com/webservices/js?domain=gamefront.com&type=epref"] = true
downloaded["http://edge.quantserve.com/quant.js"] = true
downloaded["http://pixel.quantserve.com/pixel/p-83WcMqNwWwE46.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/js/script.js?ver=1.0"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/js/plugins.js?ver=1.0"] = true
downloaded["http://code.jquery.com/ui/1.8.12/jquery-ui.js"] = true
downloaded["http://www.bkrtx.com/js/bk-static.js"] = true
downloaded["http://tags.crwdcntrl.net/c/833/cc.js"] = true
downloaded["http://www.gamefront.com/images/backgrounds/window_header.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/header_wrap.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/main_bg.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/I_want_to_search.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/search_field.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/search_button.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/breakingnews_bg.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/breaking_head.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/gf_check_out.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/check_out_remove.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/sidebar_divider.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/sidebar_menubg.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/sidemenu_bgactive.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/socialbox_bg.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/file_icon.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/filetype_one.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/filetype_two.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/filetype_three.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/featured_bg.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/featured_items.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/latest_demos.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/latest_patches.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/latest_videos.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/gaming_forum.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/upload_files.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/game_trailers.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/menu_bar.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/single_like_box.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/stroke-content-sides.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/content_cap.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/tile-hdr-240.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/scrollbar/trackbar.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/scrollbar/handle.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-3dots-6.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/logo-24.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-search-10.png"] = true
downloaded["http://media1.break.com/break/img/himalaya/sprites/bmn-spr-main2.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-btm-1152.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-btm-300.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-lft.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-rgt.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-chk-grn-12.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-th-active.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/social-icons-spr.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-tag-10.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-bubble-9.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-item-noise-140-a.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-posts-16-8.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-eye-16-12.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-thumb-frame-114-151.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-lft-wht.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/bg-mod-hdr-rgt-wht.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/logos-clear.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-cloud-24-12.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/spr/components/ico-bubtxt-gray-21-14.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/see-more.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/tile-wrap-btm.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/tile-wrap-top2.png"] = true
downloaded["http://video1.break.com/static/live/v1/pages/sponsors/scott-pilgrim/images/ff_sp_sliver.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/themes/images/sp_background.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/images/sp_postdesc_bg.png"] = true
downloaded["http://news.filefront.com/wp-content/uploads/2010/09/pax_header.jpg"] = true
downloaded["http://www.gamefront.com/wp-content/uploads/2010/09/pax_header.jpg"] = true
downloaded["http://www.gamefront.com/files/images/contribute-background.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/mobile-overlay-android.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/img/mobile-overlay-ios.png"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/css/albumset.gif"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/css/shadowAlpha.png"] = true
downloaded["http://www.gamefront.com/wp-content/plugins/nextgen-gallery/css/shadow.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/css/images/loading_background.png"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/css/images/loading.gif"] = true
downloaded["http://www.gamefront.com/wp-content/themes/gamefront/style/css/images/controls.png"] = true
downloaded["https://fbstatic-a.akamaihd.net/rsrc.php/v2/yL/r/unHwF9CkMyM.png"] = true
downloaded["https://fbstatic-a.akamaihd.net/rsrc.php/v2/y1/r/LVx-xkvaJ0b.png"] = true
downloaded["http://www.gamefront.com/files/images/downloadNow.png"] = true

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
    if (downloaded[url] ~= true and addedtolist[url] ~= true) and ((string.match(url, "[^0-9]"..item_value.."[0-9]") and not (string.match(url, "[^0-9]"..item_value.."[0-9][0-9]") or string.match(url, "/window%.open%('https?://"))) or html == 0) then
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
    if (downloaded[url] ~= true and addedtolist[url] ~= true) and ((string.match(url, "[^0-9]"..item_value.."[0-9]") and not (string.match(url, "[^0-9]"..item_value.."[0-9][0-9]") or string.match(url, "/window%.open%('https?://"))) or string.match(url, "media[0-9]+%.gamefront%.com")) then
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
  
  if string.match(url, "[^0-9]"..item_value.."[0-9]") and not string.match(url, "[^0-9]"..item_value.."[0-9][0-9]") then
    html = read_file(file)
    for newurl in string.gmatch(html, '"([^"]+)"') do
      checknewurl(newurl)
    end
    for newurl in string.gmatch(html, "'([^']+)'") do
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
