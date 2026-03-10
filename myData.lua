local new_unlocks = { }
local my_component_boost = 900 -- +%
local my_num_hp = 10000 -- 최대 10000
local my_num_power = 50000 --2147483647
local my_num_power2 = 100000000 --2147483647
local my_components = { -- 넣을것
			{ "c_higrade_capacitor_my", "hidden" } ,
			{ "c_repairer_small_aoe_my", "hidden" },
			{ "c_portablecrane_my", "hidden" },
}
function MyComponents(key,cnt,components)
	components=components or {}
	for i = 1, cnt do
		table.insert(components,{ key, "hidden" })
	end
	return components
end
function MySockets(cnt,sockets)
	sockets=sockets or {}
	for i = 1, cnt do
		table.insert(sockets,{ "", "Large" })
	end
	return sockets
end
function MyMake(faction,x,y)
	for i = 1, 16 do
			local car = Map.CreateEntity(faction, "f_bot_1s_as_my")-- Scout
			car:Place(x-10, y)
			car:PlayEffect("fx_digital_in")
	end
	for i = 1, 64 do
			local car = Map.CreateEntity(faction, "f_bot_1s_adw_my")
			car:Place(x, y-10)
			car:PlayEffect("fx_digital_in")
	end
	for i = 1, 16 do
			local car = Map.CreateEntity(faction, "f_bot_1s_adw_my_extractor")
			car:Place(x-10, y-10)
			car:PlayEffect("fx_digital_in")
	end
	for i = 1, 16 do
			local car = Map.CreateEntity(faction, "f_bot_1s_adw_my_blight")
			car:Place(x+10, y-10)
			car:PlayEffect("fx_digital_in")
	end
	for i = 1, 16 do
			local car = Map.CreateEntity(faction, "f_carrier_bot_my")
			car:Place(x+10, y)
			car:PlayEffect("fx_digital_in")
	end
