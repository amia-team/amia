//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_action_styler
//group:   Appearance changing
//used as: action script
//date:    08/06/08
//author:  Terra
//
//-----------------------------------------------------------------------------
// Edits
//-----------------------------------------------------------------------------
//16-april-2023 Frozen  added parts for using script/conversation from widget (oItem)
//
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

void SetTattooeCheck(object oPC);
void SetSkinCheck(object oPC);
int MatchThousandFaces( object oPC, object o1kfacesitem );


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{

    int iPrice = 0;

    object oPC  = OBJECT_SELF;
    object oNPC = GetLocalObject( oPC , "ds_target" );
    object oItem    = GetLocalObject (oPC , "ds_item" );
    int iNode   = GetLocalInt( oPC , "ds_node" );
    int iNumber = 0;
    int nColorChannel;
    string sString = "";
    object Item1kfaces = GetItemPossessedBy( oPC, "100faces_init" );
    switch( d3() )
    {
    case 1:sString = "What would you like instead?";
    case 2:sString = "Something else you might want?";
    case 3:sString = "Anything else on your mind?";
    }
    SetCustomToken(7000, sString);

    switch( iNode )
    {

    case 1:SetLocalInt( oPC , "td_color_channel", COLOR_CHANNEL_HAIR );break;
    case 2:SetLocalInt( oPC , "td_color_channel", COLOR_CHANNEL_TATTOO_1 );break;
    case 3:SetLocalInt( oPC , "td_color_channel", COLOR_CHANNEL_TATTOO_2 );break;

    case 4:
    nColorChannel = GetLocalInt( oPC, "td_color_channel" );
    TakeGoldFromCreature(iPrice,oPC, TRUE);

    //If we got the 1kfaces widget we store the new hair color here
    if ( nColorChannel == COLOR_CHANNEL_HAIR && GetIsObjectValid( Item1kfaces ) ){

        if( MatchThousandFaces( oPC, Item1kfaces ) )
            SetLocalInt( Item1kfaces,"td_orginal_haircolor", GetLocalInt( oPC, "td_color_selected" ) );
        else
            SetLocalInt( Item1kfaces, "td_1kf_"+IntToString( GetAppearanceType( oPC ) )+"_"+IntToString( GetColor( oPC, COLOR_CHANNEL_SKIN ) )+"_hair", GetLocalInt( oPC, "td_color_selected" ) );
    }

    SetColor( oPC, nColorChannel, GetLocalInt( oPC, "td_color_selected" ) );

        if ( GetResRef (oItem) == "js_hairdye_kit" || GetResRef (oItem) == "js_tattoo_kit" ) {
            DestroyObject (oItem);
            SendMessageToPC (oPC, "You used up the kit.");
            }

    if ( nColorChannel == COLOR_CHANNEL_HAIR && d100() > 97 ){

        AssignCommand( oNPC, SpeakString( "Ooops! A tiny bit of your ear just went 'POOFF'! Sorry!?" ) );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( 1 ), oPC );

            if ( GetResRef (oItem) == "js_hairdye_kit" || GetResRef (oItem) == "js_tattoo_kit" ) {
                DestroyObject (oItem);
                SendMessageToPC (oPC, "You used up the kit.");
                }
    }
    else if ( ( nColorChannel == COLOR_CHANNEL_TATTOO_1 || nColorChannel == COLOR_CHANNEL_TATTOO_2 )
              && d100() > 97 ){

        AssignCommand( oNPC, SpeakString( "Ooops! Did that hurt?" ) );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( 1 ), oPC );
            if ( GetResRef (oItem) == "js_hairdye_kit" || GetResRef (oItem) == "js_tattoo_kit" ) {
                DestroyObject (oItem);
                SendMessageToPC (oPC, "You used up the kit.");
                }
    }

    break;

    case 5:
    AssignCommand(OBJECT_SELF,ActionPauseConversation());
    SetLocalInt(oPC, "td_styler_listener", TRUE);
    //SendMessageToPC(oPC, "Speak the referance number into the <cþ  >SHOUT</c  channel now.");
    FloatingTextStringOnCreature("Speak the referance number into the <c þ >SHOUT</c  channel now.",oPC,FALSE);
    break;

    case 6:
    iNumber = StringToInt(GetLocalString( oPC , "td_color_chat" ));
    if(iNumber < 0) iNumber = 0;
    if(iNumber > 175) iNumber = 175;
    SetCustomToken(7001, IntToString(iNumber));
    SetLocalInt(oPC, "td_color_selected", iNumber);
    DeleteLocalString(oPC, "td_color_chat");
    break;

    case 7:SetTattooeCheck( oPC );

    break;

    case 8:SetSkinCheck( oPC );

    break;

    case 9:
    TakeGoldFromCreature(iPrice,oPC, TRUE);
    SetCreatureBodyPart(GetLocalInt(oPC, "td_tattooe_target"), GetLocalInt(oPC, "td_skintype"), oPC);
        if ( GetResRef (oItem) == "js_hairdye_kit" || GetResRef (oItem) == "js_tattoo_kit" ) {
            DestroyObject (oItem);
            SendMessageToPC (oPC, "You used up the kit.");
            }
    if( d100() > 90 )
    {
    AssignCommand( oNPC, SpeakString( "Ooops! Did that sting?" ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( 1 ), oPC );
    }
    break;

    case 10:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_RIGHT_SHIN);break;
    case 11:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_LEFT_SHIN);break;
    case 12:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_RIGHT_THIGH);break;
    case 13:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_LEFT_THIGH);break;
    case 14:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_PELVIS);break;
    case 15:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_TORSO);break;
    case 16:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_RIGHT_BICEP);break;
    case 17:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_RIGHT_FOREARM);break;
    case 18:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_LEFT_BICEP);break;
    case 19:SetLocalInt( oPC, "td_tattooe_target", CREATURE_PART_LEFT_FOREARM);break;

    default:break;
    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

