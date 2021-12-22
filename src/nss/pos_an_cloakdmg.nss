//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  pos_an_cloakdmg
//group:   Shadowscape Wastes
//used as: OnDamage
//date:    June 30 2014
//author:  Anatida - updated from disco's ai2

// When a cloaker has a victim engulfed half of its damage it taken by the cloaker
// and half by the engulfed victim
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main()
{

    object oCritter     = OBJECT_SELF;
    object oDamager     = GetLastDamager();
    object oTarget      = GetLocalObject( oCritter, L_CURRENTTARGET );
    object oEngulfed    = GetLocalObject( oCritter, "Engulfed" );
    string sArchetype   = GetLocalString( oCritter, L_ARCHETYPE );
    int nReaction       = GetReaction( oCritter, oDamager );
    int nEngulf         = GetLocalInt(oCritter, "Engulf");
    int nDamage;


    if (GetLocalObject(oCritter, "Engulfed") != OBJECT_INVALID)
    {
        nDamage = GetTotalDamageDealt();
        int nHalfDamage = (nDamage/2);
        effect eSharedDamage = EffectDamage(nHalfDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSharedDamage, oEngulfed);
        effect eHealSelf =  EffectHeal(nHalfDamage);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealSelf, oCritter);

        if ( nReaction == 2 )
        {

            if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 )
            {

                ClearAllActions();
                ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
                SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
            }
        }
        else if ( nReaction == 1 )
        {

            if ( oTarget != oDamager )
            {

                if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 )
                {

                    SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
                }
            }
        }
    }
    else
    {
        if ( nReaction == 2 )
            {

                if ( GetDistanceBetween( oCritter, oDamager ) < 5.0 )
                {

                    ClearAllActions();
                    ActionMoveAwayFromObject( oDamager, TRUE, 10.0 );
                    SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
                }
            }
            else if ( nReaction == 1 )
            {

                if ( oTarget != oDamager )
                {

                    if ( GetObjectSeen( oDamager, oCritter ) && ( d100() - 20 ) < 25 )
                    {

                        SetLocalObject( oCritter, L_CURRENTTARGET, oDamager );
                    }
                }
            }
    }
}
