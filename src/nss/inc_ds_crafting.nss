//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: inc_ds_crafting
//group: armour crafting
//used as: lib
//date: 2008-07-11
//author: Disco
// 20090513   disco            added Job System support
// 2010-10-27 disco            update weapon system


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//creates simple merged optiontype from ModelType
int GetArmourOptionType( int nModel );

//armour parts are translated into an option table ranging from n=1 to n=options
//these functions do the translation

//translates an option (n=1 to n=options) into a model part
//returns -1 on error
int GetArmourPartFromOption( int nOption, int nCurrentPart, int nModel );

//translates a model part into an option (n=1 to n=options)
int GetArmourOptionFromPart( int nCurrentPart, int nOptionType );

//gets the number of model part options
//returns -1 on error
int GetArmourOptions( int nCurrentPart, int nModel );

//translates an option (n=1 to n=options) into a chest model part
//returns -1 on error
int GetChestPartFromOption( int nOption );

//translates a chest model part into an option (n=1 to n=options)
int GetChestOptionFromPart( int nCurrentPart );

//gets the number of chest model part options
//returns -1 on error
int GetChestOptions( int nCurrentPart );

//returns next armour part
int GetNextArmourPart( int nModel, int nCurrentPart, int nSteps=1 );

//returns previous armour part
int GetPrevArmourPart( int nModel, int nCurrentPart, int nSteps=1 );

//returns the name of an armour part (ie: chest, left shoulder, etc)
string GetArmourModelName( int nModel );

//returns type of colour (ie: cloth 1, leather 2, etc)
string GetColourTypeName( int nModel );

//changes item part on item, checks for craft roll
void UpdateItem( object oPC, object oItem, int nType, int nModelType, int nPart );

//returns the options for a simple model such as a shield or helmet
int GetSimpleModelOptions( object oItem, int nItemType );

//checks if the PC is wearing/holding the relevant item
object GetCraftingItem( object oPC, int nItemType );

//translates convo option to shield part
int GetShieldPartFromOption( object oItem, int nOption );

//gets convo option from shield part
int GetShieldOptionFromPart( object oItem, int nOption );

//gets convo option from helmet
int GetHelmetOptionFromPart( object oItem, int nPart );

//translates convo option to helmet
int GetHelmetPartFromOption( object oItem, int nOption );

//gets convo option from cloak
int GetCloakOptionFromPart( object oItem, int nPart );

//translates convo option to cloak
int GetCloakPartFromOption( object oItem, int nOption );

//returns the number of model options of a weapon part
//oStorage is waypoint or other object that stores the indexes to the models
int StoreWeaponOptions( object oPC, object oWeapon, int nPart, object oStorage );

//returns the number of the next weapon model
//oStorage is waypoint or other object that stores the indexes to the models
int GetNextWeaponModel( object oPC, object oWeapon, int nPart, object oStorage );

//returns the number of the previous weapon model
//oStorage is waypoint or other object that stores the indexes to the models
int GetPreviousWeaponModel( object oPC, object oWeapon, int nPart, object oStorage );

//Does the crafting roll and take money if necessary
//returns 1 if everything is OK, 0 if oPC failed roll and doesn't have enough cash
int DoCraftingRoll( object oPC, object oItem , int nSkill=SKILL_CRAFT_ARMOR );

string DyeName( int nIndex, int nModel );

string StandardClothDyes( int nIndex );

string StandardMetalDyes( int nIndex );

string NewDyes( int nIndex );

int GetBaseAC( object oItem );

//logs crafting stuff
void CraftingLog( object oPC, object oItem, string sIssue );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
//void main (){}
int GetArmourOptionType( int nModel ){

    switch ( nModel ) {

        case ITEM_APPR_ARMOR_MODEL_LFOOT: return ( 1 ); break;
        case ITEM_APPR_ARMOR_MODEL_RFOOT: return ( 1 ); break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN: return ( 3 ); break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN: return ( 3 ); break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH: return ( 5 ); break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: return ( 5 ); break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: return ( 6 ); break;
        case ITEM_APPR_ARMOR_MODEL_TORSO: return ( 7 ); break;
        case ITEM_APPR_ARMOR_MODEL_BELT: return ( 8 ); break;
        case ITEM_APPR_ARMOR_MODEL_NECK: return ( 9 ); break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM: return ( 11 ); break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: return ( 11 ); break;
        case ITEM_APPR_ARMOR_MODEL_LBICEP: return ( 13 ); break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP: return ( 13 ); break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER: return ( 15 ); break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: return ( 15 ); break;
        case ITEM_APPR_ARMOR_MODEL_LHAND: return ( 17 ); break;
        case ITEM_APPR_ARMOR_MODEL_RHAND: return ( 17 ); break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: return ( 18 ); break;
    }

    return 0;
}

