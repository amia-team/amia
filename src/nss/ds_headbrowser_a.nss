//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:       ds_headbrowser_a
//used for:     pc customisation
//used as:      npc action script
//date:         2010-09-26
//author:       disco

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"



//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//this does something and returns nothing
int get_previous_head( int nCurrentHead, int nRace=0, int nSex=0 );

int get_next_head( int nCurrentHead, int nRace=0, int nSex=0 );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //define variables
    object oPC          = OBJECT_SELF;
    object oTarget      = GetLocalObject( oPC, "ds_target" );
    int nNode           = GetLocalInt( oPC, "ds_node" );
    int nCurrentHead    = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
    int nHeadCheck;
    int nSetHead;
    int nRace           = GetRacialType( oPC );
    int nSex            = GetGender( oPC );
    int nNoKey          = GetLocalInt( oPC, "nokey" );


    if ( nNode == 1 ){

        nSetHead = get_previous_head( nCurrentHead, nRace, nSex );
    }
    else if ( nNode == 2 ){

        nSetHead = get_next_head( nCurrentHead, nRace, nSex );
    }
    else if ( nNode == 3 ){

        //this fixes the chosen head
        nSetHead = nCurrentHead;

        //make sure everybody has one go at it
        SetPCKEYValue( oPC, "ds_head", -99 );

        //this unlocks the NPC
        DeleteLocalInt( oTarget, "ds_head" );
    }
    else if ( nNode == 4 ){

        //this unlocks the NPC
        DeleteLocalInt( oTarget, "ds_head" );

        if ( nNoKey == 1 ){

            //this returns the old head
            nSetHead = GetLocalInt( oPC, "ds_head" );

            //this value can be set to 0
            DeleteLocalInt( oPC, "ds_head" );

            //don't do anything if it's not needed
            if ( nSetHead == 0 || nSetHead == nCurrentHead ){

                return;
            }
        }
        else{

            //this returns the old head
            nSetHead = GetPCKEYValue( oPC, "ds_head" );

            //this value can be set to 0
            DeletePCKEYValue( oPC, "ds_head" );

            //don't do anything if head change already took place
            if ( nSetHead == 0 || nSetHead == -99 || nSetHead == nCurrentHead ){

                //this unlocks the NPC
                DeleteLocalInt( oTarget, "ds_head" );

                return;
            }
        }
    }
    else if ( nNode == 5 ){

        //this fixes the chosen head
        nSetHead = nCurrentHead;

        //this unlocks the NPC
        DeleteLocalInt( oTarget, "ds_head" );
    }
    else if ( nNode == 7 ) {

        //this unlocks the NPC
        DeleteLocalInt( oTarget, "ds_head" );

        return;
    }

    SetCreatureBodyPart( CREATURE_PART_HEAD, nSetHead, oPC );

    SendMessageToPC( oPC, "Head set to model #"+IntToString( nSetHead ) );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int get_previous_head( int nCurrentHead, int nRace=0, int nSex=0 ){

    if ( ( nRace == RACIAL_TYPE_HUMAN ||  nRace == RACIAL_TYPE_HALFELF ) && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 177 ){

            return 177;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 049 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 049 && nCurrentHead <= 100 ){

            return 049;
        }
        else if ( nCurrentHead > 100 && nCurrentHead <= 113 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 113 && nCurrentHead <= 140 ){

            return nCurrentHead = 113;
        }
        else if ( nCurrentHead > 140 && nCurrentHead <= 177 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFLING && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 25 ){

            return 25;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 25 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_DWARF && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 25 ){

            return 25;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 25 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_GNOME && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 25 ){

            return 25;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 25 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFORC && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 150 ){

            return 150;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 032 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 032 && nCurrentHead <= 150 ){

            return 032;
        }
    }
    else if ( nRace == RACIAL_TYPE_ELF && nSex == GENDER_MALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 45 ){

            return 45;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 45 ){

            return nCurrentHead - 1;
        }
    }
    else if ( ( nRace == RACIAL_TYPE_HUMAN ||  nRace == RACIAL_TYPE_HALFELF ) && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 199 ){

            return 199;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 129 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 129 && nCurrentHead <= 140 ){

            return 129;
        }
        else if ( nCurrentHead > 140 && nCurrentHead <= 174 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 174 && nCurrentHead <= 186 ){

            return nCurrentHead = 174;
        }
        else if ( nCurrentHead > 186 && nCurrentHead <= 199 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFLING && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 20 ){

            return 20;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 20 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_DWARF && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 21 ){

            return 21;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 21 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_ELF && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 117 ){

            return 117;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 049 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 049 && nCurrentHead <= 100 ){

            return 049;
        }
        else if ( nCurrentHead > 100 && nCurrentHead <= 113 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 113 && nCurrentHead <= 115 ){

            return nCurrentHead = 113;
        }
        else if ( nCurrentHead > 115 && nCurrentHead <= 117 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_GNOME && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 016 ){

            return 016;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 009 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 009 && nCurrentHead <= 013 ){

            return 009;
        }
        else if ( nCurrentHead > 013 && nCurrentHead <= 016 ){

            return nCurrentHead - 1;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFORC && nSex == GENDER_FEMALE ){

        if ( nCurrentHead == 001 || nCurrentHead > 150 ){

            return 150;
        }
        else if ( nCurrentHead > 001 && nCurrentHead <= 012 ){

            return nCurrentHead - 1;
        }
        else if ( nCurrentHead > 012 && nCurrentHead <= 150 ){

            return 012;
        }
    }


    //in case anything went wrong
    return 001;
}

