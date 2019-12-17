function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
function tableCopy(t)
	t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

function isPrime(n)
    local n = tonumber(n)
    
    if not n or n<2 or (n % 1 ~=0) then 
        return false
    
    elseif n>2 and (n % 2 == 0) then 
        return false
    
    
    elseif n>5 and (n % 5 ==0) then 
        return false
    
    else
        
        for i = 3, math.sqrt(n), 2 do
            
            if (n % i == 0) then
                return false
            end
        end
        
        return true
    end
end
function sleep(s)
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end
local stacks = {{}}
local vars = {}
local tabs = {}
local labels = {}
local callstack = {}
local progFile,stdin,stdout = ...
local read = function()
	return io.read()
end
local write = function(...)
	io.write(...)
end
local rfile
if stdin and stdin ~= 'cmd' then
	rfile = io.open(stdin,'r')
	read = function()
		return rfile:read()
	end
end
local wfile
if stdout and stdout ~= 'cmd' then
	wfile = io.open(stdout,'w')
	write = function(...)
		wfile:write(...)
	end
end
function stackPrint()
	
end
f = io.open(progFile,'r')
local prg = f:read("*a")
f:close()
local newPrg = ''
for c in prg:gmatch("[^\r^\n]+") do
	
	c = c:sub(1,(c:find('\"') and c:find('\"')-1 or -1))
	newPrg = newPrg..' '..c
end
local keywords = {}
for c in newPrg:gmatch("%S+") do
	table.insert(keywords,c)
