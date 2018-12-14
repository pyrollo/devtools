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

devtools = {}
devtools.name = minetest.get_current_modname()
devtools.path = minetest.get_modpath(devtools.name)

dofile(devtools.path.."/commands.lua")
dofile(devtools.path.."/items.lua")
