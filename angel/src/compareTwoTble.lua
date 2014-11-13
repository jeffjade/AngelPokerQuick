local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next

function print_lua_table (lua_table, indent)
    if not lua_table or type(lua_table) ~= "table" then
    	print("Warn : This table or sunTable not a true table")
        return;
    end

    if not next(lua_table) then
    	print("This table is kong table")
    end 

    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end

function compare2Table(tableA , tableB)
	if type(tableA) ~= "table" then
		if tableA ~= tableB then 
			return false
		end
	else 
		for k , v in pairs(tableA) do 
			if type(v) == "table" then
				compare2Table(v , tableB[k])
			elseif v ~= tableB[k] then
				return false
			end 
  		end
  	end
  	return true
end

local test1 = {{[1]= "a", [2]="b"},"b"}
local test2 = {[1]= "ccc", [2]="ddd"}
local test3 = {[1]= "333", [2]="fff"}
local test4 = {{[1]= "a", [2]="b"},"c"}

local resout = compare2Table(test1 , test4)

-- print(resout and "true" or "false")

function sortTable(tablename , sortfunc)
	table.sort( tablename , sortfunc or function(a , b)
			if type(a) ~= "table" and type(a) ~= "table" then
                return a < b 
            end
		end)
	return tablename
end

function removeRetable(retable , sortfunc)
    local result = {}
    local check = {}
    local isRetab
    for i = 1 , #retable do 
        check[i] = {}
    end

    for i = 1 , #retable do
        for j = i+1 , #retable do 
            isRetab = compare2Table(retable[i] ,retable[j])
            if isRetab then
                table.insert(check[i] , j)
                check[j] = {}
            end
        end
    end

    for i = 1 , #retable do
        if not next(check[i]) then 
            result[#result+1] = retable[i]
        end
    end
    return result
end

local tab = {
	[1] = {"a" , "b"},
	[2] = {"a" , "b"},
	[3] = {"a" , "b"},
	[4] = {"a" , "c"},
    [5] = {1 , 2},
    [6] = {1 , 2},
    [7] = {2 , 1},
    [8] = {2 , 1},
    [9] = {"ff",3}
}
local res = removeRetable(tab)

print_lua_table(res)
