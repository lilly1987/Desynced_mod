local new_unlocks = { }

local my_num_hp = 10000 -- 최대 10000
local my_num_power = 10000 --2147483647  -- 배터리
local my_num_power2 = 100000000 --2147483647  -- 배터리 발전기
local my_num_sockets_max = 12
local my_num_sockets_def = 0 --2147483647
local my_num_sockets = my_num_sockets_max-my_num_sockets_def --2147483647
local my_num_components = 6 --2147483647
local my_num_components_Engineer = my_num_sockets_max -my_num_sockets_def --2147483647
local my_num_components_building = my_num_sockets_max -my_num_sockets_def - 1 --2147483647

local my_component_boost = 900 -- +%
local my_miner_range = 4 --2147483647
local my_Turret_radius = 32 --2147483647
local my_visibility_range = 128 --2147483647
local my_movement_speed = 512 --2147483647

local my_components = { -- 공용 넣을것
			{ "c_higrade_capacitor_my", "hidden" } ,  -- 배터리
			{ "c_integrated_power_cell_my", "hidden" } ,  -- 
			{ "c_large_power_relay_my", "hidden" },
			
			{ "c_repairer_small_aoe_my", "hidden" },
			{ "c_repairkit_my", "hidden" },			
			{ "c_blight_shield_my", "hidden" },			
			
			{ "c_turret_energy", "hidden" }, -- 
			{ "c_turret_plasma", "hidden" }, -- 
			{ "c_turret_physical", "hidden" }, --
			
			{ "c_portablecrane_my", "hidden" },
			
			-- { "c_adv_miner_my", "hidden" },
			-- { "c_extractor_my", "hidden" },
			-- { "c_blight_extractor_my", "hidden" },
			-- { "c_extractor_my2", "hidden" }, -- 자리 차지
			-- { "c_extractor_my2", "hidden" }, -- 자리 차지
			-- { "c_extractor_my2", "hidden" }, -- 자리 차지
			-- { "c_extractor_my2", "hidden" }, -- 자리 차지
			
		-- { "c_uplink", "hidden" }, -- 자리 차지
			
}

-- data.brushes["component_bg_my"]={ "my/my.png", slice = 0.3 }
-- utilities.lua
-- function GetComponentRaceBG(race,bg)
	-- return race and comp_race_image[race] or "component_bg"
-- end
function MySetMining_recipe(key)
	data.items.metalore.mining_recipe[key] = 1
	data.items.crystal.mining_recipe[key] = 1
	data.items.silica.mining_recipe[key] = 1
	data.items.blight_crystal.mining_recipe[key] = 1
	
	data.items.laterite.mining_recipe[key] = 1 -- 홍토
	data.items.obsidian.mining_recipe[key] = 1 -- 흑요석
	data.items.blight_extraction.extracted_by[key]=true
end
function MyComponents(key,cnt,components)
	components=components or {}
	for i = 1, cnt do
		table.insert(components,{ key, "hidden" })
	end
	return components
end
function MySockets(max_cnt,sockets)
	sockets=sockets or {}
	max_cnt=max_cnt or my_num_sockets
	for i = 1, max_cnt - #sockets do
		table.insert(sockets,{ "", "Large" })
	end
	return sockets
end
function MyMake(faction,x,y) --본부
	local p={
	{"d","d","d","d","s"},
	{"d","d","d","d","b"},
	{"","","c","",""},
	{"","","","","r"},
	}
	local t={
		c="center",
		s={entity="f_bot_1s_as_my",cnt=10},
		-- v2={entity="f_bot_1s_adw_my",cnt=10},
		d={entity="f_bot_1s_adw_my2",cnt=10},
		-- v3={entity="f_bot_1s_adw_my_extractor",cnt=10},
		b={entity="f_bot_1s_adw_my_blight",cnt=10},
		r={entity="f_carrier_bot_my",cnt=100},
	}
	-- 중심점 찾기
	local cx, cy = 0, 0
	for i = 1, #p do
			for j = 1, #p[i] do
					if p[i][j] == "c" then
							cx = (j-1)*10
							cy = (i-1)*10
							goto exit_loop
					end
			end
	end
	::exit_loop::
	for i = 1, #p do
			for j = 1, #p[i] do
					local tag = p[i][j]
					if tag ~= "" and tag ~= "c"then
							local info = t[tag]
							for k = 1, info.cnt do
									local car = Map.CreateEntity(faction, info.entity)
									car:Place(x + (j-1)*10 - cx, y + (i-1)*10 - cy)
							end
					end
			end
	end

	local f = Map.CreateEntity(faction, "f_building_12")-- Scout
	f:Place(x+5, y+5)	
	f:AddItem("circuit_board", 40)
	f:AddItem("metalbar", 40)
	f:AddItem("robot_datacube", 40)
	-- for i = 1, 10 do
	-- end
