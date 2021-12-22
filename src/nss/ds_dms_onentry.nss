//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_dms_onentry
//group:   DMS
//used as: area on enter script
//date:    20080930
//author:  disco



//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oEntering = GetEnteringObject();

    if ( GetObjectType( oEntering ) == OBJECT_TYPE_CREATURE && !GetIsPC( oEntering ) ){

        ChangeToStandardFaction( oEntering, STANDARD_FACTION_COMMONER );
    }
}

