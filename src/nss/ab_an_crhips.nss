// script: abl_an_chhips
// By: Anatida
// 06/04/2014
// Call ability stealth for creatures with HiPS from the local variables

void main()
{
    object oCritter = OBJECT_SELF;
    object oTarget = GetLastAttacker(OBJECT_SELF);
    ClearAllActions();
    ActionMoveAwayFromObject( oTarget, TRUE, 3.0 );
    DelayCommand( 1.0, SetActionMode( oCritter, ACTION_MODE_STEALTH, TRUE ) );
    DelayCommand( 2.0, ExecuteScript( "ds_ai2_endround", oCritter ) );
}
