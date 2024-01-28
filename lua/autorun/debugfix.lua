local OldFindMetaTable = FindMetaTable

local reg = setmetatable({}, {
    __index = function(self, key)
        return OldFindMetaTable(key) or rawget(self, key)
    end
})

_R = reg

function debug.getregistry()
    return reg
end

function FindMetaTable(name)
    return reg[name]
end