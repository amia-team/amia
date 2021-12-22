#include "inc_ds_records"
#include "nwnx_dynres"
#include "inc_language"
#include "inc_td_sysdata"
#include "inc_lua"
#include "nwnx_areas"
#include "inc_td_rest"
#include "x2_inc_switches"
#include "inc_nwnx_events"
#include "nwnx_magic"
#include "cs_inc_leto"
#include "inc_ds_gods"

void ReportMemoryUsage(object oPC){

    //string sMsg = "Bytes: "+IntToString(MEM_Bytes())+"\n";
    //sMsg+= "Allocations: "+IntToString(MEM_Count())+"\n";
    //sMsg+= "Bad free prevented: "+IntToString(MEM_Bad())+"\n";

    //SendMessageToPC(oPC,sMsg);
}

//Modify the amount of sorcerer spells oTarget has per day and sets them as available.
//If nMod is 0 it return the number of spells oTarget currently has.
//Returns -1 if oTarget has no sorcerer levels or nSpellLevel is out of bounds (0-9)
//Returns the new value of spells/day on success.
int ModifySorcererSpellSlots( object oTarget, int nSpellLevel, int nMod );

int ModifySorcererSpellSlots( object oTarget, int nSpellLevel, int nMod ){

    int nSlot = -1;
    int n;

    //1-3, find which slot is sorc
    for( n=1;n<4; n++ ){

        if( GetClassByPosition( n, oTarget ) == CLASS_TYPE_SORCERER ){

            //We use 0 index
            nSlot = n-1;
            break;
        }
    }

    //Character doesnt have any sorcerer levels or spelllevel out of bounds
    if( nSlot == -1 || nSpellLevel < 0 || nSpellLevel > 9 )
        return -1;

    //Get current, calc new
    int nCurrent = NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 0, -1 );
    int nNew = nCurrent+nMod;

    //Just return what (s)he has if mod is 0
    if( nMod == 0 )
        return NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 2, -1 );

    //Can't be less then 0, unsigned
    if( nNew < 0 )
        nNew = 0;

    //Modify
    NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 0, nNew );

    //Max spells
    nCurrent = NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 2, -1 );
    nNew = nCurrent+nMod;

    //Same as before again
    if( nNew < 0 )
        nNew = 0;

    //Set new max spells
    NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 2, nNew );

    //Mark them as available right away
    nCurrent = NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 1, -1 );
    nNew = nCurrent+nMod;

    //Same as before
    if( nNew < 0 )
        nNew = 0;

    //Set new spells ready
    NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 1, nNew );


    //Return the new value
    return NWNX_Magic_ModifySpellsPerDay( oTarget, nSlot, nSpellLevel, 2, -1 );
}

void AddTool( string sName, string sResRef ){

    SQLExecDirect( "INSERT INTO pwdata (player,tag,name,val)VALUES('-','TOOL_LIST','"+sName+"','"+sResRef+"')" );
}

void Cache( string sFile, string sFull ){

    DYNRES_AddFile( sFile, sFull );
    DYNRES_CacheFile( sFile );
}

//void CreateArea( string sResref, object oPC ){

    //DYNRES_AddFile( sResref+".are", "G:/Resources/Areas/"+sResref+".are" );
   // DYNRES_AddFile( sResref+".gic", "G:/Resources/Areas/"+sResref+".gic" );
   // DYNRES_AddFile( sResref+".git", "G:/Resources/Areas/"+sResref+".git" );

    //object oArea = AREAS_CreateArea( sResref );

    //if( !GetIsObjectValid( oArea ) ){

        //SendMessageToPC( oPC, "Failed to create area with resref: " + sResref );
    //}
    //else{

        //SendMessageToPC( oPC, "Created area " + ObjectToString( oArea ) + " " + GetName( oArea ) );

        //object oThing = GetFirstObjectInArea( oArea );

        //AssignCommand( oPC, ActionJumpToObject( oThing ) );
    //}
