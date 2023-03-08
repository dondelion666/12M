engine.name="one_to_many"

BANKS=16
current_bank=1
alt=0
toggles={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

function init()

params:add_file("file","file",_path.audio)
params:set_action("file",function(x) engine.file(x) end)

for i=1,BANKS do
  params:add_control("loop_start"..i,"loop_start"..i,controlspec.new(0,1,'lin',0.01,0,'s',0.01))
  params:set_action("loop_start"..i,function(x) update_loop_start(i,x) end)
  params:add_control("loop_end"..i,"loop_end"..i,controlspec.new(0,1,'lin',0.01,1,'s',0.01))
  params:set_action("loop_end"..i,function(x) update_loop_end(i,x) end)
  params:add_control("rate"..i,"rate"..i,controlspec.new(0,10,'lin',0.01,1,'s',0.01))
  params:set_action("rate"..i,function(x) update_rate(i,x) end)
  params:add_control("vol"..i,"vol"..i,controlspec.new(0,1,'lin',0.01,1,'s',0.01))
  params:set_action("vol"..i,function(x) update_vol(i,x) end)
end

end

function key(n,d)
  if n==2 then
    alt=d
  end
end

function enc(n,z)
  if alt==0 then
    if n==1 then
      current_bank=util.clamp(current_bank+z,1,16)
    elseif n==2 then
      params:delta("loop_start"..current_bank,z)
    elseif n==3 then
      params:delta("loop_end"..current_bank,z)
    end
  elseif alt==1 then
    if n==1 then
    elseif n==2 then
      params:delta("rate"..current_bank,z)
    elseif n==3 then
      params:delta("vol"..current_bank,z)
    end
  end
  redraw()
end

function update_loop_start(i,x)
  params:set("loop_start"..i,x)
  engine.loop_start(i,x)
  redraw()
end

function update_loop_end(i,x)
  params:set("loop_end"..i,x)
  engine.loop_end(i,x)
  redraw()
end

function update_rate(i,x)
  params:set("rate"..i,x)
  engine.rate(i,x)
  redraw()
end

function update_vol(i,x)
  params:set("vol"..i,x)
  engine.amp(i,x)
  redraw()
end

g = grid.connect()

g.key = function(x,y,z)
  current_bank=x
  if y==1 and toggles[x]==0 and z==1 then
    engine.play(x,1)
    g:led(x,y,15)
    toggles[x]=1
  elseif y==1 and toggles[x]==1 and z==1 then
    engine.play(x,0)
    g:led(x,y,0)
    toggles[x]=0
  end
  g:refresh()
  redraw()
end

function redraw()
  screen.clear()
  screen.move(10,10)
  screen.text("BANK "..current_bank)
  screen.move(10,20)
  screen.text("start "..params:get("loop_start"..current_bank))
  screen.move(10,30)
  screen.text("end "..params:get("loop_end"..current_bank))
  screen.move(70,20)
  screen.text("rate "..params:get("rate"..current_bank))
  screen.move(70,30)
  screen.text("vol "..params:get("vol"..current_bank))
  screen.update()
end
    
    
    
