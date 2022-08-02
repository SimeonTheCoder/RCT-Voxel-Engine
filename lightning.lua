lmapper = {}

function lmapper.map(lights, map, red, green, blue)
  rays = {}
  
  for p, l in ipairs(lights) do
    for i = -180, 180, 1 do
      for j = -180, 180, 1 do
        local dx = math.sin((j + l.a1) * math.pi / 180)
        local dz = math.cos((j + l.a1) * math.pi / 180)
        local dy = math.cos((i + l.a2) * math.pi / 180)
        
        table.insert(rays, {x = l.x, y = l.y, z = l.z, dx = dx, dy = dy, dz = dz, dis = 0, i = i, j = j, a1 = (j + l.a1), a2 = (i + l.a2)})
      end
    end
    
    for i, v in ipairs(rays) do
      for j = 1, 50, 1 do
        if v.z >= 1 and v.z <= 100 and v.y >= 1 and v.y <= 100 and v.x >= 1 and v.x <= 100 and map[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] ~= 0 then
          v.dis = v.dis / l.range
          
          v.dis = 100 - v.dis
          
          red[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] = red[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] + v.dis / 100 * l.intensity * l.r
          green[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] = green[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] + v.dis / 100 * l.intensity * l.g
          blue[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] = blue[math.floor(v.z)][math.floor(v.x)][math.floor(v.y)] + v.dis / 100 * l.intensity * l.b
          
          break
        else
          v.dis = v.dis + 1
          
          v.x, v.y, v.z = v.x + v.dx, v.y + v.dy, v.z + v.dz
        end
      end
    end
  end
  
  return red, green, blue
end

return lmapper