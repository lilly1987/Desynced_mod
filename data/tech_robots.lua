-- ROBOTS STARTING POINT
data.techs.t_robot_tech_basic = {
	name = "New Starter Tech", -- recovered database etc.
	desc = "Establishing our own technology in this new environment. We need to adapt to resources available on this planet.",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- starting resources
		"metalore", "crystal", "metalbar", "metalplate", "silica", "foundationplate",
		"c_miner", "circuit_board", --"reinforced_plate",

		"f_building_my",
		"f_building1x1d", -- 1S
		"f_building1x1f", -- 8 Storage

		"f_bot_1s_a",

		-- starting research
		"f_foundation", "c_deconstructor",
		"c_fabricator", "c_assembler", "c_uplink", "c_portable_turret", "c_integrated_behavior",

		-- starting values
		"v_color_red", "v_color_green", "v_color_blue", "v_color_yellow", "v_color_cyan", "v_color_magenta", "v_ally_faction",
		"v_color_black", "v_color_brown", "v_color_crimson", "v_color_dark_grey", "v_color_light_green", "v_color_light_grey",
		"v_color_pink", "v_color_white", "v_color_pastel",
		"v_own_faction", "v_enemy_faction", "v_world_faction", "v_bot", "v_building", "v_construction", "v_droppeditem", "v_resource", "v_mineable",
		"v_alien_faction", "v_solved", "v_unsolved", "v_can_loot", "v_bug_faction", "v_human_faction", "v_robot_faction", "v_blight", "v_not_blight",
		"v_plateau", "v_valley", "v_in_powergrid", "v_is_foundation", "v_is_grounded", "v_is_flying", "v_is_flower", "v_wall",

		-- states
		"v_damaged", "v_infected", "v_broken", "v_unpowered", "v_emergency", "v_powereddown", "v_moving", "v_pathblocked", "v_idle", "v_setnum", "v_maxrange",

		-- walls
		"f_wall",

		"x_tutorial",
		-- NEW How to Play entries
		"x_tc_controls", "x_tc_buildings", "x_tc_deployment", "x_tc_components", "x_tc_research", "x_tc_resources_mining",
		"x_tc_production", "x_tc_logistics", "x_tc_behaviors", "x_tc_research", "x_tc_user_interface", "x_tc_registers", "x_tc_power",
		"x_tc_unit", "x_tc_transport_route", "x_tc_introduction", "x_tc_the_interface", "x_tc_virus", "x_tc_blight",

		"f_carrier_bot",
		"c_scout_radar",
		"f_building2x1g",

		"x_bugs",
	},
	uplink_recipe = CreateUplinkRecipe({ bot_ai_core = 1 }, 300),
	progress = 1,
}
