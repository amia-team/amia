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

void Kobofy();

void Gobbofy();

void set_color( object oPC, int nChannel );

void set_head( object oPC, int nRacialType, int nCurrenthead );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //define variables
    object oPC          = OBJECT_SELF;
    object oTarget      = GetLocalObject( oPC, "ds_target" );
    int nNode           = GetLocalInt( oPC, "ds_node" );
    int nRacialType     = GetRacialType(oPC);
    int nAppearance     = GetAppearanceType( oPC );
    int nCurrentColor;


    if ( nNode == 1 ){

        if ( nRacialType == 38 ){

            //this fixes the model
            Gobbofy();

            //this disables the model setter
            SetLocalInt( oPC, "ds_check_3", 0 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

            //this fixes the model
            Kobofy();

            //this disables the model setter
            SetLocalInt( oPC, "ds_check_3", 0 );
            SetLocalInt( oPC, "ds_check_4", 1 );

            SetLocalInt( oTarget, "ds_kobo", 0 );
        }
    }
    else if ( nNode == 2 ){

        //set head
        set_head( oPC, nRacialType, GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
    }
    else if ( nNode == 3 ){

        set_color( oPC, COLOR_CHANNEL_SKIN );
    }
    else if ( nNode == 4 ){

        set_color( oPC, COLOR_CHANNEL_HAIR );
    }
    else if ( nNode == 5 ){

        set_color( oPC, COLOR_CHANNEL_TATTOO_1 );
    }
    else if ( nNode == 6 ){

        set_color( oPC, COLOR_CHANNEL_TATTOO_2 );
    }
    else if ( nNode == 7 ){

        //this unlocks the NPC
        SetLocalInt( oTarget, "ds_kobo", 0 );
    }
    else if ( nNode == 8 ){

        //this unlocks the NPC
        SetLocalInt( oTarget, "ds_kobo", 0 );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void Kobofy(){

    ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CHEST ) );

    FreezePC( OBJECT_SELF, 6.0, "You will be booted to complete this change." );

    DelayCommand( 1.0, SetCreatureAppearanceType( OBJECT_SELF, APPEARANCE_TYPE_HALFLING ) );
    DelayCommand( 2.1, SetCreatureBodyPart( CREATURE_PART_NECK, 224 ) );
    DelayCommand( 2.2, SetCreatureBodyPart( CREATURE_PART_TORSO, 224 ) );
    DelayCommand( 2.3, SetCreatureBodyPart( CREATURE_PART_PELVIS, 224 ) );
    DelayCommand( 2.4, SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, 224 ) );
    DelayCommand( 2.5, SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, 224 ) );
    DelayCommand( 2.6, SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, 224 ) );
    DelayCommand( 2.7, SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, 224 ) );
    DelayCommand( 2.8, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, 224 ) );
    DelayCommand( 2.9, SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, 224 ) );
    DelayCommand( 3.0, SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, 224 ) );
    DelayCommand( 3.1, SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, 224 ) );
    DelayCommand( 3.2, SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, 224 ) );
    DelayCommand( 3.3, SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, 224 ) );
    DelayCommand( 3.4, SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, 224 ) );
    DelayCommand( 3.5, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, 224 ) );
    DelayCommand( 3.8, SetCreatureBodyPart( CREATURE_PART_HEAD, 164 ) );
    DelayCommand( 4.0, SetColor( OBJECT_SELF, COLOR_CHANNEL_SKIN, 16 ) );
    DelayCommand( 4.1, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, 20 ) );
    DelayCommand( 4.2, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, 20 ) );
    DelayCommand( 5.0, ExportSingleCharacter( OBJECT_SELF ) );
    DelayCommand( 6.0, BootPC( OBJECT_SELF ) );

}

void Gobbofy(){

    ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CHEST ) );

    FreezePC( OBJECT_SELF, 6.0, "You will be booted to complete this change." );

    DelayCommand( 1.0, SetCreatureAppearanceType( OBJECT_SELF, APPEARANCE_TYPE_HALFLING ) );
    DelayCommand( 2.0, SetCreatureBodyPart( CREATURE_PART_NECK, 202 ) );
    DelayCommand( 2.1, SetCreatureBodyPart( CREATURE_PART_TORSO, 202 ) );
    DelayCommand( 2.2, SetCreatureBodyPart( CREATURE_PART_PELVIS, 202 ) );
    DelayCommand( 2.3, SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, 202 ) );
    DelayCommand( 2.4, SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, 202 ) );
    DelayCommand( 2.5, SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, 200 ) );
    DelayCommand( 2.6, SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, 202 ) );
    DelayCommand( 2.7, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, 202 ) );
    DelayCommand( 2.8, SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, 200 ) );
    DelayCommand( 2.9, SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, 202 ) );
    DelayCommand( 3.0, SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, 202 ) );
    DelayCommand( 3.1, SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, 202 ) );
    DelayCommand( 3.2, SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, 202 ) );
    DelayCommand( 3.3, SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, 202 ) );
    DelayCommand( 3.4, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, 202 ) );
    DelayCommand( 3.6, SetCreatureBodyPart( CREATURE_PART_HEAD, 158 ) );
    DelayCommand( 4.0, SetColor( OBJECT_SELF, COLOR_CHANNEL_SKIN, 32 ) );
    DelayCommand( 4.1, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, 16 ) );
    DelayCommand( 4.2, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, 16 ) );
    DelayCommand( 5.0, ExportSingleCharacter( OBJECT_SELF ) );
    DelayCommand( 6.0, BootPC( OBJECT_SELF ) );
}


void set_color( object oPC, int nChannel ){

    int nCurrentColor = GetColor( oPC, nChannel );

    if ( nCurrentColor >= 44 ){

        SetColor( oPC, nChannel, 0 );
        SendMessageToPC( oPC, "Applying color #"+IntToString( 0 ) );
    }
    else{

        SetColor( oPC, nChannel, ( nCurrentColor + 1 ) );
        SendMessageToPC( oPC, "Applying color #"+IntToString( nCurrentColor + 1 ) );
    }
}

void set_head( object oPC, int nRacialType, int nCurrenthead ){

    int nNextHead;

    if ( nRacialType == 38 ){  // goblin

        if ( nCurrenthead >= 42 && nCurrenthead < 45 ) {

            nNextHead = nCurrenthead + 1;
        }
        else if ( nCurrenthead == 45 ){

            nNextHead = 158;
        }
        else if ( nCurrenthead >= 158 && nCurrenthead < 163 ) {

            nNextHead = nCurrenthead + 1;
        }
        else {

            nNextHead = 42;
        }
    }
    else{

        if ( nCurrenthead >= 164 && nCurrenthead < 167 ) {

            nNextHead = nCurrenthead + 1;
        }
        else {

            nNextHead = 164;
        }
    }

    SetCreatureBodyPart( CREATURE_PART_HEAD, nNextHead, oPC );
    SendMessageToPC( oPC, "Head set to model #"+IntToString( nNextHead ) );
}
