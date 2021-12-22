//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: khm_ds_onspawn
//group: NPC
//used as: onspawn
//date: 2008-09-13
//author: disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    object oNPC     = OBJECT_SELF;
    string sName    = "";
    string sGender  = "male";
    int nName       = Random( 94 ) + 1;

    if ( GetGender( oNPC ) == GENDER_FEMALE ){

        sGender = "female";
    }

    sName = Get2DAString( "ds_khm", sGender, nName );

    DelayCommand( 1.0, SetName( oNPC, sName ) );

}
