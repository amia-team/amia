//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai2_perceive
//group:   ds_ai2
//used as: OnPerception
//date:    dec 23 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "ds_ai2_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void DoImpalement( object oCritter );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oCritter = OBJECT_SELF;
    object oTarget  = GetLastPerceived();
    int nCount      = GetLocalInt( OBJECT_SELF, L_INACTIVE );

    //if it's the first time we see an enemy, use Impalement
    if( GetLocalInt( oCritter, "Impaled" ) != 1 )
    {
        DelayCommand( 6.0, DoImpalement( oCritter ) );
        SetLocalInt( oCritter, "Impaled", 1 );
    }

    //continue with standard script
    if ( GetLastPerceptionSeen() || GetLastPerceptionHeard() ){

        if ( nCount != -1 ){

            DebugMessage( "ds_ai_perceive", 1 );

            if ( PerformAction( oCritter, "ds_ai2_perceive" ) > 0 ){

                SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );
            }
        }
    }
    else if ( GetLastPerceptionVanished()
           && GetLocalObject( oCritter, L_CURRENTTARGET ) == oTarget ){

        ClearAllActions( TRUE );

        if ( PerformAction( oCritter, "ds_ai2_perceive" ) > 0 ){

            SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );
        }
    }
}

void DoImpalement( object oCritter )
{
    int nCycle = 1;
    object oTarget;

    //find furthest enemy
    oTarget = GetNearestPerceivedEnemy( oCritter, nCycle, CREATURE_TYPE_IS_ALIVE, TRUE );
    while( GetIsObjectValid( oTarget ) )
    {
        nCycle = nCycle + 1;
        SetLocalObject( oCritter, "ImpaleTarget", oTarget );
        oTarget = GetNearestPerceivedEnemy( oCritter, nCycle, CREATURE_TYPE_IS_ALIVE, TRUE );
    }

    //Impale the target
    object oImpale = GetLocalObject( oCritter, "ImpaleTarget" );
    effect eJump = EffectDisappearAppear( GetLocation( oImpale ) );
    int nBAB = GetBaseAttackBonus( oCritter );
    int nSTRMod = GetAbilityModifier( ABILITY_STRENGTH, oCritter );
    int nAttack = nBAB + nSTRMod + 5 + d20(1);
    int nAC = GetAC( oImpale );

    ClearAllActions();
    SpeakString( "<cڥ#>*leaps into the air...*</c>" );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eJump, oCritter, 3.0 );
    DelayCommand( 3.0, JumpToLocation( GetLocation( oImpale ) ) );
    if( nAttack >= nAC )
    {
        effect eDamage = EffectDamage( d8(4), DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
        DelayCommand( 3.1, SpeakString( "<cڥ#>*...and lands on "+GetName( oImpale )+", impaling them!*</c>" ) );
        DelayCommand( 3.2, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oImpale ) );
    }
    else
    {
        DelayCommand( 3.1, SpeakString( "<cڥ#>*...and tries to land on "+GetName( oImpale )+", but misses</c>*" ) );
    }
    DelayCommand( 4.0, ActionAttack( oImpale ) );
}
