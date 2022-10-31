//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_fan
//group:   widgets
//used as: activation script
//date:    oct 10 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DressNPC( object oPC, object oNPC );


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
            string sName;
            string sPortrait;
            string sSex;
            string sResRef;
            string sBio;
            object oNPC      = GetObjectByTag( sTag );
            int nType        = GetLocalInt( oItem, "ds_set" );
            int nRace        = GetRacialType( oTarget );
            int nAppearance;
            int nBodyPart;
            int nWings;
            int nTail;
            int nSex;
            int nColor;


            if ( GetIsObjectValid( oNPC ) ){

                DestroyObject( oNPC );
                return;
            }

            if ( nType == 0 ){

                //inititalise item
                nAppearance  = GetAppearanceType( oTarget );

                if ( nAppearance <= 7 ){

                    //playable race
                    for ( i=0; i<21; ++i ){

                        nBodyPart = GetCreatureBodyPart( i, oTarget );

                        if ( i != 18 ){

                            SetLocalInt( oItem, "ds_part_"+IntToString( i ), nBodyPart );
                        }
                    }

                    //1.69 new!
                    SetLocalInt( oItem, "td_skincolor", GetColor( oTarget, COLOR_CHANNEL_SKIN ) );
                    SetLocalInt( oItem, "td_haircolor", GetColor( oTarget, COLOR_CHANNEL_HAIR ) );
                    SetLocalInt( oItem, "td_tattoo1", GetColor( oTarget, COLOR_CHANNEL_TATTOO_1 ) );
                    SetLocalInt( oItem, "td_tattoo2", GetColor( oTarget, COLOR_CHANNEL_TATTOO_2 ) );
                    SetLocalInt( oItem, "ds_wings", GetCreatureWingType( oTarget ) );
                    SetLocalInt( oItem, "ds_tail", GetCreatureTailType( oTarget ) );
                    SetLocalInt( oItem, "ds_race", nRace );
                    SetLocalInt( oItem, "ds_sex", GetGender( oTarget ) );
                    SetLocalFloat( oItem, "ds_scale", GetObjectVisualTransform( oTarget, 10) );
                    SetLocalString( oItem, "ds_name", GetName( oTarget ) );
                    SetLocalString( oItem, "ds_portr", GetPortraitResRef( oTarget ) );
                    SetLocalString( oItem, "td_bio", GetDescription( oTarget ) );
                    SetLocalInt( oItem, "ds_set", 1 );

                    CreateItemOnObject( "ds_npc_suit", oPC );
                    CreateItemOnObject( "ds_npc_helm", oPC );
                    CreateItemOnObject( "ds_npc_cloak", oPC );
                    CreateItemOnObject( "ds_npc_armour", oPC );
                    CreateItemOnObject( "ds_npc_sword", oPC );
                }
                else{

                    //basic appearance
                    SetLocalInt( oItem, "ds_app", nAppearance );
                    SetLocalString( oItem, "ds_name", GetName( oTarget ) );
                    SetLocalString( oItem, "ds_portr", GetPortraitResRef( oTarget ) );
                    SetLocalString( oItem, "td_bio", GetDescription( oTarget ) );
                    SetLocalInt( oItem, "ds_tail", GetCreatureTailType( oTarget ) );
                    SetLocalInt( oItem, "ds_set", 2 );
                }

                //chame cast spell to Self unlimited times a day.
                itemproperty iNew = ItemPropertyCastSpell( 335, IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE );
                IPSafeAddItemProperty( oItem, iNew, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, TRUE, TRUE );

                SetName( oItem, "Bottled Companion" );
            }
            else if ( nType == 1 ){

                sName          = GetLocalString( oItem, "ds_name" );
                sPortrait      = GetLocalString( oItem, "ds_portr" );
                nSex           = GetLocalInt( oItem, "ds_sex" );
                sSex           = "m_";
                sBio           = GetLocalString( oItem , "td_bio" );
                nWings         = GetLocalInt( oItem, "ds_wings" );
                nTail          = GetLocalInt( oItem, "ds_tail" );

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
                float scaleSet = GetLocalFloat(oItem, "ds_scale");

                SetLocalInt( oNPC, "ds_type", 1 );
                SetName( oNPC, sName );
                if (scaleSet == 0.0) {
                    SetObjectVisualTransform(oNPC, 10, 1.0);
                }
                if (scaleSet > 0.0) {
                    SetObjectVisualTransform(oNPC, 10, scaleSet);
                }
                SetLocalObject( oNPC, "ds_master", oPC );
                DelayCommand( 1.0, DressNPC( oPC, oNPC ) );
                DelayCommand( 3.0, SetCreatureWingType( nWings, oNPC ) );
                DelayCommand( 4.0, SetCreatureTailType( nTail, oNPC ) );
                DelayCommand( 5.0, SetPortraitResRef( oNPC, sPortrait ) );

                if ( sBio != "" ){

                    DelayCommand( 6.0, SetDescription( oNPC, sBio ) );
                }
            }
            else if ( nType == 2 ){

                sName          = GetLocalString( oItem, "ds_name" );
                sPortrait      = GetLocalString( oItem, "ds_portr" );
                nAppearance    = GetLocalInt( oItem, "ds_app" );
                nSex           = GetLocalInt( oItem, "ds_sex" );
                sSex           = "m_";
                sBio           = GetLocalString( oItem , "td_bio" );

                if ( nSex == 1 ){

                    sSex = "f_";
                }

                sResRef     = "ds_base_npc_" + sSex + "6";

                oNPC        = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), FALSE, sTag );

                SetName( oNPC, sName );
                SetLocalObject( oNPC, "ds_master", oPC );
                SetLocalInt( oNPC, "ds_type", 2 );
                DelayCommand( 1.0, SetCreatureAppearanceType( oNPC, nAppearance ) );
                DelayCommand( 2.0, SetPortraitResRef( oNPC, sPortrait ) );

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

