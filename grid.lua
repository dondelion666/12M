g = grid.connect()
m = midi.connect()

function init()
  
  momentary = {}
  for x = 1,16 do
    momentary[x] = false
  end
  
  toggle = {}
  for x = 1,16 do
    toggle[x] = {}
    for y = 1,4 do
      toggle[x][y] = false
    end
  end
  
  grid_dirty = true
  clock.run(grid_redraw_clock)
end

function grid_redraw_clock()
  while true do
    if grid_dirty then
      grid_redraw()
      grid_dirty = false
    end
    clock.sleep(1/30)
  end
end

function g.key(x,y,z)  -- define what happens if a grid key is pressed or released
  -- this is cool:
  if y==1 then
    momentary[x] = z == 1 and true or false -- if a grid key is pressed, flip it's table entry to 'on'
  -- what ^that^ did was use an inline condition to assign our momentary state.
  -- same thing as: if z == 1 then momentary[x][y] = true else momentary[x][y] = false end
  elseif y >= 3 and y<= 6 then
    if z==1 and not toggle[x][y-2] then
      toggle[x][y-2] = true
    elseif z==1 and toggle[x][y-2] then
      toggle[x][y-2] = false
    end
  end
  grid_dirty = true -- flag for redraw
end

function grid_redraw() -- how we redraw
  g:all(0) -- turn off all the LEDs
  --momentary 
  for x = 1,16 do -- for each column...
    if momentary[x] then -- if the key is held...
      g:led(x,1,15) -- turn on that LED!
    end
  end
 --toggle
 for x = 1,16 do
   for y = 1,4 do
      if toggle[x][y] then
        g:led(x,y+2,15)
      end
    end
  end
  g:refresh() -- refresh the hardware to display the LED state
end

m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "note_on" then
    if d.note<=16 then
      momentary[d.note] = true
    elseif d.note>16 then
      toggle[d.note%16][(1+math.floor((d.note-17)/16))]=true
      --print(1+math.floor((d.note-17)/16))
    end
  elseif d.type=="note_off" then
    if d.note<=16 then
      momentary[d.note] = false
    elseif d.note>16 then
      toggle[d.note%16][(1+math.floor((d.note-17)/16))]=false
    end
  end
  grid_dirty=true
end
