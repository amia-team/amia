/*
    Custom Ability (widget) - Consume Shadow

        - Uses the same cooldown as Shadow Daze.
        - On a successful Ranged Touch Attack, deals 50% of target's current
            health in Magic damage, or 25% on a successful Fortitude save.
        - Damage is capped at max 250.
        - Save DC is 10 + SD Levels + Dex Mod.
        - Heals caster for same amount as damage dealt.
        - Does not work on anything with the "is_boss" local variable.
*/

#include "amia_include"
#include "x2_inc_switches"

void ActivateItem()
{
    object oPC = GetItemActivator( );
    object oTarget = GetItemActivatedTarget( );
    int nTouch;
    int nDC = 10 + GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) + GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    int nFort;
    int nDamage;
    float fDamage;

    //check Shadow Daze block time
    if ( GetIsBlocked( oPC, "ds_SD_b" ) > 0 )
    {
        string sRecharge = IntToString( GetIsBlocked( oPC, "ds_SD_b" ) );
        SendMessageToPC( oPC, "You cannot use your Consume Shadow ability for another " +sRecharge+ " seconds!" );
        return;
    }

    //if target is a Boss, abort and do not consume ability cooldown
    if( GetLocalInt( oTarget, "is_boss" ) == TRUE )
    {
        SendMessageToPC( oPC, "This ability cannot be used on Bosses!" );
        return;
    }

    //if target has already been affected by Consume Shadow this reset, abort
    if( GetLocalInt( oTarget, "ConsumedShadow" ) == TRUE )
    {
        SendMessageToPC( oPC, "Target's shadow has already been consumed today." );
        return;
    }

    int nCD = 300;
    int nSD = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC ) - 5;

    nSD = nSD * 18;

    nCD = nCD - nSD;

    DelayCommand( IntToFloat( nCD ), FloatingTextStringOnCreature( "<c þ >You can now Consume Shadow again!</c>", oPC, FALSE ) );

    //find SD adjustment to block time
    int nMin;

    while( nCD >= 60 )
    {
        nMin++;
        nCD = nCD - 60;
    }

    //apply the cooldown time
    SetBlockTime( oPC, nMin, nCD, "ds_SD_b" );

    //attempt to consume target's shadow
    nTouch = TouchAttackRanged( oTarget );

    //Fire cast spell at event for the specified target
    SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, 475  ));

    if( nTouch != 0 )
    {
        //check save
        nFort = FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_SPELL, oPC );

        if( nFort == 0 )
        {
            fDamage = IntToFloat( GetCurrentHitPoints( oTarget ) );
            nDamage = FloatToInt( fDamage * 0.5 );

            if( GetIsPC( oTarget ) )
            {
                SendMessageToPC( oTarget, "*As you meet "+GetName( oPC )+"'s gaze, you feel otherworldly talons of ice sinking into your heart. With a rending twist and a horrid poping sensation, a portion of essence is torn away, leaving behind a void of ice and despair, your strength having fled. You cast neither shadow nor reflection until the next sunrise.*" );
            }

            SetLocalInt( oTarget, "ConsumedShadow", 1 );
        }
        else if( nFort == 1 )
        {
            fDamage = IntToFloat( GetCurrentHitPoints( oTarget ) );
            nDamage = FloatToInt( fDamage * 0.25 );

            if( GetIsPC( oTarget ) )
            {
                SendMessageToPC( oTarget, "*As you meet "+GetName( oPC )+"'s gaze, you get the impression of icy talons peircing your heart. With an uncomfortable twist and a popping sensation, you feel a portion of your essence carried away. Weakness and hopelessness set into your flesh, but you shake off the despair and soldier on. You cast neither shadow nor reflection until the next sunrise.*" );
            }

            SetLocalInt( oTarget, "ConsumedShadow", 1 );
        }
        else if( nFort == 2 )
        {
            SendMessageToPC( oPC, "That target is immune to the Consume Shadows effect." );
            return;
        }

        //cap damage at 250
        if( nDamage >= 251 )
        {
            nDamage = 250;
        }

        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY );
        effect eDamVis = EffectVisualEffect( 217 );
        effect eDamLink = EffectLinkEffects( eDamVis, eDamage );
        effect eHeal = EffectHeal( nDamage );
        effect eHealVis = EffectVisualEffect( 203 );
        effect eHealLink = EffectLinkEffects( eHealVis, eHeal );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamLink, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eHealLink, oPC );
    }
    else
    {
        if( GetIsPC( oTarget ) )
        {
            SendMessageToPC( oTarget, "*As you meet "+GetName( oPC )+"'s gaze, a cold prickle washes over your skin. You feel an otherworldly presence grasping for something deep inside. Whatever the psychic attack was, however, you manage to wriggle away from its hold.*" );
        }
    }
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );
    object oPC = GetItemActivator();

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            AssignCommand( oPC, ActivateItem( ) );
            break;
    }
}