end
function FreeplaySpawnPlayer(faction, loc)
	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as_my") -- 본부 이동
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

	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my2")
	bots[#bots]:Place(loc.x, loc.y-4)
	-- bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my")
	-- bots[#bots]:Place(loc.x, loc.y-4)
	-- bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw_my_extractor")
	-- bots[#bots]:Place(loc.x-3, loc.y-4)
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
	if frame["component_boost"] ~= nil and frame["component_boost"] < my_component_boost then
		frame["component_boost"]= my_component_boost
	end
	if frame["health_points"] ~= nil and frame["health_points"] < my_num_hp then
		frame["health_points"]= my_num_hp
	end
	if frame["visibility_range"] ~= nil and frame["visibility_range"] < my_visibility_range then
		frame["visibility_range"]= my_visibility_range
	end
	if frame["movement_speed"] ~= nil and frame["movement_speed"] < my_movement_speed then
		frame["movement_speed"]= my_movement_speed
	end
	frame["slots"]= { storage = 20, gas = 2 , anomaly = 2 , virus = 2}
	if frame["power"] ~= nil and frame["power"] < 0 then
		frame["power"]= 0
	end
	if frame.production_recipe ~= nil then
			frame["production_recipe"] = CreateProductionRecipe({}, { c_carrier_factory = 1 })
	end
	if frame.construction_recipe ~= nil then
			frame["construction_recipe"] = CreateConstructionRecipe({}, 1)
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
function MyFrame:FindFrame(id)
    local frame = data.frames[id]
    if not frame then
        print("Frame INFO: Frame not found: " .. tostring(id))
        return nil
    end
    return frame
end

MyComp = {
	slot_type = "storage",
	stack_size = 1,
	texture = "Main/textures/icons/frame/replace.png"
}
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
function MyComp:FindComponent(id)
    local comp = data.components[id]
    if not comp then
        print("COMPONENT INFO: Component not found: " .. tostring(id))
        return nil
    end
    return comp
end

MyVisual = {
}
function MyVisual:RegisterVisual(id, visual)
    data.visuals[id] = setmetatable(visual, { __index = self })
    return visual
end
function MyVisual:FindVisual(id)
    local visual = data.visuals[id]
    if not visual then
        print("Visual INFO: Visual not found: " .. tostring(id))
        return nil
    end
    return visual
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
		
		-- { "c_turret_energy", "hidden" } ,
		-- { "c_turret_plasma", "hidden" } ,
		-- { "c_turret_physical", "hidden" } ,
		-- { "c_uplink", "hidden" } ,
		{ "c_virus_cure", "hidden" } ,
		{ "c_small_scanner", "hidden" } ,
		{ "c_human_explorer_slot1", "hidden" } ,
		{ "c_human_explorer_slot2", "hidden" } ,
		-- { "c_repairer_my", "hidden" } ,
	},
})

