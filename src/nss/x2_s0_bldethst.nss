// Blade Thirst
//
// Grants a +3 enhancement bonus to a slashing weapon
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/27/2002 Andrew Nobbs     Initial release.
// 07/07/2003 Georg Zoeller    Stacking Spell Pass
// 07/21/2003 Andrew Nobbs     Complete Rewrite to make use of Item Property
//                             System.
// 04/01/2004 jpavelch         Spell no longer works with Thayvian crefted
//                             items.
// 12/20/2004 jpavelch         Changed duration to turns/level.
// 2007-04-20 disco            No slashing check, caster level / 2 enhancement, keen

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"
#include "tcs_include"
#include "inc_td_itemprop"


void main(){

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if ( !X2PreSpellCastCode() ){

    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables
    int nDuration  = GetCasterLevel( OBJECT_SELF );
    int nEnh       = ( nDuration - 11 ) / 2;
    int nMetaMagic = GetMetaMagicFeat();

    object oMyWeapon = GetTargetedOrEquippedWeaponForSpell(SPELL_BLADE_THIRST);

    // Filter: Invalid weaponry.
    if( !GetIsObjectValid( oMyWeapon ) ){
        FloatingTextStrRefOnCreature( 83615, OBJECT_SELF );
        return;
    }

    if(TCS_GetIsThayvian( oMyWeapon ))
    {
    SendMessageToPC( OBJECT_SELF , "This spell does not work on thayvian crafted items.");
    return;
    }

    if ( nMetaMagic == METAMAGIC_EXTEND ){

        nDuration = nDuration * 2; //Duration is +100%
    }

    if ( GetIsObjectValid( oMyWeapon ) ){

        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if ( nDuration > 0 ){

            effect eVis     = EffectVisualEffect( VFX_IMP_SUPER_HEROISM );
            effect eVis2    = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
            float fDuration = TurnsToSeconds( nDuration );
            object oWielder = GetItemPossessor( oMyWeapon );

            if ( nEnh > 5 ){

                // cap Enhancement at +5
                nEnh = 5;
            }

            if( IPGetIsMeleeWeapon( oMyWeapon ) ){

                if ( nEnh ){

                    //add 1-5 Enhancement if caster level > 13
                    itemproperty iEnh  = ItemPropertyEnhancementBonus( nEnh );
                    IPSafeAddItemProperty( oMyWeapon, iEnh, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );
                }
            // always add Keen
            IPSafeAddItemProperty( oMyWeapon, ItemPropertyKeen(), fDuration );
            }

            //Ohn, we'd go ranged then
            else{

                if( nEnh > 0 ){

                    IPSafeAddItemProperty( oMyWeapon, ItemPropertyAttackBonus( nEnh ), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );
                    IPSafeAddItemProperty( oMyWeapon, ItemPropertyMaxRangeStrengthMod( nEnh ), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );

                }
                //Always give +1 atleast
                else{

                    IPSafeAddItemProperty( oMyWeapon, ItemPropertyAttackBonus( 1 ), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );
                    IPSafeAddItemProperty( oMyWeapon, ItemPropertyMaxRangeStrengthMod( 1 ), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, TRUE );

                }

            }


            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oWielder );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oWielder, TurnsToSeconds(nDuration));


        }

        return;
     }
     else {

          FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
          return;
    }
}