//}

void RegisterModuleFile( object oPC ){

    //Long string, extra buffer
    string sDef = "There was nothing here, pretty sad";
    string sMod = NWNX_ReadStringFromINI( "AMIA", "Mod", sDef, "./NWNX.ini" );
    string sMini = NWNX_ReadStringFromINI( "NWNX", "ModuleName", sDef, "./NWNX.ini" );
    if( sDef == sMod || sDef == sMini )
        return;

    Cache( "creaturepalcus.itp", sMod );
    Cache( "doorpalcus.itp", sMod );
    Cache( "encounterpalcus.itp", sMod );
    Cache( "itempalcus.itp", sMod );
    Cache( "placeablepalcus.itp", sMod );
    Cache( "soundpalcus.itp", sMod );
    Cache( "storepalcus.itp", sMod );
    Cache( "triggerpalcus.itp", sMod );
    Cache( "waypointpalcus.itp", sMod );

    DYNRES_AddFile( sMini+".mod", sMod );
    SendMessageToPC( oPC, "Cached palette, registered modulefile: "+sMod );
}

object GetPC( string sAcc ){

    object oPC = GetFirstPC();
    while( GetIsObjectValid( oPC ) ){

        if( GetPCPlayerName( oPC ) == sAcc ){

            return oPC;
        }

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}

void ClearSpells( object oPC ){

    int n;
    for( n=0;n<10;n++ ){
        DeleteLocalString( oPC, "cp_"+IntToString( 1 )+"_"+IntToString( n ) );
    }

    for( n=0;n<10;n++ ){
        DeleteLocalString( oPC, "cp_"+IntToString( 0 )+"_"+IntToString( n ) );
    }

    SendMessageToPC( oPC, "DEBUG: Cleared spellcache!" );
}

object GetItemResRef( object oTarget, string sResRef ){

    object o = GetFirstItemInInventory( oTarget );
    while( GetIsObjectValid( o ) ){

        if( GetResRef( o ) == sResRef ){

            return o;
        }

        o = GetNextItemInInventory( oTarget );
    }
    return OBJECT_INVALID;
}

void NoArea( object oArea ){
    AREAS_DestroyArea( oArea );
}

object GetInstantItemActivator(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return OBJECT_SELF;
    return GetItemActivator();
}

object GetInstantItemActivated(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTarget(0);
    return GetItemActivated();
}

object GetInstantItemActivatedTarget(){

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTarget(1);
    return GetItemActivated();
}

location GetInstantItemActivatedTargetLocation(){
    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT )
        return EVENTS_GetTargetLocation(0);
    return GetItemActivatedTargetLocation();
}

//void ListFiles2( object oPC, string sAcc ){

    //string sFile = NWNX_GetFirstFile( GetServerVaultPath()+sAcc+"/*.bic" );
    //while( sFile != "0" ){

        //SendMessageToPC( oPC, sFile );

        //sFile = NWNX_GetNextFile( );
    //}
//}

//void ListFiles( object oPC, object oTarget ){

    //string sFile = NWNX_GetFirstFile( GetServerVaultPath()+GetPCPlayerName( oTarget )+"/*.bic" );
    //while( sFile != "0" ){

        //SendMessageToPC( oPC, sFile );

        //sFile = NWNX_GetNextFile( );
    //}
//}

int MatchDomain2( object oPC, object oIdol, int nGetDomain2,object oTest ){
    int iDomain = GetDomain(oPC,nGetDomain2+1);
    SendMessageToPC(oTest,"testing: "+IntToString(iDomain));
    int i;
    for (i = 1; i < 7; i++)
    {
        if (GetLocalInt( oIdol, "dom_"+IntToString(i)) == iDomain)
            return iDomain;
    }
    return -1;
}

