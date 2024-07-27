---@diagnostic disable: undefined-global
local r = {}
local flipFlags = {
	HORIZONTALLY = 0x80000000,
	VERTICALLY = 0x40000000,
	DIAGONALLY = 0x20000000,
	ROTATED_HEXA_120 = 0x10000000
}

---Get tile rectangles with the specified property/value
---@param map table STI map
---@param property string Property specified in Tiled for tile
---@param value any Value of property specified in Tiled for tile
---@return table rectangles
function r.getTileRectangles(map, property, value)
	local selectedTiles = {}
	--Get all tiles (especially global ID) with this property/value
	for _, singleTile in pairs(map.tiles) do
		for prop, val in pairs(singleTile.properties) do
			if prop == property and val == value then
				table.insert(selectedTiles, singleTile)
			end
		end
	end

	local rects = {}
	for _, tilesInstanceTables in pairs(map.tileInstances) do
		for _, tileInstance in pairs(tilesInstanceTables) do
			--Check if global ID does match in tile instance
			for _, selectedTile in ipairs(selectedTiles) do
				if tileInstance.gid == selectedTile.gid then
					--Positions in tile instance is relation to chunk
					local newEntry = {
						x = tileInstance.x + tileInstance.chunk.x * map.tileheight,
						y = tileInstance.y + tileInstance.chunk.y * map.tileheight,
						width = map.tileheight,
						height = map.tileheight
					}


					local flip_horizontally = bit.band(tileInstance.gid, flipFlags.HORIZONTALLY)
					if flip_horizontally ~= 0 then
						newEntry.y = newEntry.y - map.tileheight
					end

					local flip_vertically = bit.band(tileInstance.gid, flipFlags.VERTICALLY)
					if flip_vertically ~= 0 then
						newEntry.x = newEntry.x - map.tileheight
					end

					local flip_diagonally = bit.band(tileInstance.gid, flipFlags.DIAGONALLY)
					if flip_diagonally ~= 0 and flip_vertically ~= 0 then
						newEntry.x = newEntry.x + map.tileheight
						newEntry.y = newEntry.y - map.tileheight
					end

					if flip_diagonally ~= 0 and flip_horizontally ~= 0 then
						newEntry.x = newEntry.x - map.tileheight
						newEntry.y = newEntry.y + map.tileheight
					end

					table.insert(rects, newEntry)
					break
				end
			end
		end
	end
	return rects
end

---Get objects from map
---This doesn't get objects on individual tiles!
---Property and value can both be nil
---@param map table STI map
---@param property string Property specified in object
---@param value any Value of property specified in object
---@return table rectangles {x,y,width,height}
function r.getObjectsFromMap(map, property, value)
	local objects = {}
	for _, object in pairs(map.objects) do
		for prop, val in pairs(object.properties) do
			--Get all objects, all objects with property
			--or all objects with property and value
			if (prop == property and val == value)
				or (prop == property and value == nil)
				or (property == nil and value == nil) then
				table.insert(objects,
					{
						x = object.x,
						y = object.y,
						width = object.width,
						height = object.height
					})
			end
		end
	end
	return objects
end

return r
