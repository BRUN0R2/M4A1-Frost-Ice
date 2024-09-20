#include <amxmodx>
#include <reapi>
#include <rezp_inc/rezp_main>
#pragma compress 1

new gl_pClass_Human,
	gl_pWeaponImpulse,
	gl_pItem_Index;

public plugin_precache()
{
	register_plugin("[REZOMBIE] Item: M4A1 Frost Ice", REZP_VERSION_STR, "BRUN0")

	rz_add_translate("weapons/m4a1frostice")

	RZ_CHECK_CLASS_EXISTS(gl_pClass_Human, "class_human");
	RZ_CHECK_WEAPON_EXISTS(gl_pWeaponImpulse, "weapon_m4a1_frostice")

	new pItem = gl_pItem_Index = rz_item_create("item_m4a1_frostice")

	rz_item_set(pItem, RZ_ITEM_NAME, "RZ_ITEM_M4A1_FROSTICE")
	rz_item_set(pItem, RZ_ITEM_COST, 90)
	rz_item_command_add(pItem, "say /m4frostice")
}

public rz_items_select_pre(id, pItem)
{
	if (pItem != gl_pItem_Index)
		return RZ_CONTINUE

	if (rz_player_get(id, RZ_PLAYER_CLASS) != gl_pClass_Human)
		return RZ_BREAK

	new handle[RZ_MAX_HANDLE_LENGTH]
	get_weapon_var(gl_pWeaponImpulse, RZ_WEAPON_HANDLE, handle, charsmax(handle))

	if (rz_find_weapon_by_handler(id, handle)) {
		return RZ_SUPERCEDE
	}

	return RZ_CONTINUE
}

public rz_items_select_post(id, pItem)
{
	if (pItem != gl_pItem_Index)
		return

	new reference[RZ_MAX_REFERENCE_LENGTH]
	get_weapon_var(gl_pWeaponImpulse, RZ_WEAPON_REFERENCE, reference, charsmax(reference))
	new pWeapon = rg_give_custom_item(id, reference, GT_REPLACE, gl_pWeaponImpulse)

	if (!is_nullent(pWeapon)) {
		new WeaponIdType:weaponId = get_member(pWeapon, m_iId);
		set_member(id, m_rgAmmo, rg_get_weapon_info(weaponId, WI_MAX_ROUNDS), rg_get_weapon_info(weaponId, WI_AMMO_TYPE));
	}
}