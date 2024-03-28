local xclasses = {}

function xclasses.newObject(class, ...)
    
end

function xclasses.create(className, classArgs)
    local class = newproxy(true)
    local metatable = getmetatable(class)
    local proxy = {}
    proxy.name = className

    local userdataString = tostring(class)
    metatable.__tostring = function(class)
        return proxy.name..' class: '..userdataString
    end
    metatable.__call = function(class, ...)
        return xclasses.newObject(class, ...)
    end

    return class
end

return xclasses