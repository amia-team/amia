//-------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------
#include "cs_inc_leto"
#include "inc_td_appearanc"
#include "inc_ds_j_lib"
#include "inc_td_sysdata"
#include "amia_include"
#include "nwnx_areas"
#include "nwnx_messages"
#include "nwnx_dynres"
#include "inc_language"
#include "inc_td_rest"
#include "fw_include"
#include "x3_inc_string"
#include "nwnx_creature"
#include "nwnx_chat"
#include "inc_dc_api"
#include "area_load"
#include "inc_player_api"
//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void f_Help( object oPC );
void f_Name( object oPC, object oObject, string sOption, string sValue );
void f_Bio( object oPC, object oObject, string sOption, string sValue );
void f_Deity( object oPC, object oObject, string sOption, string sValue );
void f_FindPC( object oPC, object oObject, string sOption, string sValue );
void f_PlatRace( object oPC, object oObject, string sOption, string sValue );
void f_Portrait( object oPC, object oObject, string sOption, string sValue );
void f_Say( object oPC, object oObject, string sOption, string sValue );
void f_SignWidget( object oPC, object oObject, string sOption, string sValue );
void f_Skin( object oPC, object oObject, string sOption, string sValue );
void f_SkinColor( object oPC, object oObject, string sOption, string sValue );
void f_Tattoo1( object oPC, object oObject, string sOption, string sValue );
void f_Tattoo2( object oPC, object oObject, string sOption, string sValue );
void f_SkinColor( object oPC, object oObject, string sOption, string sValue );
void f_HairColor( object oPC, object oObject, string sOption, string sValue );
void f_Tail( object oPC, object oObject, string sOption, string sValue );
void f_Wings( object oPC, object oObject, string sOption, string sValue );
void f_Horns( object oPC, object oObject, string sOption, string sValue );
void f_Head( object oPC, object oObject, string sOption, string sValue );
void f_Targets( object oPC, string sOption );
void f_PCName( object oPC, object oObject, string sOption, string sValue );
void f_Eyes( object oPC, object oObject, string sOption, string sValue );
void f_Ring( object oPC, object oObject, string sOption, string sValue );
void f_Voice( object oPC, string sOption, string sValue );
void f_PlayerBio( object oPC, string sOption, string sValue );
void f_file( object oPC );
void f_Love( object oPC, object oObject, string sOption, string sValue );
void f_Hate( object oPC, object oObject, string sOption, string sValue );
void f_Note( object oPC, string sOption, string sValue );
void f_Pheno( object oPC, string sOption, string sValue );
void f_AddFeat( object oPC, string sOption, string sValue );
void f_RemoveFeat( object oPC, string sOption, string sValue );
void f_Gender(object oPC, string sOption, string sValue);
void f_SetReloadtime( object oPC, string sValue );
void f_debuff( object oPC );
void f_Hostile(object oPC);
void f_Friend(object oPC);
void f_testwidget(object oPC);
void f_UpdateArea(object oPC);
void f_Plain( object oPC );
void f_Examine( object oPC, string sValue );
void f_Tools( object oPC );
void f_playertools( object oPC, object oObject, string sOption, string sValue );
void f_selene( object oPC );
void f_area( object oPC, string sOption, string sValue );
void f_race(object oPC, object oObject, string sOption );
void f_dreamcoins(object oPC, object oObject, string sValue);
void f_givedc(object oPC, object oObject, string sValue);
void f_takedc(object oPC, object oObject, string sValue);
void f_jsname( object oPC, object oObject, string sOption, string sValue );
void f_jsbio( object oPC, object oObject, string sOption, string sValue );
void f_ban(string sValue);
void f_unban(string sValue);

//utility stuff
void CheckAppearance( object oPC, string sSearch, int nAppearance );
string GetAppearanceName( int nAppearance );
void CheckTail( object oPC, string sSearch, int nTail );
string GetTailName( int nTail );
void CheckWing( object oPC, string sSearch, int nWing );
string GetWingName( int nWing );
string CatchCurrentlyUsedBic( object oPC );
string StripBic( string sFile );
void FileTriggerFunction( object oPC, string sOption, string sValue );
void SafeDebuff( object oPC );
int GetIsNonMalignSpellEffect( effect eEffect );
void RefreshArea( object oArea );

object GetPCNearestToCaller(object oPC);