int GetArmourPartFromOption( int nOption, int nCurrentPart, int nModel ){

    //mind that options offset from 1 and parts from 0!

    int nOptionType = GetArmourOptionType( nModel );

    //chest
    if ( nOptionType == 7 ){

        return GetChestPartFromOption( nOption );
    }

    //robe
    if ( nOptionType == 18 && nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        switch ( nOption ){

            case 01: return 0;
            case 02: return 3;
            case 03: return 4;
            case 04: return 5;
            case 05: return 6;
            case 06: return 20;
            case 07: return 21;
            case 08: return 30;
            case 09: return 31;
            case 10: return 32;
            case 11: return 33;
            case 12: return 38;
            case 13: return 55;
            case 14: return 110;
            case 15: return 111;
            case 16: return 112;
            case 17: return 114;
            case 18: return 115;
            case 19: return 135;
            case 20: return 143;
            case 21: return 145;
            case 22: return 147;
            case 23: return 152;
            case 24: return 154;
            case 25: return 159;
            case 26: return 168;
            case 27: return 182;
            case 28: return 183;
            case 29: return 12;
            case 30: return 15;
            case 31: return 27;
            case 32: return 186;
            case 33: return 187;
            case 34: return 188;
            case 35: return 189;
            case 36: return 122;
            case 37: return 123;
            case 38: return 124;
            case 39: return 126;
            case 40: return 127;
            case 41: return 128;
            case 42: return 190;
            case 43: return 191;
            case 44: return 192;
            case 45: return 013;
            case 46: return 10;
            case 47: return 11;
            case 48: return 16;
            case 49: return 100;
            case 50: return 125;
            case 51: return 164;
            case 52: return 166;
            case 53: return 167;
            case 54: return 118;
            case 55: return 200;
            case 56: return 201;
            case 57: return 202;
            case 58: return 203;
            case 59: return 204;
            case 60: return 205;
            case 61: return 206;
            case 62: return 207;
            case 63: return 208;
            case 64: return 209;
            case 65: return 210;
            case 66: return 211;
            case 67: return 212;
            case 68: return 213;
            case 69: return 219;
            case 70: return 220;
            case 71: return 221;
            case 72: return 222;
            case 73: return 223;
            case 74: return 224;
            case 75: return 225;
            case 76: return 226;
            case 77: return 227;
            case 78: return 228;
            case 79: return 229;
            case 80: return 230;
            case 81: return 231;
            case 82: return 232;
            case 83: return 233;
            case 84: return 234;
            case 85: return 235;
            case 86: return 236;
            case 87: return 237;
            case 88: return 215;
            case 89: return 216;
            case 90: return 217;
            case 91: return 218;
            case 92: return 238;


            default: return -1;
        }
    }

   // Neck
   if ( nOptionType == 9 && nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        switch ( nOption ){

            case 01: return 063;
            case 02: return 001;
            case 03: return 186;
            case 04: return 003;
            case 05: return 004;
            case 06: return 005;
            case 07: return 006;
            case 08: return 007;
            case 09: return 008;
            case 10: return 009;
            case 11: return 010;
            case 12: return 011;
            case 13: return 012;
            case 14: return 013;
            case 15: return 014;
            case 16: return 015;
            case 17: return 016;
            case 18: return 017;
            case 19: return 018;
            case 20: return 019;
            case 21: return 020;
            case 22: return 023;
            case 23: return 025;
            case 24: return 026;
            case 25: return 028;
            case 26: return 070;
            case 27: return 071;
            case 28: return 127;
            case 29: return 129;
            case 30: return 131;
            case 31: return 132;
            case 32: return 133;
            case 33: return 134;


            default: return -1;
        }
    }

    // Belt
   if ( nOptionType == 8 && nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        switch ( nOption ){

            case 01: return 000;
            case 02: return 063;
            case 03: return 186;
            case 04: return 003;
            case 05: return 004;
            case 06: return 005;
            case 07: return 006;
            case 08: return 007;
            case 09: return 008;
            case 10: return 009;
            case 11: return 010;
            case 12: return 011;
            case 13: return 012;
            case 14: return 013;
            case 15: return 014;
            case 16: return 015;
            case 17: return 016;
            case 18: return 017;
            case 19: return 018;
            case 20: return 019;
            case 21: return 020;
            case 22: return 021;
            case 23: return 022;
            case 24: return 023;
            case 25: return 031;
            case 26: return 032;
            case 27: return 037;
            case 28: return 039;
            case 29: return 071;
            case 30: return 096;
            case 31: return 108;
            case 32: return 189;
            case 33: return 190;
            case 34: return 191;
            case 35: return 40;
            case 36: return 41;
            case 37: return 42;
            case 38: return 43;
            case 39: return 44;


            default: return -1;
        }
    }

    //shoulder
    if ( nOptionType == 15 && nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        switch ( nOption ){

            case 01: return 000;
            case 02: return 186;
            case 03: return 003;
            case 04: return 004;
            case 05: return 005;
            case 06: return 006;
            case 07: return 007;
            case 08: return 008;
            case 09: return 009;
            case 10: return 010;
            case 11: return 011;
            case 12: return 012;
            case 13: return 013;
            case 14: return 014;
            case 15: return 015;
            case 16: return 016;
            case 17: return 017;
            case 18: return 018;
            case 19: return 019;
            case 20: return 020;
            case 21: return 021;
            case 22: return 022;
            case 23: return 023;
            case 24: return 024;
            case 25: return 025;
            case 26: return 026;
            case 27: return 027;
            case 28: return 028;
            case 29: return 029;
            case 30: return 030;
            case 31: return 040;
            case 32: return 041;
            case 33: return 042;
            case 34: return 043;
            case 35: return 044;
            case 36: return 096;
            case 37: return 100;
            case 38: return 103;
            case 39: return 106;
            case 40: return 190;


            default: return -1;
        }
    }

   // Feet
   if ( nOptionType == 1 && nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        switch ( nOption ){

            case 01: return 063;
            case 02: return 001;
            case 03: return 186;
            case 04: return 003;
            case 05: return 004;
            case 06: return 005;
            case 07: return 006;
            case 08: return 007;
            case 09: return 008;
            case 10: return 009;
            case 11: return 010;
            case 12: return 011;
            case 13: return 012;
            case 14: return 013;
            case 15: return 014;
            case 16: return 015;
            case 17: return 016;
            case 18: return 017;
            case 19: return 018;
            case 20: return 019;
            case 21: return 020;
            case 22: return 021;
            case 23: return 022;
            case 24: return 023;
            case 25: return 024;
            case 26: return 025;
            case 27: return 026;
            case 28: return 027;
            case 29: return 160;

            default: return -1;
        }
    }

    //other parts
    if ( nOption <= GetArmourOptions( nCurrentPart, nOptionType ) ){

        if ( nOption == 1 ) return 63;
        if ( nOption == 3 ) return 186;
        return nOption - 1;
    }

    return -1;
}

