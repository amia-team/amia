//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:       ds_headbrowser_i
//used for:     pc customisation
//used as:      npc convo script
//date:         2010-09-26
//author:       disco


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

    if ( nRacialType == 38 ){// Goblin

        if ( nAppearance == 84 || nAppearance == 86 || nAppearance == 87 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
        else if ( GetCreatureBodyPart( CREATURE_PART_TORSO, oPC ) == 202 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

            SpeakString( "Sorry, you'll need to activate your subrace first!" );

            SetLocalInt( OBJECT_SELF, "ds_kobo", 0 );

            return;
        }
    }
    else if ( nRacialType == 39 ){// Kobold

        if ( nAppearance == 301 || nAppearance == 302 || nAppearance == 305 ){

            SetLocalInt( oPC, "ds_check_2", 1 );
            SetLocalInt( oPC, "ds_check_3", 1 );
        }
        else if ( GetCreatureBodyPart( CREATURE_PART_TORSO, oPC ) == 224 ){

            SetLocalInt( oPC, "ds_check_1", 1 );
            SetLocalInt( oPC, "ds_check_4", 1 );
        }
        else{

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
