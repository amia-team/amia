//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:       ds_headbrowser_i
//used for:     pc customisation
//used as:      npc convo script
//date:         2010-09-26
//author:       disco

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
// Date:        2022-03-04
//author:       The1Kobra

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
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //this means the NPC is busy
    if ( GetLocalInt( OBJECT_SELF, "ds_kobo" ) == 1 ){

        return;
    }

    //this locks the NPC
    SetLocalInt( OBJECT_SELF, "ds_kobo", 1 );

    //variables
    object oPC      = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,OBJECT_SELF);
    int nRacialType = GetRacialType(oPC);
    int nAppearance = GetAppearanceType( oPC );


    if ( GetGender( oPC ) != GENDER_MALE ){

        SpeakString( "Shove it, woman! We're only catering males here!" );

        SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );

        return;
    }


    //action script stuff
    clean_vars( oPC, 4 );
    SetLocalString( oPC, "ds_action", "ds_kobofier_a" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    if ( nRacialType == RACIAL_TYPE_GOBLIN ){// Goblin

        if ( nAppearance == APPEARANCE_TYPE_GOBLIN_SHAMAN_A || nAppearance == APPEARANCE_TYPE_GOBLIN_A
        || nAppearance == APPEARANCE_TYPE_GOBLIN_SHAMAN_B || nAppearance == APPEARANCE_TYPE_GOBLIN_B ) {

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
        else if ( GetCreatureBodyPart( CREATURE_PART_TORSO, oPC ) == BP_TORSO_GOBLIN ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

            SpeakString( "Sorry, you'll need to activate your subrace first!" );

            SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );

            return;
        }
    }
    else if ( nRacialType == RACIAL_TYPE_KOBOLD ){// Kobold

        //if ( nAppearance == 301 || nAppearance == 302 || nAppearance == 305 ){
        if ( nAppearance == APPEARANCE_TYPE_KOBOLD_A || nAppearance == APPEARANCE_TYPE_KOBOLD_B
        || nAppearance == APPEARANCE_TYPE_KOBOLD_SHAMAN_A || nAppearance == APPEARANCE_TYPE_KOBOLD_SHAMAN_B) {
            SetLocalInt( oPC, "ds_check_2", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
        else if ( GetCreatureBodyPart( CREATURE_PART_TORSO, oPC ) == BP_TORSO_KOBOLD ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

            SpeakString( "Sorry, you'll need to activate your subrace first!" );

            SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );

            return;
        }
    } else if ( nRacialType == RACIAL_TYPE_GNOLL ) {
        if (nAppearance == APPEARANCE_TYPE_GNOLL_WARRIOR || nAppearance == APPEARANCE_TYPE_GNOLL_WIZ) {
            SetLocalInt( oPC, "ds_check_2", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        } else if (GetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT,oPC) == BP_FEET_GNOLL) {
            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        } else {
            SpeakString( "Sorry, you'll need to activate your subrace first!" );
            SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );
            return;
        }
    }
    else{

        SpeakString( "Bah. You're not my kind of creature!" );

        SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );

        return;
    }

    ActionStartConversation( oPC, "ds_kobofier", TRUE, FALSE );
    SetLocalInt(OBJECT_SELF,"ds_kobo",0);
}