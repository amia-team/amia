//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_tr_goodevil
//group:   actant
//used as: OnTransitionClick
//date:    sep 28 2007
//author:  disco


void main(){

    object oPC      = GetClickingObject();
    int nGoodEvil   = GetAlignmentGoodEvil( oPC );
    string sTarget  = GetLocalString( OBJECT_SELF, "target" );

    if ( nGoodEvil == ALIGNMENT_EVIL ){

        sTarget = sTarget + "_evil";
    }

    if ( nGoodEvil == ALIGNMENT_GOOD ){

        sTarget = sTarget + "_good";
    }

    object oTarget  = GetWaypointByTag( sTarget );

    DelayCommand( 0.5, AssignCommand( oPC, JumpToObject( oTarget ) ) );
}