void SetTattooeCheck(object oPC)
{
    SetLocalInt( oPC, "td_skintype" , 1 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oPC) == 2)
    SetLocalInt( oPC, "ds_check_10", 1 );
    else SetLocalInt( oPC, "ds_check_10", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPC) == 2)
    SetLocalInt( oPC, "ds_check_11", 1 );
    else SetLocalInt( oPC, "ds_check_11", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, oPC) == 2)
    SetLocalInt( oPC, "ds_check_12", 1 );
    else SetLocalInt( oPC, "ds_check_12", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, oPC) == 2)
    SetLocalInt( oPC, "ds_check_13", 1 );
    else SetLocalInt( oPC, "ds_check_13", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_PELVIS, oPC) == 2)
    SetLocalInt( oPC, "ds_check_14", 1 );
    else SetLocalInt( oPC, "ds_check_14", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_TORSO, oPC) == 2)
    SetLocalInt( oPC, "ds_check_15", 1 );
    else SetLocalInt( oPC, "ds_check_15", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oPC) == 2)
    SetLocalInt( oPC, "ds_check_16", 1 );
    else SetLocalInt( oPC, "ds_check_16", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oPC) == 2)
    SetLocalInt( oPC, "ds_check_17", 1 );
    else SetLocalInt( oPC, "ds_check_17", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oPC) == 2)
    SetLocalInt( oPC, "ds_check_18", 1 );
    else SetLocalInt( oPC, "ds_check_18", 0 );


    if(GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oPC) == 2)
    SetLocalInt( oPC, "ds_check_19", 1 );
    else SetLocalInt( oPC, "ds_check_19", 0 );

}

void SetSkinCheck(object oPC)
{
    SetLocalInt( oPC, "td_skintype" , 2 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, oPC) == 1)
    SetLocalInt( oPC, "ds_check_10", 1 );
    else SetLocalInt( oPC, "ds_check_10", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPC) == 1)
    SetLocalInt( oPC, "ds_check_11", 1 );
    else SetLocalInt( oPC, "ds_check_11", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, oPC) == 1)
    SetLocalInt( oPC, "ds_check_12", 1 );
    else SetLocalInt( oPC, "ds_check_12", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, oPC) == 1)
    SetLocalInt( oPC, "ds_check_13", 1 );
    else SetLocalInt( oPC, "ds_check_13", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_PELVIS, oPC) == 1)
    SetLocalInt( oPC, "ds_check_14", 1 );
    else SetLocalInt( oPC, "ds_check_14", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_TORSO, oPC) == 1)
    SetLocalInt( oPC, "ds_check_15", 1 );
    else SetLocalInt( oPC, "ds_check_15", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, oPC) == 1)
    SetLocalInt( oPC, "ds_check_16", 1 );
    else SetLocalInt( oPC, "ds_check_16", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, oPC) == 1)
    SetLocalInt( oPC, "ds_check_17", 1 );
    else SetLocalInt( oPC, "ds_check_17", 0 );

    if(GetCreatureBodyPart(CREATURE_PART_LEFT_BICEP, oPC) == 1)
    SetLocalInt( oPC, "ds_check_18", 1 );
    else SetLocalInt( oPC, "ds_check_18", 0 );


    if(GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, oPC) == 1)
    SetLocalInt( oPC, "ds_check_19", 1 );
    else SetLocalInt( oPC, "ds_check_19", 0 );

}


int MatchThousandFaces( object oPC, object o1kfacesitem ){

    int nHair = GetLocalInt( o1kfacesitem, "td_orginal_haircolor" );
    int nSkin = GetLocalInt( o1kfacesitem, "td_orginal_skincolor" );
    int nAppr = GetLocalInt( o1kfacesitem, "cs_original_appearance" );
    int nHead = GetLocalInt( o1kfacesitem , "cs_original_head" );

    if( nHair == GetColor( oPC, COLOR_CHANNEL_HAIR ) &&
        nSkin == GetColor( oPC, COLOR_CHANNEL_SKIN ) &&
        nAppr == GetAppearanceType( oPC )            &&
        nHead == GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) )
        return TRUE;

    return FALSE;
}