int get_next_head( int nCurrentHead, int nRace=0, int nSex=0 ){

    if ( ( nRace == RACIAL_TYPE_HUMAN ||  nRace == RACIAL_TYPE_HALFELF ) && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 049 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 049 && nCurrentHead < 100  ){

            return 100;
        }
        else if ( nCurrentHead >= 100 && nCurrentHead < 113 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 113 && nCurrentHead < 140 ){

            return 140;
        }
        else if ( nCurrentHead >= 140 && nCurrentHead < 177 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 177 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFLING && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 025 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 025 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_DWARF && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 025 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 025 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_GNOME && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 025 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 025 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFORC && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 032 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 032 && nCurrentHead < 150  ){

            return 150;
        }
        else if ( nCurrentHead >= 150 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_ELF && nSex == GENDER_MALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 045 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 045 && nCurrentHead < 103  ){

            return 103;
        }
        else if ( nCurrentHead >= 103 ){

            return 001;
        }
    }
    else if ( ( nRace == RACIAL_TYPE_HUMAN ||  nRace == RACIAL_TYPE_HALFELF ) && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 129 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 129 && nCurrentHead < 140  ){

            return 140;
        }
        else if ( nCurrentHead >= 140 && nCurrentHead < 174 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 174 && nCurrentHead < 186 ){

            return 186;
        }
        else if ( nCurrentHead >= 186 && nCurrentHead < 199 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 199 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFLING && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 020 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 020 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_DWARF && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 021 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 021 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_ELF && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 049 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 049 && nCurrentHead < 100  ){

            return 100;
        }
        else if ( nCurrentHead >= 100 && nCurrentHead < 113 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 113 && nCurrentHead < 115 ){

            return 115;
        }
        else if ( nCurrentHead >= 115 && nCurrentHead < 117 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 117 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_GNOME && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 009 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 009 && nCurrentHead < 013  ){

            return 013;
        }
        else if ( nCurrentHead >= 013 && nCurrentHead < 016 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 016 ){

            return 001;
        }
    }
    else if ( nRace == RACIAL_TYPE_HALFORC && nSex == GENDER_FEMALE ){

        if ( nCurrentHead >= 001 && nCurrentHead < 012 ){

            return nCurrentHead + 1;
        }
        else if ( nCurrentHead >= 012 && nCurrentHead < 150  ){

            return 150;
        }
        else if ( nCurrentHead >= 150 ){

            return 001;
        }
    }

    //in case anything went wrong
    return 001;

}


