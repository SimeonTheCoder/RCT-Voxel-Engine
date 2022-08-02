function love.load()
  love.window.setMode(1920 / 2, 1080 / 2, nil)
  
  lmapper = require("lightning")
  
  v_scale = 1
  
  reflections = true
  map_mode = false
  check_rendering = false
  double_check = false
  
  animating = false
  started = false
  
  fullbright = false
  
  map2d = {}
  
  point1 = {x = 0, y = 0}
  point2 = {x = 0, y = 0}
  point = {x = 0, y = 0}
  
  max_bounces = 1
  selected_light = 0
  
  pixel_density = 1
  
  map = {}
  sdf = {}
  
  lights = {}
  
  anim_map = {}
  
  red = {}
  green = {}
  blue = {}

  player = {x = 42, y = 45, z = 22, a1 = 12, a2 = -942}
  
  --table.insert(lights, {x = 40, y = 50, z = 43, a1 = 0, a2 = 0, intensity = .1, r = 1, g = 1, b = 0})
  
  table.insert(lights, {x = 100 - 40, y = 9, z = 100 - 83, a1 = -312, a2 = -992, intensity = .1, r = 0, g = 1, b = 1, range = 10, keyframes = {}})
  table.insert(lights, {x = 100 - 89, y = 19, z = 100 - 82, a1 = -312, a2 = -992, intensity = .01, r = 0, g = 0, b = 1, range = 1, keyframes = {}})
  table.insert(lights, {x = 100 - 71, y = 12, z = 100 - 83, a1 = -312, a2 = -992, intensity = .01, r = 0, g = 1, b = 0, range = 1, keyframes = {}})
  
  --table.insert(lights, {x = 71, y = 12, z = 20, a1 = -312, a2 = -992, intensity = .1, r = 1, g = 1, b = 0, range = 1000})
  
  --table.insert(lights, {x = 16, y = 7, z = 13, a1 = -312, a2 = -992, intensity = .1})
  --table.insert(lights, {x = 42, y = 45, z = 22, a1 = 9, a2 = -933, intensity = .5})
  
  for i = 1, 100, 1 do
    map2d[i] = {}
    
    map[i] = {}
    red[i] = {}
    green[i] = {}
    blue[i] = {}
    sdf[math.floor(i / 2)] = {}
    
    for j = 1, 100, 1 do
      map2d[i][j] = 0
      
      map[i][j] = {}
      red[i][j] = {}
      green[i][j] = {}
      blue[i][j] = {}
      sdf[math.floor(i / 2)][math.floor(j / 2)] = {}
      
      for k = 1, 100, 1 do
        map[i][j][k] = 0
        --red[i][j][k] = .2
        red[i][j][k] = 0
        --green[i][j][k] = .2
        green[i][j][k] = 0
        --blue[i][j][k] = .2
        blue[i][j][k] = 0
        
        if i == 1 or i == 100 or j == 1 or j == 100 or k <= 5 or k == 70 then
          map[i][j][k] = 1
          
          if k <= 5 or k == 140 then
            map[i][j][k] = 2
          end
        end
        
        if math.random(1, 50) == 1 then
          --map[i][j][k] = 1
        end
        
        if k < love.math.noise(i / 30, j / 30) * 10 then
          map[i][j][k] = 1
        end
      end
    end
  end
  
  lmapper.map(lights, map, red, green, blue)
end

