#include "inc_nwnx_events"
#include "amia_include"
#include "nwnx_effects"
#include "inc_lua"

const float  HIPS_COOLDOWN  = 6.0;

//Temporarily removes the HIPS feat from the specified hide
void ClearHIPSFeat( object oPC, float fCoolDown );
void GiveHIPSFeat( object oPC );
void ClearHIPSShifter( object oPC, float fCoolDown );

void main(){

    object oPC = OBJECT_SELF;
    int nEvent = EVENTS_GetData( 0 );

    if ( nEvent == ACTION_MODE_STEALTH ){
        // bStealth = 0 if leaving stealth, or 1 if entering stealth
        int bStealth = EVENTS_GetData( 1 );//!GetActionMode( oPC, ACTION_MODE_STEALTH );
        // bClearing = 1 if HIPS is being temporarily removed, or 0 otherwise
        int bClearing = GetLocalInt( oPC, HIPS_FLAG );

        // Attempt to find the currently-equipped creature hide
        object oHide = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC );
        int bShifter = FALSE;

        if( GetResRef( oHide ) == "shf_hd_kobold" || GetResRef( oHide ) == "shf_hd_epickobo" || GetResRef( oHide ) == "shf_hd_spectre" || GetResRef( oHide ) == "custom_druid_dc" ) {
            bShifter = TRUE;
        }

        //If leaving stealth
        if ( !bStealth ){

            RemoveEffectsBySpell( oPC, 12347 );

            //SD level 6 or above
            //or Kobold Commando Hide


                if( GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) >= 6 ) {
                    if ( !bClearing ){

                        //Temporarily clear the HIPS feat from the player's creature hide
                        ClearHIPSFeat( oPC, HIPS_COOLDOWN );
                        //Prevent multiple instances of ClearHIPSFeat on the same PC
                        SetLocalInt( oPC, HIPS_FLAG, 1 );
                        DelayCommand( HIPS_COOLDOWN, DeleteLocalInt( oPC, HIPS_FLAG ) );
                        DelayCommand( HIPS_COOLDOWN, FloatingTextStringOnCreature( "<c þ >You can now Hide in Plain Sight again!</c>", oPC, FALSE ) );

                    }
                }
                if ( bShifter ){

                    if ( !bClearing ){

                        //Temporarily clear the HIPS feat from the player's creature hide
                        ClearHIPSShifter( oPC, HIPS_COOLDOWN );
                        //Prevent multiple instances of ClearHIPSFeat on the same PC
                        SetLocalInt( oPC, HIPS_FLAG, 1 );
                        DelayCommand( HIPS_COOLDOWN, DeleteLocalInt( oPC, HIPS_FLAG ) );
                        DelayCommand( HIPS_COOLDOWN, FloatingTextStringOnCreature( "<c þ >You can now Hide in Plain Sight again!</c>", oPC, FALSE ) );

                    }
                }

        }

        //If entering stealth do nothing
        if ( bStealth ){

            /*effect eVis = EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_BLACK );
                   eVis = SetEffectSpellID( eVis, 12347 );
                   eVis = SupernaturalEffect( eVis );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oPC );*/
        }


    }
    else if( nEvent == ACTION_MODE_COUNTERSPELL ){

        RemoveEffectsBySpell( oPC, SPELL_ETHEREALNESS );
    }

}

void ClearHIPSFeat( object oPC, float fCoolDown ){
    if(GetHasFeat( FEAT_HIDE_IN_PLAIN_SIGHT, oPC )){
        RunLua("nwn.RemoveFeat('"+ObjectToString(oPC)+"', 433)");
        DelayCommand( fCoolDown, GiveHIPSFeat( oPC ) );
    }
}

void ClearHIPSShifter( object oHide, float fCoolDown ){

    itemproperty ipHIPS = ItemPropertyBonusFeat( IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT );

    IPRemoveMatchingItemProperties( oHide, ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_PERMANENT, 31 );
    DelayCommand( fCoolDown, IPSafeAddItemProperty( oHide, ipHIPS, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, DURATION_TYPE_PERMANENT ) );
}

void GiveHIPSFeat( object oPC ) {
    RunLua("nwn.AddFeat('"+ObjectToString(oPC)+"', 433)");
}

