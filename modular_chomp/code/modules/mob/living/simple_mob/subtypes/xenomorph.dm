// Chomp version of a xeno. Uses the thicc sprites for the queen - has a couple little custom abilities too.
// Thanks to BlackMajor for much guidance / stealing stuff from his bigdragon mob

// Base type (Mostly initialises as an ability-less xeno hunter
/mob/living/simple_mob/xeno_ch
	name = "badly spawned xenomorph"
	desc = "A chitin-covered bipedal creature with an eerie skittery nature. this one was spawned in wrong."

	icon = 'modular_chomp/icons/mob/xenos_32.dmi'
	vis_height = 32

	faction = "xeno"
	maxHealth = 200
	health = 200
	see_in_dark = 10


	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	melee_damage_lower = 8
	melee_damage_upper = 16
	grab_resist = 50

	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 50
	vore_icons = null

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"
	attacktext = list("slashed")
	friendly = list("nuzzles", "caresses", "headbumps against", "leans against", "nibbles affectionately on")
	speech_sounds = list(	'sound/voice/hiss1.ogg',
							'sound/voice/hiss2.ogg',
							'sound/voice/hiss3.ogg',
							'sound/voice/hiss4.ogg',
							'sound/voice/hiss5.ogg')
	has_hands = TRUE

	can_enter_vent_with = list(	/obj/item/weapon/implant,
								/obj/item/device/radio/borg,
								/obj/item/weapon/holder,
								/obj/machinery/camera,
								/obj/belly,
								/obj/screen,
								/atom/movable/emissive_blocker,
								/obj/item/weapon/material,
								/obj/item/weapon/melee,
								/obj/item/stack/,
								/obj/item/weapon/tool,
								/obj/item/weapon/reagent_containers/food,
								/obj/item/weapon/coin,
								/obj/item/weapon/aliencoin,
								/obj/item/weapon/ore,
								/obj/item/weapon/disk/nuclear,
								/obj/item/toy,
								/obj/item/weapon/card,
								/obj/item/device/radio,
								/obj/item/device/perfect_tele_beacon,
								/obj/item/weapon/clipboard,
								/obj/item/weapon/paper,
								/obj/item/weapon/pen,
								/obj/item/canvas,
								/obj/item/paint_palette,
								/obj/item/paint_brush,
								/obj/item/device/camera,
								/obj/item/weapon/photo,
								/obj/item/device/camera_film,
								/obj/item/device/taperecorder,
								/obj/item/device/tape)

	var/xeno_build_time = 5 //time to build a structure

	//HUD
	var/datum/action/innate/xeno_ch/xeno_build/build_action = new
	var/datum/action/innate/xeno_ch/xeno_neuro/neurotox_action = new
	var/datum/action/innate/xeno_ch/xeno_acidspit/acidspit_action = new
	var/datum/action/innate/xeno_ch/xeno_corrode/corrode_action = new
	var/datum/action/innate/xeno_ch/xeno_pounce/pounce_action = new
	var/datum/action/innate/xeno_ch/xeno_spin/spin_action = new

/mob/living/simple_mob/xeno_ch/Initialize()
	..()
	src.adjust_nutrition(src.max_nutrition)
	sight |= SEE_MOBS

/mob/living/simple_mob/xeno_ch/Login()
	. = ..()
	faction = "neutral"
	verbs |= /mob/living/simple_mob/xeno_ch/proc/xeno_build
	build_action.Grant(src)


// Xenomorph hunter subtype
/mob/living/simple_mob/xeno_ch/hunter
	name = "xenomorph hunter"
	desc = "A chitin-covered bipedal creature with an eerie skittery nature."

	movement_cooldown = 1

	icon_dead = "alienh_dead"
	icon_living = "alienh"
	icon_rest = "alienh_sleep"
	icon_state = "alienh"

	icon_state_prepounce = "alienh_pounce"
	icon_pounce = 'modular_chomp/icons/mob/xenoleap_96.dmi'
	icon_state_pounce = "alienh_leap"
	icon_overlay_spit = "alienspit"
	icon_overlay_spit_pounce = "alienspit_leap"
	icon_pounce_x = -32
	icon_pounce_y = -32

/mob/living/simple_mob/xeno_ch/hunter/Login()
	. = ..()
	verbs |= /mob/living/simple_mob/proc/pounce_toggle
	verbs |= /mob/living/proc/ventcrawl
	verbs |= /mob/living/proc/hide
	pounce_action.Grant(src)

//Xenomorph Sentinel subtype
/mob/living/simple_mob/xeno_ch/sentinel
	name = "xenomorph sentinel"
	desc = "A chitin-covered bipedal creature with an acrid scent about it."

	movement_cooldown = 1.5

	icon_dead = "aliens_dead"
	icon_living = "aliens"
	icon_rest = "aliens_sleep"
	icon_state = "aliens"

	icon_state_prepounce = "aliens_pounce"
	icon_pounce = 'modular_chomp/icons/mob/xenoleap_96.dmi'
	icon_state_pounce = "aliens_leap"
	icon_overlay_spit = "alienspit"
	icon_overlay_spit_pounce = "alienspit_leap"
	icon_pounce_x = -32
	icon_pounce_y = -32


/mob/living/simple_mob/xeno_ch/sentinel/Login()
	. = ..()
	verbs |= /mob/living/simple_mob/proc/pounce_toggle
	verbs |= /mob/living/proc/hide
	verbs |= /mob/living/simple_mob/proc/neurotoxin
	verbs |= /mob/living/simple_mob/proc/acidspit
	verbs |= /mob/living/simple_mob/proc/corrosive_acid
	pounce_action.Grant(src)
	neurotox_action.Grant(src)
	acidspit_action.Grant(src)
	corrode_action.Grant(src)


//Xenomorph queen subtype
/mob/living/simple_mob/xeno_ch/queen
	name = "xenomorph queen"
	desc = "A towering chitin-covered bipedal creature with a rather intimidating aura about them."

	icon_dead = "alienq_dead"
	icon_living = "alienq"
	icon_rest = "alienq_sleep"
	icon_state = "alienq"
	icon = 'modular_chomp/icons/mob/xenoqueen_64.dmi'
	vis_height = 64
	pixel_x = -16
	default_pixel_x = -16
	pixel_y = 0
	default_pixel_y = 0

	maxHealth = 600
	health = 600

	movement_cooldown = 2

/mob/living/simple_mob/xeno_ch/queen/Login()
	. = ..()
	verbs |= /mob/living/simple_mob/proc/neurotoxin
	verbs |= /mob/living/simple_mob/proc/acidspit
	verbs |= /mob/living/simple_mob/proc/corrosive_acid
	verbs |= /mob/living/simple_mob/proc/speen
	neurotox_action.Grant(src)
	acidspit_action.Grant(src)
	corrode_action.Grant(src)
	spin_action.Grant(src)

/mob/living/simple_mob/xeno_ch/queen/maid
	name = "xenomorph maid queen"
	desc = "A towering chitin-covered bipedal creature with a rather intimidating aura about them... though, they seem to be wearing an interesting outfit."

	icon_dead = "alienqmaid_dead"
	icon_living = "alienqmaid"
	icon_rest = "alienqmaid_sleep"
	icon_state = "alienqmaid"
