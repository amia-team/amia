void main(){

    object oPC    = OBJECT_SELF;
    object oNPC   = GetLocalObject( oPC, "ds_target" );
    int nNode     = GetLocalInt( oPC, "ds_node" );

    //--------------------------------------------
    //delete stool
    //--------------------------------------------
    string sTag     = "ds_npc_st_"+GetPCPublicCDKey( oPC );
    object oStool   = GetObjectByTag( sTag );

    if ( GetIsObjectValid( oStool ) ){

        DestroyObject( oStool, 0.5 );
    }


    //--------------------------------------------
    //actions
    //--------------------------------------------
    if ( nNode == 1 ){

        //follow
        AssignCommand( oNPC, ActionForceFollowObject( oPC, 1.0 ) );
    }
    else if ( nNode == 2 ){

        //follow
        AssignCommand( oNPC, ClearAllActions( TRUE ) );
    }
    else if ( nNode == 3 ){

        //suit
        object oSuit = GetItemPossessedBy( oNPC, "ds_npc_suit" );

        if ( GetItemInSlot( INVENTORY_SLOT_CHEST, oNPC ) == oSuit ){

            AssignCommand( oNPC, ActionUnequipItem( oSuit ) );
        }
        else{

            AssignCommand( oNPC, ActionEquipItem( oSuit, INVENTORY_SLOT_CHEST ) );
        }
    }
    else if ( nNode == 4 ){

        //armour
        object oArmour     = GetItemPossessedBy( oNPC, "ds_npc_armour" );

        if ( GetItemInSlot( INVENTORY_SLOT_CHEST, oNPC ) == oArmour ){

            AssignCommand( oNPC, ActionUnequipItem( oArmour ) );
        }
        else{

            AssignCommand( oNPC, ActionEquipItem( oArmour, INVENTORY_SLOT_CHEST ) );
        }
    }
    else if ( nNode == 5 ){

        //cloak
        object oCloak     = GetItemPossessedBy( oNPC, "ds_npc_cloak" );

        if ( GetItemInSlot( INVENTORY_SLOT_CLOAK, oNPC ) == oCloak ){

            AssignCommand( oNPC, ActionUnequipItem( oCloak ) );
        }
        else{

            AssignCommand( oNPC, ActionEquipItem( oCloak, INVENTORY_SLOT_CLOAK ) );
        }
    }
    else if ( nNode == 6 ){

        //helmet
        object oHelmet = GetItemPossessedBy( oNPC, "ds_npc_helm" );

        if ( GetItemInSlot( INVENTORY_SLOT_HEAD, oNPC ) == oHelmet ){

            AssignCommand( oNPC, ActionUnequipItem( oHelmet ) );
        }
        else{

            AssignCommand( oNPC, ActionEquipItem( oHelmet, INVENTORY_SLOT_HEAD ) );
        }
    }
    else if ( nNode == 7 ){

        //stool
        oStool = CreateObject( OBJECT_TYPE_PLACEABLE, "tha_stool", GetLocation( oNPC ), FALSE, sTag  );
        DelayCommand( 2.0, AssignCommand( oNPC, ActionSit( oStool ) ) );

    }
    else if ( nNode == 8 ){

        //stool
        DestroyObject( oNPC, 1.0 );

    }
    else if ( nNode ==9 ){

        //helmet
        object oSword = GetItemPossessedBy( oNPC, "ds_npc_sword" );

        if ( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oNPC ) == oSword ){

            AssignCommand( oNPC, ActionUnequipItem( oSword ) );
        }
        else{

            AssignCommand( oNPC, ActionEquipItem( oSword, INVENTORY_SLOT_RIGHTHAND ) );
        }
    }

    //--------------------------------------------
    //long emotes
    //--------------------------------------------

    if ( nNode == 10 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_DEAD_FRONT, 1.0, 600.0 ) );
    }
    if ( nNode == 11 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 600.0 ) );
    }
    if ( nNode == 12 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_LISTEN, 1.0, 600.0 ) );
    }
    if ( nNode == 13 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_LOOK_FAR, 1.0, 600.0 ) );
    }
    if ( nNode == 14 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, 600.0 ) );
    }
    if ( nNode == 15 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, 600.0 ) );
    }
    if ( nNode == 16 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_LOOPING_WORSHIP, 1.0, 600.0 ) );
    }

    //--------------------------------------------
    //quick emotes
    //--------------------------------------------

    if ( nNode == 17 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_FIREFORGET_BOW ) );
    }
    if ( nNode == 18 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_FIREFORGET_DRINK ) );
    }

    if ( nNode == 19 ){

        //follow
        AssignCommand( oNPC, PlayAnimation( ANIMATION_FIREFORGET_READ ) );
    }

    //--------------------------------------------
    //speak
    //--------------------------------------------
    if ( nNode == 20 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_ATTACK, oNPC );
    }
    if ( nNode == 21 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_CHEER, oNPC );
    }
    if ( nNode == 22 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_ENEMIES, oNPC );
    }
    if ( nNode == 23 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_GOODBYE, oNPC );
    }
    if ( nNode == 24 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_HELLO, oNPC );
    }
    if ( nNode == 25 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_LOOKHERE, oNPC );
    }
    if ( nNode == 26 ){

        //follow
        PlayVoiceChat( VOICE_CHAT_THANKS, oNPC );
    }

    //cleaning
    DeleteLocalInt( oPC, "ds_node" );
    DeleteLocalInt( oPC, "ds_check_1" );
    DeleteLocalInt( oPC, "ds_check_2" );
    DeleteLocalObject( oPC, "ds_target" );

}
