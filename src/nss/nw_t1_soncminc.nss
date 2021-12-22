//::///////////////////////////////////////////////
//:: Minor Sonic Trap
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the creature is stunned
//:: for 2 rounds.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16, 2001
//:://////////////////////////////////////////////

// 2008-04-11    Disco    Added PvP system

#include "NW_I0_SPELLS"
#include "inc_ds_traps"

void main()
{
    //Declare major variables
    object oTriggerer   = GetEnteringObject();

    //----------------------------------------------------------------
    //trap pvp system
    //----------------------------------------------------------------
    int nTrapStatus  = GetTrapStatus( oTriggerer, OBJECT_SELF );

    if ( nTrapStatus < 0 ){

        return;
    }

    object oOwner    = GetLocalObject( OBJECT_SELF, TRAP_CREATOR );
    //----------------------------------------------------------------

    int nDuration       = 2;
    int nDC             = 12;
    int nDamage         = 2; //2d4 damage

    int nSaved;
    int nUpgrade        = GetLocalInt( OBJECT_SELF, TRAP_UPGRADE );
    effect eFNF1        = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eFNF2        = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eMind        = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eStun        = EffectStunned();
    effect eLink        = EffectLinkEffects(eStun, eMind);
    effect eDam;
    object oTarget;

    //Apply the FNF to the spell location
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF1, GetLocation(oTriggerer));
    //Get the first target in the spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetLocation(oTriggerer));
    while (GetIsObjectValid(oTarget))
    {
        eDam             = EffectDamage( d4(nDamage), DAMAGE_TYPE_SONIC );

        DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

        //----------------------------------------------------------------
        //trap pvp system
        //----------------------------------------------------------------
        //transfer PvP settings
        TransferPvpMode( oTarget, oOwner, nTrapStatus, nDamage, "sonic" );
        //----------------------------------------------------------------

        nSaved = 1;

        if (nUpgrade){

            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_TRAP)){
                nSaved = 0;
            }

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF2, GetLocation(oTriggerer));

        }
        //Make a Will roll to avoid being stunned
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_TRAP))
        {
            nSaved = 0;
        }

        if (!nSaved){

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetLocation(oTriggerer));
    }
}

