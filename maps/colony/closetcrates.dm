
/obj/structure/closet/secure_closet/security/colony/sarg
	name = "security sergeant's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

/obj/structure/closet/secure_closet/security/colony/sarg/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/security, /obj/item/weapon/storage/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/suit/armor/vest/nt,
		/obj/item/clothing/head/HoS/dermal,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/weapon/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/grenade/chem_grenade/teargas,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/weapon/gun/energy/gun/secure,
		/obj/item/weapon/gun/energy/stunrevolver/secure/nanotrasen,
		/obj/item/device/holowarrant,)


/obj/structure/closet/secure_closet/security/colony/spetcnaz
	name = "specop's locker"
	req_access = list(access_brig)
	closet_appearance = /decl/closet_appearance/secure_closet/security

/obj/structure/closet/secure_closet/security/colony/spetcnaz/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/security, /obj/item/weapon/storage/backpack/satchel/sec)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/suit/armor/pcarrier/winter,
		/obj/item/clothing/head/helmet/tactical/winter,
		/obj/item/clothing/gloves/tactical/winter,
		/obj/item/clothing/mask/balaclava/winter,
		/obj/item/clothing/accessory/armguards/winter,
		/obj/item/clothing/accessory/legguards/winter,
		/obj/item/clothing/shoes/tactical/winter,
		/obj/item/clothing/glasses/tacgoggles/winter,
		/obj/item/device/radio/headset/headset_sec/alt/spec,
		/obj/item/weapon/storage/belt/holster/security,
		/obj/item/device/flash,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/hailer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/weapon/gun/projectile/pistol/sec/MK,
		/obj/item/weapon/gun/energy/stunrevolver/secure/nanotrasen)