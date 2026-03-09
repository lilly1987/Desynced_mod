
for key, visual in pairs(data.visuals) do
    if visual.sockets then
        for i, socket in ipairs(visual.sockets) do
						socket[2] = "Large"   -- 원하는 값으로 변경
        end
    end
end

Frame:RegisterFrame("f_bot_1s_as_my", {
	size = "Unit", race = "robot", index = 1012, name = "Scout",
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
	production_recipe = CreateProductionRecipe({ icchip = 1, uframe = 3, fused_electrodes = 2 }, { c_robotics_factory = 60 }),
	visual = "v_bot_1s_as_my",
	components = { { "c_higrade_capacitor", "hidden" } },
})

data.visuals.v_bot_1s_as_my = { -- Scout
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD.Bot_1S_AD'",
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD/Ver2/Bot_1S_AD.Bot_1S_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Large"    },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

Frame:RegisterFrame("f_carrier_bot_my", {
	size = "Unit", race = "robot", index = 1001, name = "Runner",
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
	production_recipe = CreateProductionRecipe({ metalplate = 3, crystal = 3 }, { c_carrier_factory = 10, c_assembler = 15 }),
	visual = "v_carrier_bot",
})

data.visuals.v_carrier_bot = { -- Runner
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Carrier_A.Bot_Carrier_A'",
	sockets = {
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
		{ "",       "Large" },
	},
}


-- function Comp:RegisterComponent(id, comp)
	-- comp.id = id
	-- comp.base_id = self.base_id or self.id or id
	-- if not comp.name then comp.name = id end
	--for k,v in pairs(comp) do if Tool.Hash(v) == Tool.Hash(self[k]) and k ~= "base_id" then print("COMPONENT INFO: Inherited component contains duplicated field value: " .. tostring(id) .. " (" .. tostring(k) .. " = " .. tostring(v):gsub("\n", "") .. ")") end end
	-- data.components[id] = setmetatable(comp, { __index = self })
	-- return comp
-- end

-- local c_deploy_construction = Comp:RegisterComponent("c_deploy_construction", {})
-- function c_deploy_construction:on_update(comp, cause)

function MyMake(faction,x,y)
	for i = 1, 64 do
			local car = Map.CreateEntity(faction, "f_carrier_bot_my")
			car:Place(x, y)
			car:PlayEffect("fx_digital_in")
	end
end

function FreeplaySpawnPlayer(faction, loc)
	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as")
	lander:AddComponent("c_deployment", "hidden")
	lander:AddComponent("c_power_cell")
	lander:AddItem("c_fabricator", 1)
	lander:AddItem("c_adv_portable_turret", 1)
	lander:Place(loc.x, loc.y)
	lander.disconnected = false

	local bots = {}
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_as_my")
	local radar = bots[#bots]:AddComponent("c_scout_radar", 2)
	radar:SetRegister(1, { id = "v_unsolved" })
	bots[#bots]:Place(loc.x-2, loc.y+3)
	-- bots[#bots].disconnected = false

	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw")
	-- bots[2]:AddComponent("c_adv_miner", 1)
	bots[#bots]:Place(loc.x+3, loc.y+4)
	-- bots[2].disconnected = false

	-- bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw")
	-- bots[3]:AddComponent("c_adv_miner", 1)
	-- bots[#bots]:Place(loc.x+1, loc.y+2)
	-- bots[3].disconnected = false
	
	bots[#bots+1] = Map.CreateEntity(faction, "f_carrier_bot_my")
	-- bots[3]:AddComponent("c_adv_miner", 1)
	bots[#bots]:Place(loc.x+1, loc.y+2)
	-- bots[3].disconnected = false

	return lander, bots
end

function Comp:FindComponent(id)
    local comp = data.components[id]
    if not comp then
        print("COMPONENT INFO: Component not found: " .. tostring(id))
        return nil
    end
    return comp
end

local c_deploy_construction = Comp:FindComponent("c_deploy_construction")

function c_deploy_construction:on_update(comp, cause)
	local ed = comp.extra_data
	local bp = ed.bp

	if cause & CC_FINISH_WORK ~= CC_FINISH_WORK then
		-- Duration is 10 ticks via Deployer component and 30 via Lander Deployment component
		comp:PlayWorkEffect("fx_transfer") -- active effect indicates construction is progressing
		return comp:SetStateStartWork(bp and 10 or 30, false, true)
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

			if frame_id == "f_landingpod" then
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
