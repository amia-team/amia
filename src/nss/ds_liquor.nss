//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_liquor
//group: food etc
//used as: OnUse, makes liquor
//date: 2011-21-01
//author: Disco, Nekhy's modifications
//base script ds_draft


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

    object oDraft = CreateItemOnObject( "ds_liquor", oPC );

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
