//::///////////////////////////////////////////////
//:: Etherealness
//:: x0_s0_ether.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Like sanctuary except almost always guaranteed
    to work.
    Lasts one turn per level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: Updated By: kfw.
//:: Updated On: July 6, 2K6.
//:: Reason: Unsummon Black Blade of Disaster.
//:://////////////////////////////////////////////

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
// 20080216     Disco       Added GS nerf when a level 22+ summon/domination is detected
// 20080728     Terra       Added transmutaion option
// 20100822     Terra       Turned it to temphp+eternalness+100%spellfail CL/6 rounds

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_spellhook"
#include "nwnx_effects"

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

//Returns if the PC summoned or dominated a monster above 22 levels
int HiredTooMuchMuscle( object oPC );

//Removes summons and releases dominated if they're above 22
void UnsummonTooStrongHiredMuscle( object oPC );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    if (!X2PreSpellCastCode()){

        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // Variables.
    object oCaster      = OBJECT_SELF;
    object oTarget      = GetSpellTargetObject( );
    int nCL             = GetCasterLevel( OBJECT_SELF );
    int nDuration       = 10+(nCL/6);

    int nMetaMagic = GetMetaMagicFeat();

    if (nMetaMagic == METAMAGIC_EXTEND){

        nDuration = nDuration *2; //Duration is +100%
    }
    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_ETHEREALNESS ) );

    if(nTransmutation != 2)
    {
        //-------------------------------------------------------------------------------
        // summon/domination nerf
        //-------------------------------------------------------------------------------
        if ( HiredTooMuchMuscle( oTarget ) ){

            effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
            effect eDur   = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

            effect eLink  = EffectLinkEffects(eInvis, eDur);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));

            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));

            SendMessageToPC( oCaster, "Having level 23+ summons or dominates changes GS into Invisibility." );

            return;
            }
    }

    //-------------------------------------------------------------------------------
    //Black blade nerf
    //-------------------------------------------------------------------------------
    object oBBoD        = GetNearestObjectByTag( "the_black_blade", oCaster );

    if( GetMaster( oBBoD ) == oCaster ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_DISPEL ), oBBoD );
        DestroyObject( oBBoD, 1.0 );
    }

    //-------------------------------------------------------------------------------
    //Trans override invis and unsummon
    //-------------------------------------------------------------------------------
    UnsummonTooStrongHiredMuscle( oCaster );

    //-------------------------------------------------------------------------------
    //rest of the GS script
    //-------------------------------------------------------------------------------

    //Declare major variables
    effect eVis     = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSanc    = EffectEthereal();
    effect eHP      = EffectTemporaryHitpoints( nCL*5 );
    effect eFail    = EffectSpellFailure( );

    effect eLink = EffectLinkEffects( eVis, eSanc );
    eLink = EffectLinkEffects(eLink, eDur );
    //eLink = EffectLinkEffects(eLink, eHP );
    eLink = EffectLinkEffects(eLink, eFail );
    eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease( 90 ) );

    eLink  = SetEffectScript( eLink, "gsanc_end" );

    RemoveEffectsBySpell( oTarget, SPELL_ETHEREALNESS );

    //Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREALNESS, FALSE ) );

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_3 ), GetLocation( OBJECT_SELF ) );

    //Apply the VFX impact and effects
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHP, oTarget, RoundsToSeconds( nDuration ) );
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int HiredTooMuchMuscle( object oPC ){

    object oSummon    = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );
    object oDominated = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oPC );

    if ( GetHitDice( oSummon ) > 22 || GetHitDice( oDominated ) > 22 ){

        return TRUE;
    }

    return FALSE;
}

void UnsummonTooStrongHiredMuscle( object oPC )
{
    object oSummon    = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );
    object oDominated = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oPC );

    if( GetHitDice( oSummon ) > 22 )
    {
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_UNSUMMON ), GetLocation( oSummon ) );
    DestroyObject( oSummon, 0.5 );
    }

    if( GetHitDice( oDominated ) > 22 )
    {
    effect  eEffect = GetFirstEffect( oDominated );
    int     iType = GetEffectType( eEffect );
        while( GetIsEffectValid( eEffect ) )
        {
            if( iType == EFFECT_TYPE_DOMINATED )
            {
            RemoveEffect( oDominated, eEffect );
            break;
            }
        eEffect = GetNextEffect( oDominated );
        iType   = GetEffectType( eEffect );
        }

    }

}

