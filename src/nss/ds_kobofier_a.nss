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
// Date:        2022-03-04
//author:       The1Kobra

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------

int RACIAL_TYPE_GOBLIN = 38;
int RACIAL_TYPE_KOBOLD = 39;
int RACIAL_TYPE_GNOLL = 56;

int BP_HEAD_GOBLIN = 158;
int BP_NECK_GOBLIN = 202;
int BP_TORSO_GOBLIN = 202;
int BP_PELVIS_GOBLIN = 202;
int BP_BICEP_GOBLIN = 202;
int BP_FOREARM_GOBLIN = 202;
int BP_HAND_GOBLIN = 202;
int BP_THIGH_GOBLIN = 202;
int BP_SHIN_GOBLIN = 202;
int BP_FEET_GOBLIN = 202;

int BP_HEAD_KOBOLD = 164;
int BP_NECK_KOBOLD = 224;
int BP_TORSO_KOBOLD = 224;
int BP_PELVIS_KOBOLD = 224;
int BP_BICEP_KOBOLD = 224;
int BP_FOREARM_KOBOLD = 224;
int BP_HAND_KOBOLD = 224;
int BP_THIGH_KOBOLD = 224;
int BP_SHIN_KOBOLD = 224;
int BP_FEET_KOBOLD = 224;

int BP_HEAD_GNOLL = 138;
//int BP_NECK_GNOLL = 0;
//int BP_TORSO_GNOLL = 0;
//int BP_PELVIS_GNOLL = 0;
//int BP_BICEP_GNOLL = 0;
//int BP_FOREARM_GNOLL = 0;
//int BP_HAND_GNOLL = 0;
int BP_THIGH_GNOLL = 27;
int BP_SHIN_GNOLL = 196;
int BP_FEET_GNOLL = 196;
int BP_TAIL_GNOLL = 967;

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void Kobofy();

void Gobbofy();

void Gnollify();

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

        if ( nRacialType == RACIAL_TYPE_GOBLIN ){

            //this fixes the model
            Gobbofy();

            //this disables the model setter
            SetLocalInt( oPC, "ds_check_3", 0 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        } else if (nRacialType == RACIAL_TYPE_KOBOLD) {

            //this fixes the model
            Kobofy();

            //this disables the model setter
            SetLocalInt( oPC, "ds_check_3", 0 );
            SetLocalInt( oPC, "ds_check_4", 1 );

            SetLocalInt( oTarget, "ds_kobo", 0 );
        } else if (nRacialType == RACIAL_TYPE_GNOLL) {
            //this fixes the model
            Gnollify();
            //this disables the model setter
            SetLocalInt( oPC, "ds_check_3", 0 );
            SetLocalInt( oPC, "ds_check_4", 1 );
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
    DelayCommand( 2.1, SetCreatureBodyPart( CREATURE_PART_NECK, BP_NECK_KOBOLD ) );
    DelayCommand( 2.2, SetCreatureBodyPart( CREATURE_PART_TORSO, BP_TORSO_KOBOLD ) );
    DelayCommand( 2.3, SetCreatureBodyPart( CREATURE_PART_PELVIS, BP_PELVIS_KOBOLD ) );
    DelayCommand( 2.4, SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, BP_BICEP_KOBOLD ) );
    DelayCommand( 2.5, SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, BP_FOREARM_KOBOLD ) );
    DelayCommand( 2.6, SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, BP_HAND_KOBOLD ) );
    DelayCommand( 2.7, SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, BP_BICEP_KOBOLD ) );
    DelayCommand( 2.8, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, BP_FOREARM_KOBOLD ) );
    DelayCommand( 2.9, SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, BP_HAND_KOBOLD ) );
    DelayCommand( 3.0, SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, BP_THIGH_KOBOLD ) );
    DelayCommand( 3.1, SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, BP_SHIN_KOBOLD ) );
    DelayCommand( 3.2, SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, BP_FEET_KOBOLD ) );
    DelayCommand( 3.3, SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, BP_THIGH_KOBOLD ) );
    DelayCommand( 3.4, SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, BP_SHIN_KOBOLD ) );
    DelayCommand( 3.5, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, BP_FEET_KOBOLD ) );
    DelayCommand( 3.8, SetCreatureBodyPart( CREATURE_PART_HEAD, BP_HEAD_KOBOLD ) );
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
    DelayCommand( 2.0, SetCreatureBodyPart( CREATURE_PART_NECK, BP_NECK_GOBLIN ) );
    DelayCommand( 2.1, SetCreatureBodyPart( CREATURE_PART_TORSO, BP_TORSO_GOBLIN ) );
    DelayCommand( 2.2, SetCreatureBodyPart( CREATURE_PART_PELVIS, BP_PELVIS_GOBLIN ) );
    DelayCommand( 2.3, SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, BP_BICEP_GOBLIN ) );
    DelayCommand( 2.4, SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, BP_FOREARM_GOBLIN ) );
    DelayCommand( 2.5, SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, BP_HAND_GOBLIN ) );
    DelayCommand( 2.6, SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, BP_BICEP_GOBLIN ) );
    DelayCommand( 2.7, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, BP_FOREARM_GOBLIN ) );
    DelayCommand( 2.8, SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, BP_HAND_GOBLIN ) );
    DelayCommand( 2.9, SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, BP_THIGH_GOBLIN ) );
    DelayCommand( 3.0, SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, BP_SHIN_GOBLIN ) );
    DelayCommand( 3.1, SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, BP_FEET_GOBLIN ) );
    DelayCommand( 3.2, SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, BP_THIGH_GOBLIN ) );
    DelayCommand( 3.3, SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, BP_SHIN_GOBLIN ) );
    DelayCommand( 3.4, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, BP_FEET_GOBLIN ) );
    DelayCommand( 3.6, SetCreatureBodyPart( CREATURE_PART_HEAD, BP_HEAD_GOBLIN ) );
    DelayCommand( 4.0, SetColor( OBJECT_SELF, COLOR_CHANNEL_SKIN, 32 ) );
    DelayCommand( 4.1, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, 16 ) );
    DelayCommand( 4.2, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, 16 ) );
    DelayCommand( 5.0, ExportSingleCharacter( OBJECT_SELF ) );
    DelayCommand( 6.0, BootPC( OBJECT_SELF ) );
}

