--this shit was obfuscated by luraph v14.7



                                                            --]                                                 
                                                                  --[]                                          
                                                                  --[]                                          
                                                local a;local b=--[]                                            
                                            getfenv()["This is t"..                                             
                                             "he key check libr"..                                              
                                                                --                                              
                                          "ary used by Luarmor,"..                                              
                                           " documentation can be"..                                            
                                              " view"..   "ed at h"..                                           
                                              "ttps://docs.luarmor."..                                          
       "net/luarm"..                          "or-user-manual-and-"..                       "f.a.q#key"..       
     "-check-library"]    do                  local function c                  (d)       return d%--[[==]]     
    4294967296 end;                           local function e(          f,      g)      local h,i=0,1;while     
  f>0 or g>0 do local j=            f%2;      local k=g%2;if j~=       k then           h=h+i end;f=math.floor(   
  f/2)g=math.floor(g/2)i=i*         2         end;return h end;                     local function l(d,m)--[]]  
  return c(d   *2^m)end;local                 function n(d,m)                  return math.floor(   d/2^m)%--]  
  4294967296    end;function a(o)local   p={    [1]=0x5ad69b68,[2]=          0x03b7222a,[3]=--[[{]]   0x2d074df6  
  ,[4]=        0xcb4fff2d}local q={[1  ]=     0x01c3,[    2]=              0xa408,[3]=0x964d,[4]=   0x4320}--]  
  local r=#o   ;local s=1;while s<=r   do            local           t=0   ;for u=0,3 do local v=   s-1+u;if v  
  <r then      local w=o:byte(v+1)t=t  +w*2   ^(8*u)end end;t=c(t)   for    x=1,4 do local y=e(p[x   ],t)local   
  z=p[x%4+1]   y=e(y,z)y=  c(l(y,5)+n  (y,2   )+q[x])local A=(x-1)   *5%   32;local B  =n(t,A)y=e   (y,B)y=c(y  
  )local C=p   [(x+1)%4+1  ]y=c(y+C)p  [x]=   c(y)end;s=s+4 end;     for    x=1,4 do    local y=p[   x]local D=  
  p[x%4+1]     local E=p[  (x+2)%4+1]  y=c(   y+D)y=e(y,E)local A=   x*7   %32;y=c(l(  y,A)+n(y,    32-A))p[x]  
  =y end;      local F={}  for x=1,4   do F   [x]=string.format(           "%08X",p[x  ])end;       return --]  
  table.       concat(F)   end end;           local G;local H=game   :     GetService  ("HttpS"..   "ervice")   
  local        function I  (J)return    H:    JSONDecode(J)end;            local K=    syn and      syn.--[[]]  
  request or    request or   --[[: or]]         http_request;local           function L  (M)local N   =os.time()  
  M=tostring   (M)G=       tostring(G   )     local O=K({Method=    ""..   "GET",Url=  "https:"..   "//sdka"..  
  "pi-pub"..   "lic.lu"..  "armor."..   "n"..  "et/sync"})O=I(O.   Body)   local P=O.  nodes;       local Q=P[  
  math.        random(1,#  P)]local R    =Q..   "check_key?key="   ..M     .."&scr"..  "ipt_id="    ..G;local   
  S=O.st;      local T=S-  N;N=N+T;O=     K({    Method="GET",    Url=     R,Headers=  {["clie"..   "nttime"]=  
  ""..N,[      "catcat"..  "128"]=a(M      ..     "_cfver1.0_"   ..G       .."_time_"  ..N)}})      return I(O  
  .Body)end;   local       function U       ()G=    tostring   (G)if        not G:      match(""..   "^[a-f0"..  
  "-9]{32}$"   )then       return end        ;                pcall        (writefile  ,G.."-c"..   "ache.lua"  
  ,"recac"..   "he is "..  "requi"..          "red")        wait(          0.1)pcall(  delfile,G    .."-cac"..  
  "he.lua")    end;local   function             V()      --[[+]]            --[[for]]  loadstring   (game:--[]  
  HttpGet(     "https:"..  "//ap"..        ""..   "i.luarmo"..               "r.ne"..  "t/file"..   "s/v3/l"..  
  "oaders/"    ..--[[,]]   --[[/]]                   --[[]]                   --[[%]]  tostring(G   )..".lua")  
  )()end;      return      --[[]]           --[[% ]]        --[[# ]]           --[[]]   --[[<= ]]   --[[<= +]]  
  --[[} ; ]]   --[[+ ]]                     --[[/ ]]        --[[==]]                     --[[==]]   --[[{ ( ]]  
  --[[^ ; ]]   --[[~=]]                                                                  --[[* ]]   --[[do #]]  
  --[[^ do]]   --[[]]                                                                      --[[]]   --[[goto]]  
  --[[+ do]]                                                                                        --[[~= /]]  
  --[[} % ]]                              setmetatable(  {},{__index=                               function(W  
  ,X)local Y   =                    a(X)if Y=="3"..          "0F75B193B94"..                        "8B4E96"..  
  "514636"..                      "5A85CBCC"then                 return L end;                       if Y==""..  
  "2BCEA"..                             "36EB"..                "24E2"..                             "50BBA"..  
  "B188"..                            "C"..                          "7"..                            "3A74"..  
  "DF10"                                                               then                            return U   
  end;if                               Y==                                                               "75"..  
  "6"..                                                                                                  "2"..  
                                                                                                                
"4F56542822D214B1FE25E8798CC6"then return V end;return nil end,__newindex=function(W,Z,_)if Z=="script_id"then G=_ end end})

