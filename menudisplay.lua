Hooks:Add("LocalizationManagerPostInit","loc_menu_cs_bag_bonus", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_cs_bag_bonus"] = "Secured Bags"
	})
end)

--there is definetly a better way to do this
--but i couldn't come up with one
Hooks:OverrideFunction(CrimeSpreeResultTabItem,"_create_level",function (self,total_w)
	self._level_panel = self._cs_panel:panel({})
	local level_gain = managers.crime_spree:mission_completion_gain()
	local gain_x = self._level_panel:w() * (1 - total_w) * 0.5
	local gain_y = self._level_panel:h() * 0.25
	local gain_text = "+" .. managers.localization:text("menu_cs_level", {
		level = managers.experience:cash_string(0, "")
	})
	local gain_color = self:success() and tweak_data.screen_colors.crime_spree_risk or tweak_data.screen_colors.important_1

	if not self:success() then
		gain_text = managers.localization:get_default_macro("BTN_SKULL")
	end

	local gain = self._level_panel:text({
		w = 200,
		vertical = "center",
		name = "gain",
		align = "center",
		blend_mode = "add",
		alpha = 0,
		layer = 10,
		text = gain_text,
		h = tweak_data.menu.pd2_large_font_size,
		font_size = tweak_data.menu.pd2_large_font_size,
		font = tweak_data.menu.pd2_large_font,
		color = gain_color
	})

	gain:set_center_x(gain_x)
	gain:set_center_y(gain_y)

	self._levels = {
		gain = gain,
		bonuses = {}
	}
	local bonus_i = 0

	local function add_bonus(text, level, color)
		local font = tweak_data.menu.pd2_small_font
		local font_size = tweak_data.menu.pd2_small_font_size
		local bonus = self._level_panel:text({
			blend_mode = "add",
			vertical = "center",
			alpha = 0,
			align = "center",
			layer = 10,
			text = text or "",
			h = font_size,
			font_size = font_size,
			font = font,
			color = color or tweak_data.screen_colors.crime_spree_risk
		})

		self:make_fine_text(bonus)
		bonus:set_center_x(gain_x)
		bonus:set_top(gain:bottom() + 10)

		local bonus_amt = nil

		if level ~= nil then
			bonus_amt = self._level_panel:text({
				vertical = "center",
				blend_mode = "add",
				w = 200,
				align = "center",
				alpha = 0,
				layer = 10,
				text = "+" .. managers.localization:text("menu_cs_level", {
					level = level or 0
				}),
				h = font_size,
				font_size = font_size,
				font = font,
				color = color or tweak_data.screen_colors.crime_spree_risk
			})

			bonus_amt:set_center_x(gain_x)
			bonus_amt:set_top(bonus:bottom())
		end

		table.insert(self._levels.bonuses, {
			bonus,
			bonus_amt,
			level
		})

		bonus_i = bonus_i + 1
	end

	if not self:success() then
		add_bonus(managers.localization:text("menu_cs_mission_failed"), nil, tweak_data.screen_colors.important_1)
	end

	if managers.crime_spree:catchup_bonus() > 0 and self:success() then
		add_bonus(managers.localization:text("menu_cs_catchup_bonus"), managers.crime_spree:catchup_bonus(), tweak_data.screen_colors.heat_warm_color)
	end

	--actual changes start here
	if (GetSpreeFromBags.bonus_bags and GetSpreeFromBags.bonus_bags > 0) and self:success() then
        add_bonus(managers.localization:text("menu_cs_bag_bonus"), GetSpreeFromBags.bonus_bags)
    end

	if level_gain > 0 and self:success() then
		add_bonus(managers.localization:text("menu_cs_mission_complete"), level_gain)
	end   
end)