end
local pc = 1
local currentStack = 1
local funcs = {
	["'"] = function()
		
		write(string.char(table.remove(stacks[currentStack])))
	end,
	["#"] = function()
		write(table.remove(stacks[currentStack]))
	end,
	["<--"] = function()
		pc=table.remove(callstack)
	end,
	[";"] = function()
		table.insert(callstack,table.remove(stacks[currentStack]))
	end,
	["↓"] = function()
		table.insert(stacks[currentStack],math.floor(table.remove(stacks[currentStack])))
	end,
	["↑"] = function()
		table.insert(stacks[currentStack],math.ceil(table.remove(stacks[currentStack])))
	end,
	["*"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a*b)
	end,
	["/"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a/b)
	end,
	["+"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a+b)
	end,
	["-"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a-b)
	end,
	["%"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a%b)
	end,
	["^"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a^b)
	end,
	["("] = function()
		table.insert(stacks[currentStack],1,table.remove(stacks[currentStack]))
	end,
	[")"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack],1))
	end,
	["|"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a == 1 or b == 1 then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["&"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a == 1 and b == 1 then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["\\"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if (a == 1 and b == 0) or (a == 0 and b == 1) then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["<"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a < b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	[">"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a > b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["<="] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a <= b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	[">="] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a >= b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["=="] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a == b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["!="] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		if a ~= b then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["!"] = function()
		table.insert(stacks[currentStack],1-table.remove(stacks[currentStack]))
	end,
	["_"] = function()
		table.insert(stacks[currentStack],math.random(0,9))
	end,
	["~"] = function()
		table.remove(stacks[currentStack])
	end,
	["`"] = function()
		table.insert(stacks[currentStack],stacks[currentStack][#stacks[currentStack]])
	end,
	["["] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])-1)
	end,
	["]"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])+1)
	end,
	["√"] = function()
		table.insert(stacks[currentStack],math.pow(table.remove(stacks[currentStack]),1/2))
	end,
	["∛"] = function()
		table.insert(stacks[currentStack],math.pow(table.remove(stacks[currentStack]),1/3))
	end,
	["∜"] = function()
		table.insert(stacks[currentStack],math.pow(table.remove(stacks[currentStack]),1/4))
	end,
	["∞"] = function()
		table.insert(stacks[currentStack],math.huge)
	end,
	["↶"] = function()
		table.insert(stacks[currentStack],-math.abs(table.remove(stacks[currentStack])))
	end,
	["↔"] = function()
		local a = table.remove(stacks[currentStack])
		local b = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],b-1)
		table.insert(stacks[currentStack],a+1)
	end,
	["↮"] = function()
		local a = table.remove(stacks[currentStack])
		local b = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],b+1)
		table.insert(stacks[currentStack],a-1)
	end,
	["π"] = function()
		table.insert(stacks[currentStack],math.pi)
	end,
	["τ"] = function()
		table.insert(stacks[currentStack],math.pi * 2)
	end,
	["ϕ"] = function()
		local gr = 1 + math.sqrt(5)
		gr = gr /2
		table.insert(stacks[currentStack],gr)
	end,
	["ⅇ"] = function()
		table.insert(stacks[currentStack],math.exp(1))
	end,
	["←"] = function()
		local n = table.remove(stacks[currentStack])
		if table.remove(stacks[currentStack]) == 1 then
			pc = pc - n
		end
	end,
	["→"] = function()
		local n = table.remove(stacks[currentStack])
		if table.remove(stacks[currentStack]) == 1 then
			pc = pc + n
		end
	end,
	["↓"] = function()
		if not stacks[currentStack+1] then
			stacks[currentStack+1] = {}
		end
		currentStack = currentStack+1
	end,
	["↑"] = function()
		if not currentStack-1 == 0 then
			currentStack = #stacks
		else
			currentStack = currentStack-1
		end
	end,
	["↷"] = function()
		table.insert(stacks[currentStack],math.abs(table.remove(stacks[currentStack])))
	end,
	["🔄"] = function()
		local a = table.remove(stacks[currentStack])
		local b = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],a)
		table.insert(stacks[currentStack],b)
	end,
	["■"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^2)
	end,
	["❒"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^3)
	end,
	["△"] = function()
		local h = table.remove(stacks[currentStack])
		local b = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],1/2*b*h)
	end,
	["⧖"] = function()
		sleep(table.remove(stacks[currentStack]))
	end,
	["◯"] = function()
		table.insert(stacks[currentStack],math.pi*(table.remove(stacks[currentStack])^2))
	end,
	["⬤"] = function()
		local area = table.remove(stacks[currentStack])
		local r = math.sqrt(area/pi)
		table.insert(stacks[currentStack],r)
	end,
	["☭"] = function()
		local n = #stacks[currentStack]
		local total = 0
		for k,v in pairs(stacks[currentStack]) do
			total = total + v
		end
		local average = total/n
		for k,v in pairs(stacks[currentStack]) do
			stacks[currentStack][k] = average
		end
	end,
	["ℕ"] = function()
		local v = table.remove(stacks[currentStack])
		local int = (v%1) == 0
		local gz = v > 0
		if int and gz then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["ℤ"] = function()
		local v = table.remove(stacks[currentStack])
		local int = (v%1) == 0
		if int then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["⧞"] = function()
		table.insert(stacks[currentStack],-math.huge)
	end,
	["∅"] = function()
		stacks[currentStack] = {}
	end,
	["′"] = function()
		if isPrime(table.remove(stacks[currentStack])) then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["»"] = function()
		local s = table.remove(stacks[currentStack])
		if s % 1 ~= 0 or s < 1 then
			error("Cannot switch to stack: "..s..'\nReason: N is not a natural number')
		end
		for i = #stacks+1,s do
			stacks[i] = {}
		end
		currentStack = s
	end,
	["‰"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])/100)
	end,
	["‱"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])/1000)
	end,
	["№"] = function()
		table.insert(stacks[currentStack],tonumber(read()))
	end,
	["␢"] = function()
	end,
	["⁰"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^0)
	end,
	["¹"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^1)
	end,
	["²"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^2)
	end,
	["³"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^3)
	end,
	["⁴"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^4)
	end,
	["⁵"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^5)
	end,
	["⁶"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^6)
	end,
	["⁷"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^7)
	end,
	["⁸"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^8)
	end,
	["⁹"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])^9)
	end,
	["▁"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*1/8)
	end,
	["▂"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*2/8)
	end,
	["▃"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*3/8)
	end,
	["▄"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*4/8)
	end,
	["▅"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*5/8)
	end,
	["▆"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*6/8)
	end,
	["▇"] = function()
		table.insert(stacks[currentStack],table.remove(stacks[currentStack])*7/8)
	end,
	["█"] = function()
		write('█')
	end,
	["░"] = function()
		write('░')
	end,
	["▒"] = function()
		write("▒")
	end,
	["▓"] = function()
		write("▓")
	end,
	["🖹"] = function()
		for k,v in ipairs(stacks[currentStack]) do
			write(string.char(v))
		end
		write('\n')
	end,
	["🎲"] = function()
		local b = table.remove(stacks[currentStack])
		local a = table.remove(stacks[currentStack])
		table.insert(stacks[currentStack],math.random(a,b))
	end,
	["⏰"] = function()
		table.insert(stacks[currentStack],os.time())
	end,
	["⑧"] = function()
		if math.random() >= 0.5 then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	end,
	["⩴"] = function()
		stacks[currentStack+1] = tableCopy(stacks[currentStack])
	end,
	["⩷"] = function()
		local s = table.remove(stacks[currentStack])
		if s % 1 ~= 0 or s < 1 then
			error("Cannot copy to stack: "..s..'\nReason: N is not a natural number')
		end
		for i = #stacks+1,s-1 do
			stacks[i] = {}
		end
		stacks[s] = tableCopy(stacks[currentStack])
	end,
	["sin"] = function()
		table.insert(stacks[currentStack],math.sin(table.remove(stacks[currentStack])))
	end,
	["cos"] = function()
		table.insert(stacks[currentStack],math.cos(table.remove(stacks[currentStack])))
	end,
	["tan"] = function()
		table.insert(stacks[currentStack],math.tan(table.remove(stacks[currentStack])))
	end,
	["sin-1"] = function()
		table.insert(stacks[currentStack],math.asin(table.remove(stacks[currentStack])))
	end,
	["cos-1"] = function()
		table.insert(stacks[currentStack],math.acos(table.remove(stacks[currentStack])))
	end,
	["tan-1"] = function()
		table.insert(stacks[currentStack],math.atan(table.remove(stacks[currentStack])))
	end,
	["l"] = function()
		table.insert(stacks[currentStack],#stacks[table.remove(stacks[currentStack])])
	end,

}
for k,v in pairs(keywords) do
	if v:sub(1,1) == ':' then
		labels[v:sub(2,-1)] = k
	end
