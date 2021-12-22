 /*  ds_lightrod

--------
Verbatim
--------
manages the light rod placeable widget

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
122506  Disco       Start of header

------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "aps_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void SpawnItem( object oPC, string sResRef, string sTagPrefix, location lTarget );
void DestroyItem(object oPC, string sTagPrefix );
string StripName( string sString );


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = OBJECT_SELF;
    location lTarget    = GetLocalLocation( oPC, "ds_target");
    int nNode           = GetLocalInt( oPC, "ds_node" );
    int nCount          = GetLocalInt( oPC, "ds_count" ) + 1;

    SetLocalInt( oPC, "ds_count", nCount );

    if  ( nCount == 6 ){

        SetLocalInt( oPC, "ds_count", 0 );
    }

    if ( nNode == 1 ){

        SpawnItem(oPC, "plc_solblue", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 2 ){

        SpawnItem(oPC, "plc_solcyan", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 3 ){

        SpawnItem(oPC, "plc_solgreen", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 4 ){

        SpawnItem(oPC, "plc_solorange", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 5 ){

        SpawnItem(oPC, "plc_solred", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 6 ){

        SpawnItem(oPC, "plc_solwhite", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 7 ){

        SpawnItem(oPC, "plc_solyellow", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 8 ){

        SpawnItem(oPC, "plc_solpurple", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 9 ){

        SpawnItem(oPC, "plc_magicblue", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 10 ){

        SpawnItem(oPC, "plc_magiccyan", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 11 ){

        SpawnItem(oPC, "plc_magicgreen", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 12 ){

        SpawnItem(oPC, "plc_magicorange", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 13 ){

        SpawnItem(oPC, "plc_magicpurple", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 14 ){

        SpawnItem(oPC, "plc_magicred", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 15 ){

        SpawnItem(oPC, "plc_magicwhite", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 16 ){

        SpawnItem(oPC, "plc_magicyellow", "lr_"+IntToString( nCount ), lTarget);
    }
    else if ( nNode == 17 ){

        DestroyItem( oPC, "lr_1" );
        DestroyItem( oPC, "lr_2" );
        DestroyItem( oPC, "lr_3" );
        DestroyItem( oPC, "lr_4" );
        DestroyItem( oPC, "lr_5" );
        DestroyItem( oPC, "lr_6" );

    }

}


//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
void SpawnItem(object oPC, string sResRef, string sTagPrefix, location lTarget){

    //create a tage for each object that consists of the PC name and the item
    string sTag       = sTagPrefix + GetStringLeft( StripName( GetName(oPC) ), 28 );
    object oPlaceable = GetObjectByTag(sTag);

    object oNearestPC   = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    location lNearestPC = GetLocation( oNearestPC );
    location lPC        = GetLocation( oPC );

    //if a PC tries to place the item at his own feet
    if ( GetDistanceBetweenLocations( lTarget, lPC ) < 1.5 ){

        SendMessageToPC( oPC, "You should not place this item on your own feet, my friend." );
    }
    //if a PC tries to place the item at another PC's feet
    else if ( GetDistanceBetweenLocations( lTarget, lNearestPC ) < 1.5 && oNearestPC != OBJECT_INVALID){

        SendMessageToPC( oPC, "You should not place this item on somebodies feet, my friend." );
    }
    //create object
    else{

        CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, FALSE, sTag );
    }

    if( oPlaceable != OBJECT_INVALID ){

        //no removal if somebody uses the chair/cushion
        if(GetIsPC(GetSittingCreature(oPlaceable))){

            SendMessageToPC( oPC, "You cannot remove your "+GetName(oPlaceable)+". Somebody is sitting on it.");
        }
        //remove object
        else{

            SendMessageToPC(oPC,"You removed your "+GetName(oPlaceable)+".");
            DestroyObject(oPlaceable);
        }
    }
}

void DestroyItem(object oPC, string sTagPrefix ){

    //create a tage for each object that consists of the PC name and the item
    string sTag       = sTagPrefix + GetStringLeft( StripName( GetName(oPC) ), 28 );
    object oPlaceable = GetObjectByTag(sTag);

    if( oPlaceable != OBJECT_INVALID ){

        SendMessageToPC(oPC,"You removed your "+GetName(oPlaceable)+".");
        DestroyObject(oPlaceable);

    }
}

// Trims apostrophes and whitespace characters from the input string
// and returns the trimmed string.
string StripName( string sString ){

    // If the string contains apostrohes or whitespace, trim it.
    if( FindSubString( sString, "'") >= 0 || FindSubString( sString, " ") >= 0 ){

        // Variables
        int nCounter        = 0;
        string sReturn      = "";
        string szChar       = "";
        int nStringLength   = GetStringLength( sString );

        // Loop over every character and replace special characters
        for(nCounter = 0; nCounter < nStringLength; nCounter++){

            szChar = GetSubString( sString, nCounter, 1);

            // Apostrophe or Whitespace character, convert to an underscore and append.
            if( szChar == "'" || szChar == " " )    sReturn += "_";
            // Normal character, and append.
            else                                    sReturn += szChar;

        }

        // Trimmed string.
        return( sReturn );

    }

    // No apostrophes or whitespace, no trimming done.
    else{

        return( sString );
    }

}
