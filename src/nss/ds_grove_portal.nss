//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_grove_portal
//group:   grove/bark scripts
//used as: OnUse script on portal PLC
//date:    aug 11 2007
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC        = GetLastUsedBy();
    location lTarget  = GetLocalLocation( OBJECT_SELF, "ds_destination" );

    AssignCommand( oPC, JumpToLocation( lTarget ) );
}
