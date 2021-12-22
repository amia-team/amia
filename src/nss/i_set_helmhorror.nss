/* Set Bonus Script - Helmed Horror Sets (Acid, Cold, Electrical, Fire, Sonic)

Set Bonus (3/3) - Adds 25% Damage Immunity to the applicable
                Element, plus glow VFX.

Revision History
Date     Name             Description
-------- ---------------- ---------------------------------------------
04/19/13 Glim             Initial Release
02/22/14 Glim             Converted to i_ script

*/
#include "amia_include"
#include "x2_inc_switches"
#include "nwnx_effects"

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch ( nEvent )
    {
        case X2_ITEM_EVENT_EQUIP:
        {
            object oPC = GetPCItemLastEquippedBy();
            object oPCKey = GetItemPossessedBy( oPC, "ds_pckey" );
            object oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
            object oHelm = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );
            object oWeapon = GetWeapon( oPC );
            effect eImmune;
            effect eGlow;

            if( GetResRef( oArmor ) == "horrorplate_fire" &&
                GetResRef( oHelm ) == "horrorhelm_fire" &&
                GetResRef( oWeapon ) == "horrorswrd_pc" )
            {
                eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 25 );
                eGlow = EffectVisualEffect( VFX_DUR_GLOW_RED );
                //Hack to better identify the effect for removal later
                eImmune = SetEffectCreator( eImmune, oWeapon );
                eGlow = SetEffectCreator( eGlow, oWeapon );
                SetLocalObject( oPCKey, "HorrorSet", oWeapon );
            }
            else if( GetResRef( oArmor ) == "horrorplate_cold" &&
                     GetResRef( oHelm ) == "horrorhelm_cold" &&
                     ( GetResRef( oWeapon ) == "horroraxe_pc" ||
                     GetResRef( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC ) ) == "horroraxe_pc" ) )
            {
                eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 25 );
                eGlow = EffectVisualEffect( VFX_DUR_GLOW_WHITE );
                //Hack to better identify the effect for removal later
                eImmune = SetEffectCreator( eImmune, oWeapon );
                eGlow = SetEffectCreator( eGlow, oWeapon );
                SetLocalObject( oPCKey, "HorrorSet", oWeapon );
            }
            else if( GetResRef( oArmor ) == "horrorplate_acid" &&
                     GetResRef( oHelm ) == "horrorhelm_acid" &&
                     GetResRef( oWeapon ) == "horrorhamr_pc" )
            {
                eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 25 );
                eGlow = EffectVisualEffect( VFX_DUR_GLOW_GREEN );
                //Hack to better identify the effect for removal later
                eImmune = SetEffectCreator( eImmune, oWeapon );
                eGlow = SetEffectCreator( eGlow, oWeapon );
                SetLocalObject( oPCKey, "HorrorSet", oWeapon );
            }
            else if( GetResRef( oArmor ) == "horrorplate_elec" &&
                     GetResRef( oHelm ) == "horrorhelm_elec" &&
                     GetResRef( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC ) ) == "horrorcros_pc" )
            {
                eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 25 );
                eGlow = EffectVisualEffect( VFX_DUR_GLOW_BLUE );
                //Hack to better identify the effect for removal later
                eImmune = SetEffectCreator( eImmune, oWeapon );
                eGlow = SetEffectCreator( eGlow, oWeapon );
                SetLocalObject( oPCKey, "HorrorSet", oWeapon );
            }
            else if( GetResRef( oArmor ) == "horrorplate_soni" &&
                     GetResRef( oHelm ) == "horrorhelm_soni" &&
                     GetResRef( oWeapon ) == "horrorscyt_pc" )
            {
                eImmune = EffectDamageImmunityIncrease( DAMAGE_TYPE_SONIC, 25 );
                eGlow = EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_WHITE  );
                //Hack to better identify the effect for removal later
                eImmune = SetEffectCreator( eImmune, oWeapon );
                eGlow = SetEffectCreator( eGlow, oWeapon );
                SetLocalObject( oPCKey, "HorrorSet", oWeapon );
            }

            effect eLink = EffectLinkEffects( eImmune, eGlow );
                   eLink = SupernaturalEffect( eLink );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );

            break;
        }
        case X2_ITEM_EVENT_UNEQUIP:
        {
            object oPC = GetPCItemLastUnequippedBy();
            object oPCKey = GetItemPossessedBy( oPC, "ds_pckey" );
            object oWeapon = GetLocalObject( oPCKey, "HorrorSet" );

            effect eRemove = GetFirstEffect( oPC );
            while( GetIsEffectValid( eRemove ) )
            {
                if( GetEffectCreator( eRemove ) == oWeapon &&
                    GetEffectDurationType( eRemove ) == DURATION_TYPE_PERMANENT )
                {
                    RemoveEffect( oPC, eRemove );
                }
            }
            break;
        }
        default:
        {
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}
