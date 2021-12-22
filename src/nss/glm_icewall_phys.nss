/*
    OnPhysicalAttacked script for Wall of Ice custom spell PLCs.
*/

void main()
{
    object oWall = OBJECT_SELF;
    object oPC = GetLastAttacker( oWall );
    string sName = GetName( oPC );

    //check to see if it's the first attack; if not, end the script
    if( GetLocalObject( oWall, sName ) == oPC )
    {
        return;
    }

    int nSTR = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int nCL = GetLocalInt( oWall, "CasterLevel" );

    int nPCRoll = ( d20(1) + nSTR );
    int nDC = ( 15 + nCL );

    //Strength check vs. DC in order to simply shatter the wall on the first attack only
    if( nPCRoll >= nDC )
    {
        int nHP = GetCurrentHitPoints( oWall );
        effect eDamage = EffectDamage( ( nHP + 10 ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oWall );
        AssignCommand( oPC, ActionSpeakString( "**shatters the wall with their first blow!**" ) );
    }
    SetLocalObject( oWall, sName, oPC );
}
