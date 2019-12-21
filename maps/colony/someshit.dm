//snaryaga spetcnaza

/obj/item/device/radio/headset/headset_sec/alt/spec
	ks1type = /obj/item/device/encryptionkey/heads/hos

/obj/item/clothing/mask/balaclava/winter
	icon_state = "wbalaclava"
	item_state = "wbalaclava"
	cold_protection = HEAD
	min_cold_protection_temperature = T0C - 50

/obj/item/clothing/head/helmet/tactical/winter

/obj/item/clothing/head/helmet/tactical/winter
	starting_accessories = list(/obj/item/clothing/accessory/armor/helmcover/winter)

/obj/item/clothing/accessory/armor/helmcover/winter
	name = "white helmet cover"
	desc = "A fabric cover for armored helmets. This one has a snow camouflage pattern."
	icon_state = "helmcover_wint"

/obj/item/clothing/accessory/legguards/winter
	desc = "A pair of armored leg pads in navy blue. Attaches to a plate carrier."
	icon_state = "legguards_navy"

/obj/item/clothing/accessory/armguards/winter
	desc = "A pair of blue arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_blue"

/obj/item/clothing/shoes/tactical/winter
	name = "tactical boots"
	desc = "Tan boots with extra padding and armor."
	cold_protection = FEET
	min_cold_protection_temperature = T0C - 75

/obj/item/clothing/under/syndicate/winter
	name = "tactical turtleneck"
	desc = "It's some non-descript, slightly suspicious looking, civilian clothing."
	icon_state = "syndicate"
	item_state = "bl_suit"

/obj/item/clothing/suit/armor/pcarrier/winter
	name = "plate carrier"
	desc = "A lightweight black plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "pcarrier"
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = T0C - 75

/obj/item/clothing/suit/armor/pcarrier/tactical
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/tactical)

/obj/item/clothing/gloves/tactical/winter
	desc = "These white tactical gloves are made from a durable synthetic, and have hardened knuckles."
	name = "winter tactical gloves"
	icon_state = "work"
	item_state = "wgloves"
	cold_protection = HANDS
	min_cold_protection_temperature = T0C - 75

/obj/item/clothing/glasses/tacgoggles/winter
	name = "tactical goggles"
	desc = "Self-polarizing goggles with light amplification for dark environments. Made from durable synthetic."
	icon_state = "swatgoggles"
	flash_protection = FLASH_PROTECTION_MODERATE