int GetArmourOptionFromPart( int nCurrentPart, int nOptionType ){

    //chest
    if ( nOptionType == 7 ){

        int nIndex = GetChestOptionFromPart( nCurrentPart );
        return nIndex - ( ( nIndex / 100 ) * 100 );
    }

    //robe
    if ( nOptionType == 18 ){

        switch ( nCurrentPart ){

            case 000: return 1;
            case 003: return 2;
            case 004: return 3;
            case 005: return 4;
            case 006: return 5;
            case 012: return 29;
            case 015: return 30;
            case 020: return 6;
            case 021: return 7;
            case 030: return 8;
            case 031: return 9;
            case 032: return 10;
            case 033: return 11;
            case 038: return 12;
            case 055: return 13;
            case 110: return 14;
            case 111: return 15;
            case 112: return 16;
            case 114: return 17;
            case 115: return 18;
            case 135: return 19;
            case 143: return 20;
            case 145: return 21;
            case 147: return 22;
            case 152: return 23;
            case 154: return 24;
            case 159: return 25;
            case 166: return 52;
            case 167: return 53;
            case 168: return 26;
            case 182: return 27;
            case 183: return 28;

            case 027: return 31;
            case 186: return 32;
            case 187: return 33;
            case 188: return 34;
            case 189: return 35;
            case 122: return 36;
            case 123: return 37;
            case 124: return 38;
            case 126: return 39;
            case 127: return 40;
            case 128: return 41;
            case 190: return 42;
            case 191: return 43;
            case 192: return 44;
            case 013: return 45;
            case 010: return 46;
            case 011: return 47;
            case 016: return 48;
            case 100: return 49;
            case 125: return 50;
            case 164: return 51;
            case 118: return 54;
            case 200: return 55;
            case 201: return 56;
            case 202: return 57;
            case 203: return 58;
            case 204: return 59;
            case 205: return 60;
            case 206: return 61;
            case 207: return 62;
            case 208: return 63;
            case 209: return 64;
            case 210: return 65;
            case 211: return 66;
            case 212: return 67;
            case 213: return 68;
            case 219: return 69;
            case 220: return 70;
            case 221: return 71;
            case 222: return 72;
            case 223: return 73;
            case 224: return 74;
            case 225: return 75;
            case 226: return 76;
            case 227: return 77;
            case 228: return 78;
            case 229: return 79;
            case 230: return 80;
            case 231: return 81;
            case 232: return 82;
            case 233: return 83;
            case 234: return 84;
            case 235: return 85;
            case 236: return 86;
            case 237: return 87;
            case 215: return 88;
            case 216: return 89;
            case 217: return 90;
            case 218: return 91;
            case 238: return 92;

            default: return -1;
        }
    }

    //Neck
    if ( nOptionType == 9 ){

        switch ( nCurrentPart ){

            case 063: return 01;
            case 001: return 02;
            case 186: return 03;
            case 003: return 04;
            case 004: return 05;
            case 005: return 06;
            case 006: return 07;
            case 007: return 08;
            case 008: return 09;
            case 009: return 10;
            case 010: return 11;
            case 011: return 12;
            case 012: return 13;
            case 013: return 14;
            case 014: return 15;
            case 015: return 16;
            case 016: return 17;
            case 017: return 18;
            case 018: return 19;
            case 019: return 20;
            case 020: return 21;
            case 023: return 22;
            case 025: return 23;
            case 026: return 24;
            case 028: return 25;
            case 070: return 26;
            case 071: return 27;
            case 127: return 28;
            case 129: return 29;
            case 131: return 30;
            case 132: return 31;
            case 133: return 32;
            case 134: return 33;

            default: return -1;
        }
    }

    //Belt
    if ( nOptionType == 8 ){

        switch ( nCurrentPart ){

            case 000: return 01;
            case 063: return 02;
            case 186: return 03;
            case 003: return 04;
            case 004: return 05;
            case 005: return 06;
            case 006: return 07;
            case 007: return 08;
            case 008: return 09;
            case 009: return 10;
            case 010: return 11;
            case 011: return 12;
            case 012: return 13;
            case 013: return 14;
            case 014: return 15;
            case 015: return 16;
            case 016: return 17;
            case 017: return 18;
            case 018: return 19;
            case 019: return 20;
            case 020: return 21;
            case 021: return 22;
            case 022: return 23;
            case 023: return 24;
            case 031: return 25;
            case 032: return 26;
            case 037: return 27;
            case 039: return 28;
            case 071: return 29;
            case 096: return 30;
            case 108: return 31;
            case 189: return 32;
            case 190: return 33;
            case 191: return 34;
            case 40: return 35;
            case 41: return 36;
            case 42: return 37;
            case 43: return 38;
            case 44: return 39;

            default: return -1;
        }
    }

    //shoulder
   if ( nOptionType == 15 ){

        switch ( nCurrentPart ){

            case 000: return 01;
            case 186: return 02;
            case 003: return 03;
            case 004: return 04;
            case 005: return 05;
            case 006: return 06;
            case 007: return 07;
            case 008: return 08;
            case 009: return 09;
            case 010: return 10;
            case 011: return 11;
            case 012: return 12;
            case 013: return 13;
            case 014: return 14;
            case 015: return 15;
            case 016: return 16;
            case 017: return 17;
            case 018: return 18;
            case 019: return 19;
            case 020: return 20;
            case 021: return 21;
            case 022: return 22;
            case 023: return 23;
            case 024: return 24;
            case 025: return 25;
            case 026: return 26;
            case 027: return 27;
            case 028: return 28;
            case 029: return 29;
            case 030: return 30;
            case 040: return 31;
            case 041: return 32;
            case 042: return 33;
            case 043: return 34;
            case 044: return 35;
            case 096: return 36;
            case 100: return 37;
            case 103: return 38;
            case 106: return 39;
            case 190: return 40;

            default: return -1;
        }
    }

    //Feet
    if ( nOptionType == 1 ){

        switch ( nCurrentPart ){

            case 063: return 01;
            case 001: return 02;
            case 186: return 03;
            case 003: return 04;
            case 004: return 05;
            case 005: return 06;
            case 006: return 07;
            case 007: return 08;
            case 008: return 09;
            case 009: return 10;
            case 010: return 11;
            case 011: return 12;
            case 012: return 13;
            case 013: return 14;
            case 014: return 15;
            case 015: return 16;
            case 016: return 17;
            case 017: return 18;
            case 018: return 19;
            case 019: return 20;
            case 020: return 21;
            case 021: return 22;
            case 022: return 23;
            case 023: return 24;
            case 024: return 25;
            case 025: return 26;
            case 026: return 27;
            case 027: return 28;
            case 160: return 29;

            default: return -1;
        }
    }

    //other parts
    if ( nCurrentPart == 63 ) return 1;
    if ( nCurrentPart == 186 ) return 3;
    return nCurrentPart + 1;
}

int GetArmourOptions( int nCurrentPart, int nModel ){

    int nOptionType = GetArmourOptionType( nModel );

    switch ( nOptionType ) {

        case 1: return 29;
        case 3: return 33;
        case 5: return 40;
        case 6: return 45;
        case 7: return GetChestOptions( nCurrentPart );
        case 8: return 39;
        case 9: return 33;
        case 11: return 44;
        case 13: return 39;
        case 15: return 40;
        case 17: return 11;
        case 18: return 92;
    }

    return -1;
}

int GetChestPartFromOption( int nOption ){

    switch ( nOption ) {

        case 001: return 1;
        case 002: return 3;
        case 003: return 5;
        case 004: return 6;
        case 005: return 7;
        case 006: return 8;
        case 007: return 9;
        case 008: return 12;
        case 009: return 19;
        case 010: return 39;
        case 011: return 50;
        case 012: return 66;
        case 013: return 67;
        case 014: return 73;
        case 015: return 74;
        case 016: return 150;
        case 017: return 158;
        case 018: return 199;
        case 019: return 200;
        case 020: return 228;
        case 021: return 239;
        case 022: return 240;
        case 023: return 251;
        case 024: return 210;
        case 101: return 20;
        case 102: return 28;
        case 103: return 40;
        case 201: return 10;
        case 202: return 13;
        case 203: return 16;
        case 204: return 27;
        case 205: return 41;
        case 206: return 42;
        case 207: return 49;
        case 208: return 58;
        case 209: return 75;
        case 210: return 76;
        case 211: return 77;
        case 212: return 86;
        case 213: return 92;
        case 301: return 22;
        case 302: return 29;
        case 303: return 43;
        case 304: return 44;
        case 401: return 4;
        case 402: return 15;
        case 403: return 18;
        case 404: return 34;
        case 405: return 35;
        case 406: return 36;
        case 407: return 38;
        case 408: return 54;
        case 409: return 55;
        case 410: return 56;
        case 411: return 59;
        case 412: return 63;
        case 413: return 68;
        case 414: return 69;
        case 415: return 105;
        case 416: return 64;
        case 501: return 24;
        case 502: return 25;
        case 503: return 26;
        case 504: return 31;
        case 505: return 32;
        case 506: return 204;
        case 601: return 11;
        case 602: return 17;
        case 603: return 30;
        case 604: return 45;
        case 605: return 48;
        case 701: return 33;
        case 702: return 46;
        case 703: return 47;
        case 704: return 51;
        case 705: return 52;
        case 801: return 14;
        case 802: return 21;
        case 803: return 23;
        case 804: return 37;
        case 805: return 53;
        case 806: return 57;
        case 807: return 60;
        case 808: return 61;
        case 809: return 62;
        case 810: return 186;
        case 811: return 70;
        case 812: return 71;
        case 813: return 72;
        case 814: return 65;
        case 815: return 190;
        case 816: return 209;
        case 817: return 252;
        case 818: return 220;
        case 819: return 221;
        case 820: return 222;
        case 821: return 223;
    }

    return -1;
}

