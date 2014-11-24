-- File : object.lua
-- Date : 2014.11.19

function _class_(super, autoConstructSuper)
    local classType = {};
    classType.autoConstructSuper = autoConstructSuper or (autoConstructSuper == nil);
    
    if super then
        classType.super = super;
        local mt = getmetatable(super);
        setmetatable(classType, { __index = super; __newindex = mt and mt.__newindex;});
    else
        classType.setDelegate = function(self,delegate)
            self.m_delegate = delegate;
        end
    end

    return classType;
end

function _super_(obj, ...)
    do 
        local create;
        create =
            function(c, ...)
                if c.super and c.autoConstructSuper then
                    create(c.super, ...);
                end
                if rawget(c,"ctor") then
                    obj.currentSuper = c.super;
                    c.ctor(obj, ...);
                end
            end

        create(obj.currentSuper, ...);
    end
end

function _new_(classType, ...)
    local obj = {};
    local mt = getmetatable(classType);
    setmetatable(obj, { __index = classType; __newindex = mt and mt.__newindex;});
    do
        local create;
        create =
            function(c, ...)
                if c.super and c.autoConstructSuper then
                    create(c.super, ...);
                end
				if rawget(c,"ctor") then
                    obj.currentSuper = c.super;
                    c.ctor(obj, ...);
                end
            end

        create(classType, ...);
    end
    obj.currentSuper = nil;
    return obj;
end