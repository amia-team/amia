// Blunt Strike
// 7 Rogue levels - 3 uses per day
//
// Touch Attack. On hit, Reflex save vs user's dex mod +10 for a stun effect on target.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/9/18     Angelis96       Made
//
//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void RemoveInvisEffects( object oPC );
void ActivateItem();
void DoBluntStrike( object oTarget );
int GetHasFeatEffect (int nFeat, object oObject = OBJECT_SELF);
int GetAbilityModifier(int nAbility, object oObject = OBJECT_SELF);

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem();
            break;
    }
}

void DoBluntStrike( object oTarget ){

    object oPC = GetItemActivator();
    int nTouch = TouchAttackMelee( oTarget );

    if( nTouch > 0 ){
        int nLevel = GetLevelByClass( CLASS_TYPE_ROGUE, oPC );
        int nDC = GetAbilityModifier(ABILITY_DEXTERITY, oPC)  + 10;
        int nRSave = ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC );
        effect eStun = EffectStunned();
        effect eVis = EffectVisualEffect(VFX_IMP_STUN);

        if( nRSave == 0 && GetHasFeatEffect(425, oPC)){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds( (nLevel / 7) + 2 ) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_IMP_DAZED_S ), oTarget, RoundsToSeconds( (nLevel / 7) + 2 ));
            }
        else if( nRSave == 0 ){
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds( (nLevel / 7)) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_IMP_DAZED_S ), oTarget, RoundsToSeconds( (nLevel / 7)));
            }
    }
}


void ActivateItem( )
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || !GetIsEnemy( oTarget, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You must target an enemy creature! -</c>", oPC, TRUE );
        return;
    }
    else
    {
        AssignCommand( oPC, DoBluntStrike( oTarget ) );
    }
}