int GetChestOptionFromPart( int nCurrentPart ){

    switch ( nCurrentPart ) {

        case 001: return 1;
        case 003: return 2;
        case 005: return 3;
        case 006: return 4;
        case 007: return 5;
        case 008: return 6;
        case 009: return 7;
        case 012: return 8;
        case 019: return 9;
        case 039: return 10;
        case 050: return 11;
        case 066: return 12;
        case 067: return 13;
        case 073: return 14;
        case 074: return 15;
        case 150: return 16;
        case 158: return 17;
        case 199: return 18;
        case 200: return 19;
        case 228: return 20;
        case 239: return 21;
        case 240: return 22;
        case 251: return 23;
        case 210: return 24;
        case 020: return 101;
        case 028: return 102;
        case 040: return 103;
        case 010: return 201;
        case 013: return 202;
        case 016: return 203;
        case 027: return 204;
        case 041: return 205;
        case 042: return 206;
        case 049: return 207;
        case 058: return 208;
        case 075: return 209;
        case 076: return 210;
        case 077: return 211;
        case 086: return 212;
        case 092: return 213;
        case 022: return 301;
        case 029: return 302;
        case 043: return 303;
        case 044: return 304;
        case 004: return 401;
        case 015: return 402;
        case 018: return 403;
        case 034: return 404;
        case 035: return 405;
        case 036: return 406;
        case 038: return 407;
        case 054: return 408;
        case 055: return 409;
        case 056: return 410;
        case 059: return 411;
        case 063: return 412;
        case 068: return 413;
        case 069: return 414;
        case 105: return 415;
        case 064: return 416;
        case 024: return 501;
        case 025: return 502;
        case 026: return 503;
        case 031: return 504;
        case 032: return 505;
        case 204: return 506;
        case 011: return 601;
        case 017: return 602;
        case 030: return 603;
        case 045: return 604;
        case 048: return 605;
        case 033: return 701;
        case 046: return 702;
        case 047: return 703;
        case 051: return 704;
        case 052: return 705;
        case 014: return 801;
        case 021: return 802;
        case 023: return 803;
        case 037: return 804;
        case 053: return 805;
        case 057: return 806;
        case 060: return 807;
        case 061: return 808;
        case 062: return 809;
        case 186: return 810;
        case 070: return 811;
        case 071: return 812;
        case 072: return 813;
        case 065: return 814;
        case 190: return 815;
        case 209: return 816;
        case 252: return 817;
        case 220: return 818;
        case 221: return 819;
        case 222: return 820;
        case 223: return 821;
    }

    return -1;
}

int GetChestOptions( int nCurrentPart ){

    int nAC = GetChestOptionFromPart( nCurrentPart ) / 100;

    switch ( nAC ) {

        case 0: return 23;
        case 1: return 3;
        case 2: return 14;
        case 3: return 4;
        case 4: return 14;
        case 5: return 6;
        case 6: return 5;
        case 7: return 5;
        case 8: return 21;
    }

    return -1;
}

int GetNextArmourPart( int nModel, int nCurrentPart, int nSteps=1 ){

    //I know the current part and from it I can deduce the current option(s)
    int nOptionType = GetArmourOptionType( nModel );
    int nOption     = GetArmourOptionFromPart( nCurrentPart, nOptionType );
    int nOptions    = GetArmourOptions( nCurrentPart, nModel );

    if ( nOption == -1 ){

        return -1;
    }

    //let's check if the next part is available
    int nNextOption   = nOption + nSteps;

    if ( nNextOption > nOptions ){

        nNextOption = nNextOption - nOptions;
    }

    if ( nOptionType != 7 ){

        return GetArmourPartFromOption( nNextOption, nCurrentPart, nModel );
    }
    else {

        //mind that chest options are added to AC*100!
        int nIndex = ( GetChestOptionFromPart( nCurrentPart ) / 100 ) * 100;

        return GetArmourPartFromOption( (nIndex + nNextOption ), nCurrentPart, nModel );
    }

    return -1;
}

int GetPrevArmourPart( int nModel, int nCurrentPart, int nSteps=1 ){

    //I know the current part and from it I can deduce the current option(s)
    int nOptionType = GetArmourOptionType( nModel );
    int nOption     = GetArmourOptionFromPart( nCurrentPart, nOptionType );
    int nOptions    = GetArmourOptions( nCurrentPart, nModel );

    if ( nOption == -1 ){

        return -1;
    }

    //let's check if the next part is available
    int nNextOption   = nOption - nSteps;

    if ( nNextOption < 1 ){

        nNextOption = nOptions + nNextOption;
    }

    if ( nOptionType != 7 ){

        return GetArmourPartFromOption( nNextOption, nCurrentPart, nModel );
    }
    else {

        //mind that chest options are added to AC*100!
        int nIndex = ( GetChestOptionFromPart( nCurrentPart ) / 100 ) * 100;

        return GetArmourPartFromOption( (nIndex + nNextOption ), nCurrentPart, nModel );
    }

    return -1;
}

string GetArmourModelName( int nModel ){

    switch ( nModel ) {

        case ITEM_APPR_ARMOR_MODEL_LFOOT: return "Left Foot"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOOT: return "Right Foot"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN: return "Left Shin"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHIN: return "Right Shin"; break;
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: return "Right Thigh"; break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH: return "Left Thigh"; break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: return "Pelvis"; break;
        case ITEM_APPR_ARMOR_MODEL_TORSO: return "Chest"; break;
        case ITEM_APPR_ARMOR_MODEL_BELT: return "Belt"; break;
        case ITEM_APPR_ARMOR_MODEL_NECK: return "Neck"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM: return "Left Forearm"; break;
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: return "Right Forearm"; break;
        case ITEM_APPR_ARMOR_MODEL_LBICEP: return "Left Bicep"; break;
        case ITEM_APPR_ARMOR_MODEL_RBICEP: return "Right Bicep"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER: return "Left Shoulder"; break;
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: return "Right Shoulder"; break;
        case ITEM_APPR_ARMOR_MODEL_LHAND: return "Left Hand"; break;
        case ITEM_APPR_ARMOR_MODEL_RHAND: return "Right Hand"; break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: return "Robe"; break;
    }

    return "";
}

string GetColourTypeName( int nModel ){

    switch ( nModel ) {

        case ITEM_APPR_ARMOR_COLOR_CLOTH1: return "Cloth 1"; break;
        case ITEM_APPR_ARMOR_COLOR_CLOTH2: return "Cloth 2"; break;
        case ITEM_APPR_ARMOR_COLOR_LEATHER1: return "Leather 1"; break;
        case ITEM_APPR_ARMOR_COLOR_LEATHER2: return "Leather 2"; break;
        case ITEM_APPR_ARMOR_COLOR_METAL1: return "Metal 1"; break;
        case ITEM_APPR_ARMOR_COLOR_METAL2: return "Metal 2"; break;
    }

    return "";

}