data.visuals.v_bot_1s_as_my = { -- Scout
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD.Bot_1S_AD'",
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD/Ver2/Bot_1S_AD.Bot_1S_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets =MySockets(my_num_sockets - 4, {
		{ "Small1", "Large"    },
	}),
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

MyFrame:RegisterFrame("f_bot_1s_adw_my2", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "Engineer All",
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
	visual = "v_bot_1s_adw_my2",
	components =MyComponents("c_extractor_my2",my_num_components_Engineer, {
	-- components = {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})
data.visuals.v_bot_1s_adw_my2 = { -- Engineer
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_ADW.Bot_1S_ADW'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets =MySockets(my_num_sockets - my_num_components_Engineer, {
		-- { "Small1", "Large"    },
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
	components = MyComponents("c_adv_miner_my",my_num_components_Engineer, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})
MyFrame:RegisterFrame("f_bot_1s_adw_my_extractor", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "c_extractor_my",
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
	components = MyComponents("c_extractor_my",my_num_components_Engineer, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})
MyFrame:RegisterFrame("f_bot_1s_adw_my_blight", { -- Engineer 10+2
	size = "Unit", race = "robot", index = 111, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "c_blight_extractor_my",
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
	components = MyComponents("c_blight_extractor_my",my_num_components_Engineer, {
		--{ "c_moduleefficiency", "hidden" },
		-- { "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}),
})

data.visuals.v_bot_1s_adw_my = { -- Engineer
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_ADW.Bot_1S_ADW'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets =MySockets(my_num_sockets - my_num_components_Engineer, {
		-- { "Small1", "Large"    },
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
		{ "c_uplink", "hidden" }, -- 자리 차지
	},
})

data.visuals.v_carrier_bot_my = { -- Runner 운반 로봇
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Carrier_A.Bot_Carrier_A'",
	sockets =MySockets(my_num_sockets-1),
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
	visual = "v_base2x2_as_my",
	components = {
		{ "c_carrier_factory", "hidden" },
	},
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "c_deployer", { bp = { frame = "f_landingpod_my" }, onetime = true }, true)
	end,
})
data.visuals.v_base2x2_as_my = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_AD/Ver2/Building_2x2_AD.Building_2x2_AD'",
	placement = "Max",
	tile_size = { 3, 3},
	sockets =MySockets( my_num_sockets-1,{
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

MyComp:FindComponent("c_deploy_construction").on_update = function(self, comp, cause) --본부

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
MyComp:FindComponent("c_deployment"):RegisterComponent("c_deployment_my",{ --본부
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
local v_base2=MyVisual:RegisterVisual("v_base2", {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(2, {
		-- { "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
})
data.visuals.v_base1 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = MySockets(1, {
		{ "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}
data.visuals.v_base12 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(my_num_sockets, {
		{ "small1", "Large" },
	}),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}


local f_building_my = {  -- 건물 제작기 일괄
	'c_fabricator',
	'c_assembler',
	'c_refinery',
	'c_robotics_factory',
	'c_advanced_refinery',
	'c_advanced_assembler',
	'c_adv_alien_factory',
	'c_data_analyzer',
	'c_virus_decomposer',
	'c_human_datacomplex', -- 역병 분석기
	'c_human_factory_robots',
	'c_human_science_analyzer_robots',
	'c_human_refinery', -- 인류 정제기
	'c_human_refinery', -- 멀티모달 AI 센터
	'c_human_refinery', -- 인류의 공장
}
for key, value in pairs(f_building_my) do -- 제작기 일괄
	print(key, value)
	comp=MyComp:FindComponent(value)
	if comp then
		f_building_12:RegisterFrame(value.."_my",{
			size = "Small", race = "robot", index = 101, name = comp.name,
			desc = comp.desc,
			minimap_color = { 0.8, 0.8, 0.8 },
			visibility_range = 128,
			slots = { storage = 20 },
			health_points = 10000, --150
			construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 5 }, 35),
			texture = comp.texture,
			trigger_channels = "building",
			visual = "v_base2"..value,--
			components =MyComponents(value,my_num_components_building,{
				{ "c_uplink", "hidden" }, -- 자리 차지
			}),
		})
		
		if comp.visual then
			local baseVis = MyVisual:FindVisual(comp.visual)
			if baseVis and baseVis.mesh then
				v_base2:RegisterVisual("v_base2"..value,{
					mesh = baseVis.mesh,
					sockets =MySockets(my_num_sockets-my_num_components_building-1, {
						-- { "small1", "Large" },
					}),
				})
			else
				print("Visual INFO: unable to find visual '"..tostring(comp.visual).."' for component '"..tostring(value).."'")
			end
		else
			print("Visual INFO: component '"..tostring(value).."' has no visual field")
		end
	end
end

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
		-- { "c_portable_relay_my", "auto" },
		{ "c_uplink", "auto" },
	},
	
})
MyFrame:RegisterFrame("f_beacon_my", {
	size = "Small", race = "robot", index = 1002, name = "Large Beacon",
	health_points = 1,
	minimap_color = { 0.5, 0.3, 1 },
	visibility_range = 15,
	slots = { storage = 2, },
	texture = "Main/textures/icons/frame/deployment_beacon_1.png",
	construction_recipe = CreateConstructionRecipe({ beacon_frame = 5, circuit_board = 1 }, 15),
	trigger_channels = "building",
	visual = "v_beacon_l",
	power = -5,
	components = {
		{ "c_internal_crane2", "hidden" },
		{ "c_portable_relay_my", "auto" },
	},
	no_foundations = true,
})

data.visuals.v_base1x1_12 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_F.Building_1x1_F'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

MyFrame:RegisterFrame("f_large_power_relay_my", {
	size = "Small", race = "robot", index = 111, name = "Large Power Field",
	desc = "A simple storage building. Automatically transfer items here through the logistics network by setting the Store register of other units to this building.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 10,
	-- slotsMySkip=true,
	slots = { storage = 8 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 10 }, 55),
	texture = "Main/textures/icons/components/component_powerrelay_01_l.png",
	trigger_channels = "building",
	visual = "v_large_power_relay_my",
	components = {
		{ "c_large_power_relay_my", "auto" },
		{ "c_uplink", "auto" },
	},
	
})
data.visuals.v_large_power_relay_my = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerRelay_01_L.Component_PowerRelay_01_L'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets =MySockets(),
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

local c_power_cell_my = MyComp:RegisterComponent("c_power_cell_my", { -- 발전기
	attachment_size = "Hidden", race = "robot", index = 111, name = "Power Cell",
	texture = "Main/textures/icons/components/powercell.png",
	desc = "Transmits <hl>100000000</> power per second over a small area",
	visual = "v_generic_i",
	power = my_num_power2,
	production_recipe = CreateProductionRecipe({  }, { c_carrier_factory = 1 }),
	transfer_radius = 32,
	registers = { { read_only = true, tip = "Power Production" } },
	-- get_ui = true,
})
c_power_cell_my:RegisterComponent("c_integrated_power_cell_my", {
	attachment_size = "Hidden", race = "robot", index = 1012, name = "Integrated Power Cell",
	desc = "Power system built directly into structure",
	texture = "Main/textures/icons/hidden/integrated_power_cell.png",
	power = my_num_power,
	transfer_radius = 32,
	production_recipe = false,
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
MyComp:RegisterComponent("c_higrade_capacitor_my2", { -- 배터리
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


MyComp:FindComponent("c_turret"):RegisterComponent("c_turret_energy",{
	attachment_size = "Hidden", race = "robot", index = 131, name = "Turret",
	texture = "Main/textures/icons/components/component_standardTurret_01_m.png",
	desc = "Medium sized turret with good damage and range",
	power = 0,
	visual = "v_turret_m",
	activation = "OnFirstRegisterChange|OnTrustChange",
	action_tooltip = action_tooltip_set_target,
	-- registers = false,
	registers = {
		{ type = "entity", tip = "Preferred Target", ui_icon = "icon_target", click_action = true, filter = 'entity' },
		{ read_only = true, tip = "Current Target", click_action = true },
	},
	production_recipe = CreateProductionRecipe({  c_adv_portable_turret = 1, wire = 10, hdframe = 5 }, { c_assembler = 5 }),
	-- production_recipe = CreateProductionRecipe({ circuit_board = 1, energized_plate = 5, crystal = 10 }, { c_assembler = 5 }),
	on_add = on_add_charge,
	on_remove = on_remove_clear_extra_data,
	-- get_ui = true,
	get_ui = false,

	trigger_radius = my_Turret_radius,
	attack_radius = my_Turret_radius,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "energy_damage",
	duration = 1, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	blast = 2,
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
	-- get_ui = true,
	get_ui = false,

	trigger_radius = my_Turret_radius,
	attack_radius = my_Turret_radius,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "plasma_damage",
	duration = 1, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	blast = 2,
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
	-- get_ui = true,
	get_ui = false,

	trigger_radius = my_Turret_radius,
	attack_radius = my_Turret_radius,

	trigger_channels = "bot|building|bug",

	-- internal variable
	damage = 100,   -- damage per shot -- 8
	damage_type = "physical_damage",
	duration = 1, -- charge duration -- 2
	shoot_fx = "fx_turret_laser",  -- fx_turret_1
	shoot_speed = 1,
	shoot_socket = "fx",
	shoot_while_moving = true,
	blast = 2,
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
	miner_range = my_miner_range,
	on_remove = on_remove_clear_extra_data_keep_resimulated,
})
data.items.metalore.mining_recipe.c_adv_miner_my = 1
data.items.crystal.mining_recipe.c_adv_miner_my = 1
data.items.silica.mining_recipe.c_adv_miner_my = 1
data.items.blight_crystal.mining_recipe.c_adv_miner_my = 1
MyComp:FindComponent("c_extractor"):RegisterComponent("c_extractor_my", {
	attachment_size = "Small", race = "human", index = 301, name = "Laser Extractor",
	texture = "Main/textures/icons/components/Component_LaserExtractor_01_M.png",
	desc = "Laser that mines <hl>laterite</> and <hl>obsidian</>",
	power = 0,
	visual = "v_laserextractor_01_m",
	miner_effect = "fx_extractor",
	production_recipe = CreateProductionRecipe({ micropro = 1, transformer = 1, smallreactor = 1 }, { c_advanced_assembler = 40, c_human_factory_robots = 30 }),
	on_remove = on_remove_clear_extra_data_keep_resimulated,
	miner_range = my_miner_range,
})
data.items.laterite.mining_recipe.c_extractor_my = 1 -- 홍토
data.items.obsidian.mining_recipe.c_extractor_my = 1 -- 흑요석
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
	miner_range = my_miner_range,
})
data.items.blight_extraction.extracted_by.c_blight_extractor_my=true
MyComp:FindComponent("c_blight_extractor"):RegisterComponent("c_plasma_bloom_comp_my", {
	attachment_size = "Large", race = "alien", index = 5005, name = "Plasma Bloom Component",
	texture = "Main/textures/icons/components/Component_PlasmaBloom_01_M.png",
	desc = "Alien food production",
	slots = { anomaly = 2 },
	visual = "v_PlasmaBloom_01_l",
	production_effect = "fx_alien_liquid",
	--effect = "fx_alien_feeder",
	effect_socket = "fx",
	power = -30,
	extracts = "blight_plasma",
	extraction_time = 1,
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 10, energized_artifact = 1, hdframe = 20 }, { c_adv_alien_factory = 150, }),
})
-- data.items.blight_plasma.extracted_by.c_plasma_bloom_comp_my=true
MyComp:FindComponent("c_extractor"):RegisterComponent("c_extractor_my2", {
	attachment_size = "Small", race = "human", index = 301, name = "Laser Extractor",
	texture = "Main/textures/icons/components/Component_LaserExtractor_01_M.png",
	desc = "Laser that mines <hl>laterite</> and <hl>obsidian</>",
	power = 0,
	visual = "v_laserextractor_01_m",
	miner_effect = "fx_extractor",
	production_recipe = CreateProductionRecipe({ micropro = 1, transformer = 1, smallreactor = 1 }, { c_advanced_assembler = 40, c_human_factory_robots = 30 }),
	on_remove = on_remove_clear_extra_data_keep_resimulated,
	miner_range = my_miner_range,
	extracts = "blight_extraction",
	extraction_time = 1,
	activation = "Always",
})
MySetMining_recipe("c_extractor_my2")

MyComp:FindComponent("c_repairer_small_aoe"):RegisterComponent("c_repairer_small_aoe_my",  {
	attachment_size = "Hidden", race = "robot", index = 143, name = "Small AOE Repair Component",
	texture = "Main/textures/icons/components/Component_Repairer_01_S_aoe.png",
	visual = "v_repairer_AoE_01_s",
	production_recipe = CreateProductionRecipe({ c_repairer = 1, circuit_board = 5, hdframe = 1 }, { c_assembler = 50 }),

	-- internal variable
	power = -5,
	trigger_radius = 32,
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
MyComp:FindComponent("c_blight_shield"):RegisterComponent("c_blight_shield_my", {
	attachment_size = "Hidden", race = "blight", index = 2001, name = "Blight Charger",
	visual = "v_generic_i",
	texture = "Main/textures/icons/components/blight_protection.png",
	desc = "Allows units to move into blighted areas, provides <hl>50</> power from the blight",
	production_recipe = CreateProductionRecipe({ circuit_board = 5, blight_crystal = 5 }, { c_assembler = 20, }),
	activation = "Always",
	adjust_extra_power = true,
})

MyComp:FindComponent("c_portablecrane"):RegisterComponent("c_portablecrane_my", { -- 휴대용 운송기
	attachment_size = "Hidden", race = "robot", index = 123, name = "Portable Transporter",
	visual = "v_generic_i",
	texture = "Main/textures/icons/components/portable_transporter.png",
	power = 0,
	desc = "Enables automatic transfer of inventory directly between adjacent units and buildings",
	production_recipe = CreateProductionRecipe({ circuit_board = 5, wire = 1 }, { c_assembler = 50 }),
	range = 64,-- 128 초과 안됨?
})
MyComp:FindComponent("c_portable_relay"):RegisterComponent("c_portable_relay_my", { -- 전력망
	attachment_size = "Internal", race = "robot", index = 112, name = "Portable Power Field",
	desc = "Creates or expands your logistics network with a small area, transferring power to nearby units and buildings. Produces no power on its own. Most useful on a moveable unit given its short range.",
	texture = "Main/textures/icons/components/powerrelay.png",
	visual = "v_generic_i",
	transfer_radius = 32,
	production_recipe = CreateProductionRecipe({ crystal = 1, metalbar = 5 }, { c_assembler = 60 }),
})
MyComp:FindComponent("c_large_power_relay"):RegisterComponent("c_large_power_relay_my", { -- 전력망
	attachment_size = "Hidden", race = "human", index = 3011, name = "Large Power Field",
	texture = "Main/textures/icons/components/component_powerrelay_01_l.png",
	visual = "v_power_relay_01_l",
	transfer_radius = 32,
	production_recipe = CreateProductionRecipe({ c_power_relay = 1, ldframe = 10, refined_crystal = 10 }, { c_assembler = 60 }),
})

-- local c_uplink=MyComp:FindComponent("c_uplink")
-- c_uplink.get_ui = false
-- c_uplink.registers = {}
-- c_uplink.is_missing_ingredient_register = {}

MyFrame:FindFrame("f_building_sim"):RegisterFrame("f_building_sim_my", {
	size = "Special", race = "robot", index = 102, name = "Re-Simulator",
	desc = "Reconstructs objects on a simulation level, charged via datacubes",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 30,
	health_points = 3000, -- 400
	slots = { storage = 4, },
	construction_recipe = CreateConstructionRecipe({ circuit_board = 50, hdframe = 50, silicon = 50, crystal_powder = 50 }, 300),
	texture = "Main/textures/icons/frame/3x3_SIM.png",
	trigger_channels = "building",
	visual = "v_building_sim",
	components = {
		{ "c_resimulator", "hidden" },
	},
})


for _, v in ipairs(new_unlocks) do -- 잠금 해제
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
    if value.stack_size ~= nil and value.stack_size then
        value.stack_size = value.stack_size * 2
    end
end
for key, value in pairs(data.techs) do
    if value.uplink_recipe ~= nil and value.uplink_recipe then
        value.uplink_recipe.ticks = 1
    end
end
for key, value in pairs(data.frames) do
    if value.construction_recipe ~= nil and value.construction_recipe then
        value.construction_recipe.ticks = 1
    end
end