function love.keypressed(key)
  if key == "t" then
    reflections = not reflections
  end
  
  if key == "p" then
    max_bounces = max_bounces + 1
  end
  
  if key == "o" then
    max_bounces = max_bounces - 1
  end
  
  if key == "k" then
    selected_light = selected_light - 1
  end
  
  if key == "l" then
    selected_light = selected_light + 1
  end
  
  if key == "v" then
    map_mode = not map_mode
    
    if not map_mode then
      love.window.setMode(1920 / 2, 1080 / 2, nil)
    else
      love.window.setMode(1920, 1080, nil)
    end
  end
  
  if key == "m" then
    table.insert(lights[selected_light].keyframes, {x = lights[selected_light].x, y = lights[selected_light].y, z = lights[selected_light].z})
  end
  
  if key == "-" then
    started = true
  end
  
  if key == "1" then
    point1.x, point1.y = point.x, point.y
  end
  
  if key == "2" then
    point2.x, point2.y = point.x, point.y
  end
  
  if key == "`" then
    fullbright = not fullbright
  end
  
  if key == "b" then
    check_rendering = not check_rendering
  end
  
  if key == "n" then
    double_check = not double_check
  end
  
  if key == "r" then
    lights[selected_light].x, lights[selected_light].y, lights[selected_light].a1, lights[selected_light].a2 = player.x, player.y, player.a1, player.a2
    
    for i = 1, 100, 1 do
      red[i] = {}
      green[i] = {}
      blue[i] = {}
    
      for j = 1, 100, 1 do
        red[i][j] = {}
        green[i][j] = {}
        blue[i][j] = {}
        
        for k = 1, 100, 1 do
          --red[i][j][k] = .2
          red[i][j][k] = 0
          --green[i][j][k] = .2
          green[i][j][k] = 0
          --blue[i][j][k] = .2
          blue[i][j][k] = 0
        end
      end
    end
    
    lmapper.map(lights, map, red, green, blue)
  end
  
  if key == "x" then
    map = {}
    red = {}
    green = {}
    blue = {}
    
    for i = 1, 100, 1 do   
      map[i] = {}
      red[i] = {}
      green[i] = {}
      blue[i] = {}
      
      for j = 1, 100, 1 do        
        map[i][j] = {}
        red[i][j] = {}
        green[i][j] = {}
        blue[i][j] = {}
        
        for k = 1, 100, 1 do
          map[i][j][k] = 0
          
          if i == 1 or i == 100 or j == 1 or j == 100 or k == 1 or k == 100 then
            map[i][j][k] = 1
          end
          
          if k <= map2d[i][j] or i == 1 or i == 100 or j == 1 or j == 100 or k == 1 then
            map[i][j][k] = 1
          end
          
          red[i][j][k] = 0
          green[i][j][k] = 0
          blue[i][j][k] = 0          
          --print(map[i][j][k])
        end
      end
    end
    
    lmapper.map(lights, map, red, green, blue)
  end
end

function love.update(dt)
  if started then    
    step_x = (lights[selected_light].keyframes[2].x - lights[selected_light].keyframes[1].x) / 100
    step_y = (lights[selected_light].keyframes[2].y - lights[selected_light].keyframes[1].y) / 100
    step_z = (lights[selected_light].keyframes[2].z - lights[selected_light].keyframes[1].z) / 100
    
    for r = 1, 100, 1 do
      lights[selected_light].x = lights[selected_light].x + step_x
      lights[selected_light].y = lights[selected_light].y + step_y
      lights[selected_light].z = lights[selected_light].z + step_z

      red = {}
      green = {}
      blue = {}
      
      for i = 1, 100, 1 do
        red[i] = {}
        green[i] = {}
        blue[i] = {}
        
        for j = 1, 100, 1 do
          red[i][j] = {}
          green[i][j] = {}
          blue[i][j] = {}
          
          for k = 1, 100, 1 do            
            red[i][j][k] = 0
            green[i][j][k] = 0
            blue[i][j][k] = 0
          end
        end
      end
      
      lmapper.map(lights, map, red, green, blue)
      
      table.insert(anim_map, {red = red, green = green, blue = blue})
    end
    
    started = false
    animating = true
    frame = 0
  end
  
  if animating then
    frame = frame + 1
    
    if frame == 100 then
      frame = 1
    end
    
    red = anim_map[frame].red
    green = anim_map[frame].green
    blue = anim_map[frame].blue
  end
  
  --lmapper.map(lights, map, red, green, blue)
  
  if love.keyboard.isDown("w") then
    local dx = math.sin((player.a1) * math.pi / 180)
    local dz = math.cos((player.a1) * math.pi / 180)
    local dy = math.cos((player.a2) * math.pi / 180)
    
    player.x = player.x + dx * 10 * dt
    player.y = player.y + dy * 10 * dt
    player.z = player.z + dz * 10 * dt
  end
  
  if love.keyboard.isDown("q") then
    player.y = player.y - 10 * dt
  end
  
  if love.keyboard.isDown("e") then
    player.y = player.y + 10 * dt
  end
  
  if love.keyboard.isDown("]") then
    for i = point1.y, point2.y, 1 do
      for j = point1.x, point2.x, 1 do
        map2d[i][j] = map2d[i][j] + 1
      end
    end
  end
  
  if love.keyboard.isDown("[") then
    for i = point1.y, point2.y, 1 do
      for j = point1.x, point2.x, 1 do
        map2d[i][j] = map2d[i][j] - 1
      end
    end
  end
  
  if love.keyboard.isDown("left") then
    point.x = point.x - 1
  end
  
  if love.keyboard.isDown("right") then
    point.x = point.x + 1
  end
  
  if love.keyboard.isDown("up") then
    point.y = point.y - 1
  end
  
  if love.keyboard.isDown("down") then
    point.y = point.y + 1
  end
  
  if love.keyboard.isDown("right") and not map_mode then
    pixel_density = pixel_density + 1 * dt
  end
  
  if love.keyboard.isDown("left") and not map_mode then
    pixel_density = pixel_density - 1 * dt
  end
  
  player.a2 = player.a2 + love.mouse:getY() - 1080 / 2 / 2
  player.a1 = player.a1 + love.mouse:getX() - 1920 / 2 / 2
  
  love.mouse.setPosition(1920 / 2 / 2, 1080 / 2 / 2)
  
  rays = {}
  
  for i = -40 * v_scale, 40 * v_scale, 1 * 1 / pixel_density do
    for j = -60, 60, 1 / pixel_density do
      if math.floor(i * pixel_density) % 2 == math.floor(j * pixel_density) % 2 or not check_rendering then
        local dx = math.sin((j + player.a1) * math.pi / 180)
        local dz = math.cos((j + player.a1) * math.pi / 180)
        local dy = math.cos((i + player.a2) * math.pi / 180)
        
        table.insert(rays, {x = player.x, y = player.y, z = player.z, dx = dx, dy = dy, dz = dz, dis = 0, i = i * pixel_density / v_scale, j = j * pixel_density, a1 = (j + player.a1), a2 = (i + player.a2), r = 0, g = 0, b = 0})
      end
    end
  end
  
  for i, v in ipairs(rays) do
    local bounces = 0
    local bounce_coordinates = {}
    
    local j = 1
    
    while(j < 100) do
      --z, x, y
      if map[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] ~= 0 then        
        v.dis = 100 - v.dis
        
        --print(v.dis)
        
        v.hit = map[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)]
        
        if v.r == 0 and v.g == 0 and v.b == 0 then
          v.r = red[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)]
          v.g = green[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)]
          v.b = blue[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)]
        else
          v.r = v.r + red[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] * 1 / (1 + bounces) * v.hit
          v.g = v.g + green[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] * 1 / (1 + bounces) * v.hit
          v.b = v.b + blue[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] * 1 / (1 + bounces) * v.hit
          
          if v.hit == 2 then
            v.b = v.b + .3
            v.g = v.g + .3
          end
        end
        
        if map[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] ~= 0 and bounces < max_bounces and reflections then
          v.dy = v.dy * -1
          
          bounces = bounces + 1
        else
          break
        end
      else
        v.dis = v.dis + 1
        
        v.x, v.y, v.z = v.x + v.dx, v.y + v.dy, v.z + v.dz
      end
      
      j = j + 1 / pixel_density
    end
  end
