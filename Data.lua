local Data = {}

local defaultData = {
    [1] = 0,-- map
    [2] = 0,-- positionX
    [3] = 0, -- positionY
    [4] = 0, -- latest badge (all the previous are assumed to have been taken already)
}
function Data.retrieve()
    if love.filesystem.exists("Data") then
        return io.read("Data");
    else
        local data = io.open("Data", "w");
        if data == nil then
            return -1;
        else
            for i, v in defaultData do
                data:write(v .. "\n");
            end
        end
        return data;
    end
end

return Data;