void UpdateItem( object oPC, object oItem, int nType, int nModelType, int nPart ){

    if ( GetIsPolymorphed( oPC ) ){

        SendMessageToPC( oPC, "You cannot craft items while you are polymorphed!" );

        return;
    }

    int nRoll = 2;

    if ( nType == ITEM_APPR_TYPE_ARMOR_MODEL && nModelType == ITEM_APPR_ARMOR_MODEL_ROBE ){

        if ( GetLocalObject( oPC, "crft_item" ) == oItem ){

            nRoll = 1;
        }
    }
    else if ( nType == ITEM_APPR_TYPE_SIMPLE_MODEL || nType == ITEM_APPR_TYPE_ARMOR_MODEL ){

        nRoll = DoCraftingRoll( oPC, oItem );
    }
    else if ( nType == ITEM_APPR_TYPE_WEAPON_MODEL ){

        nRoll = DoCraftingRoll( oPC, oItem , SKILL_CRAFT_WEAPON );
    }

    if ( nRoll > 0 ){

        object oNewItem = CopyItemAndModifyFixed( oItem, nType, nModelType, nPart, TRUE );
        int nSlot;

        if ( GetIsObjectValid( oNewItem ) ){

            DestroyObject( oItem );

            if ( GetBaseItemType( oNewItem ) == BASE_ITEM_ARMOR ){

                nSlot = INVENTORY_SLOT_CHEST;
            }
            else if ( GetBaseItemType( oNewItem ) == BASE_ITEM_CLOAK ){

                nSlot = INVENTORY_SLOT_CLOAK;
            }
            else if ( GetBaseItemType( oNewItem ) == BASE_ITEM_HELMET ){

                nSlot = INVENTORY_SLOT_HEAD;
            }
            else if ( GetBaseItemType( oNewItem ) == BASE_ITEM_LARGESHIELD ||
                      GetBaseItemType( oNewItem ) == BASE_ITEM_SMALLSHIELD ||
                      GetBaseItemType( oNewItem ) == BASE_ITEM_TOWERSHIELD ){

                nSlot = INVENTORY_SLOT_LEFTHAND;
            }
            else{

                nSlot = INVENTORY_SLOT_RIGHTHAND;
            }

            AssignCommand( oPC, ActionEquipItem( oNewItem, nSlot ) );

            if ( nRoll != 2 ){

                SetLocalObject( oPC, "crft_item", oNewItem );
            }
        }
        else{

            //CraftingLog( oPC, oItem, "Doesn't want to change to "+IntToString(nType)+","+IntToString(nModelType)+","+IntToString(nPart) );

            if ( nRoll != 2 ){

                SetLocalObject( oPC, "crft_item", oItem );
            }
        }
    }
}

int GetSimpleModelOptions( object oItem, int nItemType ){

    int nOptions = -1;

    if ( nItemType == 3 ){

        //cloak
        nOptions = 86; //72
    }
    else if ( nItemType == 5 ){

        //helmet
        nOptions = 81;//58
    }
    else{

        //shield
        nOptions = 21;

        if ( GetBaseItemType( oItem ) == BASE_ITEM_LARGESHIELD ){

            nOptions = 74;
        }
        else if ( GetBaseItemType( oItem ) == BASE_ITEM_TOWERSHIELD ){

            nOptions = 77;
        }

    }

    return nOptions;
}

object GetCraftingItem( object oPC, int nItemType ){

    object oItem = OBJECT_INVALID;

    if ( nItemType == 1 || nItemType == 2 ){

        //armour
        oItem = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );
    }
    else if ( nItemType == 3 || nItemType == 4 ){

        //cloak
        oItem = GetItemInSlot( INVENTORY_SLOT_CLOAK, oPC );
    }
    else if ( nItemType == 5 || nItemType == 6 ){

        //helmet
        oItem = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );
    }
    else if ( nItemType == 8 || nItemType == 9 ){

        //weapon
        oItem = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    }
    else{

        //shield
        oItem = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );

        if ( GetBaseItemType( oItem ) != BASE_ITEM_LARGESHIELD &&
             GetBaseItemType( oItem ) != BASE_ITEM_SMALLSHIELD &&
             GetBaseItemType( oItem ) != BASE_ITEM_TOWERSHIELD ){

            oItem = OBJECT_INVALID;
        }
    }

    return oItem;
}