end

function love.draw()
  if not map_mode then
    for i, v in ipairs(rays) do
      if not fullbright then
        love.graphics.setColor(v.r * v.dis / 100, v.g * v.dis / 100, v.b * v.dis / 100)
      else
        love.graphics.setColor(v.dis / 100, v.dis / 100, v.dis / 100)
      end
      
      --if v.hit == 1 then
        --love.graphics.setColor(v.dis / 100, v.dis / 100, v.dis / 100)
      --end
      
      if v.hit == 2 then
        --love.graphics.setColor(1, 0, 0)
      end
      
      if check_rendering then
        love.graphics.rectangle("fill", (v.j + 60 * pixel_density) * 10 / pixel_density, (v.i + 40 * v_scale / pixel_density) * 12 / pixel_density, 10 / pixel_density * 2, 12 / pixel_density)
      else
        if double_check then
          love.graphics.rectangle("fill", (v.j + 60 * pixel_density) * 10 / pixel_density, (v.i + 40 * v_scale / pixel_density) * 12 / pixel_density, 10 / pixel_density * 2, 12 / pixel_density * 2)
        else
          love.graphics.rectangle("fill", (v.j + 60 * pixel_density) * 10 / pixel_density, (v.i + 40 * v_scale / pixel_density) * 12 / pixel_density, 10 / pixel_density, 12 / pixel_density)
        end
      end
    end
    
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(love.timer.getFPS(), 300, 300)
    
    --love.graphics.print(""..tostring(player.x)..", "..tostring(player.y)..", "..tostring(player.z), 300, 300)
    --love.graphics.print(""..tostring(player.a1)..", "..tostring(player.a2), 300, 325)
  else
    for i = 1, 100, 1 do
      for j = 1, 100, 1 do
        love.graphics.setColor(0, .5, 0)
        love.graphics.rectangle("line", j * 15, i * 10, 15, 10)
        
        if j == point.x or i == point.y then
          love.graphics.rectangle("fill", j * 15, i * 10, 15, 10)
        end
        
        if j == point1.x or i == point1.y then
          love.graphics.rectangle("fill", j * 15, i * 10, 15, 10)
        end
        
        if j == point2.x or i == point2.y then
          love.graphics.rectangle("fill", j * 15, i * 10, 15, 10)
        end
        
        love.graphics.setColor(0, 0, 1)
        love.graphics.print(map2d[i][j], j * 15, i * 10)
      end
    end
  end
end