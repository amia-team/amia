#include "inc_ds_records"
#include "nwnx_magic"
#include "inc_lua"


void ClearBook( object oItem );
int CreateBook( object oPC, object oItem, int nClass );
int RestoreFromBook( object oPC, object oItem, int nSpellLevel );
int FindClassIndex( object oPC, int nClass );
string GetSpellName( int nSpell );

void main(){

    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject( oPC, "ds_target" );

    int nTree = GetLocalInt( oPC, "ds_section" );
    int nNode = GetLocalInt( oPC, "ds_node" );

    if( nTree <= 0 ){

        if( nNode == 1 ){
            ClearBook( oItem );
        }
        else if( nNode == 2 ){
            SetLocalInt( oPC, "ds_section", 1 );
        }
        else if( nNode == 3 ){
            SetLocalInt( oPC, "ds_section", 2 );
        }
        else if( nNode == 5 ){
            if( GetLocalString( oPC, "last_chat" ) == " " )
                SetLocalString( oPC, "last_chat", "" );
            SetName( oItem, GetLocalString( oPC, "last_chat" ) );
            SendMessageToPC( oPC, "New name: " + GetName( oItem ) );
        }
    }
    //Creation
    else if( nTree == 1 ){

        SetLocalInt( oPC, "ds_section", 0 );

        int nClass = -1;

        switch( nNode ){
            case 1: nClass = CLASS_TYPE_CLERIC;break;
            case 2: nClass = CLASS_TYPE_DRUID;break;
            case 3: nClass = CLASS_TYPE_PALADIN;break;
            case 4: nClass = CLASS_TYPE_RANGER;break;
            case 5: nClass = CLASS_TYPE_WIZARD;break;
            default:return;
        }

        if( CreateBook( oPC, oItem, nClass ) ){
            SendMessageToPC( oPC, "Book saved successfully!" );
        }
        else{
            SendMessageToPC( oPC, "Failed to save book, you sure you got the class you picked?" );
        }
    }
    //Restoration
    else if( nTree == 2 ){

        SetLocalInt( oPC, "ds_section", 0 );

        if( nNode >= 1 && nNode <= 10 ){

            nNode--;
            if( RestoreFromBook( oPC, oItem, nNode ) )
                SendMessageToPC( oPC, "Restored spell-level successfully!" );
            else
                SendMessageToPC( oPC, "Failed to restore spell level." );
        }
        else if( nNode == 11 ){

            int n;
            for( n=0;n<10;n++ ){
                RestoreFromBook( oPC, oItem, n );
            }
            SendMessageToPC( oPC, "Restored all spells" );
        }
    }
}

void ClearBook( object oItem ){

    DeleteLocalInt( oItem, "class" );
    DeleteLocalString( oItem, "owner" );

    int n;
    for( n=0;n<10;n++ ){

        DeleteLocalString( oItem, "spell_"+IntToString( n ) );
    }

    SetName( oItem );
    SetDescription( oItem );
}

int CreateBook( object oPC, object oItem, int nClass ){

    int nIndex = FindClassIndex( oPC, nClass );
    if( nIndex == -1 )
        return FALSE;

    int bOk = TRUE;
    int nStart = 0;
    int nLast;
    string sSection;

    int n;
    string sData;
    string sSpellList = "|";
    for( n=0;n<10;n++ ){

        sData = NWNX_Magic_PackSpellLevelIntoString( oPC, nIndex, n );
        if( sData != "" ){

            SetLocalString( oItem, "spell_"+IntToString( n ), sData );

            bOk=TRUE;
            nStart = -1;
            while( bOk ){

                nLast = nStart+1;
                nStart = FindSubString( sData, "|", nStart+1 );

                if( nStart == -1 ){

                    nStart = GetStringLength( sData );
                    bOk=FALSE;
                }

                sSection = GetSubString( sData, nLast, nStart-nLast );
                sSection = GetStringLeft( sSection, FindSubString( sSection, " " ) );
                if( FindSubString( sSpellList, "|"+sSection+"|" ) == -1 )
                    sSpellList +=sSection+"|";
            }

        }
    }

    string sSpell = "";
    string sDesc = "";
    nStart = 0;
    while( TRUE ){

        nStart = FindSubString( sSpellList, "|", nStart+1 );
        if( nStart == -1 )
            break;
        nLast = FindSubString( sSpellList, "|", nStart+1 );

        sSpell = GetSubString( sSpellList, nStart+1, nLast-nStart-1 );

        if( sSpell != "" )
            sDesc += GetSpellName( StringToInt( sSpell ) ) + "\n";
    }

    SetDescription( oItem, sDesc );

    SetLocalInt( oItem, "class", nClass );
    SetLocalString( oItem, "owner", GetName( GetPCKEY( oPC ) ) );

    string sClass = "";

    switch( nClass ){
        case CLASS_TYPE_CLERIC:     sClass = "Cleric"; break;
        case CLASS_TYPE_DRUID:      sClass = "Druid"; break;
        case CLASS_TYPE_PALADIN:    sClass = "Paladin"; break;
        case CLASS_TYPE_RANGER:     sClass = "Ranger"; break;
        case CLASS_TYPE_WIZARD:     sClass = "Wizard"; break;
    }

    SetName( oItem, "Spellbook: " + sClass );

    return TRUE;
}

int RestoreFromBook( object oPC, object oItem, int nSpellLevel ){

    int nClass = GetLocalInt( oItem, "class" );

    int nIndex = FindClassIndex( oPC, nClass );
    if( nIndex == -1 || nClass == 0 )
        return FALSE;

    NWNX_Magic_EmptySpellLevel( oPC, nIndex, nSpellLevel, 0 );

    string sData = GetLocalString( oItem, "spell_"+IntToString( nSpellLevel ) );

    //SendMessageToPC( oPC, "test: " + sData );

    if( sData != "" ){
        NWNX_Magic_UnPackSpellLevelString( oPC, nIndex, nSpellLevel, sData );
        NWNX_Magic_EmptySpellLevel( oPC, nIndex, nSpellLevel, 1 );
    }

    return TRUE;
}

int FindClassIndex( object oPC, int nClass ){

    int n;
    for( n=0;n<3;n++ ){

        if( GetClassByPosition( n+1, oPC ) == nClass )
            return n;
    }

    return -1;
}

string GetSpellName( int nSpell ){
    return ExecuteLuaFunction( OBJECT_SELF, "GetSpellName", IntToString( nSpell ) );
}
