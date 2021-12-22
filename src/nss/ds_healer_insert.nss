#include "inc_ds_actions"

void main()
{

    object oPC     = GetPCSpeaker();
    object oHealer = OBJECT_SELF;

    clean_vars( oPC, 4 );

    if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_GOOD ){

        SetLocalInt( oPC, "ds_check_4", 1 );
    }
    else if ( GetAlignmentGoodEvil( oHealer ) == ALIGNMENT_EVIL ){

        SetLocalInt( oPC, "ds_check_6", 1 );
    }
    else{

        SetLocalInt( oPC, "ds_check_5", 1 );
    }

    if ( GetHitDice( oHealer ) > 6 ){

        SetLocalInt( oPC, "ds_check_10", 1 );
    }

    if ( GetHitDice( oHealer ) > 12 ){

        SetLocalInt( oPC, "ds_check_11", 1 );
    }

    SetLocalString( oPC, "ds_action", "ds_healer_act" );
    SetLocalObject( oPC, "ds_target", oHealer );

    ActionStartConversation( oPC, "ds_healer", TRUE, FALSE );
}

