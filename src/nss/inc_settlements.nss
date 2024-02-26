// inc_settlements
// Contains constants for settlement names
//void main (){}
string SettlementName(int settlement);

const string SETTLEMENT_1 = "Barak Runedar";
const string SETTLEMENT_2 = "Setersborg";
const string SETTLEMENT_3 = "Howness";
const string SETTLEMENT_4 = "Thordstein";
const string SETTLEMENT_5 = "Thykkvi";
const string SETTLEMENT_6 = "Fort Cystana";
const string SETTLEMENT_7 = "Greengarden";
const string SETTLEMENT_8 = "Gregory's Landing";
const string SETTLEMENT_9 = "Whitestag";
const string SETTLEMENT_10 = "Calderis";
const string SETTLEMENT_11 = "Ostdur";
const string SETTLEMENT_12 = "Osthavn";
const string SETTLEMENT_13 = "Havskar";
const string SETTLEMENT_14 = "Fort Wiltun";
const string SETTLEMENT_15 = "Ceyren's Mill";
const string SETTLEMENT_16 = "Belenoth";
const string SETTLEMENT_17 = "Bloodspear Keep";
const string SETTLEMENT_18 = "Blue Lagoon";
const string SETTLEMENT_19 = "Brokentooth Cave";
const string SETTLEMENT_20 = "Chillwyck";
const string SETTLEMENT_21 = "The Dale";
const string SETTLEMENT_22 = "Djedet";
const string SETTLEMENT_23 = "The Eilistraeen Shrine";
const string SETTLEMENT_24 = "Endir's Point";
const string SETTLEMENT_25 = "Hangman's Cove";
const string SETTLEMENT_26 = "L'Obsul";
const string SETTLEMENT_27 = "Moonpier";
const string SETTLEMENT_28 = "Nes'ek";
const string SETTLEMENT_29 = "Oakmist Vale";
const string SETTLEMENT_30 = "The Quagmire Camp";
const string SETTLEMENT_31 = "The Quagmire Warren";
const string SETTLEMENT_32 = "Ridgewood";
const string SETTLEMENT_33 = "The Salandran Temple";
const string SETTLEMENT_34 = "Shadowscape";
const string SETTLEMENT_35 = "Southport";
const string SETTLEMENT_36 = "Traveller's Rest";
const string SETTLEMENT_37 = "The Triumvir";
const string SETTLEMENT_38 = "Winya Ravana";
const string SETTLEMENT_39 = "Zanshibon";

//void main (){}

string SettlementName(int settlement){
    string settlementName;

    switch(settlement){
        case 0: settlementName = "No Name"; break;
        case 1: settlementName = "Barak Runedar"; break;
        case 2: settlementName = "Setersborg"; break;
        case 3: settlementName = "Howness"; break;
        case 4: settlementName = "Thordstein"; break;
        case 5: settlementName = "Thykkvi"; break;
        case 6: settlementName = "Fort Cystana"; break;
        case 7: settlementName = "Greengarden"; break;
        case 8: settlementName = "Gregory's Landing"; break;
        case 9: settlementName = "Whitestag"; break;
        case 10: settlementName = "Calderis"; break;
        case 11: settlementName = "Ostdur"; break;
        case 12: settlementName = "Osthavn"; break;
        case 13: settlementName = "Havskar"; break;
        case 14: settlementName = "Fort Wiltun"; break;
        case 15: settlementName = "Ceyren's Mill"; break;
        case 16: settlementName = "Belenoth"; break;
        case 17: settlementName = "Bloodspear Keep"; break;
        case 18: settlementName = "Blue Lagoon"; break;
        case 19: settlementName = "Brokentooth Cave"; break;
        case 20: settlementName = "Chillwyck"; break;
        case 21: settlementName = "The Dale"; break;
        case 22: settlementName = "Djedet"; break;
        case 23: settlementName = "The Eilistraeen Shrine"; break;
        case 24: settlementName = "Endir's Point"; break;
        case 25: settlementName = "Hangman's Cove"; break;
        case 26: settlementName = "L'Obsul"; break;
        case 27: settlementName = "Moonpier"; break;
        case 28: settlementName = "Nes'ek"; break;
        case 29: settlementName = "Oakmist Vale"; break;
        case 30: settlementName = "The Quagmire Camp"; break;
        case 31: settlementName = "The Quagmire Warren"; break;
        case 32: settlementName = "Ridgewood"; break;
        case 33: settlementName = "The Salandran Temple"; break;
        case 34: settlementName = "Shadowscape"; break;
        case 35: settlementName = "Southport"; break;
        case 36: settlementName = "Traveller's Rest"; break;
        case 37: settlementName = "The Triumvir"; break;
        case 38: settlementName = "Winya Ravana"; break;
        case 39: settlementName = "Zanshibon"; break;
        default: settlementName = "Error: No Settlement Found!"; break;
    }
    return settlementName;
}
