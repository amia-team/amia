/*  ds_check_quest_2

--------
Verbatim
--------
Generic quest tester.
Selects on NPC tag.
Returns TRUE if condition is met.

---------
Changelog
---------

    Date    Name        Reason
    ------------------------------------------------------------------
    062406  Disco       Script header started
  20071103  Disco       Now uses databased PCKEY functions
    ------------------------------------------------------------------


*/
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"
#include "inc_ds_records"



//-------------------------------------------------------------------------------
//starting conditional
//-------------------------------------------------------------------------------

int StartingConditional(){

    //variables
    object oPC           = GetPCSpeaker();
    string sConvoNPCTag  = GetTag( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if( !GetIsPC(oPC) ){

        return FALSE;
    }

    if ( sConvoNPCTag == "ds_fisherman" ){

        // don't show option if quest is not set or items aren't collected
        if( GetPCKEYValue( oPC, "ds_quest_1" ) != 1 ){

            return FALSE;
        }

        if( !HasItem( oPC, "ds_anchor" ) ){

            SendMessageToPC( oPC, "missing anchor" );
            return FALSE;  //anchor
        }

        if( !HasItem( oPC, "ds_pitch" ) ){

            SendMessageToPC( oPC, "missing anchor" );
            return FALSE;   //pitch
        }

        if( !HasItem( oPC, "x2_it_amt_spikes" ) ){

            SendMessageToPC( oPC, "missing anchor" );
            return FALSE; //spikes
        }

        if( !HasItem( oPC, "x2_it_cmat_elmw" ) ){

            SendMessageToPC( oPC, "missing planks" );
            return FALSE;  //wooden planks
        }

        if( !HasItem( oPC, "x2_it_cmat_cloth" ) ){

            SendMessageToPC( oPC, "missing cloth" );
            return FALSE; //cloth
        }

        if( !HasItem( oPC, "NW_WBLHL001" ) ){

            SendMessageToPC( oPC, "missing hammer" );
            return FALSE; //hammer
        }

        if( !HasItem( oPC, "rope" ) ){

            SendMessageToPC( oPC, "missing hemp rope" );
            return FALSE; //hemp rope
        }
    }
    else if ( sConvoNPCTag == "Zeek" ){

        // don't show option if subquest is not set or item isn't collected
        if( GetPCKEYValue( oPC, "ds_quest_2" ) != 1 ){

            return FALSE;
        }

        if( !HasItem( oPC, "ds_golempart" ) ){

            return FALSE;
        }

    }
    else if ( sConvoNPCTag == "ds_pitcher" ){

        // don't show option if subquest is not set or item isn't collected
        if( GetPCKEYValue( oPC, "ds_quest_3" ) != 1 ){

            return FALSE;
        }

        if( !HasItem( oPC, "chinchonabark" ) ){

            return FALSE;
        }

    }
    else if ( sConvoNPCTag == "ds_uhm_mayor" ){

        // don't show option if subquest is not set or item isn't collected
        if( GetPCKEYValue( oPC, "ds_quest_4" ) != 3 ){

            return FALSE;
        }

        if( !HasItem( oPC, "ds_pirate_head" ) ){

            return FALSE;
        }

    }

    return TRUE;
}

