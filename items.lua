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

local function display_node_text(pos, node, ndef, meta)
  local text = string.format("Node: %s at %s\n", node.name, minetest.pos_to_string(pos))
  if ndef.paramtype then
    text = text..string.format("Param1 (%s): %s\n", ndef.paramtype, node.param1)
  end
  if ndef.paramtype2 then
    text = text..string.format("Param2 (%s): %s\n", ndef.paramtype2, node.param2)
  end
  if meta.fields and #meta.inventory then
    text = text .. "Meta fields:\n"
    for k, v in pairs(meta.fields) do
      text = text..string.format("%s=[%s]\n", k, v)
    end
  end
  if meta.inventory and #meta.inventory then
    text = text .. "Inventories:"
    for k, v in pairs(meta.inventory) do
      text = text..' '..k
    end
    text = text..'\n'
  end
  return text
end

minetest.register_tool("devtools:node_inspector", {
    description = "Node inspector dev tool",
    inventory_image = "devtools_node_inspector.png",
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type=="node" then
          local node = minetest.get_node(pointed_thing.under)
          local meta = minetest.get_meta(pointed_thing.under):to_table()
          local ndef = minetest.registered_nodes[node.name]
          print(display_node_text(pointed_thing.under, node, ndef, meta))
        elseif pointed_thing.type=="object" then
          print('Not implemented yet')
        end
      end
})
