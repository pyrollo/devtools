--[[
    devtools mod for Minetest - Development / test tools for minetest
    (c) Pierre-Yves Rollo

    This file is part of devtools.

    signs is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    signs is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with signs.  If not, see <http://www.gnu.org/licenses/>.
--]]

local commands = {}

local function pop_word(str)
	if str == nil then return end
	local found = string.find(str, " ", 1) or (#str + 1)
	local word = string.sub(str, 1, found - 1)
	local remaining = string.sub(str, found + 1)
	return word, remaining
end

local function pop_number(str)
	local word, remaining = pop_word(str)
	local num = tonumber(word)
	if num == nil then
		return nil, str
	else
		return num, remaining
	end
end

minetest.register_chatcommand("dev", {
	params = "<command> <arguments>",
	description = "Launch a dev tools command. Type /dev help for command list.",
	privs = {},
	func = function(pname, params)
		local command, params = pop_word(params)

		if command == '' then
			return commands.help.func(pname, '')
		end

		if commands[command] then
			return commands[command].func(pname, params)
		end

		return false, "Unknown command '"..command.."'. Type /dev help for command list."
	end
})

--TODO use table.concat and string.format!
commands.help = {
	params = "<command>",
	description = "Describes a dev command or list available commands.",
	func = function(pname, params)
			if params == nil or params == '' then
				local output = ''
				local count = 0
				for command, def in pairs(commands) do
					count = count + 1
					output = output.."\n/dev "..command..": "..def.description
				end
				return true, count..' available /dev commands:'..output
			else
				if not commands[params] then
					return false, "Unknown command '"..(params or '').."'. Type /dev help for command list."
				end
				return true, "/dev "..params.." "..commands[params].params.."\n"..
					(commands[params].long_desc or commands[params].description)
			end
		end,
}

commands.entities = {
	params = "<radius>",
	description = "Dumps to log the list of entities inside <radius>.",
	func = function(pname, param)
			local player = minetest.get_player_by_name(pname)
			if not player then
				return false, "Player not found"
			end
			local distance = param -- TODO : check params
			local count=0
			local output = '\n***** Entity dump start *****'
			for _, objref in pairs(minetest.get_objects_inside_radius(player:get_pos(), distance)) do
				if not minetest.is_player(objref) then
					local entity = objref:get_luaentity()
					output = output..'\n"'..entity.name..'" at '..minetest.pos_to_string(objref:get_pos())
					output = output..'\n'..dump(entity)
					count = count + 1
				end
			end
			minetest.log('action', output..'\n***** Entity dump stop *****\n')
			return true, count.." entities dumped in log"
		end,
}

local looks = {
	n = 0, e = math.pi, s = 2*math.pi, w = -math.pi,
	ne = math.pi/2, nw = -math.pi/2, se = 3*math.pi/2, sw = -3*math.pi/2
}

commands.look = {
	params = "<h/v/cardinal> [<degrees>]",
	description = "Set look direction.",
	long_desc = "Set look direction :\nh <degrees> : horizontal\nv <degrees> : vertical\nn,s,e,w : North/South/East/West (ne, se, nw, sw also usable)",
	func = function(pname, params)
		local player = minetest.get_player_by_name(pname)
		if not player then
			return false, "Player not found"
		end
		local command, params = pop_word(params)
		if command == '' then
			return false, "More arguments needed."
		end
		command = command:lower()
		if command == 'h' or command == 'v' then
			local degrees = pop_number(params)
			if degrees == nil then
				return false, "Number of degrees should be given as argument to /dev look "..command
			end
			if command == 'h' then
				player:set_look_horizontal(math.rad(degrees))
			else
				player:set_look_vertical(math.rad(degrees))
			end
		elseif looks[command] then
			player:set_look_horizontal(looks[command])
		else
			return false, "Unknown '"..command.."' orientation."
		end
		return true, "Oriented."
	end
}

-- TODO : Pos adjust to corner/center + orientation
