//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens doors not locked by magical means.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001
#include "nw_i0_spells"

#include "x2_inc_spellhook"


void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    // vars

    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);


    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_KNOCK ) );

    if ( GetIsObjectValid( GetSpellCastItem() ) ) {

        nTransmutation = 1;
    }

    //make picks instead of knock effect

    if ( nTransmutation == 2 ){

        int nLevel      = GetCasterLevel( OBJECT_SELF );
        string sResRef  = "nw_it_picks004";

        if ( nLevel < 5 ){

            sResRef  = "nw_it_picks001";
        }
        else if ( nLevel < 10 ){

            sResRef  = "nw_it_picks002";
        }
        else if ( nLevel < 15 ){

            sResRef  = "nw_it_picks003";
        }

        object oPick = CreateItemOnObject( sResRef );

        //we don't wanna sell it
        SetStolenFlag( oPick, TRUE );

        return;
    }


    location lLoc=GetLocation(OBJECT_SELF);
    float fDelay;
    int nLocksOpened=0;

    // Open Lock DC = 10 + (casterlevel/2) + key ability modifier
    int nKeyAbilityModifier=0;
    // sorcerers
    if(GetLastSpellCastClass()==CLASS_TYPE_SORCERER){

        nKeyAbilityModifier=GetAbilityModifier(
            ABILITY_CHARISMA,
            OBJECT_SELF);

    }
    // wizards
    else{

        nKeyAbilityModifier=GetAbilityModifier(
            ABILITY_INTELLIGENCE,
            OBJECT_SELF);

    }

    int nOpenLock=
        10                              +
        (GetCasterLevel(OBJECT_SELF)/2) +
        nKeyAbilityModifier;

    // Improvement
    if( nOpenLock < 11 )
        nOpenLock = 21;

    // spell focus feat DC bonus
    // Epic Spell Focus: Transmutation is a +6 DC bonus
    if(GetHasFeat(
        FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION,
        OBJECT_SELF)==TRUE){

        nOpenLock+=6;

    }
    // Greater Spell Focus: Transmutation is a +4 DC bonus
    else if(GetHasFeat(
        FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION,
        OBJECT_SELF)==TRUE){

        nOpenLock+=4;

    }
    // Spell Focus: Transmutation is a +2 DC bonus
    else if(GetHasFeat(
        FEAT_SPELL_FOCUS_TRANSMUTATION,
        OBJECT_SELF)==TRUE){

        nOpenLock+=2;

    }

    // Open Lock capped @ 98
    if(nOpenLock>98){
        nOpenLock=98;
    }

    // cycle for all potential locks in a 50ft radius about the spellcaster
    oTarget=GetFirstObjectInShape(
        SHAPE_SPHERE,
        50.0,
        lLoc,
        FALSE,
        OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);

    while(GetIsObjectValid(oTarget)){

        // on hit spellcast: Knock
        SignalEvent(
            oTarget,
            EventSpellCastAt(
                OBJECT_SELF,
                GetSpellId()));

        // vfx delay
        fDelay=GetRandomDelay(
            0.5,
            2.5);

        // locked an spellcaster's open lock dc equals or exceeds, bust it open!
        if(
            (GetLocked(oTarget)==TRUE)              &&
            (nOpenLock>=GetLockUnlockDC(oTarget))   &&
            (GetLockUnlockDC(oTarget)!=0)           ){

            // knocking vfx
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

            // bust itself
            AssignCommand(oTarget, ActionUnlockObject(oTarget));

            // this spell may only break 2 locks as per pnp 3.5E
            if(++nLocksOpened>1){

                break;

            }

        }
        else if(
            (GetLocked(oTarget)==TRUE)              &&
            (nOpenLock<GetLockUnlockDC(oTarget))    ){

            // warn the spellcaster she failed to open this particular lock
            FloatingTextStringOnCreature(
                "<cÌwþ>- Knock: Open Lock failed: DC "          +
                IntToString(GetLockUnlockDC(oTarget))           +
                " vs. spell "                                   +
                IntToString(nOpenLock)                          +
                " -</c>",
                OBJECT_SELF,
                FALSE);

            // even a failed open lock counts against her 2 locks per spell as per pnp 3.5E
            if(++nLocksOpened>1){

                break;

            }

        }

        // seek out the next potential lock
        oTarget=GetNextObjectInShape(
            SHAPE_SPHERE,
            50.0,
            lLoc,
            FALSE,
            OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE);

    }
}
