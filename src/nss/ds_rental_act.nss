//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_act
//group: housing
//used as: convo action script
//date: 2008-12-02
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oDoor     = GetLocalObject( oPC, "ds_target" );
    object oSign;
    object oKey;
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nPrice;
    string sName;
    string sTag;

    if ( GetLocalInt( oPC, "rental" ) == 1 ){

        SendMessageToPC( oPC, "You can only rent one house a reset." );
        return;
    }

    if ( GetLocalInt( OBJECT_SELF, "taken" ) != 1 ){

        if ( nNode == 1 || nNode == 4 ){

            nPrice = 500;
            sName  = "shack";
        }
        else if ( nNode == 2 || nNode == 5 ){

            nPrice = 2000;
            sName  = "home";
        }
        else if ( nNode == 3 || nNode == 6 ){

            nPrice = 5000;
            sName  = "residence";
        }
        else{

            return;
        }
    }
    else{

        return;
    }

    if ( nPrice ){

        if ( GetGold( oPC ) >= nPrice ){

            TakeGoldFromCreature( nPrice, oPC, TRUE );

            SetLocalInt( oDoor, "taken", 1 );

            SetLocalInt( oPC, "rental", 1 );

            oSign = GetNearestObjectByTag( "ds_rental_sign" );

            if ( nNode > 3 ){

                SetName( oSign, RandomName()+"'s "+sName );
            }
            else{

                SetName( oSign, GetName( oPC )+"'s "+sName );
            }

            //use timestamp for this!

            sTag = GetPCPublicCDKey( oPC, TRUE )+"_"+IntToString( d100() )+"_"+IntToString( d100() );

            SetLockKeyTag( oDoor, sTag );

            oKey = CreateItemOnObject( "ds_rental", oPC, 1, sTag );

            SetName( oKey, GetName( GetArea( oPC ) )+" Home Key" );
        }
    }
}

