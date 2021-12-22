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
    int nPrice     = GetLocalInt( oPLC, "price" );
    string sName   = GetLocalString( oPLC, "name" );
    string sBio    = GetLocalString( oPLC, "description" );
    string sResRef = GetLocalString( oPLC, "resref" );

    if ( GetGold( oPC ) >= nPrice ){

        TakeGoldFromCreature( nPrice, oPC, TRUE );
    }
    else{

        return;
    }

    if ( sResRef == "" ){

        return;
    }

    object oFood = CreateItemOnObject( sResRef, oPC );

    if ( sName != "" ){

        SetName( oFood, sName );
    }

    if ( sBio != "" ){

        SetDescription( oFood, sBio );
    }

    //these variables are used while drinking in i_ds_draft
    SetLocalInt( oFood, "quality", GetLocalInt( oPLC, "quality" ) );
    SetLocalInt( oFood, "amount", GetLocalInt( oPLC, "amount" ) );

    //PlaySound( "as_cv_smithwatr1" );
}
