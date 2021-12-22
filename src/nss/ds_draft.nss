//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_draft
//group: food etc
//used as: OnUse, makes beer
//date: 2008-12-07
//author: disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPLC   = OBJECT_SELF;
    object oPC    = GetLastUsedBy();
    int nPrice    = GetLocalInt( oPLC, "price" );
    string sName  = GetLocalString( oPLC, "name" );
    string sBio   = GetLocalString( oPLC, "description" );

    if ( GetGold( oPC ) >= nPrice ){

        TakeGoldFromCreature( nPrice, oPC, TRUE );
    }
    else{

        return;
    }

    object oDraft = CreateItemOnObject( "ds_draft", oPC );

    if ( sName != "" ){

        SetName( oDraft, sName );
    }

    if ( sBio != "" ){

        SetDescription( oDraft, sBio );
    }

    //these variables are used while drinking in i_ds_draft
    SetLocalInt( oDraft, "quality", GetLocalInt( oPLC, "quality" ) );
    SetLocalInt( oDraft, "strength", GetLocalInt( oPLC, "strength" ) );

    PlaySound( "as_cv_smithwatr1" );
}