//Listeners
void ColorListener( object oPC, string sMessage );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    object oPC          = GetPCChatSpeaker();
    string sMessage     = GetPCChatMessage();
    int nSpace          = 0;
    int nLength         = 0;
    int nTarget         = 0;
    int i               = 1;
    string sCommand     = "";
    string sParameters  = "";
    string sOption      = "";
    string sValue       = "";
    object oObject      = OBJECT_INVALID;
    int nMessageLength = GetStringLength(sMessage);
    string sSubShout = GetSubString(sMessage,11,nMessageLength);
    //help functions
    if ( sMessage == "?" || GetStringLowerCase( sMessage ) == "help" ){

        DelayCommand( 0.1, f_Help( oPC ) );
        SetPCChatMessage( "" );
        return;
    }

    if ( GetStringLeft( sMessage, 2 ) != "f_" ){

        if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) || GetLocalInt( oPC, "dev_shout_next" )){

            //see if we can override shouting blocks
            SetPCChatVolume( TALKVOLUME_SHOUT );
            SetPCChatMessage( sMessage );
            return;
        }
        else if((GetStringLeft( sMessage, 10 ) == "m_invasion"))
        {
            //see if we can override shouting blocks
            SetPCChatVolume( TALKVOLUME_SHOUT );
            SetPCChatMessage( sSubShout );
            return;
        }
        else if ( GetStringLeft( sMessage, 4 ) == "ds_j" ){

            ds_j_Scribe( oPC, sMessage );
            SetPCChatVolume( TALKVOLUME_TALK );
            return;
        }
        else {

            //Listen, does nothing unless td_styler_listener == TRUE
            ColorListener( oPC, GetPCChatMessage() );
            SetPCChatMessage( "" );
            return;
        }
    }

    //filter f_
    nLength  = GetStringLength( sMessage );
    sMessage = GetSubString( sMessage, 2, nLength );

    //feedback
    SetPCChatVolume( TALKVOLUME_TELL );
    SetPCChatMessage(  "Command: "+sMessage );

    //parse input
    nSpace       = FindSubString( sMessage, " " );
    sCommand     = GetStringLowerCase( GetStringLeft( sMessage, nSpace ) );
    sParameters  = GetSubString( sMessage, nSpace+1, nLength-2 );

    if ( nSpace == -1 ){

        sCommand = GetStringLowerCase( sMessage );
    }
    else{

        nLength      = GetStringLength( sParameters );
        nSpace       = FindSubString( sParameters, " " );
        sOption      = GetStringLowerCase( GetStringLeft( sParameters, nSpace ) );
        sValue       = GetSubString( sParameters, nSpace+1, nLength );

        if ( nSpace == -1 ){

            sOption = GetStringLowerCase( sParameters );
        }
    }

    if ( sOption == "item" ){

        oObject = GetNearestObject( OBJECT_TYPE_ITEM, oPC );
    }
    else if ( sOption == "npc" ){

        oObject = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    }
    else if ( sOption == "plc" ){

        oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPC );

        while ( !GetUseableFlag( oObject ) && GetIsObjectValid( oObject ) ){

            ++i;

            oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPC, i );
        }
    }
    else if ( sOption == "pc" || sOption == "first" || sOption == "last" ){

        oObject = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    }
    else {

        oObject = oPC;
    }

    //run function
    if ( sCommand != "" && GetIsObjectValid( oObject ) ){

        //Shameless hack for testing
        string sAcc = GetPCPlayerName( oPC );
        if( GetIsDM(oPC) || GetDMStatus( sAcc, GetPCPublicCDKey( oPC ) ) >= 1){

            if( sCommand == "reload" ){

                DelayCommand( 0.1, f_SetReloadtime( oPC, sValue ) );
            }
            else if( sCommand == "message" ){

                if( !GetLocalInt( oPC, "dev_shout_next" ) ){
                    SetLocalInt( oPC, "dev_shout_next", TRUE );
                    SendMessageToPC( oPC, "Shout/DM channel activated!" );
                }
                else{

                    SetLocalInt( oPC, "dev_shout_next", FALSE );
                    SendMessageToPC( oPC, "Shout/DM channel de-activated!" );
                }
            }
            else if( sCommand == "detach" ){

                ExecuteScript( "toggle_attached", oPC );
            }
            else if( sCommand == "test" ){

                DelayCommand( 0.1, f_testwidget( oPC ) );
            }
            else if( sCommand == "update" ){

                SendMessageToPC( oPC, "Attempting to rebuild area: "+GetName( GetArea( oPC ) ) );
                DelayCommand( 0.1, f_UpdateArea( oPC ) );
            }
            else if( sCommand == "tools" ){

                DelayCommand( 0.1, f_Tools( oPC ) );
            }
            else if (sCommand == "area" ) {
                DelayCommand( 0.1, f_area( oPC, sOption, sValue ) );
            }
            else if (sCommand == "selene" ) {
                DelayCommand( 0.1, f_selene( oPC ) );
            }
            else if(sCommand == "dreamcoins") {
                oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC);
                DelayCommand(0.1, f_dreamcoins(oPC, oObject, sValue));
            }
            else if(sCommand == "givedc") {
                oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC);
                DelayCommand(0.1, f_givedc(oPC, oObject, sValue));
            }
            else if(sCommand == "takedc") {
                oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC);
                DelayCommand(0.1, f_takedc(oPC, oObject, sValue));
            }
            else if(sCommand == "CreateArea"){
                DelayCommand(0.1, recreate_area(sValue));
            }
            else if (sCommand == "ban")
            {
                DelayCommand(0.1, f_ban(sValue));
            }
            else if (sCommand == "unban")
            {
                DelayCommand(0.1, f_unban(sValue));
            }
        }

        //block on non-DM stuff
        if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

            if ( sCommand == "voice" ){

                DelayCommand( 0.1, f_Voice( oPC, sOption, sValue ) );
            }
            else if( sCommand == "examine" ){

                DelayCommand( 0.1, f_Examine( oPC, sValue ) );
            }
            else if ( sCommand == "bio" ){

                DelayCommand( 0.1, f_PlayerBio( oPC, sOption, sValue ) );
            }
            else if ( sCommand == "note" ){

                DelayCommand( 0.1, f_Note( oPC, sOption, sValue ) );
            }
            else if( sCommand == "debuff" ){

                DelayCommand( 0.1, f_debuff( oPC ) );
            }
            else if( sCommand == "plain" ){

                DelayCommand( 0.1, f_Plain( oPC ) );
            }
            else if ( sCommand == "file" ){

                DelayCommand( 0.1, f_file( oPC ) );
            }
            else if (sCommand == "playertools" ) {
                DelayCommand( 0.1, f_playertools( oPC, oObject, sOption, sValue));
            }
            else if ( sCommand == "jsname" ){

            DelayCommand( 0.1, f_jsname( oPC, oObject, sOption, sValue ));
            }
            else if ( sCommand == "jsbio" ){

            DelayCommand( 0.1, f_jsbio( oPC, oObject, sOption, sValue ));
            }
            else if (sCommand == "hostile" ){
                DelayCommand( 0.1, f_Hostile( oPC ) );
            } else if (sCommand == "friend"){
                DelayCommand( 0.1, f_Friend( oPC ) );
            }
            return;
        }

        if ( sCommand == "name" ){

            DelayCommand( 0.1, f_Name( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "pheno" ){

            DelayCommand( 0.1, f_Pheno( oPC, sOption, sValue ) );
        }
        else if ( sCommand == "addfeat" ){

            DelayCommand( 0.1, f_AddFeat( oPC, sOption, sValue ) );
        }
        else if ( sCommand == "removefeat" ){

            DelayCommand( 0.1, f_RemoveFeat( oPC, sOption, sValue ) );
        }
        else if ( sCommand == "gender"){
            DelayCommand( 0.1, f_Gender( oPC, sOption, sValue ) );
        }
        else if ( sCommand == "bio" ){

            DelayCommand( 0.1, f_Bio( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "skin" ){

            DelayCommand( 0.1, f_Skin( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "skincolor" ){

            DelayCommand( 0.1, f_SkinColor( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "tattoo1" ){

            DelayCommand( 0.1, f_Tattoo1( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "tattoo2" ){

            DelayCommand( 0.1, f_Tattoo2( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "haircolor" ){

            DelayCommand( 0.1, f_HairColor( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "tail" ){

            DelayCommand( 0.1, f_Tail( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "wings" ){

            DelayCommand( 0.1, f_Wings( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "head" ){

            DelayCommand( 0.1, f_Head( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "targets" ){

            DelayCommand( 0.1, f_Targets( oPC, sOption ) );
        }
        else if ( sCommand == "pcname" ){

            DelayCommand( 0.1, f_PCName( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "deity" ){

            DelayCommand( 0.1, f_Deity( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "findpc" ){

            DelayCommand( 0.1, f_FindPC( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "platrace" ){

            DelayCommand( 0.1, f_PlatRace( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "say" ){

            DelayCommand( 0.1, f_Say( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "portrait" ){

            DelayCommand( 0.1, f_Portrait( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "eyes" ){

            DelayCommand( 0.1, f_Eyes( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "horns" ){

            DelayCommand( 0.1, f_Horns( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "signwidget" ){

            DelayCommand( 0.1, f_SignWidget( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "ring" ){

            DelayCommand( 0.1, f_Ring( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "love" ){

            DelayCommand( 0.1, f_Love( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "hate" ){

            DelayCommand( 0.1, f_Hate( oPC, oObject, sOption, sValue ) );
        }
        else if ( sCommand == "note" ){

            DelayCommand( 0.1, f_Note( oPC, sOption, sValue ) );
        }
        else if( sCommand == "plain" ){

            DelayCommand( 0.1, f_Plain( oPC ) );
        }
        else if ( sCommand == "race" ) {
            DelayCommand( 0.1, f_race( oPC, oObject, sOption ) );
        }
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void f_Help( object oPC ){

    if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

        SendMessageToPC( oPC, "Functions are shown as f_Function [argument 1][argument 2]. Options are separated by commas, and ranges are given by the minus sign. You can use 'help' or '?' as the first argument to get a detailed explanation of a function. The function name and the first argument are case-insensitive.\n\nFunction list:" );
        SendMessageToPC( oPC, " f_plain - Toggles on and off plainchat (no colors)." );
        SendMessageToPC( oPC, " f_Bio [R,B,N,A][Text] - Use this to edit your bio." );
        SendMessageToPC( oPC, " f_Voice [C,F,S,D,B,V[Text] - Use this to make companions, familiars, summons, dominated, bottled-companions or vassals say things." );
        SendMessageToPC( oPC, " f_File is temporarily disabled." );
        SendMessageToPC( oPC, " f_Note [New,Add,Remove,Load,List][Text] - Deals with persistent map pins and note." );
        SendMessageToPC( oPC, " f_debuff - Removes all positive buffs from your character." );
        SendMessageToPC( oPC, " f_examine [hide,rclaw,lcraw,bite,hand]- Examine your creature hide." );
        SendMessageToPC( oPC, " f_fetch - Brings all of your summons to your side. Good for getting them un-stuck from terrain.");
        SendMessageToPC( oPC, " f_stuck - Moves you from a stuck location to a hidden waypoint somewhere in the map. Only works in hunting areas.");
        SendMessageToPC( oPC, " f_jsname - If you have a permitted item, use this command to set the name after you drop it on the ground. This will change the item's name. See the forum for a list of all permitted items.");
        SendMessageToPC( oPC, " f_jsbio [N,A,B] - If you have a permitted item, use this command to set the bio after you drop it on the ground. This will change the item's description. [N] will create a new description. [A] will append additional text to the description. [Break] will insert a double line-break. See the forum for a list of all permitted items.");
        return;
    }

    SendMessageToPC( oPC, "Functions are shown as f_Function [argument 1][argument 2]. Options are separated by commas, and ranges are given by the minus sign. You can use 'help' or '?' as the first argument to get a detailed explanation of a function. The function name and the first argument are case-insensitive.\n\nFunction list:" );
    SendMessageToPC( oPC, " f_Bio [Self,PC,NPC,Item,PLC][New Description] - Sets target's description. See instructions!" );
    SendMessageToPC( oPC, " f_Deity [Self,PC][New Deity] - Sets target's deity." );
    SendMessageToPC( oPC, " f_Eyes [Self,PC,NPC][T,P] [color] - Gives the target glowing eyes, f_Eyes ? for more." );
    SendMessageToPC( oPC, " f_Horns [Self,PC,NPC]] [type] - Gives the target a widget to assign them horns, f_Horns ? for more." );
    SendMessageToPC( oPC, " f_FindPC [Account,Align,Area,Deity,Level,Name,Race][Search Phrase] - Searches for players that match the search term and option." );
    SendMessageToPC( oPC, " f_HairColor [Self,PC,NPC][0-175] - Sets target's hair color." );
    SendMessageToPC( oPC, " f_Hate [Self,PC,NPC][H,C,M,D] - Makes target hate(d by) creatures of a standard faction." );
    SendMessageToPC( oPC, " f_Head [Self,PC,NPC][0-145] - Sets target's head." );
    SendMessageToPC( oPC, " f_Love [Self,PC,NPC][H,C,M,D] - Makes target love(d by) creatures of a standard faction." );
    SendMessageToPC( oPC, " f_Name [PC,NPC,Item,PLC][New Name] - Sets target's name." );
    SendMessageToPC( oPC, " f_Note [New,Add,Remove,Load,List][Text] - Deals with persistent map pins and note." );
    SendMessageToPC( oPC, " f_PCName [First,Last][New Name] - Sets the closests PC's name." );
    SendMessageToPC( oPC, " f_race [PC][#] - Sets the racial type of closest PC." );
    SendMessageToPC( oPC, " f_PlatRace [Self,PC] [Authorise] - Authorises a platinum race. " );
    SendMessageToPC( oPC, " f_Portrait [Self,PC,NPC,Item,PLC] [1-1300] - Changes portraits." );
    SendMessageToPC( oPC, " f_Ring [Self,PC,NPC,PLC] [Deity] - Creates deity ring." );
    SendMessageToPC( oPC, " f_Say [PC,NPC,PLC] [text] - Assigns text to nearby objects." );
    SendMessageToPC( oPC, " f_SignWidget [Self,PC] [sign name] - Creates a widget that spawns a sign." );
    SendMessageToPC( oPC, " f_Skin [Self,PC,NPC][0-305,350-370,374-481,869-870] - Sets target's appearance." );
    SendMessageToPC( oPC, " f_SkinColor [Self,PC,NPC][0-175] - Sets target's skin color." );
    SendMessageToPC( oPC, " f_Tail [Self,PC,NPC][0-15] - Sets target's tail." );
    SendMessageToPC( oPC, " f_Targets [][] - Shows nearest targets." );
    SendMessageToPC( oPC, " f_Tattoo1 [Self,PC,NPC][0-175] - Sets target's tattoo 1 color." );
    SendMessageToPC( oPC, " f_Tattoo2 [Self,PC,NPC][0-175] - Sets target's tattoo 2 color." );
    SendMessageToPC( oPC, " f_Wings [Self,PC,NPC][0-6,59-89] - Sets target's wings." );
    SendMessageToPC( oPC, " f_Reload [###] - Sets the time in seconds until the server will reset. Cannot be less then 60." );
    SendMessageToPC( oPC, " f_Pheno [Self,PC,NPC][##] - Sets target's phenotype." );
    SendMessageToPC( oPC, " f_Test [][] - Spawns/despawns the test widget on yourself." );
    SendMessageToPC( oPC, " f_Update [][] - Attempts rebuilding the area you're currently in with a fresh one from the modfile." );
    SendMessageToPC( oPC, " f_tools [][] - Opens a list of tools you can spawn on yourself." );
    SendMessageToPC( oPC, " f_playertools [Self,Target,Option,Value] - Spawn specified player tool on self." );
    SendMessageToPC( oPC, " f_area [Self,Option,Value] - List Areas with Verbose. Usage: /s f_area find cordor" );
    SendMessageToPC( oPC, "\nNB: some functions also have a search option for finding possible values of argument 2. See the help option of the individual functions for more info." );
}

void f_race( object oPC, object oObject, string sOption ) {

    SendMessageToPC( oPC, "Target: " + GetName( oObject ) + " has racial type: " + IntToString( GetRacialType( oObject) ) );

    if ( sOption == "?" || sOption == "help" || sOption == "" ){

        SendMessageToPC( oPC, "Usage: f_race #\nRace Options: 0: RACIAL_TYPE_DWARF\n1:RACIAL_TYPE_ELF\n2:RACIAL_TYPE_GNOME\n3: RACIAL_TYPE_HALFLING\n4: RACIAL_TYPE_HALFELF\n5: RACIAL_TYPE_HALFORC\n6: RACIAL_TYPE_HUMAN\n7: RACIAL_TYPE_ABERRATION\n8: RACIAL_TYPE_ANIMAL\n9: RACIAL_TYPE_BEAST" );
        SendMessageToPC( oPC, "10: RACIAL_TYPE_CONSTRUCT\n11: RACIAL_TYPE_DRAGON\n12: RACIAL_TYPE_HUMANOID_GOBLINOID\n13: RACIAL_TYPE_HUMANOID_MONSTROUS\n14: RACIAL_TYPE_HUMANOID_ORC\n15: RACIAL_TYPE_HUMANOID_REPTILIAN\n16: RACIAL_TYPE_ELEMENTAL\n17: RACIAL_TYPE_FEY\n18: RACIAL_TYPE_GIANT\n19: RACIAL_TYPE_MAGICAL_BEAST" );
        SendMessageToPC( oPC, "20: RACIAL_TYPE_OUTSIDER\n23: RACIAL_TYPE_SHAPECHANGER\n24: RACIAL_TYPE_UNDEAD\n 25: RACIAL_TYPE_VERMIN\n28: RACIAL_TYPE_ALL/INVALID\n29: RACIAL_TYPE_OOZE" );
        return;
    }
    // minor validation
    if(FindSubString("|0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|23|24|25|29|", "|"+sOption+"|") <0) return;

    RunLua("nwn.SetRace('"+ObjectToString(oObject)+"', "+sOption+")");
    SendMessageToPC( oPC, "Target: " + GetName( oObject ) + " was switched to racial type: " + sOption );
}

void f_selene( object oPC ) {
    object oItem = GetObjectByTag("testwidget");
    int nAppearance  = GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 );
    //who owns this item?
    object oItemBearer = GetItemPossessor( oItem );
    SendMessageToPC(oPC, "Object appearance is: " + IntToString(nAppearance) );
    SendMessageToPC(oPC, "Item Bearer is : " + GetName( oItemBearer ) );
}

void f_area( object oPC, string sOption, string sValue ) {
    recreate_area(sOption);
}

void f_playertools( object oPC, object oObject, string sOption, string sValue ){
    if(!GetIsDM(oPC))
    {
       if(!GetHasFeat( 1106, oPC ))
       {
            DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1106) );
            SendMessageToPC(oPC, "<c���>~ Associate Tool Added ~</c>");
       }
    }

    else
    {
        SendMessageToPC(oPC, "More features will come soon.");
    }

}

void f_Tools( object oPC ){

    int nEntries = 10;

    SetLocalInt( oPC, "ds_check_40", FALSE );

    int n;
    for( n=0;n<nEntries;n++ ){

        SetLocalInt( oPC, "ds_check_"+IntToString( n+1 ), FALSE );
    }

    SQLExecDirect( "SELECT name,val FROM pwdata WHERE player='-' AND tag ='TOOL_LIST' LIMIT 10" );

    n=0;
    while( SQLFetch() ){

        SetCustomToken( 48110+(n++), SQLGetData( 1 ) );
        SetLocalInt( oPC, "ds_check_"+IntToString( n ), TRUE );
        SetLocalString( oPC, "tool_list_"+IntToString( n ), SQLGetData( 2 ) );
        if( n == nEntries ){
            SetLocalInt( oPC, "tool_next", 1 );
            break;
        }
    }

    SetLocalString( oPC, "ds_action", "td_act_tools" );
    AssignCommand( oPC, ActionStartConversation( oPC, "tool_list", TRUE, FALSE ) );
}

void f_Examine( object oPC, string sValue ){

    int nInv = INVENTORY_SLOT_CARMOUR;
    if( sValue == "rclaw" )
        nInv = INVENTORY_SLOT_CWEAPON_R;
    else if( sValue == "lclaw" )
        nInv = INVENTORY_SLOT_CWEAPON_L;
    else if( sValue == "bite" )
        nInv = INVENTORY_SLOT_CWEAPON_B;
    else if( sValue == "hand" )
        nInv = INVENTORY_SLOT_RIGHTHAND;

    object oHide = GetItemInSlot( nInv, oPC );
    if( !GetIsObjectValid( oHide ) )
        SendMessageToPC( oPC, "You don't have a creature hide/weapon!" );
    else
        AssignCommand( oPC, ActionExamine( oHide ) );
}

void f_Plain( object oPC ){

    if( GetLocalInt( oPC, "CHAT_PLAIN" ) ){
        SetLocalInt( oPC, "CHAT_PLAIN", FALSE );
        SendMessageToPC( oPC, "Plain is off!" );
    }
    else{
        SetLocalInt( oPC, "CHAT_PLAIN", TRUE );
        SendMessageToPC( oPC, "Plain is on!" );
    }
}

void f_debuff( object oPC ){

    SafeDebuff( oPC );
}

void f_SetReloadtime( object oPC, string sValue ){

    object oModule  = GetModule( );
    int nTime       = GetRunTime( );
    int nReload     = GetLocalInt( oModule, "AutoReload" );
    int nModTime    = StringToInt( sValue )+1;

    if( GetLocalInt( oModule, "ds_closing" ) )
        return;

    if( nModTime <= 60 ){

        SendMessageToPC( oPC, "Cannot set reload time to less then 60 seconds" );
        return;
    }

    SendMessageToPC( oPC, "Server will reset at runtime: "+IntToString( nTime + nModTime ) );

    SetLocalInt( oModule, "AutoReload", nTime + nModTime );
}

void f_Pheno( object oPC, string sOption, string sValue ){

    object oObj = oPC;

    if( sOption == "pc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    }
    else if( sOption == "npc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    }

    SetPhenoType( StringToInt( sValue ), oObj );
    SendMessageToPC( oPC, "Set "+GetName( oObj )+"'s pheno type to: "+IntToString( StringToInt( sValue ) ) );
}

void f_AddFeat( object oPC, string sOption, string sValue ){

    object oObj = oPC;
    int feat = StringToInt( sValue );

    if( sOption == "pc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    }
    else if( sOption == "npc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    }

    NWNX_Creature_AddFeat( oObj, feat );
    SendMessageToPC(oPC, "Feat "+IntToString( StringToInt( sValue ) )+" added!");
       }

void f_RemoveFeat( object oPC, string sOption, string sValue ){

    object oObj = oPC;
    int feat = StringToInt( sValue );

    if( sOption == "pc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    }
    else if( sOption == "npc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    }

    NWNX_Creature_RemoveFeat( oObj, feat );
    SendMessageToPC(oPC, "Feat "+IntToString( StringToInt( sValue ) )+" removed!");
       }

void f_Gender(object oPC, string sOption, string sValue){

    object oObj = oPC;
    int gender =  StringToInt( sValue );
    if( sOption == "pc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    }
    else if( sOption == "npc" ){

        oObj = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    }
        NWNX_Creature_SetGender ( oObj, gender );
}

void f_file( object oPC ){

    if(GetIsInCombat(oPC)){
        SendMessageToPC(oPC,"You are in combat!");
        return;
    }
    else if(StringToInt(RunLua("if file==nil then return true; else return file.DISABLED; end"))){

        SendMessageToPC(oPC,"This command is disabled!");
        return;
    }

    SetLocalInt( oPC, "ds_tree",0);
    SetCustomToken(10101,GetPCPlayerName(oPC));
    SetLocalString(oPC,"ds_action","td_act_ffile");
    AssignCommand(oPC,ActionStartConversation(oPC,"td_ffile",TRUE,FALSE));
}

void f_Eyes( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

         SendMessageToPC( oPC, "Use: f_Eyes [Self,PC,NPC][T,P] [color]\nOptions: cyan,green,orange,purple,red,white,yellow,blue or negred (humans only)\nT: Gives glowy eyes untill death/dm heal/reset\nP: Gives the target a toggleable item with the specified eyecolor." );
        return;
    }

    if( GetObjectType( oObject ) != OBJECT_TYPE_CREATURE ){

        SendMessageToPC( oPC, "Use: f_Eyes [Self,PC,NPC][T,P] [color]\nOptions: cyan,green,orange,purple,red,white,yellow,blue or negred (humans only)\nT: Gives glowy eyes untill death/dm heal/reset\nP: Gives the target a toggleable item with the specified eyecolor." );
        return;
    }

    string sParam = GetStringLowerCase( GetSubString( sValue, 0, 1) );
    string sColor = GetStringLowerCase( GetStringRight( sValue, GetStringLength( sValue ) - 2 ) );
    int iVFX = GetEyeVFX( oObject, sColor );

    if( sParam != "p" && sParam != "t" ){

        SendMessageToPC( oPC, "Invalid parameter: Must be T or P!" );
        SendMessageToPC( oPC, "Use: f_Eyes [Self,PC,NPC][T,P] [color]\nOptions: cyan,green,orange,purple,red,white,yellow,blue or negred (humans only)\nT: Gives glowy eyes untill death/dm heal/reset\nP: Gives the target a toggleable item with the specified eyecolor." );
        return;
    }

    if( iVFX == -1 ){

        SendMessageToPC( oPC, sColor+" isnt a valid color." );
        return;
    }

    if( sParam == "p" ){

        object oItem = CreateItemOnObject( "td_eyes" , oObject );
        SetLocalInt( oItem, "td_color", iVFX );
        SetDescription( oItem, GetName( oObject )+"'s "+sColor+" glowy eyes." );
        SetName( oItem, "Effect: Glowy "+sColor+" eyes");
        SendMessageToPC( oPC, "Granted "+GetName( oObject )+" permanet "+sColor+" glowy eyes." );
        return;
    }
    else{

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect( iVFX ) ), oObject );
        SendMessageToPC( oPC, "Granted "+GetName( oObject )+" temporary "+sColor+" glowy eyes." );
        return;
    }
}

void f_Horns( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Horns [Self,PC,NPC][type]\nOptions: meph,ox,rothe,balor,antlers,drag,ram." );
        return;
    }

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Horns [Self,PC,NPC][type]\nOptions: meph,ox,rothe,balor,antlers,drag,ram." );
        return;
    }

    int iVFX = GetHornVFX( oObject, sValue );

    if( iVFX == -1 ){

        SendMessageToPC( oPC, sValue+" isnt a valid horn type." );
        return;
    }

    object oItem = CreateItemOnObject( "td_horns" , oObject );
    SetLocalInt( oItem, "td_horn", iVFX );
    SetDescription( oItem, GetName( oObject )+"'s "+sValue+" horns." );
    SetName( oItem, "Effect: "+sValue+" horns");
    SendMessageToPC( oPC, "Granted "+GetName( oObject )+" "+sValue+" horns." );
    return;
}

void f_PCName( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_PCName [first,last] [New Name]\nOptions: Change the closest PC's last or first name.\nExample: f_PCName first Donkey\nThis sets the nearest PC's first name to Donkey." );
        return;
    }

    if( sOption == "first" ){

        // find ' and add escape for lua
        int iEscLoc = FindSubString("'",  sValue, 0);
        if(iEscLoc != -1) {
            sValue = StringReplace(sValue, "'", "\'");
        }

        //Save char before the actual change
        AR_ExportPlayer( oObject );

        //Send notes
        SendMessageToPC( oPC, "Setting "+GetName(oObject)+"'s first name to: "+sValue+"." );
        SendMessageToPC( oObject, GetName(oPC)+" is changing your first name to "+sValue+". Hold tight!" );

        object characterToChange = GetPCNearestToCaller(oPC);

        NWNX_Creature_SetOriginalName(oObject, sValue, FALSE);

        SendMessageToPC(oObject, "BE ADVISED: BOOTING you to change your last name!");

        DelayCommand(6.0f, BootPC(oObject, "Name change."));

        return;
    }
    else if( sOption == "last" ){

        // find ' and add escape for lua
        int iEscLoc = FindSubString("'",  sValue, 0);
        if(iEscLoc != -1) {
            sValue = StringReplace(sValue, "'", "\'");
        }

        //Save char before the actual change
        AR_ExportPlayer( oObject );

        //Send notes
        SendMessageToPC( oPC, "Setting "+GetName(oObject)+"'s last name to: "+sValue+"." );
        SendMessageToPC( oObject, GetName(oPC)+" is changing your last name to "+sValue+". Hold tight!" );

        object characterToChange = GetPCNearestToCaller(oPC);

        NWNX_Creature_SetOriginalName(oObject, sValue, TRUE);

        SendMessageToPC(oObject, "BE ADVISED: BOOTING you to change your last name!");

        DelayCommand(6.0f, BootPC(oObject, "Name change."));

        return;
    }
}

object GetPCNearestToCaller(object oPC)
{
    return GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC);
}

void f_Name( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Name [NPC,Item,PLC] [New Name]\nOptions: All options target the closest object of the given type.\nExample: f_Name NPC Donkey Kong\nThis sets the nearest NPC's name to Donkey Kong." );
        return;
    }

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s name to "+sValue+"." );

    if ( sOption != "pc" ){

        SetName( oObject, sValue );
    }
    else {

        SendMessageToPC( oPC , "Use f_PCName to set the closest PCs first or last name.");
    }

    RecomputeStaticLighting( GetArea( oPC ) );
}

void f_Bio( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Bio [Self,PC,NPC,Item,PLC] [+][text]\nOptions: All options target the closest object of the given type. If you leave text open the bio will revert to its original state. If you add a + in front of text it will be appended to the current bio and insert an empty line between the old and the new text. Using text without the + overwrites the current bio.\nExample: f_Bio NPC +Stop metagaming!\nThis adds '\n\nStop metagaming!' to the nearest NPC's bio." );
        return;
    }

    SendMessageToPC( oPC, "Updating "+GetName( oObject )+"'s bio." );

    if ( GetStringLeft( sValue, 1 ) == "+" ){

        SetDescription( oObject, GetDescription( oObject ) + "\n\n" + GetSubString( sValue, 2, GetStringLength( sValue ) ) );
    }
    else if ( sValue != "" ){

        SetDescription( oObject,  sValue );
    }
    else{

        SetDescription( oObject, "" );
    }
}

void f_Deity( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Deity [Self,PC] [new deity]\nOptions: All options target the closest object of the given type.\nExample: f_Deity PC Bane!\nThis sets the nearest PC's deity field to 'Bane'." );
        SendMessageToPC( oPC, "Search: f_Deity [Find][deity]\nExample: f_Deity find bane\nThis returns a list of online PCs with the phrase 'bane' in their deity field. This option is case-insensitive." );
        return;
    }
    else if ( sOption == "find" && sValue != "" ){

        object oPlayer  = GetFirstPC();

        SendMessageToPC( oPC, "PC's with '"+sValue+"' in their Deity field:" );

        while ( GetIsObjectValid( oPlayer ) ) {

            if ( FindSubString( GetStringLowerCase( GetDeity( oPlayer ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " (lvl " + IntToString( GetHitDice( oPlayer ) ) + " )" );
            }

            oPlayer = GetNextPC();
        }

        return;
    }

    SendMessageToPC( oPC, "Updating "+GetName( oObject )+"'s deity field." );

    SetDeity( oObject, sValue );
}

void f_FindPC( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "f_FindPC [Account,Align,Area,Deity,Level,Name,Race][Search Phrase] - Searches for players that match the search term and option. \nExample: f_FindPC level 23.\n This returns a list with all PCs of level 23.\nNB: Align takes values such as NG and CE." );
        return;
    }
    else if ( sValue != "" ){

        object oPlayer  = GetFirstPC();

        SendMessageToPC( oPC, "PC's with '"+sValue+"' in/as "+sOption+":" );

        while ( GetIsObjectValid( oPlayer ) ) {

            if ( sOption == "account" && FindSubString( GetStringLowerCase( GetPCPlayerName( oPlayer ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + GetPCPlayerName( oPlayer ) );
            }
            else if ( sOption == "align" && FindSubString( GetStringLowerCase( GetAlignmentString( oPlayer ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + GetAlignmentString( oPlayer ) );
            }
            else if ( sOption == "area" && FindSubString( GetStringLowerCase( GetName( GetArea( oPlayer ) ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + GetName( GetArea( oPlayer ) ) );
            }
            else if ( sOption == "deity" && FindSubString( GetStringLowerCase( GetDeity( oPlayer ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + GetDeity( oPlayer ) );
            }
            else if ( sOption == "level" && IntToString( GetHitDice( oPlayer ) ) == sValue ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + IntToString( GetHitDice( oPlayer ) ) );
            }
            else if ( sOption == "name" && FindSubString( GetStringLowerCase( GetName( oPlayer ) ), sValue ) != -1 ){

                SendMessageToPC( oPC, GetName( oPlayer ) + " - " + GetName( oPlayer ) );
            }
            else if ( sOption == "race" ){

                string sRace = GetRaceName( GetRaceInteger( GetRacialType( oPlayer ), GetSubRace( oPlayer ) ) );

                if ( FindSubString( GetStringLowerCase( sRace ), sValue ) != -1 ){

                    SendMessageToPC( oPC, GetName( oPlayer ) + " - " + sRace );
                }
            }

            oPlayer = GetNextPC();
        }

        return;
    }
}

void f_PlatRace( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_PlatRace [Self,PC] [Authorise]\nOptions: Authorises a platinum race.\nExample: f_PlatRace PC Authorise\nThis authorises the subrace of the nearest PC, and boots him to apply it." );
    }

    if ( sValue == "authorise" ){

        string sSubRace = GetStringLowerCase( GetSubRace( oObject ) );

        if ( sSubRace == "elfling" ||
             sSubRace == "faerie" ||
             sSubRace == "shadow" ||
             sSubRace == "aquatic" ||
             sSubRace == "snow" ){

            if ( !GetIsObjectValid( GetPCKEY( oObject ) ) ){

                FloatingTextStringOnCreature( "Creating PCKEY...", oObject, FALSE );

                object oKey = CreatePCKEY( oObject );

                FinishExport( oObject, oKey );
            }

            // Notify
            FloatingTextStringOnCreature( "Changing subrace...", oObject, FALSE );

            // Makes the targeted player an XYZ
            DelayCommand( 1.0, SetPCKEYValue( oObject, SUBRACE_AUTHORIZED, TRUE ) );
            DelayCommand( 1.0, SetPCKEYValue( oObject, "ds_subrace_activated", 1 ) );
            DelayCommand( 1.0, SetPCKEYValue( oObject, "ds_done", 5 ) );

            if ( sSubRace == "elfling" ) { DelayCommand( 3.0, AddElflingAbilitiesToBicFile( oObject ) ); }
            if ( sSubRace == "faerie" )  { DelayCommand( 3.0, AddFaerieAbilitiesToBicFile( oObject ) ); }
            if ( sSubRace == "shadow" )  { DelayCommand( 3.0, AddShadowElfAbilitiesToBicFile( oObject ) ); }
            if ( sSubRace == "aquatic" ) { DelayCommand( 3.0, AddAquaticElfAbilitiesToBicFile( oObject ) ); }
            if ( sSubRace == "snow" )    { DelayCommand( 3.0, AddSnowElfAbilitiesToBicFile( oObject ) ); }
        }

        SendMessageToPC( oPC, "Authorising "+GetName( oObject )+"'s subrace." );
    }
}

void f_Portrait( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Portrait [Self,PC,NPC,Item,PLC] [1-1300]\nOptions: 'Self' changes your own portrait, the other options target the closest object of the given type.\nExample: f_Portrait NPC 126\nThis sets nearest NPC's portrait to 126." );
        return;
    }

    SetPortraitId( oObject, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s portrait to "+sValue+"." );
}

void f_Say( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Say [PC,NPC,PLC] [text]\nOptions: 'NPC' assigns your text to the nearest NPC, the other options target the closest object of the given type.\nExample: f_Say NPC I am so hot\nThis lets nearest NPC say 'I am so hot'." );
        return;
    }

    AssignCommand( oObject, SpeakString( sValue ) );

    SendMessageToPC( oPC, "Assigning text to "+GetName( oObject )+"." );
}

void f_SignWidget( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_SignWidget [Self,PC] [sign name]\nOptions: The text you type behind it will become the name of the sign, a widget that spawns said sign is created in your or the nearest PC's inventory.\nExample: f_Skin PC Here lies Bobo. R.I.P.\nThis gives the nearest PC a widget that spawns Bobo's headstone." );
        return;
    }

    object oWidget = CreateItemOnObject( "ds_sign_widget", oObject );

    SetName( oWidget, sValue );
    SetDescription( oWidget, "Sign Widget" );
}



void f_Skin( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Skin [Self,PC,NPC] [0-305,350-370,374-481,869-870]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Skin NPC 126\nThis sets nearest NPC's skin to 126.\nMind that skins between 569-868 are used in conjunction with tails.\nYou can also look for a certain appearance with Find." );
        SendMessageToPC( oPC, "Search: f_Skin [Find][search term]\nExample: f_Skin find ogre\nThis returns a list of appearances with the phrase 'ogre' in their name. This option is case-insensitive." );
        return;
    }
    else if ( sOption == "find" && sValue != "" ){

        int i;
        string sSearch = GetStringLowerCase( sValue );

        for ( i=0; i<=870; ++i ){

            DelayCommand( 0.0, CheckAppearance( oPC, sSearch, i ) );
        }

        return;
    }

    SetCreatureAppearanceType( oObject, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s skin to "+sValue+"." );
}

void f_SkinColor( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_SkinColor [Self,PC,NPC] [0-175]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_SkinColor NPC 126\nThis sets nearest NPC's skin color to 126." );
        return;
    }

    SetColor( oObject, COLOR_CHANNEL_SKIN, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s skin color to "+sValue+"." );
}

void f_Tattoo1( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Tattoo1 [Self,PC,NPC] [0-175]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Tattoo1 NPC 126\nThis sets nearest NPC's tattoo 1 color to 126." );
        return;
    }

    SetColor( oObject, COLOR_CHANNEL_TATTOO_1, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s tattoo 1 color to "+sValue+"." );
}

void f_Tattoo2( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Tattoo2 [Self,PC,NPC] [0-175]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Tattoo2 NPC 126\nThis sets nearest NPC's tattoo 2 color to 126." );
        return;
    }

    SetColor( oObject, COLOR_CHANNEL_TATTOO_2, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s tattoo 2 color to "+sValue+"." );
}

void f_HairColor( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_HairColor [Self,PC,NPC] [0-175]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_HairColor NPC 126\nThis sets nearest NPC's hair color to 126." );
        return;
    }

    SetColor( oObject, COLOR_CHANNEL_HAIR, StringToInt( sValue ) );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s hair color to "+sValue+"." );
}

void f_Tail( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Tail [Self,PC,NPC] [0-13]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Tail NPC 11\nThis sets nearest NPC's tail to 11.\nMind that tails 15-490 are used in conjunction with null skins." );
        SendMessageToPC( oPC, "Search: f_Tail [Find][search term]\nExample: f_Skin find lizard\nThis returns a list of tails with the phrase 'lizard' in their name. This option is case-insensitive." );
        return;
    }
    else if ( sOption == "find" && sValue != "" ){

        int i;
        string sSearch = GetStringLowerCase( sValue );

        for ( i=0; i<=490; ++i ){

            DelayCommand( 0.0, CheckTail( oPC, sSearch, i ) );
        }

        return;
    }

    SetCreatureTailType( StringToInt( sValue ), oObject );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s tail to "+sValue+"." );
}

void f_dreamcoins(object oPC, object oObject, string sValue){
    if(!GetIsPC(oObject)) return;

    string cdKey = GetPCPublicCDKey(oObject);
    int dreamcoinAmount = StringToInt(sValue);
    int priorDreamcoins = GetDreamCoins(cdKey);

    SetDreamCoins(cdKey, dreamcoinAmount);

    SendMessageToAllDMs("Set " + GetPCPlayerName(oObject) + "'s dreamcoins from " + IntToString(priorDreamcoins) + " to " + IntToString(dreamcoinAmount) + ".");
}

void f_givedc(object oPC, object oObject, string sValue){
    if(!GetIsPC(oObject)) return;

    string cdKey = GetPCPublicCDKey(oObject);
    int priorDreamcoins = GetDreamCoins(cdKey);
    int dreamcoinAmount = priorDreamcoins + StringToInt(sValue);
    int dreamcoinAdded  = StringToInt(sValue);

    SetDreamCoins(cdKey, dreamcoinAmount);

    SendMessageToAllDMs(GetPCPlayerName(oObject) + " received " + IntToString(dreamcoinAdded) + " DCs.");
}

void f_takedc(object oPC, object oObject, string sValue){
    if(!GetIsPC(oObject)) return;

    string cdKey = GetPCPublicCDKey(oObject);
    int priorDreamcoins = GetDreamCoins(cdKey);
    int dreamcoinAmount = priorDreamcoins - StringToInt(sValue);
    int dreamcoinTaken  = StringToInt(sValue);

    SetDreamCoins(cdKey, dreamcoinAmount);

    SendMessageToAllDMs(GetPCPlayerName(oObject) + " lost " + IntToString(dreamcoinTaken) + " DCs.");
}

void f_ban(string sValue)
{
    BanPlayer(sValue);
    SendMessageToAllDMs(sValue + " has been banned.");
}

void f_unban(string sValue)
{
    UnbanPlayer(sValue);
    SendMessageToAllDMs(sValue + " has been unbanned.");
}

/*void f_paydc(object oPC, object oObject, string cdKey, string sValue){

    object oPC = OBJECT_SELF;
    int priorDreamcoins = GetDreamCoins(sOption);
    int dreamcoinAmount = priorDreamcoins + StringToInt(sValue);
    int dreamcoinAdded  = StringToInt(sValue);

    SetDreamCoins(sOption, dreamcoinAmount);

    SendMessageToAllDMs(sOption + " was paid " + IntToString(dreamcoinAdded) + " DCs.");
}*/

void f_Wings( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Wings [Self,PC,NPC][0-6,59-89]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Wings NPC 5\nThis sets nearest NPC's wings to 5." );
        SendMessageToPC( oPC, "Search: f_Wings [Find][search term]\nExample: f_Skin find bat\nThis returns a list of tails with the phrase 'bat' in their name. This option is case-insensitive." );
        return;
    }
    else if ( sOption == "find" && sValue != "" ){

        int i;
        string sSearch = GetStringLowerCase( sValue );

        for ( i=0; i<=89; ++i ){

            DelayCommand( 0.0, CheckWing( oPC, sSearch, i ) );
        }

        return;
    }

    SetCreatureWingType( StringToInt( sValue ), oObject );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s tail to "+sValue+"." );
}

void f_Head( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Head [Self,PC,NPC][0-143]\nOptions: 'Self' changes your own appearance, the other options target the closest object of the given type.\nExample: f_Head NPC 5\nThis sets nearest NPC's head to 5." );
        return;
    }

    SetCreatureBodyPart( CREATURE_PART_HEAD, StringToInt( sValue ), oObject );

    SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s head to "+sValue+"." );
}

void f_Targets( object oPC, string sOption ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Targets [][]\nOptions: n.a.\nExample: f_Targets\nShows the nearest targets so you know what you'll target with the other functions." );
        return;
    }

    object oObject;
    int i = 1;

    oObject = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
    SendMessageToPC( oPC, "Nearest PC:"+GetName( oObject ) );

    oObject = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );
    SendMessageToPC( oPC, "Nearest NPC:"+GetName( oObject ) );

    oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPC );

    while ( !GetUseableFlag( oObject ) && GetIsObjectValid( oObject ) ){

        ++i;

        oObject = GetNearestObject( OBJECT_TYPE_PLACEABLE, oPC, i );
    }

    SendMessageToPC( oPC, "Nearest Interactive PLC:"+GetName( oObject ) );

    oObject = GetNearestObject( OBJECT_TYPE_ITEM, oPC );
    SendMessageToPC( oPC, "Nearest item:"+GetName( oObject ) );
}


void f_Ring( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Ring [Self,PC,NPC,PLC] [Deity]\nOptions: You don't have to give the whole name of the deity, the script looks for the first match in the database. No value creates a random ring.\nExample: f_Ring PC Shaun\nThis creates a ring of Shaundakul in the closest PC's inventory." );
        return;
    }

    SendMessageToPC( oPC, "Creating a ring in "+GetName( oObject )+"'s inventory." );

    CreateRing( oObject, sValue );
}

void f_Voice( object oPC, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use:[f_Voice C,F,S,D,B,V] [Text]\nOptions: C=companion, F=Familiar, S=summon D=Dominated, B=Bottled Companion, V=Vassal.\nExample: f_Voice F Donkey Kong\nThis makes your familiar say 'Donkey Kong'." );
        return;
    }

    object oTarget;

    if ( sOption == "c" ){

        oTarget = GetAssociate( ASSOCIATE_TYPE_ANIMALCOMPANION, oPC );
    }
    else if ( sOption == "f" ){

        oTarget = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC );
    }
    else if ( sOption == "s" ){

        oTarget = GetAssociate( ASSOCIATE_TYPE_SUMMONED, oPC );
    }
    else if ( sOption == "d" ){

        oTarget = GetAssociate( ASSOCIATE_TYPE_DOMINATED, oPC );
    }
    else if( sOption == "b" ){
        oTarget = GetNearestObjectByTag( "ds_npc_"+GetPCPublicCDKey( oPC ), oPC );

        SetLocalInt( oTarget, "chat_language", GetLocalInt( oPC, "chat_language" ) );
        SetLocalInt( oTarget, "chat_reverse", GetLocalInt( oPC, "chat_reverse" ) );
        SetLocalString( oTarget, "chat_emote", GetLocalString( oPC, "chat_emote" ) );
    }
	else if( sOption == "v" ){
    oTarget = GetNearestObjectByTag( "vassal_"+GetPCPublicCDKey( oPC ), oPC );

    SetLocalInt( oTarget, "chat_language", GetLocalInt( oPC, "chat_language" ) );
    SetLocalInt( oTarget, "chat_reverse", GetLocalInt( oPC, "chat_reverse" ) );
    SetLocalString( oTarget, "chat_emote", GetLocalString( oPC, "chat_emote" ) );
    }

    if ( GetIsObjectValid( oTarget ) ){

        AssignCommand( oTarget, SpeakString( sValue ) );

        SendMessageToPC( oPC, "Assigning text to "+GetName( oTarget )+"." );

        //NWNX_Chat_SendMessage   (1 , SpeakString( sValue ) ) ;

        //AssignCommand( oTarget, SpeakString( sValue ) );
        //BroadcastChatLua( oTarget, sValue, TALKVOLUME_TALK );
    }

    RecomputeStaticLighting( GetArea( oPC ) );
}

void f_PlayerBio( object oPC, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Bio [R,B,N,A] [text]\nOptions: If you use [R]evert you set the bio back to the character creation version, you can leave [Text] open. [B]reak adds a linebreak (return) to the end of your current bio, you can leave [Text] open. [N]ew overwrites current bio with [Text] and adds a space to the end. [A]dd appendeds to the current bio with [Text] and a space. \nExample: f_Bio Add Stop metagaming!\nThis adds 'Stop metagaming! ' to your current bio." );
        return;
    }

    if ( sOption == "r" ){

        SetDescription( oPC, "" );

        SendMessageToPC( oPC, "Updating your bio: Resetting to orginal." );
    }
    else if ( sOption == "b" ){

        SetDescription( oPC, GetDescription( oPC ) + "\n" );

        SendMessageToPC( oPC, "Updating your bio: Inserting linebreak." );
    }
    else if ( sOption == "n" ){

        SetDescription( oPC, sValue + " " );

        SendMessageToPC( oPC, "Updating your bio: Overwriting current bio." );
    }
    else if ( sOption == "a" ){

        SetDescription( oPC, GetDescription( oPC ) + sValue + " " );

        SendMessageToPC( oPC, "Updating your bio: Adding more text." );
    }
    else{

        SendMessageToPC( oPC, "Updating your bio: Invalid command!" );
    }
}

void SafeDebuff( object oPC ){

    effect eEffect = GetFirstEffect( oPC );

    while( GetIsEffectValid( eEffect ) )  {

        if( GetIsNonMalignSpellEffect( eEffect ) ){

            RemoveEffect( oPC, eEffect );
        }

        eEffect = GetNextEffect( oPC );
    }

    itemproperty IP;
    object       oObject;
    int iLoop = 0;

    while ( iLoop < NUM_INVENTORY_SLOTS ) {

        oObject = GetItemInSlot( iLoop, oPC );

        if ( GetIsObjectValid( oObject ) ){

            IP = GetFirstItemProperty( oObject );

            while( GetIsItemPropertyValid( IP ) ) {

                if( GetItemPropertyDurationType( IP ) == DURATION_TYPE_TEMPORARY ){

                    RemoveItemProperty( oObject, IP );
                }

                IP = GetNextItemProperty( oObject );
            }
        }

        iLoop++;
    }
}

int GetIsNonMalignSpellEffect( effect eEffect ){

    switch( GetEffectSpellId( eEffect ) ) {

        case SPELL_AID: return TRUE; break;
        case SPELL_AMPLIFY: return TRUE; break;
        case SPELL_AURA_OF_VITALITY: return TRUE; break;
        case SPELL_AURAOFGLORY: return TRUE; break;
        case SPELL_AWAKEN: return TRUE; break;
        case SPELL_BARKSKIN: return TRUE; break;
        case SPELL_BATTLETIDE: return TRUE; break;
        case SPELL_BLACKSTAFF: return TRUE; break;
        case SPELL_BLADE_THIRST: return TRUE; break;
        case SPELL_BLESS: return TRUE; break;
        case SPELL_BLESS_WEAPON: return TRUE; break;
        case SPELL_BLOOD_FRENZY: return TRUE; break;
        case SPELL_BULLS_STRENGTH: return TRUE; break;
        case SPELL_CAMOFLAGE: return TRUE; break;
        case SPELL_CATS_GRACE: return TRUE; break;
        case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE: return TRUE; break;
        case SPELL_CLARITY: return TRUE; break;
        case SPELL_DEATH_ARMOR: return TRUE; break;
        case SPELL_DEAFENING_CLANG: return TRUE; break;
        case SPELL_DARKVISION: return TRUE; break;
        case SPELL_DEATH_WARD: return TRUE; break;
        case SPELL_DISPLACEMENT: return TRUE; break;
        case SPELL_DIVINE_FAVOR: return TRUE; break;
        case SPELL_DIVINE_MIGHT: return TRUE; break;
        case SPELL_DIVINE_POWER: return TRUE; break;
        case SPELL_DIVINE_SHIELD: return TRUE; break;
        case SPELL_EAGLE_SPLEDOR: return TRUE; break;
        case SPELL_ELEMENTAL_SHIELD: return TRUE; break;
        case SPELL_ENDURANCE: return TRUE; break;
        case SPELL_ENDURE_ELEMENTS: return TRUE; break;
        case SPELL_ENERGY_BUFFER: return TRUE; break;
        case SPELL_ENTROPIC_SHIELD: return TRUE; break;
        case SPELL_EPIC_MAGE_ARMOR: return TRUE; break;
        case SPELL_ETHEREAL_VISAGE: return TRUE; break;
        case SPELL_ETHEREALNESS: return TRUE; break;
        case SPELL_EXPEDITIOUS_RETREAT: return TRUE; break;
        case SPELL_FOXS_CUNNING: return TRUE; break;
        case SPELL_FREEDOM_OF_MOVEMENT: return TRUE; break;
        case SPELL_GHOSTLY_VISAGE: return TRUE; break;
        case SPELL_GLOBE_OF_INVULNERABILITY: return TRUE; break;
        case SPELL_GREATER_BULLS_STRENGTH: return TRUE; break;
        case SPELL_GREATER_CATS_GRACE: return TRUE; break;
        case SPELL_GREATER_EAGLE_SPLENDOR: return TRUE; break;
        case SPELL_GREATER_ENDURANCE: return TRUE; break;
        case SPELL_GREATER_FOXS_CUNNING: return TRUE; break;
        case SPELL_GREATER_MAGIC_WEAPON: return TRUE; break;
        case SPELL_GREATER_OWLS_WISDOM: return TRUE; break;
        case SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE: return TRUE; break;
        case SPELL_GREATER_SHADOW_CONJURATION_MIRROR_IMAGE: return TRUE; break;
        case SPELL_GREATER_SPELL_MANTLE: return TRUE; break;
        case SPELL_GREATER_STONESKIN: return TRUE; break;
        case SPELL_HASTE: return TRUE; break;
        case SPELL_HOLY_AURA: return TRUE; break;
        case SPELL_HOLY_SWORD: return TRUE; break;
        case SPELL_IDENTIFY: return TRUE; break;
        case SPELL_IMPROVED_INVISIBILITY: return TRUE; break;
        case SPELL_INVISIBILITY: return TRUE; break;
        case SPELL_INVISIBILITY_PURGE: return TRUE; break;
        case SPELL_INVISIBILITY_SPHERE: return TRUE; break;
        case SPELL_IOUN_STONE_BLUE: return TRUE; break;
        case SPELL_IOUN_STONE_DEEP_RED: return TRUE; break;
        case SPELL_IOUN_STONE_DUSTY_ROSE: return TRUE; break;
        case SPELL_IOUN_STONE_PALE_BLUE: return TRUE; break;
        case SPELL_IOUN_STONE_PINK: return TRUE; break;
        case SPELL_IOUN_STONE_PINK_GREEN: return TRUE; break;
        case SPELL_IOUN_STONE_SCARLET_BLUE: return TRUE; break;
        case SPELL_IRONGUTS: return TRUE; break;
        case SPELL_KEEN_EDGE: return TRUE; break;
        case SPELL_LEGEND_LORE: return TRUE; break;
        case SPELL_LESSER_MIND_BLANK: return TRUE; break;
        case SPELL_LESSER_SPELL_MANTLE: return TRUE; break;
        case SPELL_MAGE_ARMOR: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD: return TRUE; break;
        case SPELL_MAGIC_CIRCLE_AGAINST_LAW: return TRUE; break;
        case SPELL_MAGIC_WEAPON: return TRUE; break;
        case SPELL_MAGIC_VESTMENT: return TRUE; break;
        case SPELL_MASS_CAMOFLAGE: return TRUE; break;
        case SPELL_MASS_HASTE: return TRUE; break;
        case SPELL_MESTILS_ACID_SHEATH: return TRUE; break;
        case SPELL_MIND_BLANK: return TRUE; break;
        case SPELL_MINOR_GLOBE_OF_INVULNERABILITY: return TRUE; break;
        case SPELL_MONSTROUS_REGENERATION: return TRUE; break;
        case SPELL_NEGATIVE_ENERGY_PROTECTION: return TRUE; break;
        case SPELL_ONE_WITH_THE_LAND: return TRUE; break;
        case SPELL_OWLS_INSIGHT: return TRUE; break;
        case SPELL_OWLS_WISDOM: return TRUE; break;
        case SPELL_PRAYER: return TRUE; break;
        case SPELL_PREMONITION: return TRUE; break;
        case SPELL_PROTECTION__FROM_CHAOS: return TRUE; break;
        case SPELL_PROTECTION_FROM_ELEMENTS: return TRUE; break;
        case SPELL_PROTECTION_FROM_EVIL: return TRUE; break;
        case SPELL_PROTECTION_FROM_GOOD: return TRUE; break;
        case SPELL_PROTECTION_FROM_LAW: return TRUE; break;
        case SPELL_PROTECTION_FROM_SPELLS: return TRUE; break;
        case SPELL_REGENERATE: return TRUE; break;
        case SPELL_REMOVE_FEAR: return TRUE; break;
        case SPELL_RESIST_ELEMENTS: return TRUE; break;
        case SPELL_RESISTANCE: return TRUE; break;
        case SPELL_SANCTUARY: return TRUE; break;
        case SPELL_SEE_INVISIBILITY: return TRUE; break;
        case SPELL_SHADES_STONESKIN: return TRUE; break;
        case SPELL_SHADOW_CONJURATION_INIVSIBILITY: return TRUE; break;
        case SPELL_SHADOW_CONJURATION_MAGE_ARMOR: return TRUE; break;
        case SPELL_SHADOW_EVADE: return TRUE; break;
        case SPELL_SHADOW_SHIELD: return TRUE; break;
        case SPELL_SHIELD: return TRUE; break;
        case SPELL_SHIELD_OF_FAITH: return TRUE; break;
        case SPELL_SHIELD_OF_LAW: return TRUE; break;
        case SPELL_SPELL_MANTLE: return TRUE; break;
        case SPELL_SPELL_RESISTANCE: return TRUE; break;
        case SPELL_STONE_BONES: return TRUE; break;
        case SPELL_STONESKIN: return TRUE; break;
        case SPELL_TENSERS_TRANSFORMATION: return TRUE; break;
        case SPELL_TRUE_SEEING: return TRUE; break;
        case SPELL_TRUE_STRIKE: return TRUE; break;
        case SPELL_TYMORAS_SMILE: return TRUE; break;
        case SPELL_UNDEATHS_ETERNAL_FOE: return TRUE; break;
        case SPELL_VINE_MINE_CAMOUFLAGE: return TRUE; break;
        case SPELL_VIRTUE: return TRUE; break;

        default: return FALSE;
    }

    return FALSE;
}

void CheckAppearance( object oPC, string sSearch, int nAppearance ){

    string sAppearance = GetAppearanceName( nAppearance );

    if ( FindSubString( GetStringLowerCase( sAppearance ), sSearch ) != -1 ){

        SendMessageToPC( oPC, IntToString( nAppearance )+": "+sAppearance );
    }
}

string GetAppearanceName( int nAppearance ){

    switch ( nAppearance ){

        case 0: return "Dwarf";
        case 1: return "Elf";
        case 2: return "Gnome";
        case 3: return "Halfling";
        case 4: return "Half_Elf";
        case 5: return "Half_Orc";
        case 6: return "Human";
        case 7: return "Parrot";
        case 8: return "Badger";
        case 9: return "Badger_Dire";
        case 10: return "Bat";
        case 11: return "Bat_Horror";
        case 12: return "Bear_Black";
        case 13: return "Bear_Brown";
        case 14: return "Bear_Polar";
        case 15: return "Bear_Dire";
        case 16: return "Curst_Swordsman";
        case 17: return "Beetle_Slicer";
        case 18: return "Beetle_Fire";
        case 19: return "Beetle_Stag";
        case 20: return "Beetle_Stink";
        case 21: return "Boar";
        case 22: return "Boar_Dire";
        case 23: return "Bodak";
        case 24: return "Golem_Bone";
        case 25: return "Bugbear_Chieftain_A";
        case 26: return "Bugbear_Chieftain_B";
        case 27: return "Bugbear_Shaman_A";
        case 28: return "Bugbear_Shaman_B";
        case 29: return "Bugbear_A";
        case 30: return "Bugbear_B";
        case 31: return "Chicken";
        case 32: return "Satyr_Archer";
        case 33: return "Satyr_Warrior";
        case 34: return "Cow";
        case 35: return "Deer";
        case 36: return "Skeletal_Devourer";
        case 37: return "Deer_Stag";
        case 38: return "Balor";
        case 39: return "Lich";
        case 40: return "Doom_Knight";
        case 41: return "Dragon_Black";
        case 42: return "Dragon_Brass";
        case 43: return "Dragon_Copper";
        case 44: return "Dragon_Silver";
        case 45: return "Dragon_Bronze";
        case 46: return "Dragon_Gold";
        case 47: return "Dragon_Blue";
        case 48: return "Dragon_Green";
        case 49: return "Dragon_Red";
        case 50: return "Dragon_White";
        case 51: return "Dryad";
        case 52: return "Elemental_Air";
        case 53: return "Elemental_Air_Elder";
        case 54: return "War_Devourer";
        case 55: return "Fairy";
        case 56: return "Elemental_Earth";
        case 57: return "Elemental_Earth_Elder";
        case 58: return "Mummy_Common";
        case 59: return "Mummy_Fighter_2";
        case 60: return "Elemental_Fire";
        case 61: return "Elemental_Fire_Elder";
        case 62: return "Skeleton_Priest";
        case 63: return "Skeleton_Common";
        case 64: return "Invisible_Stalker";
        case 65: return "Sahuagin";
        case 66: return "Sahuagin_Leader";
        case 67: return "Sahuagin_Cleric";
        case 68: return "Elemental_Water_Elder";
        case 69: return "Elemental_Water";
        case 70: return "Skeleton_Warrior_1";
        case 71: return "Skeleton_Warrior_2";
        case 72: return "Ettin";
        case 73: return "Gargoyle";
        case 74: return "Ghast";
        case 75: return "Ogre_Elite";
        case 76: return "Ghoul";
        case 77: return "Ghoul_Lord";
        case 78: return "Giant_Hill";
        case 79: return "Giant_Mountain";
        case 80: return "Giant_Fire";
        case 81: return "Giant_Frost";
        case 82: return "Goblin_Chief_A";
        case 83: return "Goblin_Chief_B";
        case 84: return "Goblin_Shaman_A";
        case 85: return "Goblin_Shaman_B";
        case 86: return "Goblin_A";
        case 87: return "Goblin_B";
        case 88: return "Golem_Flesh";
        case 89: return "Golem_Iron";
        case 90: return "Shield_Guardian";
        case 91: return "Golem_Clay";
        case 92: return "Golem_Stone";
        case 93: return "Cat_Leopard";
        case 94: return "Cat_Crag_Cat";
        case 95: return "Cat_Cat_Dire";
        case 96: return "Cat_Krenshar";
        case 97: return "Cat_Lion";
        case 98: return "Cat_Jaguar";
        case 99: return "Werecat";
        case 100: return "Helmed_Horror";
        case 101: return "Vrock";
        case 102: return "Hook_Horror";
        case 103: return "Lantern_Archon";
        case 104: return "Quasit";
        case 105: return "Imp";
        case 106: return "Mephit_Air";
        case 107: return "Mephit_Dust";
        case 108: return "Mephit_Earth";
        case 109: return "Mephit_Fire";
        case 110: return "Mephit_Ice";
        case 111: return "Mephit_Salt";
        case 112: return "Mephit_Ooze";
        case 113: return "Mephit_Steam";
        case 114: return "Mephit_Magma";
        case 115: return "Mephit_Water";
        case 116: return "Will_O_Wisp";
        case 117: return "Intellect_Devourer";
        case 118: return "Dragon_Mist";
        case 119: return "Minogon";
        case 120: return "Minotaur";
        case 121: return "Minotaur_Chieftain";
        case 122: return "Minotaur_Shaman";
        case 123: return "Mohrg";
        case 124: return "Mummy_Greater";
        case 125: return "Mummy_Warrior";
        case 126: return "Nymph";
        case 127: return "Ogre";
        case 128: return "Ogre_Chieftain";
        case 129: return "Ogre_Mage";
        case 130: return "Lizardfolk_Warrior_A";
        case 131: return "Lizardfolk_Warrior_B";
        case 132: return "Lizardfolk_Shaman_A";
        case 133: return "Lizardfolk_Shaman_B";
        case 134: return "Lizardfolk_A";
        case 135: return "Lizardfolk_B";
        case 136: return "Orc_Chieftain_A";
        case 137: return "Orc_Chieftain_B";
        case 138: return "Orc_Shaman_A";
        case 139: return "Orc_Shaman_B";
        case 140: return "Orc_A";
        case 141: return "Orc_B";
        case 142: return "Ox";
        case 143: return "Satyr";
        case 144: return "Falcon";
        case 145: return "Raven";
        case 146: return "Shadow";
        case 147: return "Shadow_Fiend";
        case 148: return "Skeleton_Mage";
        case 149: return "Golem_Diamond";
        case 150: return "Skeleton_Warrior";
        case 151: return "Slaad_Blue";
        case 152: return "Slaad_Death";
        case 153: return "Slaad_Gray";
        case 154: return "Slaad_Green";
        case 155: return "Slaad_Red";
        case 156: return "Spectre";
        case 157: return "Aranea";
        case 158: return "Spider_Dire";
        case 159: return "Spider_Giant";
        case 160: return "Spider_Phase";
        case 161: return "Spider_Sword";
        case 162: return "Spider_Wraith";
        case 163: return "Succubus";
        case 164: return "Troll_Chieftain";
        case 165: return "Troll_Shaman";
        case 166: return "Ettercap";
        case 167: return "Troll";
        case 168: return "Umberhulk";
        case 169: return "Golem_Emerald";
        case 170: return "Wererat";
        case 171: return "Werewolf";
        case 172: return "Wight";
        case 173: return "Golem_Ruby";
        case 174: return "Dog_Blinkdog";
        case 175: return "Dog_Dire_Wolf";
        case 176: return "Dog";
        case 177: return "Dog_Fenhound";
        case 178: return "Snake_Black_Cobra";
        case 179: return "Dog_Hell_Hound";
        case 180: return "Dog_Shadow_Mastif";
        case 181: return "Dog_Wolf";
        case 182: return "Skeleton_Chieftain";
        case 183: return "Snake_Cobra";
        case 184: return "Dog_Winter_Wolf";
        case 185: return "Dog_Worg";
        case 186: return "Allip";
        case 187: return "Wraith";
        case 188: return "NWN_Aarin";
        case 189: return "NWN_Aribeth_Evil";
        case 190: return "aribeth";
        case 191: return "NWN_Haedraline";
        case 192: return "NWN_Morag";
        case 193: return "NWN_Maugrim";
        case 194: return "Snake_Gold_Cobra";
        case 195: return "Zombie_Rotting";
        case 196: return "Zombie_Warrior_1";
        case 197: return "Zombie_Warrior_2";
        case 198: return "Zombie";
        case 199: return "Zombie_Tyrant_Fog";
        case 200: return "arch_target";
        case 201: return "combat_dummy";
        case 202: return "Cat_Panther";
        case 203: return "Cat_Cougar";
        case 204: return "Bear_Kodiak";
        case 205: return "Grey_Render";
        case 206: return "Penguin";
        case 207: return "OgreB";
        case 208: return "Ogre_ChieftainB";
        case 209: return "Ogre_MageB";
        case 210: return "NW_Militia_Member";
        case 211: return "Luskan_Guard";
        case 212: return "Cult_Member";
        case 213: return "Uthgard_Elk_Tribe";
        case 214: return "Uthgard_Tiger_Tribe";
        case 215: return "Drow_Cleric";
        case 216: return "Drow_Fighter";
        case 217: return "Druegar_Fighter";
        case 218: return "Druegar_Cleric";
        case 219: return "House_Guard";
        case 220: return "Begger";
        case 221: return "Blood_Sailer";
        case 222: return "Female_01";
        case 223: return "Female_02";
        case 224: return "Female_03";
        case 225: return "Female_04";
        case 226: return "Male_01";
        case 227: return "Male_02";
        case 228: return "Male_03";
        case 229: return "Male_04";
        case 230: return "Male_05";
        case 231: return "Plague_Victim";
        case 232: return "Shop_Keeper";
        case 233: return "Inn_Keeper";
        case 234: return "Bartender";
        case 235: return "Waitress";
        case 236: return "Prostitute_01";
        case 237: return "Prostitute_02";
        case 238: return "Convict";
        case 239: return "Old_Man";
        case 240: return "Old_Woman";
        case 241: return "Kid_Male";
        case 242: return "Kid_Female";
        case 243: return "Gnome_NPC_Female";
        case 244: return "Gnome_NPC_Male";
        case 245: return "Elf_NPC_Female";
        case 246: return "Elf_NPC_Male_01";
        case 247: return "Elf_NPC_Male_02";
        case 248: return "Dwarf_NPC_Female";
        case 249: return "Dwarf_NPC_Male";
        case 250: return "Halfling_NPC_Female";
        case 251: return "Halfling_NPC_Male";
        case 252: return "Half_Orc_NPC_Female";
        case 253: return "Half_Orc_NPC_Male_01";
        case 254: return "Half_Orc_NPC_Male_02";
        case 255: return "Human_NPC_Female_01";
        case 256: return "Human_NPC_Female_02";
        case 257: return "Human_NPC_Female_03";
        case 258: return "Human_NPC_Female_04";
        case 259: return "Human_NPC_Female_05";
        case 260: return "Human_NPC_Female_06";
        case 261: return "Human_NPC_Female_07";
        case 262: return "Human_NPC_Female_08";
        case 263: return "Human_NPC_Female_09";
        case 264: return "Human_NPC_Female_10";
        case 265: return "Human_NPC_Female_11";
        case 266: return "Human_NPC_Female_12";
        case 267: return "Human_NPC_Male_01";
        case 268: return "Human_NPC_Male_02";
        case 269: return "Human_NPC_Male_03";
        case 270: return "Human_NPC_Male_04";
        case 271: return "Human_NPC_Male_05";
        case 272: return "Human_NPC_Male_06";
        case 273: return "Human_NPC_Male_07";
        case 274: return "Human_NPC_Male_08";
        case 275: return "Human_NPC_Male_09";
        case 276: return "Human_NPC_Male_10";
        case 277: return "Human_NPC_Male_11";
        case 278: return "Human_NPC_Male_12";
        case 279: return "Human_NPC_Male_13";
        case 280: return "Human_NPC_Male_14";
        case 281: return "Human_NPC_Male_15";
        case 282: return "Human_NPC_Male_16";
        case 283: return "Human_NPC_Male_17";
        case 284: return "Human_NPC_Male_18";
        case 285: return "Yuan_Ti";
        case 286: return "Yuan_Ti_Chieften";
        case 287: return "Yuan_Ti_Wizard";
        case 288: return "Vampire_Female";
        case 289: return "Vampire_Male";
        case 290: return "Rakshasa_Tiger_Female";
        case 291: return "Seagull_Flying";
        case 292: return "Seagull_Walking";
        case 293: return "Rakshasa_Tiger_Male";
        case 294: return "Rakshasa_Bear_Male";
        case 295: return "Rakshasa_Wolf_Male";
        case 296: return "NWN_Nasher";
        case 297: return "NWN_Sedos";
        case 298: return "Invisible_Human_Male";
        case 299: return "Beholder_GZhorb";
        case 300: return "Kobold_Chief_A";
        case 301: return "Kobold_Shaman_A";
        case 302: return "Kobold_A";
        case 303: return "Kobold_Chief_B";
        case 304: return "Kobold_Shaman_B";
        case 305: return "Kobold_B";
        case 306: return "Cat_MPanther";
        case 350: return "Giant_Frost_Female";
        case 351: return "Giant_Fire_Female";
        case 352: return "Medusa";
        case 353: return "Asabi_Chieftain";
        case 354: return "Asabi_Shaman";
        case 355: return "Asabi_Warrior";
        case 356: return "Stinger";
        case 357: return "Stinger_Warrior";
        case 358: return "Stinger_Chieftain";
        case 359: return "Stinger_Mage";
        case 360: return "Formian_Worker";
        case 361: return "Formian_Warrior";
        case 362: return "Formian_Myrmarch";
        case 363: return "Formian_Queen";
        case 364: return "Sphinx";
        case 365: return "Gynosphinx";
        case 366: return "Manticore";
        case 367: return "Gorgon";
        case 368: return "Cockatrice";
        case 369: return "Basilisk";
        case 370: return "XP1_HeurodisLich";
        case 374: return "Faerie_Dragon";
        case 375: return "Pseudodragon";
        case 376: return "Wyrmling_Red";
        case 377: return "Wyrmling_Blue";
        case 378: return "Wyrmling_Black";
        case 379: return "Wyrmling_Green";
        case 380: return "Wyrmling_White";
        case 381: return "Wyrmling_Brass";
        case 382: return "Wyrmling_Copper";
        case 383: return "Wyrmling_Bronze";
        case 384: return "Wyrmling_Silver";
        case 385: return "Wyrmling_Gold";
        case 386: return "Rat";
        case 387: return "Rat_Dire";
        case 388: return "Gnoll_Warrior";
        case 389: return "Gnoll_Wiz";
        case 390: return "Hobgoblin_Warrior";
        case 391: return "Hobgoblin_Wizard";
        case 392: return "Devil";
        case 393: return "Gray_Ooze";
        case 394: return "Ochre_Jelly_Large";
        case 395: return "PDK_Archer_Female";
        case 396: return "Ochre_Jelly_Medium";
        case 397: return "PDK_Archer_Male";
        case 398: return "Ochre_Jelly_Small";
        case 399: return "PDK_Blade_Female";
        case 400: return "PDK_Blade_Male";
        case 401: return "Beholder";
        case 402: return "Beholder_Mage";
        case 403: return "Beholder_Eyeball";
        case 404: return "Mephisto_Big";
        case 405: return "Dracolich";
        case 406: return "Drider";
        case 407: return "Drider_Chief";
        case 408: return "Drow_Slave";
        case 409: return "Drow_Wizard";
        case 410: return "Drow_Matron";
        case 411: return "Duergar_Slave";
        case 412: return "Duergar_Chief";
        case 413: return "Mindflayer";
        case 414: return "Mindflayer2";
        case 415: return "Mindflayer_Alhoon";
        case 416: return "Deep_Rothe";
        case 417: return "Lord_Antoine";
        case 418: return "Dragon_Shadow";
        case 419: return "Harpy";
        case 420: return "Golem_Mithril";
        case 421: return "Golem_Adamantium";
        case 422: return "Spider_Demon";
        case 423: return "Svirf_Male";
        case 424: return "Svirf_Female";
        case 425: return "Dragon_Pris";
        case 426: return "Slaad_Black";
        case 427: return "Slaad_White";
        case 428: return "Azer_Male";
        case 429: return "Azer_Female";
        case 430: return "Demi_Lich";
        case 431: return "ObjectChair";
        case 432: return "objectTable";
        case 433: return "objectCandle";
        case 434: return "objectChest";
        case 435: return "objectWhite";
        case 436: return "objectBlue";
        case 437: return "objectCyan";
        case 438: return "objectGreen";
        case 439: return "objectYellow";
        case 440: return "objectOrange";
        case 441: return "objectRed";
        case 442: return "objectPurple";
        case 443: return "objectFlameSmall";
        case 444: return "objectFlameMedium";
        case 445: return "objectFlameLarge";
        case 446: return "Drider_Female";
        case 447: return "Shark_Mako";
        case 448: return "Shark_Hammerhead";
        case 449: return "Shark_Goblin";
        case 450: return "Caladnei";
        case 451: return "Troglodyte";
        case 452: return "Troglodyte_Warrior";
        case 453: return "Troglodyte_Cleric";
        case 454: return "Sea_Hag";
        case 455: return "Wyvern_Adult";
        case 456: return "Wyvern_Great";
        case 457: return "Wyvern_Juvenile";
        case 458: return "Wyvern_Young";
        case 459: return "Hagatha";
        case 460: return "Halaster";
        case 461: return "Harat";
        case 462: return "Harat_Small";
        case 463: return "Maggris";
        case 464: return "Masterius";
        case 465: return "Masterius_Full_Power";
        case 466: return "Witch_King_Disguised";
        case 467: return "Wereboar";
        case 468: return "Golem_Demonflesh";
        case 469: return "animated_chest";
        case 470: return "GelatinousCube";
        case 471: return "Mephisto_Norm";
        case 472: return "Beholder_Mother";
        case 473: return "objectBoat";
        case 474: return "Dwarf_Golem";
        case 475: return "Dwarf_HalfOrc";
        case 476: return "Drow_Warrior_1";
        case 477: return "Drow_Warrior_2";
        case 478: return "Drow_Female_1";
        case 479: return "Drow_Female_2";
        case 480: return "Drow_Warrior_3";
        case 481: return "Bulette";
        case 482: return "Dwarf_mounted_f";
        case 483: return "Dwarf_mounted";
        case 484: return "Elf_mounted_f";
        case 485: return "Elf_mounted";
        case 486: return "Gnome_mounted_f";
        case 487: return "Gnome_mounted";
        case 488: return "Halfling_mounted_f";
        case 489: return "Halfling_mounted";
        case 490: return "Half_Elf_mounted_f";
        case 491: return "Half_Elf_mounted";
        case 492: return "Half_Orc_mounted_f";
        case 493: return "Half_Orc_mounted";
        case 494: return "Human_mounted_f";
        case 495: return "Human_mounted";
        case 496: return "Horse_Walnut";
        case 497: return "Horse_Walnut_saddle";
        case 498: return "Horse_Walnut_saddle_packs";
        case 499: return "Horse_Walnut_leather_barding";
        case 500: return "Horse_Walnut_scale_mail_barding";
        case 501: return "Horse_Walnut_chain_barding";
        case 502: return "Horse_Walnut_purple_barding";
        case 503: return "Horse_Walnut_red_barding";
        case 504: return "Horse_Walnut_leather_barding_packs";
        case 505: return "Horse_Walnut_scale_mail_barding_packs";
        case 506: return "Horse_Walnut_chain_barding_packs";
        case 507: return "Horse_Walnut_purple_barding_packs";
        case 508: return "Horse_Walnut_red_barding_packs";
        case 509: return "Horse_Gunpowder";
        case 510: return "Horse_Gunpowder_saddle";
        case 511: return "Horse_Gunpowder_saddle_packs";
        case 512: return "Horse_Gunpowder_leather_barding";
        case 513: return "Horse_Gunpowder_scale_mail_barding";
        case 514: return "Horse_Gunpowder_chain_barding";
        case 515: return "Horse_Gunpowder_purple_barding";
        case 516: return "Horse_Gunpowder_red_barding";
        case 517: return "Horse_Gunpowder_leather_barding_packs";
        case 518: return "Horse_Gunpowder_scale_mail_barding_packs";
        case 519: return "Horse_Gunpowder_chain_barding_packs";
        case 520: return "Horse_Gunpowder_purple_barding_packs";
        case 521: return "Horse_Gunpowder_red_barding_packs";
        case 522: return "Horse_Spotted";
        case 523: return "Horse_Spotted_saddle";
        case 524: return "Horse_Spotted_saddle_packs";
        case 525: return "Horse_Spotted_leather_barding";
        case 526: return "Horse_Spotted_scale_mail_barding";
        case 527: return "Horse_Spotted_chain_barding";
        case 528: return "Horse_Spotted_purple_barding";
        case 529: return "Horse_Spotted_red_barding";
        case 530: return "Horse_Spotted_leather_barding_packs";
        case 531: return "Horse_Spotted_scale_mail_barding_packs";
        case 532: return "Horse_Spotted_chain_barding_packs";
        case 533: return "Horse_Spotted_purple_barding_packs";
        case 534: return "Horse_Spotted_red_barding_packs";
        case 535: return "Horse_Black";
        case 536: return "Horse_Black_saddle";
        case 537: return "Horse_Black_saddle_packs";
        case 538: return "Horse_Black_leather_barding";
        case 539: return "Horse_Black_scale_mail_barding";
        case 540: return "Horse_Black_chain_barding";
        case 541: return "Horse_Black_purple_barding";
        case 542: return "Horse_Black_red_barding";
        case 543: return "Horse_Black_leather_barding_packs";
        case 544: return "Horse_Black_scale_mail_barding_packs";
        case 545: return "Horse_Black_chain_barding_packs";
        case 546: return "Horse_Black_purple_barding_packs";
        case 547: return "Horse_Black_red_barding_packs";
        case 548: return "Nightmare_barding";
        case 549: return "Nightmare_saddle";
        case 550: return "Nightmare";
        case 551: return "Horse_Jousting_Purple";
        case 552: return "Horse_Jousting_Blue_Gold";
        case 553: return "Horse_Jousting_Black_White";
        case 554: return "Horse_Jousting_Red_Yellow";
        case 555: return "Horse_Jousting_Red_Black_Stripes";
        case 556: return "Horse_Jousting_Green";
        case 557: return "Horse_Jousting_Blue_Pink";
        case 558: return "Horse_Jousting_Red_Gold_Brick";
        case 559: return "Horse_Jousting_Black";
        case 560: return "Horse_Jousting_Cyan_White";
        case 561: return "Horse_Jousting_White";
        case 562: return "Horse_Invis_Dwarf";
        case 563: return "Horse_Invis_Elf";
        case 564: return "Horse_Invis_Gnome";
        case 565: return "Horse_Invis_Halfling";
        case 566: return "Horse_Invis_Half-Elf";
        case 567: return "Horse_Invis_Half-Orc";
        case 568: return "Horse_Invis_Human";
        case 569: return "Invisible_Dragon_10";
        case 570: return "Invisible_Dragon_20";
        case 571: return "Invisible_Dragon_30";
        case 572: return "Invisible_Dragon_40";
        case 573: return "Invisible_Dragon_50";
        case 574: return "Invisible_Dragon_60";
        case 575: return "Invisible_Dragon_70";
        case 576: return "Invisible_Dragon_80";
        case 577: return "Invisible_Dragon_90";
        case 578: return "Invisible_Dragon_100";
        case 579: return "Invisible_Dragon_110";
        case 580: return "Invisible_Dragon_120";
        case 581: return "Invisible_Dragon_130";
        case 582: return "Invisible_Dragon_140";
        case 583: return "Invisible_Dragon_150";
        case 584: return "Invisible_Dragon_160";
        case 585: return "Invisible_Dragon_170";
        case 586: return "Invisible_Dragon_180";
        case 587: return "Invisible_Dragon_190";
        case 588: return "Invisible_Dragon_200";
        case 589: return "Invisible_Dwarf_Female_010";
        case 590: return "Invisible_Dwarf_Female_020";
        case 591: return "Invisible_Dwarf_Female_030";
        case 592: return "Invisible_Dwarf_Female_040";
        case 593: return "Invisible_Dwarf_Female_050";
        case 594: return "Invisible_Dwarf_Female_060";
        case 595: return "Invisible_Dwarf_Female_070";
        case 596: return "Invisible_Dwarf_Female_080";
        case 597: return "Invisible_Dwarf_Female_090";
        case 598: return "Invisible_Dwarf_Female_100";
        case 599: return "Invisible_Dwarf_Female_110";
        case 600: return "Invisible_Dwarf_Female_120";
        case 601: return "Invisible_Dwarf_Female_130";
        case 602: return "Invisible_Dwarf_Female_140";
        case 603: return "Invisible_Dwarf_Female_150";
        case 604: return "Invisible_Dwarf_Female_160";
        case 605: return "Invisible_Dwarf_Female_170";
        case 606: return "Invisible_Dwarf_Female_180";
        case 607: return "Invisible_Dwarf_Female_190";
        case 608: return "Invisible_Dwarf_Female_200";
        case 609: return "Invisible_Elf_Female_010";
        case 610: return "Invisible_Elf_Female_020";
        case 611: return "Invisible_Elf_Female_030";
        case 612: return "Invisible_Elf_Female_040";
        case 613: return "Invisible_Elf_Female_050";
        case 614: return "Invisible_Elf_Female_060";
        case 615: return "Invisible_Elf_Female_070";
        case 616: return "Invisible_Elf_Female_080";
        case 617: return "Invisible_Elf_Female_090";
        case 618: return "Invisible_Elf_Female_100";
        case 619: return "Invisible_Elf_Female_110";
        case 620: return "Invisible_Elf_Female_120";
        case 621: return "Invisible_Elf_Female_130";
        case 622: return "Invisible_Elf_Female_140";
        case 623: return "Invisible_Elf_Female_150";
        case 624: return "Invisible_Elf_Female_160";
        case 625: return "Invisible_Elf_Female_170";
        case 626: return "Invisible_Elf_Female_180";
        case 627: return "Invisible_Elf_Female_190";
        case 628: return "Invisible_Elf_Female_200";
        case 629: return "Invisible_Gnome_Female_010";
        case 630: return "Invisible_Gnome_Female_020";
        case 631: return "Invisible_Gnome_Female_030";
        case 632: return "Invisible_Gnome_Female_040";
        case 633: return "Invisible_Gnome_Female_050";
        case 634: return "Invisible_Gnome_Female_060";
        case 635: return "Invisible_Gnome_Female_070";
        case 636: return "Invisible_Gnome_Female_080";
        case 637: return "Invisible_Gnome_Female_090";
        case 638: return "Invisible_Gnome_Female_100";
        case 639: return "Invisible_Gnome_Female_110";
        case 640: return "Invisible_Gnome_Female_120";
        case 641: return "Invisible_Gnome_Female_130";
        case 642: return "Invisible_Gnome_Female_140";
        case 643: return "Invisible_Gnome_Female_150";
        case 644: return "Invisible_Gnome_Female_160";
        case 645: return "Invisible_Gnome_Female_170";
        case 646: return "Invisible_Gnome_Female_180";
        case 647: return "Invisible_Gnome_Female_190";
        case 648: return "Invisible_Gnome_Female_200";
        case 649: return "Invisible_Halfling_Female_010";
        case 650: return "Invisible_Halfling_Female_020";
        case 651: return "Invisible_Halfling_Female_030";
        case 652: return "Invisible_Halfling_Female_040";
        case 653: return "Invisible_Halfling_Female_050";
        case 654: return "Invisible_Halfling_Female_060";
        case 655: return "Invisible_Halfling_Female_070";
        case 656: return "Invisible_Halfling_Female_080";
        case 657: return "Invisible_Halfling_Female_090";
        case 658: return "Invisible_Halfling_Female_100";
        case 659: return "Invisible_Halfling_Female_110";
        case 660: return "Invisible_Halfling_Female_120";
        case 661: return "Invisible_Halfling_Female_130";
        case 662: return "Invisible_Halfling_Female_140";
        case 663: return "Invisible_Halfling_Female_150";
        case 664: return "Invisible_Halfling_Female_160";
        case 665: return "Invisible_Halfling_Female_170";
        case 666: return "Invisible_Halfling_Female_180";
        case 667: return "Invisible_Halfling_Female_190";
        case 668: return "Invisible_Halfling_Female_200";
        case 669: return "Invisible_Halforc_Female_010";
        case 670: return "Invisible_Halforc_Female_020";
        case 671: return "Invisible_Halforc_Female_030";
        case 672: return "Invisible_Halforc_Female_040";
        case 673: return "Invisible_Halforc_Female_050";
        case 674: return "Invisible_Halforc_Female_060";
        case 675: return "Invisible_Halforc_Female_070";
        case 676: return "Invisible_Halforc_Female_080";
        case 677: return "Invisible_Halforc_Female_090";
        case 678: return "Invisible_Halforc_Female_100";
        case 679: return "Invisible_Halforc_Female_110";
        case 680: return "Invisible_Halforc_Female_120";
        case 681: return "Invisible_Halforc_Female_130";
        case 682: return "Invisible_Halforc_Female_140";
        case 683: return "Invisible_Halforc_Female_150";
        case 684: return "Invisible_Halforc_Female_160";
        case 685: return "Invisible_Halforc_Female_170";
        case 686: return "Invisible_Halforc_Female_180";
        case 687: return "Invisible_Halforc_Female_190";
        case 688: return "Invisible_Halforc_Female_200";
        case 689: return "Invisible_Human_Female_010";
        case 690: return "Invisible_Human_Female_020";
        case 691: return "Invisible_Human_Female_030";
        case 692: return "Invisible_Human_Female_040";
        case 693: return "Invisible_Human_Female_050";
        case 694: return "Invisible_Human_Female_060";
        case 695: return "Invisible_Human_Female_070";
        case 696: return "Invisible_Human_Female_080";
        case 697: return "Invisible_Human_Female_090";
        case 698: return "Invisible_Human_Female_100";
        case 699: return "Invisible_Human_Female_110";
        case 700: return "Invisible_Human_Female_120";
        case 701: return "Invisible_Human_Female_130";
        case 702: return "Invisible_Human_Female_140";
        case 703: return "Invisible_Human_Female_150";
        case 704: return "Invisible_Human_Female_160";
        case 705: return "Invisible_Human_Female_170";
        case 706: return "Invisible_Human_Female_180";
        case 707: return "Invisible_Human_Female_190";
        case 708: return "Invisible_Human_Female_200";
        case 709: return "Invisible_Dwarf_Male_010";
        case 710: return "Invisible_Dwarf_Male_020";
        case 711: return "Invisible_Dwarf_Male_030";
        case 712: return "Invisible_Dwarf_Male_040";
        case 713: return "Invisible_Dwarf_Male_050";
        case 714: return "Invisible_Dwarf_Male_060";
        case 715: return "Invisible_Dwarf_Male_070";
        case 716: return "Invisible_Dwarf_Male_080";
        case 717: return "Invisible_Dwarf_Male_090";
        case 718: return "Invisible_Dwarf_Male_100";
        case 719: return "Invisible_Dwarf_Male_110";
        case 720: return "Invisible_Dwarf_Male_120";
        case 721: return "Invisible_Dwarf_Male_130";
        case 722: return "Invisible_Dwarf_Male_140";
        case 723: return "Invisible_Dwarf_Male_150";
        case 724: return "Invisible_Dwarf_Male_160";
        case 725: return "Invisible_Dwarf_Male_170";
        case 726: return "Invisible_Dwarf_Male_180";
        case 727: return "Invisible_Dwarf_Male_190";
        case 728: return "Invisible_Dwarf_Male_200";
        case 729: return "Invisible_Elf_Male_010";
        case 730: return "Invisible_Elf_Male_020";
        case 731: return "Invisible_Elf_Male_030";
        case 732: return "Invisible_Elf_Male_040";
        case 733: return "Invisible_Elf_Male_050";
        case 734: return "Invisible_Elf_Male_060";
        case 735: return "Invisible_Elf_Male_070";
        case 736: return "Invisible_Elf_Male_080";
        case 737: return "Invisible_Elf_Male_090";
        case 738: return "Invisible_Elf_Male_100";
        case 739: return "Invisible_Elf_Male_110";
        case 740: return "Invisible_Elf_Male_120";
        case 741: return "Invisible_Elf_Male_130";
        case 742: return "Invisible_Elf_Male_140";
        case 743: return "Invisible_Elf_Male_150";
        case 744: return "Invisible_Elf_Male_160";
        case 745: return "Invisible_Elf_Male_170";
        case 746: return "Invisible_Elf_Male_180";
        case 747: return "Invisible_Elf_Male_190";
        case 748: return "Invisible_Elf_Male_200";
        case 749: return "Invisible_Gnome_Male_010";
        case 750: return "Invisible_Gnome_Male_020";
        case 751: return "Invisible_Gnome_Male_030";
        case 752: return "Invisible_Gnome_Male_040";
        case 753: return "Invisible_Gnome_Male_050";
        case 754: return "Invisible_Gnome_Male_060";
        case 755: return "Invisible_Gnome_Male_070";
        case 756: return "Invisible_Gnome_Male_080";
        case 757: return "Invisible_Gnome_Male_090";
        case 758: return "Invisible_Gnome_Male_100";
        case 759: return "Invisible_Gnome_Male_110";
        case 760: return "Invisible_Gnome_Male_120";
        case 761: return "Invisible_Gnome_Male_130";
        case 762: return "Invisible_Gnome_Male_140";
        case 763: return "Invisible_Gnome_Male_150";
        case 764: return "Invisible_Gnome_Male_160";
        case 765: return "Invisible_Gnome_Male_170";
        case 766: return "Invisible_Gnome_Male_180";
        case 767: return "Invisible_Gnome_Male_190";
        case 768: return "Invisible_Gnome_Male_200";
        case 769: return "Invisible_Halfling_Male_010";
        case 770: return "Invisible_Halfling_Male_020";
        case 771: return "Invisible_Halfling_Male_030";
        case 772: return "Invisible_Halfling_Male_040";
        case 773: return "Invisible_Halfling_Male_050";
        case 774: return "Invisible_Halfling_Male_060";
        case 775: return "Invisible_Halfling_Male_070";
        case 776: return "Invisible_Halfling_Male_080";
        case 777: return "Invisible_Halfling_Male_090";
        case 778: return "Invisible_Halfling_Male_100";
        case 779: return "Invisible_Halfling_Male_110";
        case 780: return "Invisible_Halfling_Male_120";
        case 781: return "Invisible_Halfling_Male_130";
        case 782: return "Invisible_Halfling_Male_140";
        case 783: return "Invisible_Halfling_Male_150";
        case 784: return "Invisible_Halfling_Male_160";
        case 785: return "Invisible_Halfling_Male_170";
        case 786: return "Invisible_Halfling_Male_180";
        case 787: return "Invisible_Halfling_Male_190";
        case 788: return "Invisible_Halfling_Male_200";
        case 789: return "Invisible_Halforc_Male_010";
        case 790: return "Invisible_Halforc_Male_020";
        case 791: return "Invisible_Halforc_Male_030";
        case 792: return "Invisible_Halforc_Male_040";
        case 793: return "Invisible_Halforc_Male_050";
        case 794: return "Invisible_Halforc_Male_060";
        case 795: return "Invisible_Halforc_Male_070";
        case 796: return "Invisible_Halforc_Male_080";
        case 797: return "Invisible_Halforc_Male_090";
        case 798: return "Invisible_Halforc_Male_100";
        case 799: return "Invisible_Halforc_Male_110";
        case 800: return "Invisible_Halforc_Male_120";
        case 801: return "Invisible_Halforc_Male_130";
        case 802: return "Invisible_Halforc_Male_140";
        case 803: return "Invisible_Halforc_Male_150";
        case 804: return "Invisible_Halforc_Male_160";
        case 805: return "Invisible_Halforc_Male_170";
        case 806: return "Invisible_Halforc_Male_180";
        case 807: return "Invisible_Halforc_Male_190";
        case 808: return "Invisible_Halforc_Male_200";
        case 809: return "Invisible_Human_Male_010";
        case 810: return "Invisible_Human_Male_020";
        case 811: return "Invisible_Human_Male_030";
        case 812: return "Invisible_Human_Male_040";
        case 813: return "Invisible_Human_Male_050";
        case 814: return "Invisible_Human_Male_060";
        case 815: return "Invisible_Human_Male_070";
        case 816: return "Invisible_Human_Male_080";
        case 817: return "Invisible_Human_Male_090";
        case 818: return "Invisible_Human_Male_100";
        case 819: return "Invisible_Human_Male_110";
        case 820: return "Invisible_Human_Male_120";
        case 821: return "Invisible_Human_Male_130";
        case 822: return "Invisible_Human_Male_140";
        case 823: return "Invisible_Human_Male_150";
        case 824: return "Invisible_Human_Male_160";
        case 825: return "Invisible_Human_Male_170";
        case 826: return "Invisible_Human_Male_180";
        case 827: return "Invisible_Human_Male_190";
        case 828: return "Invisible_Human_Male_200";
        case 829: return "Invisible_CreatureS_010";
        case 830: return "Invisible_CreatureS_020";
        case 831: return "Invisible_CreatureS_030";
        case 832: return "Invisible_CreatureS_040";
        case 833: return "Invisible_CreatureS_050";
        case 834: return "Invisible_CreatureS_060";
        case 835: return "Invisible_CreatureS_070";
        case 836: return "Invisible_CreatureS_080";
        case 837: return "Invisible_CreatureS_090";
        case 838: return "Invisible_CreatureS_100";
        case 839: return "Invisible_CreatureS_110";
        case 840: return "Invisible_CreatureS_120";
        case 841: return "Invisible_CreatureS_130";
        case 842: return "Invisible_CreatureS_140";
        case 843: return "Invisible_CreatureS_150";
        case 844: return "Invisible_CreatureS_160";
        case 845: return "Invisible_CreatureS_170";
        case 846: return "Invisible_CreatureS_180";
        case 847: return "Invisible_CreatureS_190";
        case 848: return "Invisible_CreatureS_200";
        case 849: return "Invisible_CreatureL_010";
        case 850: return "Invisible_CreatureL_020";
        case 851: return "Invisible_CreatureL_030";
        case 852: return "Invisible_CreatureL_040";
        case 853: return "Invisible_CreatureL_050";
        case 854: return "Invisible_CreatureL_060";
        case 855: return "Invisible_CreatureL_070";
        case 856: return "Invisible_CreatureL_080";
        case 857: return "Invisible_CreatureL_090";
        case 858: return "Invisible_CreatureL_100";
        case 859: return "Invisible_CreatureL_110";
        case 860: return "Invisible_CreatureL_120";
        case 861: return "Invisible_CreatureL_130";
        case 862: return "Invisible_CreatureL_140";
        case 863: return "Invisible_CreatureL_150";
        case 864: return "Invisible_CreatureL_160";
        case 865: return "Invisible_CreatureL_170";
        case 866: return "Invisible_CreatureL_180";
        case 867: return "Invisible_CreatureL_190";
        case 868: return "Invisible_CreatureL_200";
        case 869: return "Troglodyte_garm";
        case 870: return "Troglodyte_green";
    }

    return "";
}

void CheckTail( object oPC, string sSearch, int nTail ){

    string sTail = GetTailName( nTail );

    if ( FindSubString( GetStringLowerCase( sTail ), sSearch ) != -1 ){

        SendMessageToPC( oPC, IntToString( nTail )+": "+sTail );
    }
}

string GetTailName( int nTail ){

    switch ( nTail ){

        case 0: return "None";
        case 1: return "Lizard";
        case 2: return "Bone";
        case 3: return "Devil";
        case 4: return "Dragon, Brass";
        case 5: return "Dragon, Bronze";
        case 6: return "Dragon, Copper";
        case 7: return "Dragon, Silver";
        case 8: return "Dragon, Gold";
        case 9: return "Dragon, Black";
        case 10: return "Dragon, Blue";
        case 11: return "Dragon, Green";
        case 12: return "Dragon, Red";
        case 13: return "Dragon, White";
        case 14: return "NullTail";
        case 15: return "Horse, Walnut";
        case 16: return "Horse, Walnut, saddle";
        case 17: return "Horse, Walnut, saddle, packs";
        case 18: return "Horse, Walnut, leather barding";
        case 19: return "Horse, Walnut, scale mail barding";
        case 20: return "Horse, Walnut, chain barding";
        case 21: return "Horse, Walnut, purple barding";
        case 22: return "Horse, Walnut, red barding";
        case 23: return "Horse, Walnut, leather barding, packs";
        case 24: return "Horse, Walnut, scale mail barding, packs";
        case 25: return "Horse, Walnut, chain barding, packs";
        case 26: return "Horse, Walnut, purple barding, packs";
        case 27: return "Horse, Walnut, red barding, packs";
        case 28: return "Horse, Gunpowder";
        case 29: return "Horse, Gunpowder, saddle";
        case 30: return "Horse, Gunpowder, saddle, packs";
        case 31: return "Horse, Gunpowder, leather barding";
        case 32: return "Horse, Gunpowder, scale mail barding";
        case 33: return "Horse, Gunpowder, chain barding";
        case 34: return "Horse, Gunpowder, purple barding";
        case 35: return "Horse, Gunpowder, red barding";
        case 36: return "Horse, Gunpowder, leather barding, packs";
        case 37: return "Horse, Gunpowder, scale mail barding, packs";
        case 38: return "Horse, Gunpowder, chain barding, packs";
        case 39: return "Horse, Gunpowder, purple barding, packs";
        case 40: return "Horse, Gunpowder, red barding, packs";
        case 41: return "Horse, Spotted";
        case 42: return "Horse, Spotted, saddle";
        case 43: return "Horse, Spotted, saddle, packs";
        case 44: return "Horse, Spotted, leather barding";
        case 45: return "Horse, Spotted, scale mail barding";
        case 46: return "Horse, Spotted, chain barding";
        case 47: return "Horse, Spotted, purple barding";
        case 48: return "Horse, Spotted, red barding";
        case 49: return "Horse, Spotted, leather barding, packs";
        case 50: return "Horse, Spotted, scale mail barding, packs";
        case 51: return "Horse, Spotted, chain barding, packs";
        case 52: return "Horse, Spotted, purple barding, packs";
        case 53: return "Horse, Spotted, red barding, packs";
        case 54: return "Horse, Black";
        case 55: return "Horse, Black, saddle";
        case 56: return "Horse, Black, saddle, packs";
        case 57: return "Horse, Black, leather barding";
        case 58: return "Horse, Black, scale mail barding";
        case 59: return "Horse, Black, chain barding";
        case 60: return "Horse, Black, purple barding";
        case 61: return "Horse, Black, red barding";
        case 62: return "Horse, Black, leather barding, packs";
        case 63: return "Horse, Black, scale mail barding, packs";
        case 64: return "Horse, Black, chain barding, packs";
        case 65: return "Horse, Black, purple barding, packs";
        case 66: return "Horse, Black, red barding, packs";
        case 67: return "Nightmare, barding";
        case 68: return "Nightmare, saddle";
        case 69: return "Nightmare";
        case 70: return "Horse, Jousting, Purple cloth";
        case 71: return "Horse, Jousting, Blue and gold cloth";
        case 72: return "Horse, Jousting, Black and white cloth";
        case 73: return "Horse, Jousting, Red and yellow cloth";
        case 74: return "Horse, Jousting, Red and black Striped cloth";
        case 75: return "Horse, Jousting, Green cloth";
        case 76: return "Horse, Jousting, Blue and pink cloth";
        case 77: return "Horse, Jousting, Red and gold brick cloth";
        case 78: return "Horse, Jousting, Black cloth";
        case 79: return "Horse, Jousting, Cyan and white cloth";
        case 80: return "Horse, Jousting, White cloth";
        case 81: return "Halfling, NPC, Female";
        case 82: return "Halfling, NPC, Male";
        case 83: return "Azer, Female";
        case 84: return "Azer, Male";
        case 85: return "Druegar, Cleric";
        case 86: return "Druegar, Fighter";
        case 87: return "Duergar, Chief";
        case 88: return "Duergar, Slave";
        case 89: return "Dwarf, NPC, Female";
        case 90: return "Dwarf, NPC, Male";
        case 91: return "Svirf, Female";
        case 92: return "Svirf, Male";
        case 93: return "Drow, Matron";
        case 94: return "Drow, Cleric";
        case 95: return "Drow, Female, 1";
        case 96: return "Drow, Female, 2";
        case 97: return "Drow, Fighter";
        case 98: return "Drow, Slave";
        case 99: return "Drow, Warrior, 1";
        case 100: return "Drow, Warrior, 2";
        case 101: return "Drow, Warrior, 3";
        case 102: return "Drow, Wizard";
        case 103: return "Elf, NPC, Female";
        case 104: return "Elf, NPC, Male, 01";
        case 105: return "Elf, NPC, Male, 02";
        case 106: return "Gnome, NPC, Female";
        case 107: return "Gnome, NPC, Male";
        case 108: return "Half-Orc, NPC, Female";
        case 109: return "Half-Orc, NPC, Male, 01";
        case 110: return "Half-Orc, NPC, Male, 02";
        case 111: return "Bartender";
        case 112: return "Begger";
        case 113: return "Blood, Sailer";
        case 114: return "Convict";
        case 115: return "Cult, Member";
        case 116: return "Dryad";
        case 117: return "Female, 01";
        case 118: return "Female, 02";
        case 119: return "Female, 03";
        case 120: return "Female, 04";
        case 121: return "House, Guard";
        case 122: return "Human, NPC, Female, 01";
        case 123: return "Human, NPC, Female, 02";
        case 124: return "Human, NPC, Female, 03";
        case 125: return "Human, NPC, Female, 04";
        case 126: return "Human, NPC, Female, 05";
        case 127: return "Human, NPC, Female, 06";
        case 128: return "Human, NPC, Female, 07";
        case 129: return "Human, NPC, Female, 08";
        case 130: return "Human, NPC, Female, 09";
        case 131: return "Human, NPC, Female, 10";
        case 132: return "Human, NPC, Female, 11";
        case 133: return "Human, NPC, Female, 12";
        case 134: return "Human, NPC, Male, 01";
        case 135: return "Human, NPC, Male, 02";
        case 136: return "Human, NPC, Male, 03";
        case 137: return "Human, NPC, Male, 04";
        case 138: return "Human, NPC, Male, 05";
        case 139: return "Human, NPC, Male, 06";
        case 140: return "Human, NPC, Male, 07";
        case 141: return "Human, NPC, Male, 08";
        case 142: return "Human, NPC, Male, 09";
        case 143: return "Human, NPC, Male, 10";
        case 144: return "Human, NPC, Male, 11";
        case 145: return "Human, NPC, Male, 12";
        case 146: return "Human, NPC, Male, 13";
        case 147: return "Human, NPC, Male, 14";
        case 148: return "Human, NPC, Male, 15";
        case 149: return "Human, NPC, Male, 16";
        case 150: return "Human, NPC, Male, 17";
        case 151: return "Human, NPC, Male, 18";
        case 152: return "Inn, Keeper";
        case 153: return "Kid, Female";
        case 154: return "Kid, Male";
        case 155: return "Luskan, Guard";
        case 156: return "Male, 01";
        case 157: return "Male, 02";
        case 158: return "Male, 03";
        case 159: return "Male, 04";
        case 160: return "Male, 05";
        case 161: return "Medusa";
        case 162: return "NW, Militia, Member";
        case 163: return "Nymph";
        case 164: return "Old, Man";
        case 165: return "Old, Woman";
        case 166: return "PDK, Archer, Female";
        case 167: return "PDK, Archer, Male";
        case 168: return "PDK, Blade, Female";
        case 169: return "PDK, Blade, Male";
        case 170: return "Plague, Victim";
        case 171: return "Prostitute, 01";
        case 172: return "Prostitute, 02";
        case 173: return "Sea, Hag";
        case 174: return "Shop, Keeper";
        case 175: return "Succubus";
        case 176: return "Uthgard, Elk, Tribe";
        case 177: return "Uthgard, Tiger, Tribe";
        case 178: return "Waitress";
        case 179: return "Caladnei";
        case 180: return "Hagatha";
        case 181: return "Halaster";
        case 182: return "Lord, Antoine";
        case 183: return "Masterius";
        case 184: return "Masterius, Full, Power";
        case 185: return "NWN, Aarin";
        case 186: return "NWN, Aribeth";
        case 187: return "NWN, Aribeth, Evil";
        case 188: return "NWN, Haedraline";
        case 189: return "NWN, Maugrim";
        case 190: return "NWN, Morag";
        case 191: return "NWN, Nasher";
        case 192: return "NWN, Sedos";
        case 193: return "Witch, King, Disguised";
        case 194: return "XP1, HeurodisLich";
        case 195: return "Gnoll, Warrior";
        case 196: return "Gnoll, Wiz";
        case 197: return "Hobgoblin, Warrior";
        case 198: return "Hobgoblin, Wizard";
        case 199: return "Bugbear, A";
        case 200: return "Bugbear, B";
        case 201: return "Bugbear, Chieftain, A";
        case 202: return "Bugbear, Chieftain, B";
        case 203: return "Bugbear, Shaman, A";
        case 204: return "Bugbear, Shaman, B";
        case 205: return "None";
        case 206: return "Goblin, Chief, A";
        case 207: return "Goblin, Chief, B";
        case 208: return "Goblin, A";
        case 209: return "Goblin, B";
        case 210: return "Goblin, Shaman, A";
        case 211: return "Goblin, Shaman, B";
        case 212: return "Orc, A";
        case 213: return "Orc, B";
        case 214: return "Orc, Chieftain, A";
        case 215: return "Orc, Chieftain, B";
        case 216: return "Orc, Shaman, A";
        case 217: return "Orc, Shaman, B";
        case 218: return "Kobold, A";
        case 219: return "Kobold, B";
        case 220: return "Kobold, Chief, A";
        case 221: return "Kobold, Chief, B";
        case 222: return "Kobold, Shaman, A";
        case 223: return "Kobold, Shaman, B";
        case 224: return "Asabi, Shaman";
        case 225: return "Lizardfolk, Shaman, A";
        case 226: return "Lizardfolk, Shaman, B";
        case 227: return "Asabi, Chieftain";
        case 228: return "Lizardfolk, Warrior, A";
        case 229: return "Lizardfolk, Warrior, B";
        case 230: return "Lizardfolk, B";
        case 231: return "Asabi, Warrior";
        case 232: return "Lizardfolk, A";
        case 233: return "Yuan, Ti";
        case 234: return "Yuan, Ti, Chieften";
        case 235: return "Yuan, Ti, Wizard";
        case 236: return "Troglodyte";
        case 237: return "Troglodyte, Cleric";
        case 238: return "Troglodyte, Warrior";
        case 239: return "Rakshasa, Bear, Male";
        case 240: return "Rakshasa, Tiger, Male";
        case 241: return "Rakshasa, Tiger, Female";
        case 242: return "Rakshasa, Wolf, Male";
        case 243: return "Sahuagin";
        case 244: return "Sahuagin, Cleric";
        case 245: return "Sahuagin, Leader";
        case 246: return "Satyr";
        case 247: return "Satyr, Archer";
        case 248: return "Satyr, Warrior";
        case 249: return "Bodak";
        case 250: return "Doom, Knight";
        case 251: return "Ghast";
        case 252: return "Ghoul";
        case 253: return "Ghoul, Lord";
        case 254: return "Lich";
        case 255: return "Helmed, Horror";
        case 256: return "Mohrg";
        case 257: return "Mummy, Common";
        case 258: return "Mummy, Fighter, 2";
        case 259: return "Mummy, Warrior";
        case 260: return "Mummy, Greater";
        case 261: return "Vampire, Female";
        case 262: return "Vampire, Male";
        case 263: return "Shadow";
        case 264: return "Shadow, Fiend";
        case 265: return "Skeleton, Mage";
        case 266: return "Skeleton, Chieftain";
        case 267: return "Skeleton, Common";
        case 268: return "Skeleton, Priest";
        case 269: return "Skeleton, Warrior, 1";
        case 270: return "Skeleton, Warrior, 2";
        case 271: return "Skeleton, Warrior";
        case 272: return "Wight";
        case 273: return "Zombie";
        case 274: return "Zombie, Rotting";
        case 275: return "Zombie, Warrior, 1";
        case 276: return "Zombie, Warrior, 2";
        case 277: return "Zombie, Tyrant, Fog";
        case 278: return "Bat, Horror";
        case 279: return "Golem, Diamond";
        case 280: return "Golem, Emerald";
        case 281: return "Golem, Ruby";
        case 282: return "****";
        case 283: return "Golem, Adamantium";
        case 284: return "Golem, Demonflesh";
        case 285: return "Golem, Iron";
        case 286: return "Golem, Mithril";
        case 287: return "Balor";
        case 288: return "Devil";
        case 289: return "Drider";
        case 290: return "Drider, Female";
        case 291: return "Drider, Chief";
        case 292: return "Ettin";
        case 293: return "Formian, Myrmarch";
        case 294: return "Formian, Queen";
        case 295: return "Formian, Warrior";
        case 296: return "Formian, Worker";
        case 297: return "GelatinousCube";
        case 298: return "Giant, Hill";
        case 299: return "Giant, Mountain";
        case 300: return "Giant, Fire";
        case 301: return "Giant, Fire, Female";
        case 302: return "Giant, Frost";
        case 303: return "Giant, Frost, Female";
        case 304: return "Minotaur, Chieftain";
        case 305: return "Minogon";
        case 306: return "Minotaur";
        case 307: return "Minotaur, Shaman";
        case 308: return "Ogre";
        case 309: return "Ogre, Chieftain";
        case 310: return "Ogre, Mage";
        case 311: return "Ogre, ChieftainB";
        case 312: return "Ogre, Elite";
        case 313: return "Ogre, MageB";
        case 314: return "OgreB";
        case 315: return "Stinger, Chieftain";
        case 316: return "Stinger";
        case 317: return "Stinger, Mage";
        case 318: return "Stinger, Warrior";
        case 319: return "Wereboar";
        case 320: return "****";
        case 321: return "Dracolich";
        case 322: return "Dragon, Black";
        case 323: return "Dragon, Blue";
        case 324: return "Dragon, Brass";
        case 325: return "Dragon, Bronze";
        case 326: return "Dragon, Copper";
        case 327: return "Dragon, Gold";
        case 328: return "Dragon, Green";
        case 329: return "Dragon, Mist";
        case 330: return "Dragon, Pris";
        case 331: return "Dragon, Red";
        case 332: return "Dragon, Shadow";
        case 333: return "Dragon, Silver";
        case 334: return "Dragon, White";
        case 335: return "Golem, Bone";
        case 336: return "Golem, Clay";
        case 337: return "Golem, Flesh";
        case 338: return "Golem, Stone";
        case 339: return "Elemental, Air";
        case 340: return "Elemental, Air, Elder";
        case 341: return "Elemental, Earth";
        case 342: return "Elemental, Earth, Elder";
        case 343: return "Elemental, Fire";
        case 344: return "Elemental, Fire, Elder";
        case 345: return "Elemental, Water";
        case 346: return "Elemental, Water, Elder";
        case 347: return "Badger, Dire";
        case 348: return "Bat";
        case 349: return "Badger";
        case 350: return "Bear, Brown";
        case 351: return "Boar";
        case 352: return "Bear, Black";
        case 353: return "Bear, Dire";
        case 354: return "Bear, Kodiak";
        case 355: return "Bear, Polar";
        case 356: return "Boar, Dire";
        case 357: return "Chicken";
        case 358: return "Snake, Cobra";
        case 359: return "Snake, Black, Cobra";
        case 360: return "Snake, Gold, Cobra";
        case 361: return "Cow";
        case 362: return "Deep, Rothe";
        case 363: return "Deer";
        case 364: return "Deer, Stag";
        case 365: return "Rat, Dire";
        case 366: return "Cat, Cougar";
        case 367: return "Cat, Crag, Cat";
        case 368: return "Cat, Cat, Dire";
        case 369: return "Cat, Jaguar";
        case 370: return "Cat, Krenshar";
        case 371: return "Cat, Leopard";
        case 372: return "Cat, Lion";
        case 373: return "Cat, Panther";
        case 374: return "Cat, MPanther";
        case 375: return "Ox";
        case 376: return "Parrot";
        case 377: return "Penguin";
        case 378: return "Falcon";
        case 379: return "Rat";
        case 380: return "Raven";
        case 381: return "Seagull, Flying";
        case 382: return "Seagull, Walking";
        case 383: return "Shark, Goblin";
        case 384: return "Shark, Hammerhead";
        case 385: return "Shark, Mako";
        case 386: return "Dog, Blinkdog";
        case 387: return "Dog, Dire, Wolf";
        case 388: return "Dog";
        case 389: return "Dog, Fenhound";
        case 390: return "Dog, Hell, Hound";
        case 391: return "Dog, Shadow, Mastif";
        case 392: return "Dog, Wolf";
        case 393: return "Dog, Winter, Wolf";
        case 394: return "Dog, Worg";
        case 395: return "Maggris";
        case 396: return "Harat";
        case 397: return "Harat, Small";
        case 398: return "Beholder, GZhorb";
        case 399: return "Mephisto, Big";
        case 400: return "Mephisto, Norm";
        case 401: return "Allip";
        case 402: return "arch, target";
        case 403: return "Beetle, Stag";
        case 404: return "Lantern, Archon";
        case 405: return "Will, O, Wisp";
        case 406: return "Beetle, Fire";
        case 407: return "Beetle, Slicer";
        case 408: return "Beetle, Stink";
        case 409: return "Beholder";
        case 410: return "Beholder, Mother";
        case 411: return "Beholder, Eyeball";
        case 412: return "Beholder, Mage";
        case 413: return "objectBoat";
        case 414: return "Bulette";
        case 415: return "animated, chest";
        case 416: return "Cockatrice";
        case 417: return "Curst, Swordsman";
        case 418: return "Demi, Lich";
        case 419: return "Fairy";
        case 420: return "Gargoyle";
        case 421: return "Grey, Render";
        case 422: return "Shield, Guardian";
        case 423: return "Gorgon";
        case 424: return "Gray, Ooze";
        case 425: return "Gynosphinx";
        case 426: return "Manticore";
        case 427: return "Sphinx";
        case 428: return "Werecat";
        case 429: return "Harpy";
        case 430: return "Vrock";
        case 431: return "Hook, Horror";
        case 432: return "Quasit";
        case 433: return "Imp";
        case 434: return "Mephit, Air";
        case 435: return "Mephit, Dust";
        case 436: return "Mephit, Earth";
        case 437: return "Mephit, Fire";
        case 438: return "Mephit, Ice";
        case 439: return "Mephit, Magma";
        case 440: return "Mephit, Ooze";
        case 441: return "Mephit, Salt";
        case 442: return "Mephit, Steam";
        case 443: return "Mephit, Water";
        case 444: return "War, Devourer";
        case 445: return "Skeletal, Devourer";
        case 446: return "Intellect, Devourer";
        case 447: return "Basilisk";
        case 448: return "Mindflayer";
        case 449: return "Mindflayer, Alhoon";
        case 450: return "Mindflayer2";
        case 451: return "Ochre, Jelly, Large";
        case 452: return "Ochre, Jelly, Medium";
        case 453: return "Ochre, Jelly, Small";
        case 454: return "Wyrmling, Black";
        case 455: return "Wyrmling, Blue";
        case 456: return "Wyrmling, Brass";
        case 457: return "Wyrmling, Bronze";
        case 458: return "Wyrmling, Copper";
        case 459: return "Wyrmling, Gold";
        case 460: return "Wyrmling, Green";
        case 461: return "Wyrmling, Red";
        case 462: return "Wyrmling, Silver";
        case 463: return "Wyrmling, White";
        case 464: return "Slaad, Blue";
        case 465: return "Slaad, Death";
        case 466: return "Slaad, Gray";
        case 467: return "Slaad, Green";
        case 468: return "Slaad, Red";
        case 469: return "Slaad, Black";
        case 470: return "Slaad, White";
        case 471: return "Spectre";
        case 472: return "Spider, Demon";
        case 473: return "Aranea";
        case 474: return "Spider, Dire";
        case 475: return "Spider, Giant";
        case 476: return "Spider, Phase";
        case 477: return "Spider, Sword";
        case 478: return "Spider, Wraith";
        case 479: return "Ettercap";
        case 480: return "Troll";
        case 481: return "Troll, Chieftain";
        case 482: return "Troll, Shaman";
        case 483: return "Umberhulk";
        case 484: return "Wererat";
        case 485: return "Werewolf";
        case 486: return "Wraith";
        case 487: return "Wyvern, Adult";
        case 488: return "Wyvern, Great";
        case 489: return "Wyvern, Juvenile";
        case 490: return "Wyvern, Young";
    }

    return "";
}

void CheckWing( object oPC, string sSearch, int nWing ){

    string sWing = GetWingName( nWing );

    if ( FindSubString( GetStringLowerCase( sWing ), sSearch ) != -1 ){

        SendMessageToPC( oPC, IntToString( nWing )+": "+sWing );
    }
}

string GetWingName( int nWing ){

    switch ( nWing ){

        case 0: return "None'";
        case 1: return "Demon'";
        case 2: return "Angel'";
        case 3: return "Bat'";
        case 4: return "Dragon'";
        case 5: return "Butterfly'";
        case 6: return "Bird'";
        case 59: return "Dragon Wing, Brass'";
        case 60: return "Dragon Wing, Bronze'";
        case 61: return "Dragon Wing, Copper'";
        case 62: return "Dragon Wing, Silver'";
        case 63: return "Dragon Wing, Gold'";
        case 64: return "Dragon Wing, White'";
        case 65: return "Dragon Wing, Black'";
        case 66: return "Dragon Wing, Green'";
        case 67: return "Dragon Wing, Blue'";
        case 68: return "Dragon Wing, Red'";
        case 69: return "Dragon Wing, Brass 2'";
        case 70: return "Dragon Wing, Bronze 2'";
        case 71: return "Dragon Wing, Copper 2'";
        case 72: return "Dragon Wing, Silver 2'";
        case 73: return "Dragon Wing, Gold 2'";
        case 74: return "Dragon Wing, White 2'";
        case 75: return "Dragon Wing, Black 2'";
        case 76: return "Dragon Wing, Green 2'";
        case 77: return "Dragon Wing, Blue 2'";
        case 78: return "Dragon Wing, Red 2'";
        case 79: return "Backpack'";
        case 80: return "Backpack, Bedroll'";
        case 81: return "Quiver'";
        case 82: return "Quiver, Empty'";
        case 83: return "Scabbard'";
        case 84: return "Scabbard, empty'";
        case 85: return "Scabbard A'";
        case 86: return "Scabbard A, empty'";
        case 87: return "Scabbard B'";
        case 88: return "Scabbard B, empty'";
        case 89: return "Greatsword'";
    }

    return "";
}

void ColorListener( object oPC, string sMessage ){

    if ( GetLocalInt(oPC, "td_styler_listener" ) != TRUE ){

        return;
    }

    SetLocalString(oPC, "td_color_chat", sMessage);
    DeleteLocalInt(oPC, "td_styler_listener");
    SendMessageToPC(oPC, "Catched: "+sMessage);
    AssignCommand(oPC,ActionResumeConversation());
}

void f_Love( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Love [Self,PC,NPC][H,C,M,D]\nOptions: H=hostile, C=commoner, M=merchant, D=defender.\nExample: f_Love PC H\nThis makes the nearest PC a friend of all hostile critters." );
        return;
    }

    int nFaction;

    if ( sValue == "H" ){ nFaction = STANDARD_FACTION_HOSTILE; }
    else if ( sValue == "C" ){ nFaction = STANDARD_FACTION_COMMONER; }
    else if ( sValue == "M" ){ nFaction = STANDARD_FACTION_MERCHANT; }
    else if ( sValue == "D" ){ nFaction = STANDARD_FACTION_DEFENDER; }
    else { return; }

    SetStandardFactionReputation( nFaction, 100, oObject );
}

void f_Hate( object oPC, object oObject, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Hate [Self,PC,NPC][H,C,M,D]\nOptions: H=hostile, C=commoner, M=merchant, D=defender.\nExample: f_Hate PC M\nThis makes the nearest PC an enemy of all merchants." );
        return;
    }

    int nFaction;

    if ( sValue == "H" ){ nFaction = STANDARD_FACTION_HOSTILE; }
    else if ( sValue == "C" ){ nFaction = STANDARD_FACTION_COMMONER; }
    else if ( sValue == "M" ){ nFaction = STANDARD_FACTION_MERCHANT; }
    else if ( sValue == "D" ){ nFaction = STANDARD_FACTION_DEFENDER; }
    else { return; }

    SetStandardFactionReputation( nFaction, 100, oObject );
}

void f_Note( object oPC, string sOption, string sValue ){

    if ( sOption == "?" || sOption == "help" ){

        SendMessageToPC( oPC, "Use: f_Note [Add,Remove,Load,List][Text]\nOptions: Add creates a note at your current location. Remove removes your last note. Load loads your notes in this server from the database and places their map pins. List lists the notes you loaded earlier. Only Add uses the Text option.\nExample: f_Note Add This is a cave. \nThis adds a persistent map pin with the text 'This is a cave'." );
        return;
    }

    string sSQL;
    string sAccount = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    int nModule     = GetLocalInt( GetModule(), "Module" );
    object oArea    = GetArea( oPC );
    int nPins;

    if ( sOption == "add" ){

        string sResref  = GetResRef( oArea );
        vector vPos     = GetPosition( oPC );
        string sX       = FloatToString( vPos.x, 3, 2 );
        string sY       = FloatToString( vPos.y, 3, 2 );

        //create query for map pin
        sSQL = "INSERT INTO player_notes VALUES ( NULL, '"
                +sAccount+"', "
                +IntToString( nModule )+", '"
                +sResref+"', '"
                +sX+"', '"
                +sY+"', '"
                +SQLEncodeSpecialChars( sValue )+"', NOW() )";

        //execute map pin query
        SQLExecDirect( sSQL );

        SendMessageToPC( oPC, "Note added. \nMind that the minimap will not change when you are in the same area. Exit and reenter to see the change." );

        nPins = GetLocalInt( oPC, "NW_TOTAL_MAP_PINS" ) + 1;

        SetLocalString( oPC, "NW_MAP_PIN_NTRY_"+IntToString( nPins ), sValue );
        SetLocalFloat( oPC, "NW_MAP_PIN_XPOS_"+IntToString( nPins ), vPos.x );
        SetLocalFloat( oPC, "NW_MAP_PIN_YPOS_"+IntToString( nPins ), vPos.y );
        SetLocalObject( oPC, "NW_MAP_PIN_AREA_"+IntToString( nPins ), oArea );
        SetLocalInt( oPC, "NW_TOTAL_MAP_PINS", nPins );

    }
    else if ( sOption == "remove" ){

        //create map pin removal query
        sSQL = "DELETE FROM `player_notes` WHERE account = '"+sAccount+"' ORDER BY insert_at DESC LIMIT 1";

        //execute map pin query
        SQLExecDirect( sSQL );

        nPins = GetLocalInt( oPC, "NW_TOTAL_MAP_PINS" );

        if ( nPins > 0 ){

            DeleteLocalString( oPC, "NW_MAP_PIN_NTRY_"+IntToString( nPins ) );
            DeleteLocalFloat( oPC, "NW_MAP_PIN_XPOS_"+IntToString( nPins ) );
            DeleteLocalFloat( oPC, "NW_MAP_PIN_YPOS_"+IntToString( nPins ) );
            DeleteLocalObject( oPC, "NW_MAP_PIN_AREA_"+IntToString( nPins ) );

            SetLocalInt( oPC, "NW_TOTAL_MAP_PINS", nPins - 1 );
        }

        SendMessageToPC( oPC, "Most recent note removed. \nMind that the minimap will not change when you are in the same area. Exit and reenter to see the change." );
    }
    else if ( sOption == "load" ){

        object oAreaList = GetCache( "ds_area_storage" );

        if ( GetLocalInt( oAreaList, "ds_count" ) == -1  ){

            object oArea = GetArea( GetObjectByTag( "is_area", 0 ) );
            int nAreas;

            while ( GetIsObjectValid( oArea ) ){

                ++nAreas;

                oArea = GetArea( GetObjectByTag( "is_area", nAreas ) );

                SetLocalObject( oAreaList, GetResRef( oArea ), oArea );
            }

            SetLocalInt( oAreaList, "ds_count", nAreas );
        }

        //create map pins
        sSQL = "SELECT * FROM `player_notes` WHERE account = '"+sAccount+"' AND module = "+IntToString( nModule );

        SQLExecDirect( sSQL );

        while ( SQLFetch() == SQL_SUCCESS ){

            oArea = GetLocalObject( oAreaList, SQLGetData( 4 ) );

            if ( GetIsObjectValid( oArea ) ){

                ++nPins;

                SetLocalString( oPC, "NW_MAP_PIN_NTRY_"+IntToString( nPins ), DecodeSpecialChars( SQLGetData( 7 ) ) );
                SetLocalFloat( oPC, "NW_MAP_PIN_XPOS_"+IntToString( nPins ), StringToFloat( SQLGetData( 5 ) ) );
                SetLocalFloat( oPC, "NW_MAP_PIN_YPOS_"+IntToString( nPins ), StringToFloat( SQLGetData( 6 ) ) );
                SetLocalObject( oPC, "NW_MAP_PIN_AREA_"+IntToString( nPins ), oArea );


                SendMessageToPC( oPC, "\n<c ??>"+GetName( oArea )+"</c>" );
                SendMessageToPC( oPC, "<c ? >"+DecodeSpecialChars( SQLGetData( 7 ) )+"</c>" );

            }
        }

        SendMessageToPC( oPC, "Mind that the minimap will not change when you are in the same area. Exit and reenter to see the change." );

        SetLocalInt( oPC, "NW_TOTAL_MAP_PINS", nPins );
    }
    else if ( sOption == "list" ){

        nPins = GetLocalInt( oPC, "NW_TOTAL_MAP_PINS" );

        if ( nPins > 0 ){

            int i;

            for ( i=1; i<=nPins; ++i ){

                SendMessageToPC( oPC, "\n<c ??>"+GetName( GetLocalObject( oPC, "NW_MAP_PIN_AREA_"+IntToString( i ) ) )+"</c>" );
                SendMessageToPC( oPC, "<c ? >"+GetLocalString( oPC, "NW_MAP_PIN_NTRY_"+IntToString( i ) )+"</c>" );
            }
        }
        else{

            SendMessageToPC( oPC, "No notes found. Sure you loaded them this session?" );
        }
    }
}
// Set all players to Dislike
void f_Hostile(object oPC) {
    object oEnemy = GetFirstPC();
    while(GetIsObjectValid(oEnemy)) {
         // Check to see if in same party.
         if (GetName( GetFactionLeader( oPC ) ) != GetName( GetFactionLeader( oEnemy ) ) ){
            SetPCDislike( oPC, oEnemy );
         }
         oEnemy = GetNextPC();
    }
}
// Set all players to Like
void f_Friend(object oPC) {
// Check if in combat. May add more to this check later.
    if (GetIsInCombat(oPC)) {
        SendMessageToPC(oPC, "This command may not be used while in combat!");
        return;
    }
    object oFriend = GetFirstPC();
    while(GetIsObjectValid(oFriend)) {
        SetPCLike( oPC, oFriend );
        oFriend = GetNextPC();
    }
}

void f_testwidget(object oPC){

    object oTest = GetItemPossessedBy( oPC, "testwidget" );
    if( GetIsObjectValid( oTest ) )
        DestroyObject( oTest );
    else
        CreateItemOnObject( "testwidget", oPC );
}

void f_UpdateArea(object oPC){

    if( GetLocalInt( GetModule(),"rebuilding_area" ) ){

        SendMessageToPC( oPC, "Area rebuild already in progress!" );
        return;
    }

    SetLocalInt( GetModule(),"rebuilding_area", TRUE );

    RefreshArea( GetArea( oPC ) );
}

void RefreshArea( object oArea ){

    if( oArea == GetAreaFromLocation( GetStartingLocation() ) ){

        SetLocalInt( GetModule(),"rebuilding_area", FALSE );
        SendMessageToAllDMs( "Cannot update module start area!" );
        return;
    }

    // SendMessageToAllDMs( "Updating area: "+GetName( oArea ) );

    object oPC = GetFirstPC( );
    int nRetry = FALSE;
    vector v;
    float fFace;
    string sRef;
    while( GetIsObjectValid( oPC ) ){

        if( !GetIsObjectValid( GetArea( oPC ) ) ){

            nRetry=TRUE;
        }
        else if( GetArea( oPC ) == oArea ){

            fFace = GetFacing( oPC );
            v = GetPosition( oPC );
            AssignCommand( oPC, ActionJumpToLocation( GetStartingLocation() ) );
            SetLocalFloat( oPC, "new_area_x", v.x );
            SetLocalFloat( oPC, "new_area_y", v.y );
            SetLocalFloat( oPC, "new_area_z", v.z );
            SetLocalFloat( oPC, "new_area_f", fFace );
            SetLocalInt( oPC, "area_refresh", TRUE );
            nRetry=TRUE;
        }
        oPC = GetNextPC( );
    }

    if( nRetry ){
        DelayCommand( 1.0, RefreshArea( oArea ) );
        return;
    }

    object oNew = AREAS_CreateArea( GetResRef( oArea ) );
    AREAS_DestroyArea( oArea );

    location lLoc;
    oPC = GetFirstPC( );
    while( GetIsObjectValid( oPC ) ){

        if( GetLocalInt( oPC, "area_refresh" ) ){
            DeleteLocalInt( oPC, "area_refresh" );


            v.x = GetLocalFloat( oPC, "new_area_x" );
            v.y = GetLocalFloat( oPC, "new_area_y" );
            v.z = GetLocalFloat( oPC, "new_area_z" );
            fFace = GetLocalFloat( oPC, "new_area_f" );

            DeleteLocalFloat( oPC, "new_area_x" );
            DeleteLocalFloat( oPC, "new_area_y" );
            DeleteLocalFloat( oPC, "new_area_z" );

            lLoc = Location( oNew, v, fFace );
            AssignCommand( oPC, ActionJumpToLocation( lLoc ) );
        }

        oPC = GetNextPC( );
    }

    SetLocalInt( GetModule(),"rebuilding_area", FALSE );
    SendMessageToAllDMs( "Updated: "+GetName( oNew ) );
}
void f_jsname( object oPC, object oObject, string sOption, string sValue ){

    object oObject  = GetNearestObject( OBJECT_TYPE_ITEM, oPC );
    string sjsTag =  GetTag(oObject);

    if ( GetSubString(sjsTag, 0, 3) == "js_" ){

        SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s name to "+sValue+"." );
        SetName( oObject, sValue );
    }

    else {

        SendMessageToPC( oPC , "You can only use this command on allowed items. See the forum for all allowed items.");
    }
}
void f_jsbio( object oPC, object oObject, string sOption, string sValue ){

    object oObject     =  GetNearestObject( OBJECT_TYPE_ITEM, oPC );
    string sCurrentjs  =  GetDescription(oObject);
    string sjsTag      =  GetTag(oObject);


    if ( sOption == "?" || sOption == "help" || sOption == "Help" ) {
        SendMessageToPC( oPC , "If you have a permitted item, use this command to set the bio after you drop it on the ground. This will change the item's description. [N] will create a new description. [A] will append additional text to the description. [Break] will insert a double line-break. See the forum for a list of all permitted items.");
    }
    if ( GetSubString(sjsTag, 0, 3) != "js_" ){
        SendMessageToPC( oPC , "You can only use this command on allowed items. See the forum for all allowed items.");
    }
    else if ( sOption == "a" || sOption == "A" ){
        SendMessageToPC( oPC, "Adding "+sValue+" to "+GetName( oObject )+"'s description." );
        SetDescription( oObject, sCurrentjs + sValue, TRUE );
    }
    else if ( sOption == "b" || sOption == "B" ){
        SendMessageToPC( oPC, "Adding line break to "+GetName( oObject )+"'s description." );
        SetDescription( oObject, sCurrentjs + "\n\n", TRUE );
    }
    else if ( sOption == "n" || sOption == "N" ) {
        SendMessageToPC( oPC, "Setting "+GetName( oObject )+"'s description to "+sValue );
        SetDescription( oObject, sValue, TRUE );
    }
    else {
        SendMessageToPC( oPC , "Invalid Command. Please use [A], [B], or [N] to change the bio.");
    }
}