end

while true do
	local keyword = keywords[pc]
	
	if tonumber(keyword) then
		
		
		stackPrint()
		table.insert(stacks[currentStack],tonumber(keyword))
		
		stackPrint()
	elseif keyword:sub(1,2) == '->' then
		
		pc = labels[keyword:sub(3,-1)]
	elseif keyword:sub(1,3) == '-->' then
		table.insert(callstack,pc)
		pc = labels[keyword:sub(4,-1)]
	elseif keyword:sub(1,1) == '$' then
		local varName = keyword:sub(2,-1)
		vars[varName] = table.remove(stacks[currentStack])
	elseif keyword:sub(1,3) == '}->' then
		if table.remove(stacks[currentStack]) == 1 then
			
			pc = labels[keyword:sub(4,-1)]
		end
	elseif keyword:sub(1,4) == '}-->' then
		if table.remove(stacks[currentStack]) == 1 then
			table.insert(callstack,pc)
			pc = labels[keyword:sub(5,-1)]
		end
	elseif keyword:sub(1,1) == '=' then
		table.insert(stacks[currentStack],vars[keyword:sub(2,-1)])
	elseif keyword:sub(1,1) == '?' then
		local varName = keyword:sub(2,-1)
		if tabs[varName] or vars[varName] then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	elseif keyword:sub(1,1) == '@' then
		local label = keyword:sub(2,-1)
		table.insert(stacks[currentStack],labels[label])
	elseif keyword:sub(1,1) == '.' then
		local varName = keyword:sub(2,-1)
		tabs[varName] = nil
		vars[varName] = nil
	elseif keyword:sub(1,3) == '‽' then
		local varName = keyword:sub(4,-1)
		if not(tabs[varName] or vars[varName]) then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	elseif keyword:sub(1,2) == '«' then
		tabs[keyword:sub(3,-1)] = {}
	elseif keyword:sub(1,3) == '〈' then
		local varName = keyword:sub(4,-1)
		table.insert(stacks[currentStack],table.remove(tabs[varName]))
	elseif keyword:sub(1,3) == '〉' then
		local varName = keyword:sub(4,-1)
		table.insert(tabs[varName],table.remove(stacks[currentStack]))
	elseif keyword:sub(1,3) == '《' then
		local varName = keyword:sub(4,-1)
		table.insert(stacks[currentStack],tabs[varName][table.remove(stacks[currentStack])])
	elseif keyword:sub(1,3) == '》' then
		local varName = keyword:sub(4,-1)
		tabs[varName][table.remove(stacks[currentStack])] = table.remove(stacks,currentStack)
	elseif keyword:sub(1,3) == '⨝' then
		local varAname = keyword:sub(4,-1)
		pc = pc+1
		local varBname = keywords[pc]
		TableConcat(tabs[varAname],tabs[varBname])
	elseif keyword:sub(1,3) == '∹' then
		local varAname = keyword:sub(4,-1)
		pc = pc+1
		local varBname = keywords[pc]
		tabs[varBname]=tableCopy(tabs[varAname])
	elseif keyword:sub(1,2) == '©' then
		local varName = keyword:sub(3,-1)
		TableConcat(tabs[varName],stacks[table.remove(stacks[currentStack])])
	elseif keyword:sub(1,2) == '®' then
		local varName = keyword:sub(3,-1)
		
		local t2 = {}
		local d = read()
		for c in d:gmatch('.') do
			table.insert(t2,string.byte(c))
		end
		TableConcat(tabs[varName],t2)
	elseif keyword:sub(1,3) == '℗' then
		for k,v in ipairs(tabs[keyword:sub(4,-1)]) do
			write(string.char(v))
		end
		write('\n')
	elseif keyword:sub(1,3) == '⩷' then
		table.remove(tabs[keyword:sub(4,-1)])
	elseif keyword:sub(1,3) == '∋' then
		local varName = keyword:sub(4,-1)
		local val = table.remove(stacks[currentStack])
		local found = false
		for k,v in pairs(tabs[varName]) do
			if v == val then
				found = true
			end
		end
		if found then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	elseif keyword:sub(1,3) == '∌' then
		local varName = keyword:sub(4,-1)
		local val = table.remove(stacks[currentStack])
		local found = false
		for k,v in pairs(tabs[varName]) do
			if v == val then
				found = true
			end
		end
		if not found then
			table.insert(stacks[currentStack],1)
		else
			table.insert(stacks[currentStack],0)
		end
	elseif keyword:sub(1,2) == 'α' then
		table.insert(stacks[currentStack],tabs[keyword:sub(3,-1)][1])
	elseif keyword:sub(1,3) == '⌖' then
		vars[keyword:sub(4,-1)] = 0
	elseif keyword:sub(1,4) == '👁' then
		stacks[currentStack] = tableCopy(tabs[keyword:sub(5,-1)])
	elseif keyword:sub(1,2) == '¯' then
		table.insert(stacks[currentStack],#tabs[keyword:sub(3,-1)])
	elseif keyword:sub(1,1) == "c" then
		table.insert(stacks[currentStack],string.byte(keyword:sub(2,2)))
	elseif keyword == 's' then
		table.insert(stacks[currentStack],string.byte(' '))
	elseif keyword == 'n' then
		table.insert(stacks[currentStack],string.byte('\n'))
	elseif keyword == 't' then
		table.insert(stacks[currentStack],string.byte('\t'))
	elseif funcs[keyword] then
		
		
		stackPrint()
		funcs[keyword]()
		
		stackPrint()
	end
	pc=pc+1
	if pc > #keywords then
		break
	end
end
if wfile then
	wfile:flush()
end
