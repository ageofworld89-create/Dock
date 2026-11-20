-- Spring hover/press animation for all dock icons (time-based, frame-rate independent).
local order={'search','telegram','tiktok','instagram','yandex','youtube'}
local ic,last={},0
local function clamp(v,a,b) return v<a and a or (v>b and b or v) end

function Initialize()
 for i,n in ipairs(order) do ic[n]={x=1,v=0,h=0,p=0,cy=36+52*(i-1),mv=false} end
 last=os.clock()
end
function H(n,s) ic[n].h=s end
function P(n,s) ic[n].p=s end

local function apply(n,s)
 local size=math.floor(36*s.x+0.5)
 local k=clamp((s.x-1)/0.2,0,1)
 local o='I'..n
 SKIN:Bang('!SetOption',o,'W',size)
 SKIN:Bang('!SetOption',o,'H',size)
 SKIN:Bang('!SetOption',o,'X',math.floor(32-size/2))
 SKIN:Bang('!SetOption',o,'Y',math.floor(s.cy-size/2))
 SKIN:Bang('!SetOption',o,'ImageTint','255,255,255,'..math.floor(215+40*k))
 SKIN:Bang('!SetOption','G'..n,'Shape',string.format('Ellipse 32,%d,%.1f | Fill Color 255,255,255,%d | StrokeWidth 0',s.cy,23*s.x,math.floor(clamp((s.x-1)/0.2,0,1.2)*55)))
end

function Update()
 local now=os.clock()
 local dt=clamp(now-last,0,0.05); last=now
 if dt==0 then return 0 end
 for _,n in ipairs(order) do
  local s=ic[n]
  local t=(s.p==1 and 0.88) or (s.h==1 and 1.2) or 1
  s.v=s.v+((t-s.x)*420-s.v*26)*dt
  s.x=s.x+s.v*dt
  if math.abs(t-s.x)<0.002 and math.abs(s.v)<0.02 then
   s.x=t s.v=0
   if s.mv then s.mv=false apply(n,s) end
  else
   s.mv=true apply(n,s)
  end
 end
 return 0
end
