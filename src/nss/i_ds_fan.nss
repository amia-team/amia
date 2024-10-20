//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_fan
//group:   widgets
//used as: activation script
//date:    oct 10 2007
//author:  disco

//2008-05-19    Disco       Added The Hurting :D
//2023-02-13    Frozen      Made multi (difirent)BC spawning possible
//2023-02-26    Frozen      Made spawned npc not have collision
//2023-04-29    Frozen      Added option to not have hitbox killed (ghost int 1)
//2023-05-11    Frozen      Added wings and tail options for non dynamic
//2023-07-29    Frozen      Added Phenotype and mounted dynamic skin support

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DressNPC( object oPC, object oNPC );
void change_axis(object oNPC, float fZaxis);

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    int i;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();

            string sTag      = "ds_npc_"+GetPCPublicCDKey( oPC );
            string sUUID;
            string sName;
            string sPortrait;
            string sSex;
            string sResRef;
            string sBio;
            object oUUID;
            object oNPC      = GetObjectByTag( sTag );
            int nSpawned     = GetLocalInt( oItem, "spawned");
            int nType        = GetLocalInt( oItem, "ds_set" );
            int nRace        = GetRacialType( oTarget );
            int nAppearance;
            int nBodyPart;
            int nWings;
            int nTail;
            int nSex;
            int nColor;
            int nPheno;
            float fZaxis;
            float scaleSet;

            if ( nSpawned = 1 ){

                sUUID   = GetLocalString (oItem, "UUID");
                oUUID   = GetObjectByUUID (sUUID);
                sName   = GetLocalString( oItem, "ds_name" );

                if ( GetIsObjectValid( oUUID ) ){
                    DestroyObject( oUUID );
                    DeleteLocalInt ( oItem, "spawned");
                    SendMessageToPC(oPC, "Despawning "+sName);
                    return;
                    }
                else {
                    DeleteLocalInt ( oItem, "spawned");
                    }


            }


            if ( nType == 0 ){

                //inititalise item
                nAppearance  = GetAppearanceType( oTarget );

                if (nAppearance <= 7 ||
                    nAppearance == 482 ||
                    nAppearance == 483 ||
                    nAppearance == 484 ||
                    nAppearance == 485 ||
                    nAppearance == 486 ||
                    nAppearance == 487 ||
                    nAppearance == 488 ||
                    nAppearance == 489 ||
                    nAppearance == 490 ||
                    nAppearance == 491 ||
                    nAppearance == 492 ||
                    nAppearance == 493 ||
                    nAppearance == 494 ||
                    nAppearance == 495 ){

                    //playable race
                    for ( i=0; i<21; ++i ){

                        nBodyPart = GetCreatureBodyPart( i, oTarget );

                        if ( i != 18 ){

                            SetLocalInt( oItem, "ds_part_"+IntToString( i ), nBodyPart );
                        }
                    }

                    //1.69 new!
                    SetLocalInt   ( oItem, "td_skincolor", GetColor( oTarget, COLOR_CHANNEL_SKIN ) );
                    SetLocalInt   ( oItem, "td_haircolor", GetColor( oTarget, COLOR_CHANNEL_HAIR ) );
                    SetLocalInt   ( oItem, "td_tattoo1", GetColor( oTarget, COLOR_CHANNEL_TATTOO_1 ) );
                    SetLocalInt   ( oItem, "td_tattoo2", GetColor( oTarget, COLOR_CHANNEL_TATTOO_2 ) );
                    SetLocalInt   ( oItem, "ds_wings", GetCreatureWingType( oTarget ) );
                    SetLocalInt   ( oItem, "ds_tail", GetCreatureTailType( oTarget ) );
                    SetLocalInt   ( oItem, "ds_race", nRace );
                    SetLocalInt   ( oItem, "ds_pheno", GetPhenoType( oTarget ) );
                    SetLocalInt   ( oItem, "ds_sex", GetGender( oTarget ) );
                    SetLocalInt   ( oItem, "ds_app", nAppearance );
                    SetLocalFloat ( oItem, "ds_scale", GetObjectVisualTransform( oTarget, 10) );
                    SetLocalFloat ( oItem, "cr_zaxis", GetObjectVisualTransform(oTarget, 33) );
                    SetLocalString( oItem, "ds_name", GetName( oTarget ) );
                    SetLocalString( oItem, "ds_portr", GetPortraitResRef( oTarget ) );
                    SetLocalString( oItem, "td_bio", GetDescription( oTarget ) );
                    SetLocalInt   ( oItem, "ds_set", 1 );

                    CreateItemOnObject( "ds_npc_suit", oPC );
                    CreateItemOnObject( "ds_npc_helm", oPC );
                    CreateItemOnObject( "ds_npc_cloak", oPC );
                    CreateItemOnObject( "ds_npc_armour", oPC );
                    CreateItemOnObject( "ds_npc_sword", oPC );
                }
                else{

                    //basic appearance
                    SetLocalInt     ( oItem, "ds_app", nAppearance );
                    SetLocalString  ( oItem, "ds_name", GetName( oTarget ) );
                    SetLocalString  ( oItem, "ds_portr", GetPortraitResRef( oTarget ) );
                    SetLocalString  ( oItem, "td_bio", GetDescription( oTarget ) );
                    SetLocalInt     ( oItem, "ds_tail", GetCreatureTailType( oTarget ) );
                    SetLocalInt     ( oItem, "ds_wings", GetCreatureWingType( oTarget ) );
                    SetLocalInt     ( oItem, "ds_pheno", GetPhenoType( oTarget ) );
                    SetLocalFloat   ( oItem, "ds_scale", GetObjectVisualTransform( oTarget, 10) );
                    SetLocalFloat   ( oItem, "cr_zaxis", GetObjectVisualTransform(oTarget, 33) );
                    SetLocalInt     ( oItem, "ds_set", 2 );
                }

                //chame cast spell to Self unlimited times a day.
                itemproperty iNew = ItemPropertyCastSpell( 335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );
                IPSafeAddItemProperty( oItem, iNew, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );

                SetName( oItem, "Bottled Companion" );
            }
            else if ( nType == 1 ){

                nAppearance    = GetLocalInt ( oItem, "ds_app" );
                sName          = GetLocalString( oItem, "ds_name" );
                sPortrait      = GetLocalString( oItem, "ds_portr" );
                nSex           = GetLocalInt( oItem, "ds_sex" );
                sSex           = "m_";
                sBio           = GetLocalString( oItem , "td_bio" );
                nWings         = GetLocalInt( oItem, "ds_wings" );
                nTail          = GetLocalInt( oItem, "ds_tail" );
                nPheno         = GetLocalInt( oItem, "ds_pheno" );
                scaleSet       = GetLocalFloat(oItem, "ds_scale");
                fZaxis         = GetLocalFloat( oItem, "cr_zaxis");

                if ( nSex == 1 ){

                    sSex = "f_";
                }

                sResRef     = "ds_base_npc_" + sSex + IntToString( GetLocalInt( oItem, "ds_race" ) );

                oNPC        = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), FALSE, sTag );

                for ( i=20; i>=0; --i ){

                    if ( i != 18 ){

                        nBodyPart = GetLocalInt( oItem, "ds_part_"+IntToString( i ) );

                        DelayCommand( IntToFloat( i ) / 10, SetCreatureBodyPart( i, nBodyPart, oNPC ) );
                    }
                }



                //Skin, hair and tattoo colors
                nColor = GetLocalInt( oItem, "td_skincolor" );

                if ( nColor > 0 && nColor < 176 ){

                    SetColor( oNPC, COLOR_CHANNEL_SKIN, nColor );
                }

                nColor = GetLocalInt( oItem, "td_haircolor" );

                if ( nColor > 0 && nColor < 176 ){

                    SetColor( oNPC, COLOR_CHANNEL_HAIR, nColor );
                }

                nColor = GetLocalInt( oItem, "td_tattoo1" );

                if ( nColor > 0 && nColor < 176 ){

                    SetColor( oNPC, COLOR_CHANNEL_TATTOO_1, nColor );
                }

                nColor = GetLocalInt( oItem, "td_tattoo2" );

                if ( nColor > 0 && nColor < 176 ){

                    SetColor( oNPC, COLOR_CHANNEL_TATTOO_2, nColor );
                }

                //----------------------------

                SetLocalInt( oNPC, "ds_type", 1 );
                SetName( oNPC, sName );
                if (scaleSet == 0.0) {
                    SetObjectVisualTransform(oNPC, 10, 1.0);
                }
                if (scaleSet > 0.0) {
                    SetObjectVisualTransform(oNPC, 10, scaleSet);
                }
                if (nAppearance != 0) {
                    DelayCommand( 1.0, SetCreatureAppearanceType( oNPC, nAppearance ) );
                }

                sUUID = GetObjectUUID(oNPC);

                SetLocalString (oItem, "UUID", sUUID);
                SetLocalInt (oItem, "spawned", 1);
                SetLocalObject( oNPC, "ds_master", oPC );
                SetPhenoType ( nPheno, oNPC);
                DelayCommand( 1.1, DressNPC( oPC, oNPC ) );
                DelayCommand( 3.0, SetCreatureWingType( nWings, oNPC ) );
                DelayCommand( 3.0, SetCreatureTailType( nTail, oNPC ) );
                DelayCommand( 3.0, SetPortraitResRef( oNPC, sPortrait ) );
                DelayCommand( 1.0, change_axis( oNPC, fZaxis) );

                if (GetLocalInt( oItem, "ghost") == 0){
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oNPC);
                    }

                if ( sBio != "" ){

                    DelayCommand( 6.0, SetDescription( oNPC, sBio ) );
                }
            }
            else if ( nType == 2 ){

                sName          = GetLocalString( oItem, "ds_name" );
                sPortrait      = GetLocalString( oItem, "ds_portr" );
                nAppearance    = GetLocalInt( oItem, "ds_app" );
                nWings         = GetLocalInt( oItem, "ds_wings" );
                nTail          = GetLocalInt( oItem, "ds_tail" );
                nSex           = GetLocalInt( oItem, "ds_sex" );
                sSex           = "m_";
                nPheno         = GetLocalInt( oItem, "ds_pheno" );
                sBio           = GetLocalString( oItem , "td_bio" );
                scaleSet       = GetLocalFloat(oItem, "ds_scale");
                fZaxis         = GetLocalFloat( oItem, "cr_zaxis");

                if ( nSex == 1 ){

                    sSex = "f_";
                }

                sResRef     = "ds_base_npc_" + sSex + "6";

                oNPC        = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), FALSE, sTag );

                SetName( oNPC, sName );
                if (scaleSet == 0.0) {
                    SetObjectVisualTransform(oNPC, 10, 1.0);
                }
                if (scaleSet > 0.0) {
                    SetObjectVisualTransform(oNPC, 10, scaleSet);
                }

                sUUID = GetObjectUUID(oNPC);

                SetLocalString (oItem, "UUID", sUUID);
                SetLocalInt (oItem, "spawned", 1);
                SetLocalObject( oNPC, "ds_master", oPC );
                SetLocalInt( oNPC, "ds_type", 2 );
                SetPhenoType ( nPheno, oNPC);
                DelayCommand( 1.0, SetCreatureAppearanceType( oNPC, nAppearance ) );
                DelayCommand( 2.0, SetPortraitResRef( oNPC, sPortrait ) );
                DelayCommand( 3.0, SetCreatureWingType( nWings, oNPC ) );
                DelayCommand( 4.0, SetCreatureTailType( nTail, oNPC ) );
                DelayCommand( 1.0, change_axis( oNPC, fZaxis) );

                if (GetLocalInt( oItem, "ghost") == 0){
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oNPC);
                    }

                if ( sBio != "" ){

                    DelayCommand( 4.0, SetDescription( oNPC, sBio ) );
                }
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);

}

void DressNPC( object oPC, object oNPC ){

     object oSuit       = GetItemPossessedBy( oPC, "ds_npc_suit" );
     object oArmour     = GetItemPossessedBy( oPC, "ds_npc_armour" );
     object oHelmet     = GetItemPossessedBy( oPC, "ds_npc_helm" );
     object oCloak      = GetItemPossessedBy( oPC, "ds_npc_cloak" );
     object oSword      = GetItemPossessedBy( oPC, "ds_npc_sword" );

     object oNewSuit    = CopyItem( oSuit, oNPC );

     CopyItem( oArmour, oNPC );
     CopyItem( oHelmet, oNPC );
     CopyItem( oCloak, oNPC );
     CopyItem( oSword, oNPC );

     DelayCommand( 2.0, AssignCommand( oNPC, ActionEquipItem( oNewSuit, INVENTORY_SLOT_CHEST ) ) );

}
void change_axis(object oNPC, float fZaxis){
    if (fZaxis == 0.0) {
        SetObjectVisualTransform( oNPC, 33, 0.0);
    }
    if (fZaxis != 0.0) {
        SetObjectVisualTransform( oNPC, 33, fZaxis);
    }
}
