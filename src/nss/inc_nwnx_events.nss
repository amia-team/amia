//void main(){}

//Return data related to the events (type: index: data)
//Spellcast: 0 spellID, 1 metamagic, 2, class index
//Itemuse: 0 item spell index, rest unknown
//Featuse: 0 feat used, rest unknown
//Skilluse: 0 skill used, rest unknown
//Polymorph: 0 polymorph type, 1 casterlevel, 2 duration type
//Unpolymorph: 0 polymorph type, 1 casterlevel, 2 duration type
//Attack: 0-2 unknown
//Togglemode: 0 mode being toggled
//Devcrit: 0 baseitem type (BASE_ITEM_INVALID if invalid)
//Validate: 0 unknown
//RemovePC: not used
int EVENTS_GetData( int nIndex );

//Returns the event thats occuring
//0: Spellcast
//1: Item use
//2: Feat use
//3: Skill use
//4: Polymorph
//5: Unpolymorph
//6: Attack
//7: Togglemode
//8: Devcrit
//9: Validate character
//10: Remove PC
int EVENTS_GetEvent( );

//Get the target location (if any)(type: index: data)
//Spellcast: 0 spell target location
//Itemuse: 0 item target location
//Featuse: 0 feat target location
//Skilluse: 0 skill target location
//Polymorph: not used
//Unpolymorph: not used
//Attack: not used
//Togglemode: not used
//Devcrit: not used
//Validate: not used
//RemovePC: not used
location EVENTS_GetTargetLocation( int nIndex );

//Get string from the event (if any)
//Spellcast: not used
//Itemuse: not used
//Featuse: not used
//Skilluse: not used
//Polymorph: not used
//Unpolymorph: not used
//Attack: not used
//Togglemode: not used
//Devcrit: not used
//Validate: not used
//RemovePC: not used
string EVENTS_GetString( int nIndex );

//Get the target from the event (if any)(type: index: data)
//Spellcast: 0 spell-target
//Itemuse: 0 the item, 1 the item target
//Featuse: 0 feat target, 1 area used in
//Skilluse: 0 feat target, 1 area used in
//Polymorph: 0 polymorph effect creator
//Unpolymorph: 0 polymorph effect creator
//Attack: 0 attack target
//Togglemode: not used
//Devcrit: 0 item used, 1 attack target
//Validate: not used
//RemovePC: not used
object EVENTS_GetTarget( int nIndex );

//Flags the game to bypass the event, returning nReturn to it
//Devcrit should pass 1 if standard devcrit is desired, 0 otherwise
//RemovePC cannot be bypassed
//Validate character should return a strref which will be shown to the PC when denied entry
//All others should be either 0 or 1
void EVENTS_Bypass( int nReturn=1 );

//Placeholders

//Same as GetItemActivator() but works with nwnx instant events
object InstantGetItemActivator();
object InstantGetItemActivator(){

    //This is to makesure its instant
    if( GetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT") == 7 ){
        return OBJECT_SELF;
    }
    return GetItemActivator();
}

//Same as GetItemActivated() but works with nwnx instant events
object InstantGetItemActivated();
object InstantGetItemActivated(){

    //This is to makesure its instant
    if( GetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT") == 7 ){
        return EVENTS_GetTarget( 0 );
    }
    return GetItemActivator();
}

//Same as GetItemActivatedTarget() but works with nwnx instant events
object InstantGetItemActivatedTarget();
object InstantGetItemActivatedTarget(){

    //This is to makesure its instant
    if( GetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT") == 7 ){
        return EVENTS_GetTarget( 1 );
    }
    return GetItemActivator();
}

//Same as GetItemActivatedTargetLocation() but works with nwnx instant events
location InstantGetItemActivatedTargetLocation();
location InstantGetItemActivatedTargetLocation(){

    //This is to makesure its instant
    if( GetLocalInt(OBJECT_SELF,"X2_L_LAST_ITEM_EVENT") == 7 ){
        return EVENTS_GetTargetLocation( 0 );
    }
    return GetItemActivatedTargetLocation();
}

void EVENTS_Bypass( int nReturn=1 ){

    SetLocalString( OBJECT_SELF, "NWNX!EVENTS!4", IntToString( nReturn ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!EVENTS!4" );
}

object EVENTS_GetTarget( int nIndex ){

    return GetLocalObject( OBJECT_SELF, "NWNX!EVENTS!"+IntToString( nIndex ) );
}

int EVENTS_GetEvent( ){

    SetLocalString( OBJECT_SELF, "NWNX!EVENTS!0", ".........." );
    int nRet = StringToInt( GetLocalString( OBJECT_SELF, "NWNX!EVENTS!0" ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!EVENTS!0" );
    return nRet;
}

int EVENTS_GetData( int nIndex ){

    SetLocalString( OBJECT_SELF, "NWNX!EVENTS!1", IntToString( nIndex )+".........." );
    int nRet = StringToInt( GetLocalString( OBJECT_SELF, "NWNX!EVENTS!1" ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!EVENTS!1" );
    return nRet;
}

location EVENTS_GetTargetLocation( int nIndex ){

    SetLocalString( OBJECT_SELF, "NWNX!EVENTS!2", IntToString( nIndex )+"                                                                                                          " );
    string sRet = GetLocalString( OBJECT_SELF, "NWNX!EVENTS!2" );
    DeleteLocalString( OBJECT_SELF, "NWNX!EVENTS!2" );

    vector V;
    int nFirst  = FindSubString( sRet, "|" );
    int nSecond = FindSubString( sRet, "|", nFirst+1 );
    int nLen = GetStringLength( sRet );

    V.x = StringToFloat( GetStringLeft( sRet, nFirst ) );
    V.y = StringToFloat( GetSubString( sRet, nFirst+1, nLen-nSecond ) );
    V.z = StringToFloat( GetStringRight( sRet, nLen-nSecond-1 ) );

    return Location( GetArea( OBJECT_SELF ), V, GetFacing( OBJECT_SELF ) );
}

string EVENTS_GetString( int nIndex ){

    SetLocalString( OBJECT_SELF, "NWNX!EVENTS!3", IntToString( nIndex )+"                                                                                                          " );
    string sRet = GetLocalString( OBJECT_SELF, "NWNX!EVENTS!3" );
    DeleteLocalString( OBJECT_SELF, "NWNX!EVENTS!3" );
    return sRet;
}