end
function FreeplaySpawnPlayer(faction, loc)
	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as_my")
	lander:AddComponent("c_deployment_my", "hidden")
	lander:AddComponent("c_power_cell_my", "hidden")
	-- lander:AddItem("c_fabricator", 1)
	-- lander:AddItem("c_adv_portable_turret", 1)
	lander:Place(loc.x, loc.y)
	lander.disconnected = false

	local bots = {}
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_as_my") -- Scout
	local radar = bots[#bots]:AddComponent("c_scout_radar", 2)
	radar:SetRegister(1, { id = "v_unsolved" })
	bots[#bots]:Place(loc.x-3, loc.y)
	-- bots[#bots].disconnected = false

	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my")
	bots[#bots]:Place(loc.x, loc.y-4)
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my_extractor")
	bots[#bots]:Place(loc.x-3, loc.y-4)
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my_blight")
	bots[#bots]:Place(loc.x+3, loc.y-4)
	-- bots[2]:AddComponent("c_adv_miner", 1)
	-- bots[2].disconnected = false

	-- bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw")
	-- bots[3]:AddComponent("c_adv_miner", 1)
	-- bots[#bots]:Place(loc.x+1, loc.y+2)
	-- bots[3].disconnected = false
	
	bots[#bots+1] = Map.CreateEntity(faction, "f_carrier_bot_my")
	-- bots[3]:AddComponent("c_adv_miner", 1)
	bots[#bots]:Place(loc.x+3, loc.y)
	-- bots[3].disconnected = false

	return lander, bots
end

MyFrame = {
	texture = "Main/textures/icons/frame/replace.png",
	minimap_color = { 0.8, 0.8, 0.8 },
	shield_type = "alloy",
}
function MyFrame:RegisterFrame(id, frame)
	table.insert(new_unlocks,id)
	frame["start_disconnected"]= false
	frame["component_boost"]= my_component_boost
	frame["health_points"]= my_num_hp -- 10만 안됨)
	frame["visibility_range"]= 128
	frame["slots"]= { storage = 20, gas = 4  }
	if frame["power"] ~= nil and frame["power"] < 0 then
		frame["power"]= 0
	end
	if frame.production_recipe ~= nil then
			frame["production_recipe"] = CreateProductionRecipe({}, { c_carrier_factory = 1 })
	end
	if frame.construction_recipe ~= nil then
			frame["construction_recipe"] = CreateConstructionRecipe({}, 1)
	end
	if frame.movement_speed ~= nil then
			frame["movement_speed"] = 128
	end	
	if frame.components ~= nil and not frame.MyComponentsSkip then
		for key, value in pairs(my_components) do 
			table.insert(frame.components,value)
		end
	elseif not frame.MyComponentsSkip then
		frame.components=my_components
	end
	data.frames[id] = setmetatable(frame, { __index = self })
	return frame
end

MyFrame:RegisterFrame("f_bot_1s_as_my", { -- Scout
	size = "Unit", race = "robot", index = 112, name = "Scout",
	texture = "Main/textures/icons/frame/bot_1s_ad.png",
	desc = "Advanced high-speed starter bot with a single small socket",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 4, },
	movement_speed = 4,
	start_disconnected = true,
	health_points = 250, -- 150
	power = -2,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	visual = "v_bot_1s_as_my",
	components = { 
		-- { "c_higrade_capacitor_my", "hidden" } ,
		
		{ "c_turret_energy", "hidden" } ,
		{ "c_turret_plasma", "hidden" } ,
		{ "c_turret_physical", "hidden" } ,
		{ "c_uplink", "hidden" } ,
		{ "c_virus_cure", "hidden" } ,
		{ "c_small_scanner", "hidden" } ,
		-- { "c_repairer_my", "hidden" } ,
	},
})

data.visuals.v_bot_1s_as_my = { -- Scout
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD.Bot_1S_AD'",
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD/Ver2/Bot_1S_AD.Bot_1S_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets =MySockets(12-5-1, {
		{ "Small1", "Large"    },
	}),
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

MyFrame:RegisterFrame("f_bot_1s_adw_my", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "Engineer unit with excellent production speed and extensive upgradeability",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 7,
	slots = { storage = 2, },
	movement_speed = 2,
	component_boost = 200,
	start_disconnected = true,
	health_points = 200, -- 120
	power = -4,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	visual = "v_bot_1s_adw_my",
	components =MyComponents("c_adv_miner_my",10, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})
MyFrame:RegisterFrame("f_bot_1s_adw_my_extractor", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "Engineer unit with excellent production speed and extensive upgradeability",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 7,
	slots = { storage = 2, },
	movement_speed = 2,
	component_boost = 200,
	start_disconnected = false,
	health_points = 200, -- 120
	power = -4,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	visual = "v_bot_1s_adw_my",
	components =MyComponents("c_extractor_my",10, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})
MyFrame:RegisterFrame("f_bot_1s_adw_my_blight", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "Engineer unit with excellent production speed and extensive upgradeability",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 7,
	slots = { storage = 2, },
	movement_speed = 2,
	component_boost = 200,
	start_disconnected = false,
	health_points = 200, -- 120
	power = -4,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	visual = "v_bot_1s_adw_my",
	components = MyComponents("c_blight_extractor_my",10, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})

data.visuals.v_bot_1s_adw_my = { -- Engineer
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_ADW.Bot_1S_ADW'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets =MySockets(1, {
		{ "Small1", "Large"    },
	}),
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

MyFrame:RegisterFrame("f_carrier_bot_my", { -- Runner 12
	size = "Unit", race = "robot", index = 101, name = "Runner",
	texture = "Main/textures/icons/frame/carrier_bot.png",
	desc = "A small cargo bot for moving items",
	minimap_color = { 0.9, 0.9, 0.8 },
	health_points = 5,
	slot_type = "garage",
	visibility_range = 5,
	slots = { storage = 1 },
	movement_speed = 3,
	start_disconnected = false,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	power = -2,
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	visual = "v_carrier_bot_my",
	components = {
		-- { "c_higrade_capacitor", "hidden" },
	},
})

data.visuals.v_carrier_bot_my = { -- Runner
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Carrier_A.Bot_Carrier_A'",
	sockets =MySockets(12),
}

MyFrame:RegisterFrame("f_bot_2m_as_my", { -- 본부 이동
	size = "Unit", race = "robot", index = 113, name = "Command Center",
	texture = "Main/textures/icons/frame/bot_2m_ad.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 8, },
	movement_speed = 4,
	start_disconnected = true,
	power = -2,
	health_points = 400, -- 150
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_bot_2m_as",
	production_recipe = CreateProductionRecipe({ icchip = 10, uframe = 20, fused_electrodes = 20 }, { c_robotics_factory = 80 }),
	MyComponentsSkip=true,
	components = { 
	{ "c_higrade_capacitor_my2", "hidden" } 
	},
})

MyFrame:RegisterFrame("f_landingpod_my", { -- 본부 건물
	size = "Special", race = "robot", index = 101, name = "Command Center",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 128,
	slots = { storage = 20, },
	health_points = 10000, -- 500
	texture = "Main/textures/icons/frame/building_2x2_ad.png",
	trigger_channels = "building",
	visual = "v_base2x2_as",
	components = {
		{ "c_carrier_factory", "hidden" },
	},
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "c_deployer", { bp = { frame = "f_landingpod_my" }, onetime = true }, true)
	end,
})
data.visuals.v_base2x2_as = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_AD/Ver2/Building_2x2_AD.Building_2x2_AD'",
	placement = "Max",
	tile_size = { 3, 3},
	sockets =MySockets( 10,{
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

local f_building_12=MyFrame:RegisterFrame("f_building_12", { -- 12
	size = "Small", race = "robot", index = 101, name = "Building 1x1 12",
	desc = "Basic 1x1 Building with Good Inventory space, but supports only one Small Component",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 128,
	slots = { storage = 20 },
	health_points = 10000, --150
	construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 5 }, 35),
	texture = "Main/textures/icons/frame/building_1x1_d.png",
	trigger_channels = "building",
	visual = "v_base12",
	components = {
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "", "hidden" },
		-- { "c_fabricator", "hidden" },
		-- { "c_fabricator", "hidden" },
	},
})

local f_building_my = {  -- 제작기 일괄
	c_fabricator={"Fabricator","Main/textures/icons/components/Component_Fabricator_01_S.png",},
	c_assembler={"Assembler","Main/textures/icons/components/Component_Assembler_01_M.png",},
	c_refinery={"Refinery","Main/textures/icons/components/Component_Refinery_01_M.png",},
	c_robotics_factory={"Robotics Assembler","Main/textures/icons/components/component_roboticsfactory_01_m.png",},
	c_advanced_refinery={"Advanced Refinery","Main/textures/icons/components/component_adv_refinery_01_l.png",},
	c_advanced_assembler={"Advanced Assembler","Main/textures/icons/components/component_adv_assembler_01_l.png",},
	c_adv_alien_factory={"Advanced Alien Factory","Main/textures/icons/components/Component_AdvancedAlienFactory_01_M.png",},
	c_data_analyzer={"Data Analyzer","Main/textures/icons/components/Component_DataAnalyzer_01_L.png"},
}
for key, value in pairs(f_building_my) do -- 제작기 일괄
	print(key, value)
	f_building_12:RegisterFrame(key.."_my",{
		size = "Small", race = "robot", index = 101, name = value[1],
		desc = "Basic 1x1 Building with Good Inventory space, but supports only one Small Component",
		minimap_color = { 0.8, 0.8, 0.8 },
		visibility_range = 128,
		slots = { storage = 20 },
		health_points = 10000, --150
		construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 5 }, 35),
		texture = value[2],
		trigger_channels = "building",
		visual = "v_base2",
		components =MyComponents(key,10),
	})
end

data.visuals.v_base2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(1, {
		{ "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}
data.visuals.v_base1 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = MySockets(0, {
		{ "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}
data.visuals.v_base12 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(11, {
		{ "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

MyFrame:RegisterFrame("f_building1x1f_my", {
	size = "Small", race = "robot", index = 111, name = "Storage Block (20)",
	desc = "A simple storage building. Automatically transfer items here through the logistics network by setting the Store register of other units to this building.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 10,
	-- slotsMySkip=true,
	slots = { storage = 8 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 10 }, 55),
	texture = "Main/textures/icons/frame/building_1x1_f.png",
	trigger_channels = "building",
	visual = "v_base1x1_12",
	components = {
		{ "c_portable_relay_my", "auto" },
	},
	
})

data.visuals.v_base1x1_12 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_F.Building_1x1_F'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(12),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

MyComp = {
	slot_type = "storage",
	stack_size = 1,
	texture = "Main/textures/icons/frame/replace.png"
}
function MyComp:FindComponent(id)
    local comp = data.components[id]
    if not comp then
        print("COMPONENT INFO: Component not found: " .. tostring(id))
        return nil
    end
    return comp
end
function MyComp:RegisterComponent(id, comp)
	table.insert(new_unlocks,id)
	comp.id = id
	comp.base_id = self.base_id or self.id or id
	if not comp.name then comp.name = id end
	if comp.production_recipe ~= nil then
			comp["production_recipe"] = CreateProductionRecipe({}, { c_carrier_factory = 1 })
	end
	if comp.construction_recipe ~= nil then
			comp["construction_recipe"] = CreateConstructionRecipe({}, 1)
	end
	comp["component_boost"]= 1000
	if comp["power"] ~= nil and comp["power"] < 0 then
		comp["power"]= 0
	end
	-- comp["attachment_size"]= "Internal"
	
	--for k,v in pairs(comp) do if Tool.Hash(v) == Tool.Hash(self[k]) and k ~= "base_id" then print("COMPONENT INFO: Inherited component contains duplicated field value: " .. tostring(id) .. " (" .. tostring(k) .. " = " .. tostring(v):gsub("\n", "") .. ")") end end
	data.components[id] = setmetatable(comp, { __index = self })
	return comp
end

MyComp:RegisterComponent("c_power_cell_my", {
	attachment_size = "Hidden", race = "robot", index = 111, name = "Power Cell",
	texture = "Main/textures/icons/components/powercell.png",
	desc = "Transmits <hl>100000000</> power per second over a small area",
	visual = "v_generic_i",
	power = 100000000,
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	transfer_radius = 128,
	registers = { { read_only = true, tip = "Power Production" } },
	-- get_ui = true,
})
MyComp:RegisterComponent("c_higrade_capacitor_my", {
	attachment_size = "Hidden", race = "robot", index = 115, name = "Hi-Grade Capacitor",
	texture = "Main/textures/icons/hidden/higrade_capacitor.png",
	visual = "v_generic_i",
	desc = "Stores excess power from your logistics network making it available when needed",
	power_storage = my_num_power,
	drain_rate = my_num_power,
	charge_rate = my_num_power,
	-- get_ui = battery_get_ui,
	--production_recipe = CreateProductionRecipe({ hdframe = 1, refined_crystal = 5 }, { c_assembler = 30 }),
})
MyComp:RegisterComponent("c_higrade_capacitor_my2", {
	attachment_size = "Hidden", race = "robot", index = 115, name = "Hi-Grade Capacitor",
	texture = "Main/textures/icons/hidden/higrade_capacitor.png",
	visual = "v_generic_i",
	desc = "Stores excess power from your logistics network making it available when needed",
	power_storage = my_num_power2,
	drain_rate = my_num_power2,
	charge_rate = my_num_power2,
	-- get_ui = battery_get_ui,
	--production_recipe = CreateProductionRecipe({ hdframe = 1, refined_crystal = 5 }, { c_assembler = 30 }),
})

MyComp:FindComponent("c_deploy_construction").on_update = function(self, comp, cause)

	local ed = comp.extra_data
	local bp = ed.bp

	if cause & CC_FINISH_WORK ~= CC_FINISH_WORK then
		-- Duration is 10 ticks via Deployer component and 30 via Lander Deployment component
		comp:PlayWorkEffect("fx_transfer") -- active effect indicates construction is progressing
		return comp:SetStateStartWork(bp and 1 or 3, false, true)
	end

	local lander = not bp and ed.lander
	local frame_id = lander and lander:FindComponent("c_deployment", true).def.deployment_frame or (bp and bp.frame)
	local temp = comp.owner
	local faction, loc, rotation = temp.faction, temp.placed_location, temp.rotation
	local x, y = loc.x, loc.y
	if not faction:CanPlace(frame_id, x, y, rotation, bp and bp.visual or nil) then
		-- Try again after 5 ticks
		faction:OrderEntitiesToMoveAway(temp)
		return comp:SetStateStartWork(TICKS_PER_SECOND)
	end

	-- Deployment is completing, signal c_deploy_construction:on_remove to not do anything anymore
	comp.extra_data = nil

	Map.Defer(function()
		if not temp.exists then return end
		local built = CreateFrameOrBlueprint(faction, (bp or data.frames[frame_id]), true, nil, nil, true, temp)
		if not built then error("failed to spawn frame") end
		--built:PlayEffect("fx_ui_BUILD_COMPLETE")

		-- spawn foundations around entity if it's a building
		CreateFoundationsForEntity(built, x, y, rotation)

		if lander then
			local lander_components = lander.components

			-- If behavior was running before deployment, continue it for MakeBlueprintFromEntity below (will be immediately destroyed afterwards anyway)
			for _,v in ipairs(lander_components) do
				if v.base_id == "c_behavior" and v.has_extra_data and v.extra_data.debug == "c_deployment" then
					DebugBehavior(v, "CONTINUE")
				end
			end

			local lander_bp = MakeBlueprintFromEntity(lander) -- copy settings

			-- move components and items from lander to building
			for _,v in ipairs(lander_components) do
				if v.base_id ~= "c_deployment" and v.id ~= "c_small_fusion_reactor" then
					local comp_hidden, comp_id, comp_extra = v.is_hidden, v.id, (v.has_extra_data and v.extra_data or nil)
					if comp_extra then v.extra_data = nil end
					local newcomp = comp_hidden and built:AddComponent(comp_id, "hidden", comp_extra) or built:AddComponent(comp_id, comp_extra)
					if not newcomp then built:AddItem(comp_id, comp_extra) end
				end
			end
			for _,v in ipairs(lander.slots) do
				if v.stack > 0 then
					local item_extra = v.has_extra_data and v.extra_data or nil
					if item_extra then v.extra_data = nil end
					built:AddItem(v.id, v.stack, item_extra)
				end
			end

			ApplyBlueprintToEntity(built, lander_bp) -- apply settings (register, logistics, locks)

			-- destroy the deploy entity without dropping items
			lander:Destroy(false)

			if frame_id == "f_landingpod" or frame_id == "f_landingpod_my" then
				FactionCount("built_landingpod", true, faction)

				-- spawn 2 carriers
				-- local car = Map.CreateEntity(faction, "f_carrier_bot")
				-- car:Place(x, y)
				-- car:PlayEffect("fx_digital_in")
				-- car = Map.CreateEntity(faction, "f_carrier_bot")
				-- car:Place(x, y)
				-- car:PlayEffect("fx_digital_in")
				
				MyMake(faction,x, y)
				
			end
		end
	end)
end
MyComp:FindComponent("c_deployment"):RegisterComponent("c_deployment_my",{
	attachment_size = "Hidden", race = "robot", index = 142, name = "Deployment",
	texture = "Main/textures/icons/hidden/integrated_deployer.png",
	desc = "Initial planetary colonization support package, cannot deploy while frame is active",
	visual = "v_generic_i",
	activation = "OnFirstRegisterChange",
	action_tooltip = "Deploy",
	required_resources = { "crystal", "metalore" },
	registers = { { tip = "Deploy Base", click_action = true, ui_icon = "icon_new", filter = 'coord' } },
	deployment_frame = "f_landingpod_my",
})

MyComp:FindComponent("c_turret"):RegisterComponent("c_turret_energy",{
	attachment_size = "Hidden", race = "robot", index = 131, name = "Turret",
	texture = "Main/textures/icons/components/component_standardTurret_01_m.png",
	desc = "Medium sized turret with good damage and range",
	power = 0,
	visual = "v_turret_m",
	activation = "OnFirstRegisterChange|OnTrustChange",
	action_tooltip = action_tooltip_set_target,
	registers = {
		{ type = "entity", tip = "Preferred Target", ui_icon = "icon_target", click_action = true, filter = 'entity' },
		{ read_only = true, tip = "Current Target", click_action = true },
	},
	production_recipe = CreateProductionRecipe({  c_adv_portable_turret = 1, wire = 10, hdframe = 5 }, { c_assembler = 5 }),
	-- production_recipe = CreateProductionRecipe({ circuit_board = 1, energized_plate = 5, crystal = 10 }, { c_assembler = 5 }),
	on_add = on_add_charge,
	on_remove = on_remove_clear_extra_data,
	get_ui = true,

	trigger_radius = 128,
	attack_radius = 128,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "energy_damage",
	duration = 6, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	--shoot_target = "ground", -- set to "air" or "ground" to limit, otherwise can shoot both
})
MyComp:FindComponent("c_turret"):RegisterComponent("c_turret_plasma",{
	attachment_size = "Hidden", race = "robot", index = 131, name = "Turret",
	texture = "Main/textures/icons/components/component_standardTurret_01_m.png",
	desc = "Medium sized turret with good damage and range",
	power = 0,
	visual = "v_turret_m",
	activation = "OnFirstRegisterChange|OnTrustChange",
	action_tooltip = action_tooltip_set_target,
	registers = {
		{ type = "entity", tip = "Preferred Target", ui_icon = "icon_target", click_action = true, filter = 'entity' },
		{ read_only = true, tip = "Current Target", click_action = true },
	},
	production_recipe = CreateProductionRecipe({  c_adv_portable_turret = 1, wire = 10, hdframe = 5 }, { c_assembler = 5 }),
	-- production_recipe = CreateProductionRecipe({ circuit_board = 1, energized_plate = 5, crystal = 10 }, { c_assembler = 5 }),
	on_add = on_add_charge,
	on_remove = on_remove_clear_extra_data,
	get_ui = true,

	trigger_radius = 128,
	attack_radius = 128,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "plasma_damage",
	duration = 6, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	--shoot_target = "ground", -- set to "air" or "ground" to limit, otherwise can shoot both
})
MyComp:FindComponent("c_turret"):RegisterComponent("c_turret_physical",{
	attachment_size = "Hidden", race = "robot", index = 131, name = "Turret",
	texture = "Main/textures/icons/components/component_standardTurret_01_m.png",
	desc = "Medium sized turret with good damage and range",
	power = 0,
	visual = "v_turret_m",
	activation = "OnFirstRegisterChange|OnTrustChange",
	action_tooltip = action_tooltip_set_target,
	registers = {
		{ type = "entity", tip = "Preferred Target", ui_icon = "icon_target", click_action = true, filter = 'entity' },
		{ read_only = true, tip = "Current Target", click_action = true },
	},
	production_recipe = CreateProductionRecipe({  c_adv_portable_turret = 1, wire = 10, hdframe = 5 }, { c_assembler = 5 }),
	-- production_recipe = CreateProductionRecipe({ circuit_board = 1, energized_plate = 5, crystal = 10 }, { c_assembler = 5 }),
	on_add = on_add_charge,
	on_remove = on_remove_clear_extra_data,
	get_ui = true,

	trigger_radius = 128,
	attack_radius = 128,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "physical_damage",
	duration = 6, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	--shoot_target = "ground", -- set to "air" or "ground" to limit, otherwise can shoot both
})

MyComp:FindComponent("c_adv_miner"):RegisterComponent("c_adv_miner_my",{
	attachment_size = "Small", race = "robot", index = 103, name = "Laser Mining Tool",
	texture = "Main/textures/icons/components/Component_Miner_02_S.png",
	desc = "Laser Mining Tool - extracts metal and crystal with high efficiency (2x)",
	power = 0,
	visual = "v_miner_adv_s",
	disregard_tooltip = true,
	-- production_recipe = false,
	production_recipe = CreateProductionRecipe({ fused_electrodes = 2, icchip = 2, optic_cable = 5 }, { c_assembler = 50 }),
	activation = "OnFirstRegisterChange",
	miner_effect = "fx_miner",
	miner_range = 128,
	on_remove = on_remove_clear_extra_data_keep_resimulated,
})
MyComp:FindComponent("c_extractor"):RegisterComponent("c_extractor_my", {
	attachment_size = "Medium", race = "human", index = 301, name = "Laser Extractor",
	texture = "Main/textures/icons/components/Component_LaserExtractor_01_M.png",
	desc = "Laser that mines <hl>laterite</> and <hl>obsidian</>",
	power = 0,
	visual = "v_laserextractor_01_m",
	miner_effect = "fx_extractor",
	production_recipe = CreateProductionRecipe({ micropro = 1, transformer = 1, smallreactor = 1 }, { c_advanced_assembler = 40, c_human_factory_robots = 30 }),
	on_remove = on_remove_clear_extra_data_keep_resimulated,
	miner_range = 128,
})
MyComp:FindComponent("c_blight_extractor"):RegisterComponent("c_blight_extractor_my", {
	attachment_size = "Small", race = "blight", index = 201, name = "Blight Extractor",
	texture = "Main/textures/icons/components/component_blightextractor_01_s.png",
	desc = "Extracts blight gas when placed inside a blighted area",
	power = 0,
	visual = "v_blightextractor_s",
	slots = { gas = 4 },
	production_recipe = CreateProductionRecipe({ reinforced_plate = 5, crystal_powder = 10 }, { c_assembler = 40, c_human_factory = 40 }),
	extracts = "blight_extraction",
	extraction_time = 1,
	activation = "Always",
	miner_range = 128,
})

MyComp:FindComponent("c_repairer_small_aoe"):RegisterComponent("c_repairer_small_aoe_my",  {
	attachment_size = "Hidden", race = "robot", index = 143, name = "Small AOE Repair Component",
	texture = "Main/textures/icons/components/Component_Repairer_01_S_aoe.png",
	visual = "v_repairer_AoE_01_s",
	production_recipe = CreateProductionRecipe({ c_repairer = 1, circuit_board = 5, hdframe = 1 }, { c_assembler = 50 }),

	-- internal variable
	power = -5,
	trigger_radius = 128,
	repair = 2,   -- repair health per use
})
MyComp:FindComponent("c_repairkit"):RegisterComponent("c_repairkit_my", {
	attachment_size = "Hidden", race = "robot", index = 143, name = "Repair Kit",
	desc = "Can repair the unit or building it is equipped on",
	texture = "Main/textures/icons/components/repairkit.png",
	visual = "v_generic_i",
	production_recipe = CreateProductionRecipe({ circuit_board = 1, crystal = 5 }, { c_assembler = 50 }),
	activation = "Always",
	power = -2,
	on_add = on_add_charge,
	on_remove = on_remove_clear_extra_data,
	repair = 1,
	duration = 10,
	repair_fx = "fx_heal_unit",
})

MyComp:FindComponent("c_portablecrane"):RegisterComponent("c_portablecrane_my", {
	attachment_size = "Hidden", race = "robot", index = 123, name = "Portable Transporter",
	visual = "v_generic_i",
	texture = "Main/textures/icons/components/portable_transporter.png",
	power = 0,
	desc = "Enables automatic transfer of inventory directly between adjacent units and buildings",
	production_recipe = CreateProductionRecipe({ circuit_board = 5, wire = 1 }, { c_assembler = 50 }),
	range = 128,
})
MyComp:FindComponent("c_portable_relay"):RegisterComponent("c_portable_relay_my", {
	attachment_size = "Internal", race = "robot", index = 112, name = "Portable Power Field",
	desc = "Creates or expands your logistics network with a small area, transferring power to nearby units and buildings. Produces no power on its own. Most useful on a moveable unit given its short range.",
	texture = "Main/textures/icons/components/powerrelay.png",
	visual = "v_generic_i",
	transfer_radius = 128,
	production_recipe = CreateProductionRecipe({ crystal = 1, metalbar = 5 }, { c_assembler = 60 }),
})


for _, v in ipairs(new_unlocks) do
    table.insert(data.techs.t_robot_tech_basic.unlocks, v)
end

for key, visual in pairs(data.visuals) do
    if visual.sockets then
        for i, socket in ipairs(visual.sockets) do
						socket[2] = "Large"   -- 원하는 값으로 변경
        end
    end
end

for key, value in pairs(data.items) do
    if value.stack_size ~= nil then
        value.stack_size = value.stack_size * 2
    end
end

data.items.metalore.mining_recipe.c_adv_miner_my = 1
data.items.crystal.mining_recipe.c_adv_miner_my = 1
data.items.silica.mining_recipe.c_adv_miner_my = 1
data.items.blight_crystal.mining_recipe.c_adv_miner_my = 1

data.items.laterite.mining_recipe.c_extractor_my = 1 -- 홍토
data.items.obsidian.mining_recipe.c_extractor_my = 1 -- 흑요석

data.items.blight_extraction.extracted_by.c_blight_extractor_my=true