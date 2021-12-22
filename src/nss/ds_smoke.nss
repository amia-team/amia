//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_smoke
//group: consumales
//used as: OnUse, makes tobacco etc.
//date: 2011-01-29
//author: Nekhy, using Disco's original


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

    object oDraft = CreateItemOnObject( "ds_smoke", oPC );

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
