/* ENGINEERING
 * ===========
 */

/decl/hierarchy/mil_uniform/nt/eng
	name = "Employee Engineering"
	departments = ENG

	hat = list(\
		/obj/item/clothing/head/soft/yellow, /obj/item/clothing/head/hardhat)
	under = list(\
		/obj/item/clothing/under/rank/engineer, /obj/item/clothing/under/rank/atmospheric_technician, \
		/obj/item/clothing/under/hazard)
	shoes = list(\
		/obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/workboots/alt)

/decl/hierarchy/mil_uniform/nt/eng/head
	name = "Employee Engineering Head"
	departments = ENG|COM

	hat = list(\
		/obj/item/clothing/head/soft/yellow, /obj/item/clothing/head/hardhat/white)
	under = list(\
		/obj/item/clothing/under/rank/chief_engineer)

/* SUPPLY
 * ======
 */

/decl/hierarchy/mil_uniform/nt/sup
	name = "Employee Supply"
	departments = SUP

	hat = list(\
		/obj/item/clothing/head/soft/yellow)
	under = list(\
		/obj/item/clothing/under/rank/cargotech)
	shoes = list(\
		/obj/item/clothing/shoes/brown, /obj/item/clothing/shoes/dutyboots)

/decl/hierarchy/mil_uniform/nt/sup/head
	name = "Employee Supply Head"
	departments = SUP|COM

	under = list(\
		/obj/item/clothing/under/rank/cargo)

/* SECURITY
 * ========
 */

/decl/hierarchy/mil_uniform/nt/sec
	name = "Employee Security"
	departments = SEC

	hat = list(\
		/obj/item/clothing/head/beret/sec/corporate/officer, \
		/obj/item/clothing/head/beret/sec, /obj/item/clothing/head/soft/sec, \
		/obj/item/clothing/head/soft/sec/corp, /obj/item/clothing/head/soft/sec/corp/guard)
	under = list(\
		/obj/item/clothing/under/rank/security, /obj/item/clothing/under/rank/security/alt, \
		/obj/item/clothing/under/rank/security/corp, /obj/item/clothing/under/rank/security/corp/alt, \
		/obj/item/clothing/under/rank/security/navyblue, /obj/item/clothing/under/rank/security/navyblue/alt, \
		/obj/item/clothing/under/rank/security2)
	shoes = list(\
		/obj/item/clothing/shoes/jackboots)

/decl/hierarchy/mil_uniform/nt/sec/head
	name = "Employee Security Head"
	departments = SEC|COM

	hat = list(\
		/obj/item/clothing/head/beret/sec/corporate/hos, /obj/item/clothing/head/HoS)
	under = list(\
		/obj/item/clothing/under/rank/head_of_security, /obj/item/clothing/under/rank/head_of_security/jensen, \
		/obj/item/clothing/under/rank/head_of_security/navyblue, /obj/item/clothing/under/rank/head_of_security/navyblue/alt, \
		/obj/item/clothing/under/rank/head_of_security/corp, /obj/item/clothing/under/rank/head_of_security/corp/alt, \
		/obj/item/clothing/under/hosformalfem, /obj/item/clothing/under/hosformalmale)

/* MEDICAL
 * =======
 */

/decl/hierarchy/mil_uniform/nt/med
	name = "Employee Medical"
	departments = MED

	hat = list(\
		/obj/item/clothing/head/soft/mime, /obj/item/clothing/head/nursehat, \
		/obj/item/clothing/head/surgery, /obj/item/clothing/head/surgery/purple, \
		/obj/item/clothing/head/surgery/blue, /obj/item/clothing/head/surgery/green, \
		/obj/item/clothing/head/surgery/black, /obj/item/clothing/head/surgery/navyblue, \
		/obj/item/clothing/head/surgery/lilac, /obj/item/clothing/head/surgery/teal, \
		/obj/item/clothing/head/surgery/heliodor, /obj/item/clothing/head/hardhat/EMS)
	under = list(\
		/obj/item/clothing/under/rank/chemist, /obj/item/clothing/under/rank/chemist_new, \
		/obj/item/clothing/under/rank/medical, /obj/item/clothing/under/rank/medical/paramedic, \
		/obj/item/clothing/under/rank/nurse, /obj/item/clothing/under/rank/nursesuit, \
		/obj/item/clothing/under/rank/orderly, /obj/item/clothing/under/rank/virologist, \
		/obj/item/clothing/under/rank/virologist_new, /obj/item/clothing/under/sterile, \
		/obj/item/clothing/under/rank/medical/scrubs, /obj/item/clothing/under/rank/medical/scrubs/blue, \
		/obj/item/clothing/under/rank/medical/scrubs/green, /obj/item/clothing/under/rank/medical/scrubs/purple, \
		/obj/item/clothing/under/rank/medical/scrubs/black, /obj/item/clothing/under/rank/medical/scrubs/navyblue, \
		/obj/item/clothing/under/rank/medical/scrubs/lilac, /obj/item/clothing/under/rank/medical/scrubs/teal, \
		/obj/item/clothing/under/rank/medical/scrubs/heliodor)
	shoes = list(\
		/obj/item/clothing/shoes/white)

/decl/hierarchy/mil_uniform/nt/med/head
	name = "Employee Medical Head"
	departments = MED|COM

	hat = list(\
		/obj/item/clothing/head/surgery, /obj/item/clothing/head/surgery/purple, \
		/obj/item/clothing/head/surgery/blue, /obj/item/clothing/head/surgery/green, \
		/obj/item/clothing/head/surgery/black, /obj/item/clothing/head/surgery/navyblue, \
		/obj/item/clothing/head/surgery/lilac, /obj/item/clothing/head/surgery/teal, \
		/obj/item/clothing/head/surgery/heliodor)
	under = list(\
		/obj/item/clothing/under/rank/chief_medical_officer, /obj/item/clothing/under/sterile, \
		/obj/item/clothing/under/rank/medical/scrubs, /obj/item/clothing/under/rank/medical/scrubs/blue, \
		/obj/item/clothing/under/rank/medical/scrubs/green, /obj/item/clothing/under/rank/medical/scrubs/purple, \
		/obj/item/clothing/under/rank/medical/scrubs/black, /obj/item/clothing/under/rank/medical/scrubs/navyblue, \
		/obj/item/clothing/under/rank/medical/scrubs/lilac, /obj/item/clothing/under/rank/medical/scrubs/teal, \
		/obj/item/clothing/under/rank/medical/scrubs/heliodor)

/* RESEARCH
 * ========
 */

/decl/hierarchy/mil_uniform/nt/res
	name = "Employee Research"
	departments = SCI

	under = list(\
		/obj/item/clothing/under/sterile, /obj/item/clothing/under/rank/scientist, \
		/obj/item/clothing/under/rank/scientist_new)
	shoes = list(\
		/obj/item/clothing/shoes/white)

/decl/hierarchy/mil_uniform/nt/res/head
	name = "Employee Research Head"
	departments = SCI|COM

	under = list(\
		/obj/item/clothing/under/rank/research_director, /obj/item/clothing/under/rank/research_director/dress_rd, \
		/obj/item/clothing/under/rank/research_director/rdalt)

/* COMMAND
 * =======
 */

/decl/hierarchy/mil_uniform/nt/com
	name = "Employee Command"
	departments = COM
