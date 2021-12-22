//includes
#include "inc_ds_records"


void SetDwarf( object oTarget, int nNode );
void SetElf( object oTarget, int nNode );
void SetGnome( object oTarget, int nNode );
void SetHalfElf( object oTarget, int nNode );
void SetHalfling( object oTarget, int nNode );
void SetHalfOrc( object oTarget, int nNode );
void SetHuman( object oTarget, int nNode );
void SetUniversal( object oTarget, int nNode );
void SetReport( object oTarget, string sSubRace );

void main( ){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );

    SetLocalInt( oPC, "ds_node", 0 );

    if ( nNode > 0 && nNode < 9 ){

        SetLocalInt( oPC, "ds_race", nNode );

    }
    else if ( nNode > 9 && nNode < 20 ){

        int nRace = GetLocalInt( oPC, "ds_race" );

        switch ( nRace ) {

            case 1:
                SetDwarf( oTarget, nNode );
            break;

            case 2:
                SetElf( oTarget, nNode );
            break;

            case 3:
                SetGnome( oTarget, nNode );
            break;

            case 4:
                SetHalfElf( oTarget, nNode );
            break;

            case 5:
                SetHalfling( oTarget, nNode );
            break;

            case 6:
                SetHalfOrc( oTarget, nNode );
            break;

            case 7:
                SetHuman( oTarget, nNode );
            break;

            case 8:
                SetUniversal( oTarget, nNode );
            break;

            default:
                return;
            break;
        }
    }
}


void SetDwarf( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "gold" );
        break;

        case 12:
            SetReport( oTarget, "duergar" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetElf( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "aquatic" );
        break;

        case 12:
            SetReport( oTarget, "drow" );
        break;

        case 13:
            SetReport( oTarget, "feytouched" );
        break;

        case 14:
            SetReport( oTarget, "shadow" );
        break;

        case 15:
            SetReport( oTarget, "snow" );
        break;

        case 16:
            SetReport( oTarget, "sun" );
        break;

        case 17:
            SetReport( oTarget, "wild elf" );
        break;

        case 18:
            SetReport( oTarget, "wood elf" );
        break;

        case 19:
            SetReport( oTarget, "daemonfey" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetGnome( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "svirfneblin" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetHalfElf( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "halfdrow" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetHalfling( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "elfling" );
        break;

        case 12:
            SetReport( oTarget, "faerie" );
        break;

        case 13:
            SetReport( oTarget, "ghostwise" );
        break;

        case 14:
            SetReport( oTarget, "goblin" );
        break;

        case 15:
            SetReport( oTarget, "kobold" );
        break;

        case 16:
            SetReport( oTarget, "strongheart" );
        break;

        default:
            return;
        break;
    }

    return;
}


void SetHalfOrc( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "hobgoblin" );
        break;

        case 12:
            SetReport( oTarget, "ogrillion" );
        break;

        case 13:
            SetReport( oTarget, "orog" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetHuman( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "calishite" );
        break;

        case 12:
            SetReport( oTarget, "chultan" );
        break;

        case 13:
            SetReport( oTarget, "damaran" );
        break;

        case 14:
            SetReport( oTarget, "durpari" );
        break;

        case 15:
            SetReport( oTarget, "ffolk" );
        break;

        case 16:
            SetReport( oTarget, "halruaan" );
        break;

        case 17:
            SetReport( oTarget, "mulan" );
        break;

        case 18:
            SetReport( oTarget, "shadovar" );
        break;

        case 19:
            SetReport( oTarget, "tuigan" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetUniversal( object oTarget, int nNode ){

    switch ( nNode ) {

        case 10:
            SetReport( oTarget, "" );
        break;

        case 11:
            SetReport( oTarget, "aasimar" );
        break;

        case 12:
            SetReport( oTarget, "air" );
        break;

        case 13:
            SetReport( oTarget, "earth" );
        break;

        case 14:
            SetReport( oTarget, "fire" );
        break;

        case 15:
            SetReport( oTarget, "tiefling" );
        break;

        case 16:
            SetReport( oTarget, "water" );
        break;

        default:
            return;
        break;
    }

    return;
}

void SetReport( object oTarget, string sSubRace ){

    SetSubRace( oTarget, sSubRace );

    SetLocalInt( oTarget, "ds_subrace_activated", 0 );
    SetPCKEYValue( oTarget, "ds_subrace_activated", 0 );

    SendMessageToPC( oTarget, " - Subrace set to: "+sSubRace+" - " );
}