int GetShieldPartFromOption( object oItem, int nOption ){

    switch ( nOption ) {

        case 1: return 11;
        case 2: return 12;
        case 3: return 13;
        case 4: return 21;
        case 5: return 22;
        case 6: return 23;
        case 7: return 31;
        case 8: return 32;
        case 9: return 33;
        case 10: return 41;
        case 11: return 42;
        case 12: return 43;
    }

    if ( GetBaseItemType( oItem ) == BASE_ITEM_SMALLSHIELD ){

        switch ( nOption ) {

            case 13: return 14;
            case 14: return 15;
            case 15: return 16;
            case 16: return 44;
            case 17: return 45;
            case 18: return 46;
            case 19: return 47;
            case 20: return 48;
            case 21: return 49;
        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_LARGESHIELD ){

        switch ( nOption ) {

            case 13: return 51;
            case 14: return 52;
            case 15: return 53;
            case 16: return 54;
            case 17: return 55;
            case 18: return 56;
            case 19: return 61;
            case 20: return 62;
            case 21: return 63;
            case 22: return 64;
            case 23: return 65;
            case 24: return 66;
            case 25: return 67;
            case 26: return 68;
            case 27: return 69;
            case 28: return 70;
            case 29: return 71;
            case 30: return 72;
            case 31: return 73;
            case 32: return 74;
            case 33: return 75;
            case 34: return 14;
            case 35: return 15;
            case 36: return 16;
            case 37: return 24;
            case 38: return 25;
            case 39: return 26;
            case 40: return 81;
            case 41: return 82;
            case 42: return 83;
            case 43: return 84;
            case 44: return 85;
            case 45: return 86;
            case 46: return 87;
            case 47: return 88;
            case 48: return 89;
            case 49: return 90;
            case 50: return 91;
            case 51: return 92;
            case 52: return 93;
            case 53: return 94;
            case 54: return 95;
            case 55: return 96;
            case 56: return 97;
            case 57: return 98;
            case 58: return 99;
            case 59: return 100;
            case 60: return 101;
            case 61: return 102;
            case 62: return 103;
            case 63: return 104;
            case 64: return 105;
            case 65: return 106;
            case 66: return 107;
            case 67: return 110;
            case 68: return 111;
            case 69: return 112;
            case 70: return 113;
            case 71: return 114;
            case 72: return 115;
            case 73: return 117;
            case 74: return 118;

        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_TOWERSHIELD ){

        switch ( nOption ) {

            case 13: return 34;
            case 14: return 35;
            case 15: return 36;
            case 16: return 44;
            case 17: return 45;
            case 18: return 46;
            case 19: return 47;
            case 20: return 48;
            case 21: return 49;
            case 22: return 80;
            case 23: return 111;
            case 24: return 112;
            case 25: return 113;
            case 26: return 114;
            case 27: return 115;
            case 28: return 116;
            case 29: return 117;
            case 30: return 118;
            case 31: return 119;
            case 32: return 121;
            case 33: return 131;
            case 34: return 120;
            case 35: return 51;
            case 36: return 52;
            case 37: return 53;
            case 38: return 54;
            case 39: return 122;
            case 40: return 123;
            case 41: return 124;
            case 42: return 125;
            case 43: return 162;
            case 44: return 164;
            case 45: return 165;
            case 46: return 166;
            case 47: return 167;
            case 48: return 168;
            case 49: return 169;
            case 50: return 170;
            case 51: return 171;
            case 52: return 172;
            case 53: return 173;
            case 54: return 174;
            case 55: return 175;
            case 56: return 176;
            case 57: return 177;
            case 58: return 178;
            case 59: return 179;
            case 60: return 180;
            case 61: return 181;
            case 62: return 182;
            case 63: return 183;
            case 64: return 184;
            case 65: return 185;
            case 66: return 187;
            case 67: return 189;
            case 68: return 190;
            case 69: return 191;
            case 70: return 192;
            case 71: return 193;
            case 72: return 194;
            case 73: return 195;
            case 74: return 196;
            case 75: return 197;
            case 76: return 198;
            case 77: return 199;
        }
    }

    return 11;
}

int GetShieldOptionFromPart( object oItem, int nPart ){

    switch ( nPart ) {

        case 11: return 1;
        case 12: return 2;
        case 13: return 3;
        case 21: return 4;
        case 22: return 5;
        case 23: return 6;
        case 31: return 7;
        case 32: return 8;
        case 33: return 9;
        case 41: return 10;
        case 42: return 11;
        case 43: return 12;
    }

    if ( GetBaseItemType( oItem ) == BASE_ITEM_SMALLSHIELD ){

        switch ( nPart ) {

            case 14: return 13;
            case 15: return 14;
            case 16: return 15;
            case 44: return 16;
            case 45: return 17;
            case 46: return 18;
            case 47: return 19;
            case 48: return 20;
            case 49: return 21;
        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_LARGESHIELD ){

        switch ( nPart ) {

            case 14: return 34;
            case 15: return 35;
            case 16: return 36;
            case 24: return 37;
            case 25: return 38;
            case 26: return 39;
            case 51: return 13;
            case 52: return 14;
            case 53: return 15;
            case 54: return 16;
            case 55: return 17;
            case 56: return 18;
            case 61: return 19;
            case 62: return 20;
            case 63: return 21;
            case 64: return 22;
            case 65: return 23;
            case 66: return 24;
            case 67: return 25;
            case 68: return 26;
            case 69: return 27;
            case 70: return 28;
            case 71: return 29;
            case 72: return 30;
            case 73: return 31;
            case 74: return 32;
            case 75: return 33;
            case 81: return 40;
            case 82: return 41;
            case 83: return 42;
            case 84: return 43;
            case 85: return 44;
            case 86: return 45;
            case 87: return 46;
            case 88: return 47;
            case 89: return 48;
            case 90: return 49;
            case 91: return 50;
            case 92: return 51;
            case 93: return 52;
            case 94: return 53;
            case 95: return 54;
            case 96: return 55;
            case 97: return 56;
            case 98: return 57;
            case 99: return 58;
            case 100: return 59;
            case 101: return 60;
            case 102: return 61;
            case 103: return 62;
            case 104: return 63;
            case 105: return 64;
            case 106: return 65;
            case 107: return 66;
            case 110: return 67;
            case 111: return 68;
            case 112: return 69;
            case 113: return 70;
            case 114: return 71;
            case 115: return 72;
            case 117: return 73;
            case 118: return 74;

        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_TOWERSHIELD ){

        switch ( nPart ) {

            case 34: return 13;
            case 35: return 14;
            case 36: return 15;
            case 44: return 16;
            case 45: return 17;
            case 46: return 18;
            case 47: return 19;
            case 48: return 20;
            case 49: return 21;
            case 80: return 22;
            case 111: return 23;
            case 112: return 24;
            case 113: return 25;
            case 114: return 26;
            case 115: return 27;
            case 116: return 28;
            case 117: return 29;
            case 118: return 30;
            case 119: return 31;
            case 121: return 32;
            case 131: return 33;
            case 120: return 34;
            case 51: return 35;
            case 52: return 36;
            case 53: return 37;
            case 54: return 38;
            case 122: return 39;
            case 123: return 40;
            case 124: return 41;
            case 125: return 42;
            case 162: return 43;
            case 164: return 44;
            case 165: return 45;
            case 166: return 46;
            case 167: return 47;
            case 168: return 48;
            case 169: return 49;
            case 170: return 50;
            case 171: return 51;
            case 172: return 52;
            case 173: return 53;
            case 174: return 54;
            case 175: return 55;
            case 176: return 56;
            case 177: return 57;
            case 178: return 58;
            case 179: return 59;
            case 180: return 60;
            case 181: return 61;
            case 182: return 62;
            case 183: return 63;
            case 184: return 64;
            case 185: return 65;
            case 187: return 66;
            case 189: return 67;
            case 190: return 68;
            case 191: return 69;
            case 192: return 70;
            case 193: return 71;
            case 194: return 72;
            case 195: return 73;
            case 196: return 74;
            case 197: return 75;
            case 198: return 76;
            case 199: return 77;
        }
    }

    return 1;
}

int GetHelmetOptionFromPart( object oItem, int nPart ){

    if ( nPart > 0 && nPart < 34 ){

        return nPart;
    }

    switch ( nPart ) {

        case 35: return 34;
        case 40: return 35;
        case 41: return 36;
        case 47: return 37;
        case 48: return 38;
        case 53: return 39;
        case 56: return 40;
        case 58: return 41;
        case 61: return 42;
        case 62: return 43;
        case 65: return 44;
        case 66: return 45;
        case 70: return 46;
        case 71: return 47;
        case 82: return 48;
        case 84: return 49;
        case 85: return 50;
        case 86: return 51;
        case 87: return 52;
        case 88: return 53;
        case 90: return 54;
        case 101: return 55;
        case 102: return 56;
        case 103: return 57;
        case 104: return 58;
        case 049: return 059;
        case 050: return 060;
        case 051: return 061;
        case 052: return 062;
        case 054: return 063;

        case 057: return 064;
        case 059: return 065;
        case 060: return 066;
        case 063: return 067;
        case 064: return 068;
        case 067: return 069;
        case 069: return 070;
        case 100: return 071;
        case 112: return 072;
        case 206: return 073;
        case 207: return 074;
        case 208: return 075;
        case 209: return 076;
        case 210: return 077;
        case 036: return 078;
        case 037: return 079;
        case 038: return 080;
        case 205: return 081;
    }

    return 1;
}

int GetHelmetPartFromOption( object oItem, int nOption ){

    if ( nOption > 0 && nOption < 34 ){

        return nOption;
    }

    switch ( nOption ) {

        case 34: return 35;
        case 35: return 40;
        case 36: return 41;
        case 37: return 47;
        case 38: return 48;
        case 39: return 53;
        case 40: return 56;
        case 41: return 58;
        case 42: return 61;
        case 43: return 62;
        case 44: return 65;
        case 45: return 66;
        case 46: return 70;
        case 47: return 71;
        case 48: return 82;
        case 49: return 84;
        case 50: return 85;
        case 51: return 86;
        case 52: return 87;
        case 53: return 88;
        case 54: return 90;
        case 55: return 101;
        case 56: return 102;
        case 57: return 103;
        case 58: return 104;
        case 59: return 049;
        case 60: return 050;
        case 61: return 051;
        case 62: return 052;
        case 63: return 054;
        case 64: return 057;
        case 65: return 059;
        case 66: return 060;
        case 67: return 063;
        case 68: return 064;
        case 69: return 067;
        case 70: return 069;
        case 71: return 100;
        case 72: return 112;
        case 73: return 206;
        case 74: return 207;
        case 75: return 208;
        case 76: return 209;
        case 77: return 210;
        case 78: return 36;
        case 79: return 37;
        case 80: return 38;
        case 81: return 205;

    }

    return 1;
}

int GetCloakOptionFromPart( object oItem, int nPart ){

    return nPart;
}

int GetCloakPartFromOption( object oItem, int nOption ){

    return nOption;
}


int StoreWeaponOptions( object oPC, object oWeapon, int nPart, object oStorage ){

    int nType   = GetBaseItemType( oWeapon );
    string sKey = "cr_w_"+IntToString( nType )+"_"+IntToString( nPart );
    int nMax    = 0;
    object oCopy;
    int i;

    //CraftingLog( oPC, oStorage, "Cache" );
    //CraftingLog( oPC, oWeapon, "Caching "+sKey );


    for ( i=1; i<30; ++i ){

        oCopy = CopyItemAndModify( oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nPart, i );

        if ( GetIsObjectValid( oCopy ) ){

            SetLocalInt( oStorage, sKey+"_"+IntToString( i ), 1 );

            nMax = i;
        }

        DestroyObject( oCopy );
    }

    SetLocalInt( oStorage, sKey, nMax );

    return nMax;
}

int GetNextWeaponModel( object oPC, object oWeapon, int nPart, object oStorage ){

    int nType   = GetBaseItemType( oWeapon );
    string sKey = "cr_w_"+IntToString( nType )+"_"+IntToString( nPart );
    int nModel  = GetItemAppearance( oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nPart );
    int nMax    = GetLocalInt( oStorage, sKey );
    object oCopy;
    int i;
    int nNewModel;

    if ( nMax == 0 ){

        nMax = StoreWeaponOptions( oPC, oWeapon, nPart, oStorage );

        if ( nMax == 0 ){

            return -1;
        }
    }

    if ( nModel >= nMax ){

        nNewModel = 1;
    }
    else{

        ++nModel;

        for ( i=nModel; i<=nMax; ++i ){

            if ( GetLocalInt( oStorage, sKey+"_"+IntToString( i ) ) == 1 ){

                nNewModel = i;

                break;
            }
        }
    }

    return nNewModel;
}

int GetPreviousWeaponModel( object oPC, object oWeapon, int nPart, object oStorage ){

    int nType   = GetBaseItemType( oWeapon );
    string sKey = "cr_w_"+IntToString( nType )+"_"+IntToString( nPart );
    int nModel  = GetItemAppearance( oWeapon, ITEM_APPR_TYPE_WEAPON_MODEL, nPart );
    int nMax    = GetLocalInt( oStorage, sKey );
    object oCopy;
    int i;
    int nNewModel;

    if ( !GetIsObjectValid( oWeapon ) ){

        return -1;
    }

    if ( nMax == 0 ){

        nMax = StoreWeaponOptions( oPC, oWeapon, nPart, oStorage );

        if ( nMax == 0 ){

            return -1;
        }
    }

    if ( nModel <= 1 ){

        nNewModel = nMax;
    }
    else{

        --nModel;

        for ( i=nModel; i>=1; --i ){

            if ( GetLocalInt( oStorage, sKey+"_"+IntToString( i ) ) == 1 ){

                nNewModel = i;

                break;
            }
        }
    }

    return nNewModel;
}

int DoCraftingRoll( object oPC, object oItem , int nSkill=SKILL_CRAFT_ARMOR ){

    if ( GetLocalObject( oPC, "crft_item" ) != oItem ){

        SetLocalObject( oPC, "crft_item", oItem );

        return 1;
    }
    else{

        return 1;
    }
}

//List of names for each dye
string DyeName( int nIndex, int nModel ){

    //get the indexed colour from the correct colour list
    if ( nIndex > -1 && nIndex < 64 ){

        if ( nModel == ITEM_APPR_ARMOR_COLOR_METAL1 || nModel == ITEM_APPR_ARMOR_COLOR_METAL2 ){

            return StandardMetalDyes(nIndex );
        }
        else {

            return StandardClothDyes(nIndex );
        }
    }
    else if ( nIndex > 63 && nIndex <176 ){

        return NewDyes(nIndex );
    }

    return "Unknown Colour";
}


//standard pre 1.67 cloth/leather colours
string StandardClothDyes( int nIndex ){

    switch ( nIndex ){

        case 00: return "Lightest Brown";
        case 01: return "Light Brown";
        case 02: return "Dark Brown";
        case 03: return "Darkest Brown";
        case 04: return "Lightest Tan";
        case 05: return "Light Tan";
        case 06: return "Dark Tan";
        case 07: return "Darkest Tan";
        case 08: return "Lightest Beige";
        case 09: return "Light Beige";
        case 10: return "Dark Beige";
        case 11: return "Darkest Beige";
        case 12: return "Lightest Taupe";
        case 13: return "Light Taupe";
        case 14: return "Dark Taupe";
        case 15: return "Darkest Taupe";
        case 16: return "Lightest Olive";
        case 17: return "Light Olive";
        case 18: return "Dark Olive";
        case 19: return "Darkest Olive";
        case 20: return "Lightest Grey";
        case 21: return "Light Grey";
        case 22: return "Grey";
        case 23: return "Dark Grey";
        case 24: return "Blue";
        case 25: return "Dark Blue";
        case 26: return "Lightest Blue";
        case 27: return "Light Blue";
        case 28: return "Turquoise";
        case 29: return "Teal";
        case 30: return "Light Green";
        case 31: return "Dark Green";
        case 32: return "Yellow";
        case 33: return "Dark Yellow";
        case 34: return "Orange";
        case 35: return "Dark Orange";
        case 36: return "Red";
        case 37: return "Light Red";
        case 38: return "Dark Red";
        case 39: return "Pink";
        case 40: return "Purple";
        case 41: return "Dark Purple";
        case 42: return "Lavender";
        case 43: return "Dark Lavender";
        case 44: return "White";
        case 45: return "Black";
        case 46: return "Shiny Dark Blue";
        case 47: return "Shiny Light Blue";
        case 48: return "Shiny Teal";
        case 49: return "Shiny Dark Green";
        case 50: return "Shiny Dark Yellow";
        case 51: return "Shiny Dark Orange";
        case 52: return "Shiny Red";
        case 53: return "Shiny Pink";
        case 54: return "Shiny Purple";
        case 55: return "Shiny Dark Lavender";
        case 56: return "Silver";
        case 57: return "Obsidian";
        case 58: return "Shiny Yellow";
        case 59: return "Pale Copper";
        case 60: return "Textured Grey";
        case 61: return "Reflective";
        case 62: return "Pure White";
        case 63: return "Pure Black";
    }

    return "Unknown Colour";
}

//standard pre 1.67 metal colours
string StandardMetalDyes( int nIndex ){

    switch ( nIndex ){

        case 00: return "Silver";
        case 01: return "Steel";
        case 02: return "Dark Steel";
        case 03: return "Obsidian";
        case 04: return "Bright Grey";
        case 05: return "Light Grey";
        case 06: return "Dark Grey";
        case 07: return "Darkest Grey";
        case 08: return "Bright Yellow";
        case 09: return "Light Yellow";
        case 10: return "Muted  Yellow";
        case 11: return "Dark Yellow";
        case 12: return "Bright Gold";
        case 13: return "Light Gold";
        case 14: return "Muted Gold";
        case 15: return "Dark Gold";
        case 16: return "Bright Orange";
        case 17: return "Light Orange";
        case 18: return "Muted Orange";
        case 19: return "Dark Orange";
        case 20: return "Bright Copper";
        case 21: return "Light Copper";
        case 22: return "Muted Copper";
        case 23: return "Dark Copper";
        case 24: return "Bright Red";
        case 25: return "Maroon";
        case 26: return "Muted Bright Red";
        case 27: return "Muted Maroon";
        case 28: return "Bright Purple";
        case 29: return "Dark Purple";
        case 30: return "Bright Lavender";
        case 31: return "Muted Lavender";
        case 32: return "Bright Blue";
        case 33: return "Dark Blue";
        case 34: return "Muted Bright Blue";
        case 35: return "Muted Dark Blue";
        case 36: return "Bright Turquoise";
        case 37: return "Bright Teal";
        case 38: return "Muted Turquoise";
        case 39: return "Muted Teal";
        case 40: return "Bright Green";
        case 41: return "Dark Green";
        case 42: return "Muted Bright Green";
        case 43: return "Muted Dark Green";
        case 44: return "Bright Olive";
        case 45: return "Dark Olive";
        case 46: return "Muted Bright Olive";
        case 47: return "Muted Dark Olive";
        case 48: return "Rainbow";
        case 49: return "Muted Rainbow";
        case 50: return "Light Rust";
        case 51: return "Full  Rust";
        case 52: return "Dark Rust";
        case 53: return "Dark Full Rust";
        case 54: return "Textured Grey";
        case 55: return "Fully Textured Grey";
        case 56: return "Silver";
        case 57: return "Obsidian";
        case 58: return "Bright Yellow";
        case 59: return "Bright Copper";
        case 60: return "Shiny Black";
        case 61: return "Reflective";
        case 62: return "Pure White";
        case 63: return "Pure Black";
    }

    return "Unknown Colour";
}

//Cloth and metal are the same.
string NewDyes( int nIndex ){

    switch ( nIndex ){

        case 64: return "Dark Rose";
        case 65: return "Mauve";
        case 66: return "Dark Gold";
        case 67: return "Dull Olive";
        case 68: return "Leaf";
        case 69: return "Bluegrass";
        case 70: return "Dark Plum";
        case 71: return "Stone";
        case 72: return "Plum";
        case 73: return "Faded Plum";
        case 74: return "Peachy Tan";
        case 75: return "Mouse";
        case 76: return "Jade Green";
        case 77: return "Dark Jade";
        case 78: return "Blue Steel";
        case 79: return "Medium Blue Steel";
        case 80: return "Medium Olive";
        case 81: return "Taupe";
        case 82: return "Sky Blue";
        case 83: return "Light Blue Steel";
        case 84: return "Mould";
        case 85: return "Smoke";
        case 86: return "Dust";
        case 87: return "Dirty Olive";
        case 88: return "Light Red";
        case 89: return "Red";
        case 90: return "Brick Red";
        case 91: return "Cherry";
        case 92: return "Honey";
        case 93: return "Dark Honey";
        case 94: return "Mustard";
        case 95: return "Dark Mustard";
        case 96: return "Lightest Burgundy";
        case 97: return "Light Burgundy";
        case 98: return "Burgundy";
        case 99: return "Dark Burgundy";
        case 100: return "Lightest Rouge";
        case 101: return "Light Rouge";
        case 102: return "Rouge";
        case 103: return "Dark Rouge";
        case 104: return "Lightest Pine";
        case 105: return "Light Pine";
        case 106: return "Pine";
        case 107: return "Dark Pine";
        case 108: return "Lightest Olive";
        case 109: return "Light Olive";
        case 110: return "Olive";
        case 111: return "Dark Olive";
        case 112: return "Lightest Taupe";
        case 113: return "Light Taupe";
        case 114: return "Taupe";
        case 115: return "Dark Taupe";
        case 116: return "Lighest Caramel";
        case 117: return "Light Caramel";
        case 118: return "Caramel";
        case 119: return "Dark Caramel";
        case 120: return "Lightest Champagne";
        case 121: return "Light Champagne";
        case 122: return "Champagne";
        case 123: return "Dark Champagne";
        case 124: return "Lightest Chocolate";
        case 125: return "Light Chocolate";
        case 126: return "Chocolate";
        case 127: return "Dark Chocolate";
        case 128: return "Lighest Amber";
        case 129: return "Light Amber";
        case 130: return "Amber";
        case 131: return "Dark Amber";
        case 132: return "Lightest Shadow";
        case 133: return "Light Shadow";
        case 134: return "Shadow";
        case 135: return "Dark Shadow";
        case 136: return "Lightest Indigo";
        case 137: return "Light Indigo";
        case 138: return "Indigo";
        case 139: return "Dark Indigo";
        case 140: return "Lightest Turquoise";
        case 141: return "Light Turquoise";
        case 142: return "Turquoise";
        case 143: return "Dark Turquoise";
        case 144: return "Lightest Magenta";
        case 145: return "Light Magenta";
        case 146: return "Magenta";
        case 147: return "Dark Magenta";
        case 148: return "Light Sky";
        case 149: return "Sky";
        case 150: return "Light Aquamarine";
        case 151: return "Aquamarine";
        case 152: return "Light Lime";
        case 153: return "Lime";
        case 154: return "Light Hobo";
        case 155: return "Hobo";
        case 156: return "Light Potatoesack";
        case 157: return "Potatoesack";
        case 158: return "Light Peach";
        case 159: return "Peach";
        case 160: return "Light Grape";
        case 161: return "Grape";
        case 162: return "Candy";
        case 163: return "Petunia";
        case 164: return "Ice";
        case 165: return "Dark Frost";
        case 166: return "Snow";
        case 167: return "Oil";
        case 168: return "Bone";
        case 169: return "Scale";
        case 170: return "Twilight";
        case 171: return "Charcoal";
        case 172: return "Swampgator";
        case 173: return "Dark Mocha";
        case 174: return "Light Mocha";
        case 175: return "Tarnished Gold";
    }

    return "Unknown Colour";
}

int GetBaseAC( object oItem ){

    if ( GetBaseItemType( oItem ) != BASE_ITEM_ARMOR ){

        return -1;
    }

    int nCurrentPart = GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO );

    if ( nCurrentPart == 190 ){

        return 8;
    }

    int nAC = GetChestOptionFromPart( nCurrentPart ) / 100;

    return nAC;
}

void CraftingLog( object oPC, object oItem, string sIssue ){

    string sQuery;

    if ( sIssue == "Cache" ){

        sQuery = "INSERT INTO exploits  VALUES ( NULL, 'Crafting System',"
                    +"'"+SQLEncodeSpecialChars( sIssue )+"',"
                    +"'"+SQLEncodeSpecialChars( GetName( oPC ) )+"',"
                    +"'"+SQLEncodeSpecialChars( GetName( GetArea( oItem ) ) )+"',"
                    +"'"+SQLEncodeSpecialChars( GetName( oItem ) ) +"',"
                    +"'"+SQLEncodeSpecialChars(  GetTag( oItem ) )+"', NOW() )";

        //execute query
        SQLExecDirect( sQuery );

        return;
    }

    string sItem = GetName( oItem )+";"+GetItemBaseTypeName( oItem )+";"+IntToString( GetGoldPieceValue( oItem ) );
    string sData;
    int i;

    if ( GetIsWeapon( oItem ) ){

        for ( i=0; i<3; ++i ){

            sData += IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_WEAPON_MODEL, i ) )+";";
        }

        for ( i=0; i<3; ++i ){

            sData += IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_WEAPON_COLOR, i ) )+";";
        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_ARMOR ){

        for ( i=0; i<19; ++i ){

            sData += IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, i ) )+";";
        }

        for ( i=0; i<6; ++i ){

            sData += IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, i ) )+";";
        }
    }
    else {

        sData = IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 ) )+";";

        for ( i=0; i<6; ++i ){

            sData += IntToString( i )+"="+IntToString( GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, i ) )+";";
        }
    }

    sQuery = "INSERT INTO exploits  VALUES ( NULL, 'Crafting System',"
                +"'"+SQLEncodeSpecialChars( sIssue )+"',"
                +"'"+SQLEncodeSpecialChars( GetName( oPC ) )+"',"
                +"'"+SQLEncodeSpecialChars( GetSubString( sItem, 0, 255 ) )+"',"
                +"'"+SQLEncodeSpecialChars( GetSubString( sData, 0, 255 ) ) +"',"
                +"'"+SQLEncodeSpecialChars(  sData )+"', NOW() )";

    //execute query
    SQLExecDirect( sQuery );
}