// Note that several of the Gnoll body parts are unmodified from base human.
// They remain commented out for future use.
void Gnollify() {
    ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_CHEST ) );

    FreezePC( OBJECT_SELF, 6.0, "You will be booted to complete this change." );

    DelayCommand( 1.0, SetCreatureAppearanceType( OBJECT_SELF, APPEARANCE_TYPE_HUMAN ) );
    //DelayCommand( 2.0, SetCreatureBodyPart( CREATURE_PART_NECK, BP_NECK_GNOLL ) );
    //DelayCommand( 2.1, SetCreatureBodyPart( CREATURE_PART_TORSO, BP_TORSO_GNOLL ) );
    //DelayCommand( 2.2, SetCreatureBodyPart( CREATURE_PART_PELVIS, BP_PELVIS_GNOLL ) );
    //DelayCommand( 2.3, SetCreatureBodyPart( CREATURE_PART_LEFT_BICEP, BP_BICEP_GNOLL ) );
    //DelayCommand( 2.4, SetCreatureBodyPart( CREATURE_PART_LEFT_FOREARM, BP_FOREARM_GNOLL ) );
    //DelayCommand( 2.5, SetCreatureBodyPart( CREATURE_PART_LEFT_HAND, BP_HAND_GNOLL ) );
    //DelayCommand( 2.6, SetCreatureBodyPart( CREATURE_PART_RIGHT_BICEP, BP_BICEP_GNOLL ) );
    //DelayCommand( 2.7, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOREARM, BP_FOREARM_GNOLL ) );
    //DelayCommand( 2.8, SetCreatureBodyPart( CREATURE_PART_RIGHT_HAND, BP_HAND_GNOLL ) );
    DelayCommand( 2.9, SetCreatureBodyPart( CREATURE_PART_LEFT_THIGH, BP_THIGH_GNOLL ) );
    DelayCommand( 3.0, SetCreatureBodyPart( CREATURE_PART_LEFT_SHIN, BP_SHIN_GNOLL ) );
    DelayCommand( 3.1, SetCreatureBodyPart( CREATURE_PART_LEFT_FOOT, BP_FEET_GNOLL ) );
    DelayCommand( 3.2, SetCreatureBodyPart( CREATURE_PART_RIGHT_THIGH, BP_THIGH_GNOLL ) );
    DelayCommand( 3.3, SetCreatureBodyPart( CREATURE_PART_RIGHT_SHIN, BP_SHIN_GNOLL ) );
    DelayCommand( 3.4, SetCreatureBodyPart( CREATURE_PART_RIGHT_FOOT, BP_FEET_GNOLL ) );
    DelayCommand( 3.6, SetCreatureBodyPart( CREATURE_PART_HEAD, BP_HEAD_GNOLL ) );
    DelayCommand( 4.0, SetColor( OBJECT_SELF, COLOR_CHANNEL_SKIN, 3 ) );
    //DelayCommand( 4.1, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_1, 16 ) );
    //DelayCommand( 4.2, SetColor( OBJECT_SELF, COLOR_CHANNEL_TATTOO_2, 16 ) );
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

    if ( nRacialType == RACIAL_TYPE_GOBLIN ){  // goblin

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
    } else if (nRacialType == RACIAL_TYPE_KOBOLD) { // Kobold

        if ( nCurrenthead >= 164 && nCurrenthead < 167 ) {

            nNextHead = nCurrenthead + 1;
        }
        else {

            nNextHead = 164;
        }
    } else if (nRacialType == RACIAL_TYPE_GNOLL) {
        nNextHead = BP_HEAD_GNOLL;
    } else {
        return;
    }

    SetCreatureBodyPart( CREATURE_PART_HEAD, nNextHead, oPC );
    SendMessageToPC( oPC, "Head set to model #"+IntToString( nNextHead ) );
}
