//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_lockpick
//group:   faction doors
//used as: OnUnlock
//date:    aug 24 2007
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    int nBaseRanks  = GetSkillRank( SKILL_OPEN_LOCK, oPC, TRUE );
    int nBuffRanks  = GetSkillRank( SKILL_OPEN_LOCK, oPC, FALSE ) - nBaseRanks;
    int nAbilityMod = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    int nLockDC     = GetLockUnlockDC( OBJECT_SELF );

    if ( nBuffRanks > nBaseRanks ){

        nBuffRanks = nBaseRanks;
    }
    int nDie        = d100();
    int nMod        = ( 2 * nBaseRanks ) + nAbilityMod + ( 2 * nBuffRanks );
    int nResult     = nDie + nMod;

    DelayCommand( 8.0, SendMessageToPC( oPC, IntToString( nDie ) + " + " + IntToString( nMod ) + " = " + IntToString( nResult ) + " vs " + "DC " + IntToString( nLockDC ) ) );

    if ( nResult >= nLockDC ){

        AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 10.0 ) );
        DelayCommand( 10.0, SendMessageToPC( oPC, "You opened this lock!" ) );
        DelayCommand( 10.0, ActionOpenDoor( OBJECT_SELF ) );
    }
}
