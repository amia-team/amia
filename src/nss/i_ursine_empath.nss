// Item event script for Ursine Empathy. Dominates hostile/neutral ursines
// within a howl's radius.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/04/2021 Jes              Initial release.
//

#include "x2_inc_switches"
#include "amia_include"

void KillInvis( object oPC ){

    effect eEff = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEff ) ){
        nType=GetEffectType( eEff );

        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY )
            RemoveEffect( oPC, eEff );

        eEff = GetNextEffect( oPC );
    }
}

void ActivateItem( )
{
    // Main variables.
    object oPC      = GetItemActivator();
    int nDuration   = GetHitDice( oPC );
    int nCount;

    // Effects to be added to ursines.
    effect eDom     = EffectCutsceneDominated();
    effect eStr     = EffectAbilityIncrease( ABILITY_STRENGTH, 4 );
    effect eCon     = EffectAbilityIncrease( ABILITY_CONSTITUTION, 4 );
    effect eWis     = EffectAbilityIncrease( ABILITY_WISDOM, d10() );
    effect eAttack  = EffectAttackIncrease( 5 );
    effect eDamage  = EffectDamageIncrease( 5 );

    // Wrap it all together.
    effect eLink    = EffectLinkEffects( eStr, eCon );
           eLink    = EffectLinkEffects( eLink, eAttack );
           eLink    = EffectLinkEffects( eLink, eWis );
           eLink    = EffectLinkEffects( eLink, eDamage );
           eLink    = SupernaturalEffect( eLink );

    // Apply a howl to the PC first!
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_HOWL_MIND ), oPC );

    // Wrap through targets in a colossal radius.
    object oVictim = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE, OBJECT_TYPE_CREATURE );
    while( oVictim != OBJECT_INVALID && nCount < 3 ) // Cap targets to 3
    {
        if( oVictim != oPC && !GetIsPC(oVictim)) // Can't target yourself or another player!
        {
            // Check for ursines only.
            if( GetAppearanceType( oVictim ) >= 12 && GetAppearanceType( oVictim ) <= 15 ||
                GetAppearanceType( oVictim ) == 204 ||
                GetAppearanceType( oVictim ) >= 1501 && GetAppearanceType( oVictim ) <= 1502 ||
                GetAppearanceType( oVictim ) == 1576 ||
                GetAppearanceType( oVictim ) == 1928 ||
                GetCreatureTailType( oVictim ) == 350 ||
                GetCreatureTailType( oVictim ) >= 352 && GetCreatureTailType( oVictim ) <= 356 ||
                GetCreatureTailType( oVictim ) >= 1330 && GetCreatureTailType( oVictim ) <= 1331 ||
                GetCreatureTailType( oVictim ) == 1367 ||
                GetCreatureTailType( oVictim ) == 1443 ||
                GetCreatureTailType( oVictim ) == 1458 ||
                GetCreatureTailType( oVictim ) == 1459 )
            {
                // Only works on non-evil ursines.
                if( GetAlignmentGoodEvil( oVictim ) != ALIGNMENT_EVIL )
                {
                    // If they're not friendly, dominate them and add them to the PC's party.
                    if( !GetIsFriend( oVictim, oPC ) && GetAssociateType( oVictim ) == ASSOCIATE_TYPE_NONE )
                    {
                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( eDom ), oVictim, NewHoursToSeconds( nDuration ) );
                    }

                    // Remove any invisibility effects.
                    KillInvis( oPC );

                    // Apply buffs.
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oVictim, NewHoursToSeconds( nDuration ) );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 685 ), oVictim );
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HOLY_AID ), oVictim );

                    // Increment the count.
                    nCount++;
                }
           }
        }
        oVictim = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), FALSE,  OBJECT_TYPE_CREATURE );
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    object oPC = GetItemActivator();

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
        AssignCommand( oPC, ActivateItem() ); // Assign to PC so it dominates targets properly
        break;
    }
}
