/*
tha_quests_chk

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script pools a lot of convo checks. All checks are dealing with Forrstakkr.

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Check if the Priest is still in convo with a PC
20071103        Disco      Now uses databased PCKEY functions
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

string tha_get_race(object oPC);

int tha_check_notebook(object oPC);

//-------------------------------------------------------------------------------
//starting conditional
//-------------------------------------------------------------------------------
int StartingConditional(){

    //variables
    object oPC          = GetPCSpeaker();
    string sConvoNPCTag = GetTag( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if( !GetIsPC( oPC ) ){

        return( FALSE );
    }

    //Howness Temple
    if( sConvoNPCTag == "tha_highpriest"){

        // Make sure the PC speaker has the quest and these items in their inventory
        if(GetPCKEYValue( oPC, "tha_quest1" ) != 1){ return FALSE; }
        if ( !HasItem( oPC, "tha_flour")){ return FALSE; }
        if ( !HasItem( oPC, "tha_ice")){ return FALSE; }
        if ( !HasItem( oPC, "tha_nuts")){ return FALSE; }
     }
     //Thordstein Buildings
     else if( sConvoNPCTag == "tha_vinni"){

        // Make sure the PC speaker has the quest and these items in their inventory
        if(GetPCKEYValue( oPC, "tha_quest2" ) != 1){ return FALSE; }
        if ( !HasItem( oPC, "tha_bread")){ return FALSE; }
     }
     //Thordstein Buildings
     else if( sConvoNPCTag == "tha_gudmund"){

        if(GetPCKEYValue( oPC, "tha_quest2" ) != 2){ return FALSE; }
        if(GetPCKEYValue( oPC, "tha_quest3" ) != 0){ return FALSE; }
     }
     //Smith
     else if( sConvoNPCTag == "tha_olaf"){

        if ( !HasItem( oPC, "x2_it_cmat_iron")){ return FALSE; }
     }
     //Thykkvi Monastery
     else if( sConvoNPCTag == "tha_thorghir"){

        if(GetPCKEYValue( oPC, "tha_quest3" ) != 1){ return FALSE; }
        if ( !HasItem( oPC, "tha_book")){ return FALSE; }
     }
     //Dragon lair
     else if( sConvoNPCTag == "tha_dragon"){

        if ( !HasItem( oPC, "archmagibook") && !HasItem( oPC, "HowIlearendtobeanArchMageovernig")){
            return FALSE;
        }
        if(GetPCKEYValue( oPC, "tha_quest4" ) != 1){
            return FALSE;
        }
     }
     //Ostman in the Thirsty Marauder
     else if( sConvoNPCTag == "tha_ostman"){

         if ( !HasItem( oPC, "tha_notebook")){ return FALSE; }
         if ( tha_check_notebook( oPC) != 1){ return FALSE; }
     }
     //Thirmir in Thordstein Buildings
     else if( sConvoNPCTag == "tha_thirmir"){

         if(GetPCKEYValue( oPC, "tha_quest7" ) != 1){ return FALSE; }
     }
     //Hunter's Company
     else if( sConvoNPCTag == "tha_halldor"){

        if(GetHitDice( oPC) < 11){
            SpeakString("Come back when yer been grown up an' all, youngster.");
            return FALSE;
        }
     }
     //Hunter's Company
     else if( sConvoNPCTag == "tha_alf"){

        if ( !HasItem( oPC, "tha_hide")){ return FALSE; }
     }
     //Howness Gate Street
     else if( sConvoNPCTag == "tha_hrolf"){

        int nReputation=tha_reputation( oPC,0);
        if(nReputation<2){
            SpeakString("Of course not! What does a stranger like YOU know of this?");
            return FALSE;
        }
        else if(nReputation<4){
            SpeakString("No, stranger, this a matter of we must solve alone, as the tradition wants it.");
            return FALSE;
        }
        else if( GetRacialType( oPC )  ==  RACIAL_TYPE_HUMAN && GetStringLowerCase( GetSubRace( oPC ) ) != "tiefling" ){
            return TRUE;
        }
        else{
            SpeakString("No offense, stranger, but this is something only humans can understand.");
            return FALSE;
        }
     }
     else{
        return FALSE;
     }

    return TRUE;
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
string tha_get_race( object oPC){

    string sRace=GetSubRace( oPC);
    if( sRace == ""){
        int nRace=GetRacialType( oPC);
        if(nRace == RACIAL_TYPE_DWARF){ sRace = "dwarf"; }
        if(nRace == RACIAL_TYPE_ELF){ sRace = "elf"; }
        if(nRace == RACIAL_TYPE_GNOME){ sRace = "gnome"; }
        if(nRace == RACIAL_TYPE_HALFELF){ sRace = "halfelf"; }
        if(nRace == RACIAL_TYPE_HALFLING){ sRace = "halfling"; }
        if(nRace == RACIAL_TYPE_HALFORC){ sRace = "halfork"; }
        if(nRace == RACIAL_TYPE_HUMAN){ sRace = "human"; }
    }
    return GetStringLowerCase( sRace);
}

//checks if the pc wrote down all the runes
int tha_check_notebook( object oPC){

    object oItem=GetItemPossessedBy( oPC,"tha_notebook");

    // return 0 if one of the variables isn't set
    if(GetLocalInt( oItem, "tha_rune_1") != 1){ return( 0 ); }
    if(GetLocalInt( oItem, "tha_rune_2") != 1){ return( 0 ); }
    if(GetLocalInt( oItem, "tha_rune_3") != 1){ return( 0 ); }
    if(GetLocalInt( oItem, "tha_rune_4") != 1){ return( 0 ); }

    //return 1 if all variables are set
    return(1);
}
