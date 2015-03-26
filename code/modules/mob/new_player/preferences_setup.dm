
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	underwear = random_underwear(gender)
	skin_tone = random_skin_tone()
	hair_style = random_hair_style(gender)
	facial_hair_style = random_facial_hair_style(gender)
	hair_color = random_short_color()
	facial_hair_color = hair_color
	eye_color = random_eye_color()
	pref_species = new /datum/species/human()
	backbag = 2
	age = rand(AGE_MIN,AGE_MAX)

/datum/preferences/proc/update_preview_icon()		//seriously. This is horrendous.
	del(preview_icon_front)
	del(preview_icon_side)
	var/icon/preview_icon = null

	var/g = "m"
	if(gender == FEMALE)	g = "f"

	var/mutant_race=pref_species.id
	if(pref_species.id == "human" || !config.mutant_races)
		preview_icon = new /icon('icons/mob/human.dmi', "[skin_tone]_[g]_s")
	else
		/*preview_icon = new /icon('icons/mob/human.dmi', "[pref_species.id]_[g]_s")
		preview_icon.Blend("#[mutant_color]", ICON_MULTIPLY)*/
		preview_icon = new /icon('icons/mob/human.dmi', "[mutant_race]_[g]_s")
		var/icon/chk=new/icon('icons/mob/human.dmi')
		var/list/available_states=chk.IconStates()
		if(special_color[1]&&available_states.Find("[mutant_race]_[g]_s_1"))
			var/icon/sp_one = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[mutant_race]_[g]_s_1")
			sp_one.Blend("#[special_color[1]]", ICON_MULTIPLY)
			preview_icon.Blend(sp_one, ICON_OVERLAY)
		if(special_color[2]&&available_states.Find("[mutant_race]_[g]_s_2"))
			var/icon/sp_two = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[mutant_race]_[g]_s_2")
			sp_two.Blend("#[special_color[2]]", ICON_MULTIPLY)
			preview_icon.Blend(sp_two, ICON_OVERLAY)
		if(special_color[3]&&available_states.Find("[mutant_race]_[g]_s_3"))
			var/icon/sp_thr = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = "[mutant_race]_[g]_s_3")
			sp_thr.Blend("#[special_color[3]]", ICON_MULTIPLY)
			preview_icon.Blend(sp_thr, ICON_OVERLAY)

	var/datum/sprite_accessory/S
	if(underwear)
		S = underwear_all[underwear]
		if(S)
			preview_icon.Blend(new /icon(S.icon, "[S.icon_state]_s"), ICON_OVERLAY)

	var/icon/eyes_s = new/icon()
	if(EYECOLOR in pref_species.specflags)
		eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = "[pref_species.eyes]_s")
		eyes_s.Blend("#[eye_color]", ICON_MULTIPLY)
		if(eye_het)
			var/icon/eyes_h = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = "[pref_species.eyes]_h_s")
			eyes_h.Blend("#[eye_het]", ICON_MULTIPLY)
			eyes_s.Blend(eyes_h, ICON_OVERLAY)

	S = hair_styles_list[hair_style]
	if(S && (HAIR in pref_species.specflags))
		var/icon/hair_s = new/icon("icon" = S.icon, "icon_state" = "[S.icon_state]_s")
		hair_s.Blend("#[hair_color]", ICON_MULTIPLY)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	S = facial_hair_styles_list[facial_hair_style]
	if(S && (FACEHAIR in pref_species.specflags))
		var/icon/facial_s = new/icon("icon" = S.icon, "icon_state" = "[S.icon_state]_s")
		facial_s.Blend("#[facial_hair_color]", ICON_MULTIPLY)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/icon/clothes_s = null
	if(job_civilian_low & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
		clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
		clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
		if(backbag == 2)
			clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
		else if(backbag == 3)
			clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

	else if(job_civilian_high)//I hate how this looks, but there's no reason to go through this switch if it's empty
		switch(job_civilian_high)
			if(HOP)
				clothes_s = new /icon('icons/mob/uniform.dmi', "hop_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "hopcap"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(BARTENDER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "ba_suit_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(BOTANIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "hydroponics_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "ggloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "apron"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-hyd"), ICON_OVERLAY)
			if(CHEF)
				clothes_s = new /icon('icons/mob/uniform.dmi', "chef_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "chef"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(JANITOR)
				clothes_s = new /icon('icons/mob/uniform.dmi', "janitor_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(LIBRARIAN)
				clothes_s = new /icon('icons/mob/uniform.dmi', "red_suit_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(QUARTERMASTER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "qm_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sun"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "clipboard"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(CARGOTECH)
				clothes_s = new /icon('icons/mob/uniform.dmi', "cargotech_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(MINER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "miner_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
			if(LAWYER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "lawyer_blue_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "briefcase"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(CHAPLAIN)
				clothes_s = new /icon('icons/mob/uniform.dmi', "chapblack_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(CLOWN)
				clothes_s = new /icon('icons/mob/uniform.dmi', "clown_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "clown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/mask.dmi', "clown"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "clownpack"), ICON_OVERLAY)
			if(MIME)
				clothes_s = new /icon('icons/mob/uniform.dmi', "mime_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "lgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/mask.dmi', "mime"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "beret"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "suspenders"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "mimepack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)

	else if(job_medsci_high)
		switch(job_medsci_high)
			if(RD)
				clothes_s = new /icon('icons/mob/uniform.dmi', "director_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "clipboard"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
			if(SCIENTIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "toxinswhite_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
			if(CHEMIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "chemistrywhite_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-chem"), ICON_OVERLAY)
			if(CMO)
				clothes_s = new /icon('icons/mob/uniform.dmi', "cmo_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_lefthand.dmi', "firstaid"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
			if(DOCTOR)
				clothes_s = new /icon('icons/mob/uniform.dmi', "medical_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_lefthand.dmi', "firstaid"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
			if(GENETICIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "geneticswhite_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-gen"), ICON_OVERLAY)
			if(VIROLOGIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "virologywhite_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/mask.dmi', "sterile"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-vir"), ICON_OVERLAY)
			if(ROBOTICIST)
				clothes_s = new /icon('icons/mob/uniform.dmi', "robotics_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/items_righthand.dmi', "toolbox_blue"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)

	else if(job_engsec_high)
		switch(job_engsec_high)
			if(CAPTAIN)
				clothes_s = new /icon('icons/mob/uniform.dmi', "captain_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "captain"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sun"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "capcarapace"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(HOS)
				clothes_s = new /icon('icons/mob/uniform.dmi', "hosred_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "hoscap"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sunhud"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "hos"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
			if(WARDEN)
				clothes_s = new /icon('icons/mob/uniform.dmi', "warden_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "policehelm"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/eyes.dmi', "sunhud"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "warden_jacket"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
			if(DETECTIVE)
				clothes_s = new /icon('icons/mob/uniform.dmi', "detective_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "detective"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "detective"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(OFFICER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "secred_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "helmet"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/suit.dmi', "armor"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
			if(CHIEF)
				clothes_s = new /icon('icons/mob/uniform.dmi', "chief_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_white"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
			if(ENGINEER)
				clothes_s = new /icon('icons/mob/uniform.dmi', "engine_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "orange"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
				clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_yellow"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
			if(ATMOSTECH)
				clothes_s = new /icon('icons/mob/uniform.dmi', "atmos_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
				clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
			if(AI)//Gives AI and borgs assistant-wear, so they can still customize their character
				clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
			if(CYBORG)
				clothes_s = new /icon('icons/mob/uniform.dmi', "grey_s")
				clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
				if(backbag == 2)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
				else if(backbag == 3)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)

	//Wings!
	if(mutant_wing&&mutant_wing!="none")
		var/icon/wing_s = new/icon("icon" = 'icons/mob/wing.dmi', "icon_state" = "[mutant_wing]")
		wing_s.Blend("#[wingcolor]", ICON_MULTIPLY)
		preview_icon.Blend(wing_s, ICON_OVERLAY)
	//Tail!
	var/icon/chk=new/icon('icons/mob/tail.dmi')
	var/list/available_states=chk.IconStates()
	if(mutant_race!="human"&&kpcode_hastail(mutant_race))
		var/icon/tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[mutant_race]")
		if(special_color[1]&&available_states.Find("[mutant_race]_h") && !available_states.Find("[mutant_race]_1"))
			var/icon/sp_tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[mutant_race]_h")
			sp_tail.Blend("#[special_color[1]]", ICON_MULTIPLY)
			tail.Blend(sp_tail,ICON_OVERLAY)
		if(special_color[1]&&available_states.Find("[mutant_race]_1"))
			var/icon/sp_tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[mutant_race]_1")
			sp_tail.Blend("#[special_color[1]]", ICON_MULTIPLY)
			tail.Blend(sp_tail,ICON_OVERLAY)
		if(special_color[2]&&available_states.Find("[mutant_race]_2"))
			var/icon/sp_tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[mutant_race]_2")
			sp_tail.Blend("#[special_color[2]]", ICON_MULTIPLY)
			tail.Blend(sp_tail,ICON_OVERLAY)
		if(special_color[3]&&available_states.Find("[mutant_race]_3"))
			var/icon/sp_tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[mutant_race]_3")
			sp_tail.Blend("#[special_color[3]]", ICON_MULTIPLY)
			tail.Blend(sp_tail,ICON_OVERLAY)
		tail.Shift(NORTH,kpcode_tail_offset(mutant_race))
		preview_icon.Blend(tail, ICON_OVERLAY)
	else
		if(mutant_race=="human"&&mutant_tail!="none"&&kpcode_hastail(mutant_tail))
			var/tail_name=kpcode_hastail(mutant_tail)
			var/icon/tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[tail_name]")
			if(available_states.Find("[mutant_race]_h"))
				var/icon/sp_tail = new/icon("icon" = 'icons/mob/tail.dmi', "icon_state" = "[tail_name]_h")
				sp_tail.Blend("#[hair_color]", ICON_MULTIPLY)
				tail.Shift(NORTH,kpcode_tail_offset(mutant_tail))
				tail.Blend(sp_tail,ICON_OVERLAY)
			preview_icon.Blend(tail, ICON_OVERLAY)

	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

	del(preview_icon)
	del(eyes_s)
	del(clothes_s)