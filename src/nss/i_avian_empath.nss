// Item event script for Avian Empathy. Dominates hostile/neutral avians
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

    // Effects to be added to avians.
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
        if( oVictim != oPC && !GetIsPC(oVictim) ) // Can't target yourself or another player!
        {
            // Check for avians only.
            if( GetAppearanceType( oVictim ) == 7 ||
                GetAppearanceType( oVictim ) == 31 ||
                GetAppearanceType( oVictim ) >= 144 && GetAppearanceType( oVictim ) <= 145 ||
                GetAppearanceType( oVictim ) == 206 ||
                GetAppearanceType( oVictim ) >= 291 && GetAppearanceType( oVictim ) <= 292 ||
                GetAppearanceType( oVictim ) == 368 ||
                GetAppearanceType( oVictim ) >= 1083 && GetAppearanceType( oVictim ) <= 1085 ||
                GetAppearanceType( oVictim ) == 1179 ||
                GetAppearanceType( oVictim ) == 1558 ||
                GetAppearanceType( oVictim ) == 1561 ||
                GetAppearanceType( oVictim ) >= 1563 && GetAppearanceType( oVictim ) <= 1564 ||
                GetAppearanceType( oVictim ) == 1566 ||
                GetAppearanceType( oVictim ) >= 1568 && GetAppearanceType( oVictim ) <= 1570 ||
                GetAppearanceType( oVictim ) >= 1578 && GetAppearanceType( oVictim ) <= 1581 ||
                GetAppearanceType( oVictim ) == 1843 ||
                GetAppearanceType( oVictim ) >= 1873 && GetAppearanceType( oVictim ) <= 1904 ||
                GetCreatureTailType( oVictim ) == 357 ||
                GetCreatureTailType( oVictim ) >= 376 && GetCreatureTailType( oVictim ) <= 378 ||
                GetCreatureTailType( oVictim ) >= 380 && GetCreatureTailType( oVictim ) <= 382 ||
                GetCreatureTailType( oVictim ) == 416 ||
                GetCreatureTailType( oVictim ) >= 743 && GetCreatureTailType( oVictim ) <= 745 ||
                GetCreatureTailType( oVictim ) == 829 ||
                GetCreatureTailType( oVictim ) == 1347 ||
                GetCreatureTailType( oVictim ) == 1350 ||
                GetCreatureTailType( oVictim ) >= 1352 && GetCreatureTailType( oVictim ) <= 1353 ||
                GetCreatureTailType( oVictim ) == 1355 ||
                GetCreatureTailType( oVictim ) >= 1357 && GetCreatureTailType( oVictim ) <= 1359 ||
                GetCreatureTailType( oVictim ) >= 1369 && GetCreatureTailType( oVictim ) <= 1372 ||
                GetCreatureTailType( oVictim ) == 1452 ||
                GetCreatureTailType( oVictim ) == 1356 ||
                GetCreatureTailType( oVictim ) == 1357 ||
                GetCreatureTailType( oVictim ) == 1632 )
            {
                // Only works on non-evil avians.
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
