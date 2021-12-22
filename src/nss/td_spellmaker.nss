void SetSpellWidget( object oItem, int nSpell, int nUses, int nSelf, int nCL );
string GetSpellName( int nSpell );

void main(){

    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject( oPC, "ds_target" );
    string sLast = GetLocalString( oPC, "last_chat" );
    int nNode = GetLocalInt( oPC, "ds_node" );

    switch( nNode ){

        case 1:
            SetLocalInt( oPC, "smw_spell", StringToInt( sLast ) );
            SendMessageToPC( oPC, "Spell: " + GetSpellName( StringToInt( sLast ) ) );
        break;
        case 2:
            SetLocalInt( oPC, "smw_self", TRUE );
            break;
        case 3:
            SetLocalInt( oPC, "smw_self", FALSE );
            break;
        case 4:
            SetLocalInt( oPC, "smw_uses", StringToInt( sLast ) );
            SendMessageToPC( oPC, "Uses: " + IntToString( StringToInt( sLast ) ) );
        break;
        case 5:
            SetLocalInt( oPC, "smw_cl", StringToInt( sLast ) );
            SendMessageToPC( oPC, "Uses: " + IntToString( StringToInt( sLast ) ) );
        break;
        case 6:
            SetLocalInt( oPC, "smw_cl", -1 );
        break;
        case 7:
            SetLocalInt( oPC, "smw_cl", -2 );
        break;
        case 8:
            SetLocalInt( oPC, "smw_cl", -3 );
        break;
        case 9:
            SetLocalInt( oPC, "smw_cl", 0 );
        break;
        case 10:
            SetSpellWidget( oItem, GetLocalInt( oPC, "smw_spell" ), GetLocalInt( oPC, "smw_uses" ), GetLocalInt( oPC, "smw_self" ), GetLocalInt( oPC, "smw_cl" ) );
            DeleteLocalInt( oPC, "smw_spell" );
            DeleteLocalInt( oPC, "smw_uses" );
            DeleteLocalInt( oPC, "smw_self" );
            DeleteLocalInt( oPC, "smw_cl" );
        break;
    }

}

string GetSpellName( int nSpell ){
    string sRow = Get2DAString( "spells", "name", nSpell );
    if(sRow == "")
        return "";

    return GetStringByStrRef( StringToInt( sRow ) );
}

void SetSpellWidget( object oItem, int nSpell, int nUses, int nSelf, int nCL ){

    string sName = GetSpellName( nSpell );
    if( sName == "" )return;

    SetLocalInt( oItem, "uses", nUses );
    if(nUses > 0)
        SetLocalInt( oItem, "left", nUses );
    SetLocalInt( oItem, "spell", nSpell );
    SetLocalInt( oItem, "self", nSelf );
    SetLocalInt( oItem, "cl", nCL );
    SetName( oItem, "Spell: " + sName );
}