int MatchGod2(object oTest, object oPC){
    object oIdol= FindIdol(oPC, GetDeity(oPC));

    SendMessageToPC(oTest,"isvalid: "+IntToString(GetIsObjectValid(oIdol)));

    if (!GetIsObjectValid(oIdol))
        return 0;

    SendMessageToPC(oTest,"domain1: "+IntToString(MatchDomain2(oPC,oIdol,0,oTest)));
    SendMessageToPC(oTest,"domain2: "+IntToString(MatchDomain2(oPC,oIdol,1,oTest)));

    SendMessageToPC(oTest,"Align: "+IntToString(MatchAlignment(oPC,oIdol)));

    return MatchDomain2(oPC,oIdol,0,oTest) != -1 &&
        MatchDomain2(oPC,oIdol,1,oTest) != -1 &&
        MatchAlignment(oPC,oIdol);
}

void main( ){

    object oPC = GetInstantItemActivator();

    if( GetDMStatus( GetPCPlayerName( oPC ), GetPCPublicCDKey( oPC ) ) <= 0 &&
        GetPCPlayerName( oPC ) != "Terra_777" && GetPCPlayerName( oPC ) != "RaveN" ) {

        DestroyObject( GetInstantItemActivated() );
        return;
    }

    object oTarget = GetInstantItemActivatedTarget();
    string sLast = GetLocalString( oPC, "last_chat" );
    object oArea = GetArea( oPC );
    location lTarget = GetInstantItemActivatedTargetLocation();

    if( GetIsObjectValid( oTarget ) )
        lTarget = GetLocation( oTarget );

    if( GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_INSTANT && GetStringLeft( sLast, 3 ) != "run" ){
        EVENTS_Bypass();
    }

    if( sLast == "nocast" ){

        if( GetLocalInt( oArea, "NoCasting" ) ){
            SetLocalInt( oArea, "NoCasting", FALSE );
            SendMessageToPC( oPC, "Casting turned on!" );
        }
        else{
            SetLocalInt( oArea, "NoCasting", TRUE );
            SendMessageToPC( oPC, "Casting turned off!" );
        }
    }
    else if(sLast == "mem"){
        ReportMemoryUsage(oPC);
    }
    else if( GetStringLeft( sLast, 5 ) == "wings" ){
        int nWing = StringToInt( GetSubString( sLast, 6, GetStringLength( sLast )-6 ) );
        SetCreatureWingType( nWing, oTarget );
    }
    else if( GetStringLeft( sLast, 5 ) == "aname" ){
        string sName = GetSubString( sLast, 6, GetStringLength( sLast )-6 );
        AREAS_SetAreaName( GetArea( oPC ), sName );
    }
    else if( sLast == "daze" ){

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectDazed( ), oTarget );
    }
    //else if( sLast == "flist" ){

        //ListFiles( oPC, oTarget );
    //}
    else if( sLast == "spells" ){

        int nCurrent = ModifySorcererSpellSlots( oPC, 9, 1 );
        SendMessageToPC( oPC, "Spells: " + IntToString( nCurrent ) );
        //ForceRest( oPC );
    }
    else if( GetStringLeft( sLast, 2 ) == "p#" ){
        int p = StringToInt( GetSubString( sLast, 3, GetStringLength( sLast )-3 ) );
        SetPortraitId( oTarget, p );
    }
    //else if( GetStringLeft( sLast, 5 ) == "alist" ){
        //string sBic = GetSubString( sLast, 6, GetStringLength( sLast )-6 );
        //ListFiles2( oPC, sBic );
    //}
    else if( GetStringLeft( sLast, 4 ) == "skin" ){
        int nSkin = StringToInt( GetSubString( sLast, 5, GetStringLength( sLast )-5 ) );
        SendMessageToPC( oPC, "Skin: " + IntToString( nSkin ) );
        SetCreatureAppearanceType( oTarget, nSkin );
    }
    else if( GetStringLeft( sLast, 4 ) == "numb" ){
        string sSeed = GetSubString( sLast, 5, GetStringLength( sLast )-5 );
        SendMessageToPC( oPC, "Numb: " + sSeed + " -> " + IntToString( StringToInt( sSeed ) ) );
    }
    else if( GetStringLeft( sLast, 3 ) == "lua" ){
        string lua = GetSubString( sLast, 4, GetStringLength( sLast )-4 );
        SendMessageToPC( oPC, "Executing: "+lua );
        SendMessageToPC( oPC, ExecuteLuaString( oTarget, lua ) );
    }
    else if( GetStringLeft( sLast, 4 ) == "name" ){
        SetName( oTarget, GetSubString( sLast, 5, GetStringLength( sLast )-5 ) );
    }
   //else if( GetStringLeft( sLast, 4 ) == "area" ){
        //string sArea = GetSubString( sLast, 5, GetStringLength( sLast )-5 );
        //CreateArea( sArea, oPC );
    //}
    else if( sLast == "go" ){
        AssignCommand( oPC, ActionJumpToLocation( lTarget ) );
    }
    else if( sLast == "vanish" ){
        effect eVanish = EffectEthereal();
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVanish, oPC );
    }
    else if( sLast == "appear" ){
        effect eLoop=GetFirstEffect(oPC);
        while (GetIsEffectValid(eLoop))
        {
            if (GetEffectType(eLoop)==EFFECT_TYPE_ETHEREAL)
                 RemoveEffect(oPC, eLoop);

            eLoop=GetNextEffect(oPC);
           }
    }
    else if( GetStringLeft( sLast, 5) == "spawn" ){
        string sPlace = GetSubString( sLast, 6, GetStringLength( sLast )-6 );
        CreateObject( OBJECT_TYPE_CREATURE, sPlace, lTarget, TRUE );
    }
    else if( GetStringLeft( sLast, 4 ) == "goto" ){
        string sPlace = GetSubString( sLast, 5, GetStringLength( sLast )-5 );

        object oThing = GetObjectByTag( sPlace );
        location lTarget;
        switch( GetObjectType( oThing ) ){

            case OBJECT_TYPE_CREATURE: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_DOOR: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_ENCOUNTER: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_AREA_OF_EFFECT: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_ITEM:

            lTarget = GetIsObjectValid( GetItemPossessor( oThing ) ) ? GetLocation( GetItemPossessor( oThing ) ) : GetLocation( oThing );

            break;
            case OBJECT_TYPE_PLACEABLE: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_STORE: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_TRIGGER: lTarget = GetLocation( oThing ); break;
            case OBJECT_TYPE_WAYPOINT: lTarget = GetLocation( oThing ); break;
            default:

                object oArea = oThing;

                if( GetIsObjectValid( oThing ) ){
                    oThing = GetFirstObjectInArea( oThing );
                }

                if( GetIsObjectValid( oThing ) ){
                    lTarget = GetLocation( oThing );
                }
                else{

                    lTarget = GetCenterInArea( oArea );
                }
        }

        AssignCommand( oTarget, ActionJumpToLocation( lTarget ) );
    }
    else if( sLast == "delete area" ){

        SendMessageToPC( oPC, "Destroyed area " + GetResRef( GetArea( oPC ) ) );
        object oArea = GetArea( oPC );
        object o = GetFirstPC();
        while( GetIsObjectValid( o ) ){

            if( GetArea( o ) == oArea ){
                AssignCommand( o, ActionJumpToLocation( GetStartingLocation( ) ) );
            }

            o = GetNextPC();
        }


        DelayCommand( 5.0, NoArea( oArea ) );
    }
    else if( sLast == "destroy" ){

        if( GetIsPC( oTarget ) )
            SendMessageToPC( oPC, "Can't destroy players!" );
        else{
            AssignCommand( oTarget, SetIsDestroyable( TRUE, FALSE, TRUE ) );
            DestroyObject( oTarget );
        }
    }
    else if( GetStringLeft( sLast, 5 ) == "fetch" ){

        string sPerson = GetSubString( sLast, 6, GetStringLength( sLast )-6 );
        oTarget = GetPC( sPerson );

        if( GetIsObjectValid( oTarget ) ){
            lTarget = GetLocation(oPC);
            AssignCommand( oTarget, ActionJumpToLocation( lTarget ) );
        }
        else
            SendMessageToPC( oPC, "Couldnt find: "+sPerson );
    }
    else if ( GetStringLeft( sLast, 7 ) == "explore" ){
        string sPerson = GetSubString( sLast, 8, GetStringLength( sLast )-8 );
        oTarget = GetPC( sPerson );
        oArea = GetArea( oTarget );

        int bExplored = GetLocalInt( oTarget, "fw_explore");
        if( bExplored > 0 ) {
            bExplored = FALSE;
            DeleteLocalInt( oTarget, "fw_explore" );
        }
        else {
            bExplored = TRUE;
            SetLocalInt( oTarget, "fw_explore", 1);
        }

        if( GetIsObjectValid( oTarget ) ){
            ExploreAreaForPlayer(oArea, oTarget, bExplored);
            if( bExplored == TRUE ) {
                SendMessageToPC( oPC, "Area Explored for Player: "+sPerson );
                SendMessageToPC( oTarget, "DEBUG: Area Explored." );
            }
            else {
                SendMessageToPC( oPC, "Area Unexplored for Player: "+sPerson );
                SendMessageToPC( oTarget, "DEBUG: Area UNexplored." );
            }
        }
        else
            SendMessageToPC( oPC, "Couldnt find: "+sPerson );
    }
    else if( GetStringLeft( sLast, 4 ) == "item" ){

        string sRef = GetSubString( sLast, 5, GetStringLength( sLast )-5 );
        oTarget = CreateItemOnObject( sRef, oTarget );

        if( !GetIsObjectValid( oTarget ) )
            SendMessageToPC( oPC, "Couldnt create: "+sRef );

        SetIdentified(oTarget,TRUE);
    }
    else if( GetStringLeft( sLast, 3 ) == "plc" ){

        string sRef = GetSubString( sLast, 4, GetStringLength( sLast )-4 );
        oTarget = CreateObject( OBJECT_TYPE_PLACEABLE, sRef, lTarget );

        if( !GetIsObjectValid( oTarget ) )
            SendMessageToPC( oPC, "Couldnt create: "+sRef );
    }
    else if( GetStringLeft( sLast, 3 ) == "run" ){

        string sScript = GetSubString( sLast, 4, GetStringLength( sLast )-4 );
        SendMessageToPC( oPC, "Running: " + sScript );
        ExecuteScript( sScript, OBJECT_SELF );
    }
    else if( GetStringLeft( sLast, 2 ) == "gp" ){

        int nGP = StringToInt( GetSubString( sLast, 3, GetStringLength( sLast )-3 ) );
        if( nGP > 0 )
            GiveGoldToCreature( oTarget, nGP );
        else if( nGP < 0 )
            TakeGoldFromCreature( nGP*-1,oTarget, TRUE );
    }
    else if( GetStringLeft( sLast, 2 ) == "dy" ){

        object oArea = GetArea( oPC );
        int nNew = StringToInt( GetSubString( sLast, 3, GetStringLength( sLast )-3 ) );
        if( nNew < 0 || nNew > 2 ) return;

        SetLocalInt( oArea, "area_type", nNew );
    }
    else if( GetStringLeft( sLast, 4 ) == "tail" ){

        int nTail = StringToInt( GetSubString( sLast, 5, GetStringLength( sLast )-5 ) );
        SetCreatureTailType(nTail, oTarget);
    }
    else if( sLast == "deplc" ){

        object oPLC = oTarget;

        if( GetObjectType( oPLC ) != OBJECT_TYPE_PLACEABLE )
            oPLC = GetNearestObjectToLocation( OBJECT_TYPE_PLACEABLE, lTarget );

        if( GetIsObjectValid( oPLC ) ){

            SendMessageToPC( oPC, "Destroyed "+ObjectToString( oPLC )+ " " + GetName( oPLC ) );
            DestroyObject( oPLC );
        }
    }
    else if( GetStringLeft( sLast, 6 ) == "deitem" ){

        string sRef = GetSubString( sLast, 7, GetStringLength( sLast )-7 );
        oTarget = GetItemResRef( oTarget, sRef );

        if( GetIsObjectValid( oTarget ) )
            DestroyObject( oTarget );
        else
            SendMessageToPC( oPC, "Couldnt find: "+sRef );
    }
    else if( GetStringLeft( sLast, 3 ) == "vfx" ){
        int nVFX = StringToInt( GetSubString( sLast, 4, GetStringLength( sLast )-4 ) );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), lTarget );
        SendMessageToPC( oPC, "Played VFX: "+IntToString( nVFX ) );
    }
    else if( GetStringLeft( sLast, 6 ) == "getref" ){
        string sTag = GetSubString( sLast, 7, GetStringLength( sLast )-7 );
        object oFind = GetObjectByTag( sTag );
        SendMessageToPC(oPC, "Found: " + ( GetIsObjectValid( oFind ) ? GetResRef( oFind ) : "Nothing" ) );
    }
    else if( sLast == "rest" ){
        ForceRest( oTarget );
    }
    else if( sLast == "key" ){
        SendMessageToPC( oPC, "Key: "+GetName( GetPCKEY( oTarget ) ) );
    }
    else if( sLast == "atr" ){

        AssignCommand( oTarget, ActionJumpToObject( GetWaypointByTag( "wp_pcport_rest" ) ) );
    }
    else if( sLast == "clr spells" ){

        oPC = GetFirstPC();
        while( GetIsObjectValid( oPC ) ){
            ClearSpells( oPC );
            oPC = GetNextPC();
        }
    }
    else if( sLast == "dummy" ){

        //DYNRES_AddFile( "td_test_dummy.utc", "G:/Resources/creatures/other/td_test_dummy.utc");
        CreateObject( OBJECT_TYPE_CREATURE, "td_test_dummy", lTarget );
    }
    else if( sLast == "die" ){
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetMaxHitPoints( oTarget )+1000+Random(500) ), oTarget );
    }
    else if( sLast == "live" ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints(oTarget) ), oTarget );
    }
    else if( sLast == "plain" ){

        if( GetLocalInt( oTarget, "CHAT_PLAIN" ) ){
            SetLocalInt( oTarget, "CHAT_PLAIN", FALSE );
            SendMessageToPC( oPC, "Plain is off!" );
        }
        else{
            SetLocalInt( oTarget, "CHAT_PLAIN", TRUE );
            SendMessageToPC( oPC, "Plain is on!" );
        }
    }
    else if( sLast == "dropflag" && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){
        SetDroppableFlag(oTarget,TRUE);
        SetItemCursedFlag(oTarget,FALSE);
        SendMessageToPC(oPC,"Item is droppable now");
    }
    else if( sLast == "drop" && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        CopyObject( oTarget, GetLocation( oPC ) );
        DestroyObject( oTarget, 0.1 );
    }
    else if( sLast == "reg" ){
        RegisterModuleFile( oPC );
    }
    else if( sLast == "tag" ){

        if(!GetIsObjectValid(oTarget))
            oTarget = GetArea( oPC );

        SendMessageToPC( oPC, "Tag: "+GetTag( oTarget ) );
    }
    else if( sLast == "copy" ){

        if( GetObjectType(oTarget ) != OBJECT_TYPE_ITEM ){

            SendMessageToPC( oPC, "Can only copy items!");
            return;
        }

        object oNew = CopyItem( oTarget, oPC, TRUE );
        SetDescription(oNew,GetDescription(oTarget));
        SendMessageToPC( oPC, "Copy " + ObjectToString( oTarget )+" -> " + ObjectToString( oNew )  );
    }
    else if( GetStringLeft( sLast, 11 ) == "getitempart" ){
        /*
        void SetItemPart(item,index,part) - Set an item part, index must be between 1 and 19. Does not update appearance on the client!
        void SetItemModel(item,index,part) - Sets the model of an item, index is valid between 1 and 3. Does not update appearance on the client!
        list.models GetItemModelData( item ) - Returns a list containing all parts (1 indexed) and a subtable containing the models
        */
    }
    else if( GetStringLeft( sLast, 11 ) == "setitempart" ){
        if( GetObjectType(oTarget ) != OBJECT_TYPE_ITEM ){

            SendMessageToPC( oPC, "Can only change items!");
            return;
        }
        int nNewModel = StringToInt( GetSubString( sLast, 12, GetStringLength( sLast )-12 ) );

        RunLua( "nwn.SetItemPart( '" + ObjectToString( oTarget ) + "','18','" + IntToString( nNewModel ) + "')" );
    }
    else if( sLast == "all" ){

        int nNth = 1;
        oTarget = GetNearestObject( OBJECT_TYPE_CREATURE, oPC, nNth );
        while( GetIsObjectValid( oTarget ) ){

            SendMessageToPC( oPC, GetName( oTarget ) );
            oTarget = GetNearestObject( OBJECT_TYPE_CREATURE, oPC, ++nNth );
        }
    }
    else if( sLast == "unfall" ){
        SetLocalInt(oTarget, "Fallen",0);
    }
    else if( sLast == "dom" ){
        int i;
        for (i = 1; i < 7; i++)
        {
            SendMessageToPC(oPC, IntToString(GetLocalInt( oTarget, "dom_"+IntToString(i))));
        }
    }
    else if( sLast == "interior" ) {
       object oArea = GetArea( oPC );
       if (GetIsObjectValid( oArea ) ) {
           if(GetIsAreaInterior( oArea ) ) {
                SendMessageToPC( oPC, "Area is INTERIOR!" );
           }
           else {
                SendMessageToPC( oPC, "Area is EXTERIOR!" );
           }
       }
    }
    else if( GetStringLeft( sLast, 4 ) == "idol" ){

        string sTag = GetSubString( sLast, 5, GetStringLength( sLast )-5 );
        object oIdol = FindIdol(oPC,sTag);
        if(GetIsObjectValid(oIdol)){
            AssignCommand(oPC,ActionJumpToObject(oIdol));
        }
        else
            SendMessageToPC(oPC,"didnt find: "+sTag);
    }
    else if(sLast=="matchgod"){

        SendMessageToPC(oPC, "lua: "+ExecuteLuaString(OBJECT_SELF,"return nwn.SetGetDomain('"+ObjectToString(oTarget)+"',"+IntToString(1)+",nil);"));
        SendMessageToPC(oPC, "lua: "+ExecuteLuaString(OBJECT_SELF,"return nwn.SetGetDomain('"+ObjectToString(oTarget)+"',"+IntToString(2)+",nil);"));
        SendMessageToPC(oPC, "1: " + IntToString(GetDomain(oTarget,1)));
        SendMessageToPC(oPC, "2: " + IntToString(GetDomain(oTarget,2)));
        SendMessageToPC(oPC,IntToString(MatchGod2(oPC,oTarget)));
    }
    else if( sLast == "cache" ){
        DYNRES_AddFile( "npc_save_action.ncs", "G:/Resources/scripts/items/npc_save_action.ncs" );
        DYNRES_AddFile( "npc_saver.dlg", "G:/Resources/scripts/items/npc_saver.dlg" );
        SendMessageToPC(oPC,"Did it!");
    }
    else if( sLast == "test" ){

        //AddTool( "PC Editor", "pcmodder" );
    }
    else
        SendMessageToPC( oPC, "Invalid command: "+sLast );

}


