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

data.visuals.v_bot_1s_as_my = {
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD.Bot_1S_AD'",
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD/Ver2/Bot_1S_AD.Bot_1S_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}