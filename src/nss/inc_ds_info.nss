//  20070630  Disco       Added item history tracer
//  20120522  Glim        Added recognition for Master Scout & Knight Commander classes


#include "x2_inc_switches"
#include "X0_I0_PARTYWIDE"
#include "nw_i0_plot"
#include "inc_ds_records"

//creature info functions
void GetPCInfo( object oTarget, object oDM );
void GetFullPCInfo( object oTarget, object oDM );
void GetCreatureInfo( object oTarget, object oDM );
void GetNpcInfo( object oTarget,object oDM );
void GetXPDC( object oTarget, object oDM );
void GetClassAndLevel( object oTarget, object oDM );
void GetParty( object oTarget, object oDM );

//other objects
void GetItemInfo( object oTarget, object oDM );
void GetAreaInfo( object oDM, object oArea );
void GetPlaceableInfo( object oTarget, object oDM );
void GetDoorInfo( object oTarget, object oDM );

//helper functions
string GetClassName(int i, object oTarget);
string GetRace_Name( object oTarget);
string GetAlignmentName(int nAlignment);
string GetItemLevel(int nPrice);
int GetIdentifiedGoldPieceValue( object oItem);

// Report PC XP Info to the DM
void ReportXPStatus( object oTarget, object oDM );

//from the DMFI package
void GetNetWorth( object oTarget, object oDM );

string item_properties( object oTarget );

//lists effects
void ListEffects( object oPC, object oTarget );
string GetEffectTypeName( int nEffectType );


void GetPCInfo( object oTarget, object oDM){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  login: "+GetPCPlayerName(oTarget) );
    SendMessageToPC( oDM, "  CDKEY: "+GetPCPublicCDKey(oTarget) );
    SendMessageToPC( oDM, "  IP: "+GetPCIPAddress(oTarget) );
    SendMessageToPC( oDM, "  PCKEY: "+GetName(GetPCKEY(oTarget)) );
    GetXPDC( oTarget, oDM );
}

void GetFullPCInfo( object oTarget, object oDM){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  login: "+GetPCPlayerName(oTarget) );
    SendMessageToPC( oDM, "  CDKEY: "+GetPCPublicCDKey(oTarget) );
    SendMessageToPC( oDM, "  IP: "+GetPCIPAddress(oTarget) );
    SendMessageToPC( oDM, "  PCKEY: "+GetName(GetPCKEY(oTarget)) );
    GetCreatureInfo( oTarget, oDM );
    GetXPDC( oTarget, oDM );
    GetNetWorth( oTarget, oDM );
    GetParty( oTarget, oDM );
}

void GetNpcInfo( object oTarget, object oDM ){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  Tag: "+GetTag(oTarget) );
    SendMessageToPC( oDM, "  ResRef: "+GetResRef(oTarget) );
    SendMessageToPC( oDM, "  Plot flag: "+IntToString(GetPlotFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Immortal flag: "+IntToString(GetImmortal(oTarget) ) );
    SendMessageToPC( oDM, "  Challenge rating: "+FloatToString(GetChallengeRating(oTarget),3,1) );

    if(GetMaster(oTarget)!=OBJECT_INVALID){
        SendMessageToPC( oDM, "  Master: "+GetName(GetMaster(oTarget) ) );
    }

    GetCreatureInfo( oTarget, oDM );
}

void GetCreatureInfo( object oTarget, object oDM ){

    int i;
    int nLevel;
    string sClass;
    string sClasses="";
    string sAlignment=GetAlignmentName(GetAlignmentLawChaos(oTarget) )+GetAlignmentName(GetAlignmentGoodEvil(oTarget) );
    string sRace=GetRace_Name(oTarget);

    if(GetSubRace(oTarget)!=""){sRace=sRace+"/"+GetSubRace(oTarget);}


    for (i=1; i<4; ++i){
        nLevel = GetLevelByPosition(i,oTarget);
        if(nLevel>0){
            sClass=GetClassName(i,oTarget);
            sClasses=sClasses+sClass+": "+IntToString(nLevel)+", ";
        }
    }
    sClasses=GetStringLeft(sClasses, (GetStringLength(sClasses)-2) );

    SendMessageToPC( oDM, "  Race: "+sRace);
    SendMessageToPC( oDM, "  Alignment: "+sAlignment);
    SendMessageToPC( oDM, "  Friendly towards you: "+IntToString( GetReputation( oTarget, oDM ) )+"%" );
    SendMessageToPC( oDM, "  Deity: "+GetDeity( oTarget ) );
    SendMessageToPC( oDM, "  Bindpoint: "+GetName( GetArea( GetWaypointByTag( GetStartWaypoint( oTarget, TRUE ) ) ) ) );
    SendMessageToPC( oDM, "  Level: "+IntToString(GetHitDice(oTarget) ) );
    SendMessageToPC( oDM, "  Classes: "+sClasses);
    SendMessageToPC( oDM, "  HP:"+IntToString(GetCurrentHitPoints(oTarget) )+"/"+IntToString(GetMaxHitPoints(oTarget) )+", AC:"+IntToString(GetAC(oTarget) )+", BA:"+IntToString(GetBaseAttackBonus(oTarget) )+", SR:"+IntToString(GetSpellResistance(oTarget) ) );

}

void GetXPDC( object oTarget, object oDM){

    string sMessage = "  XP:"+IntToString(GetXP(oTarget) )+", DC:"+IntToString(GetNumItems(oTarget,"dreamcoin") );
    SendMessageToPC( oDM, sMessage );
}

void GetParty( object oTarget, object oDM){

    //int nPlayerCount = GetNumberPartyMembers(oTarget)-1;
    //if (nPlayerCount>1){
        object oLeader      = GetFactionLeader( oTarget );
        object oDMArea      = GetArea( oDM );
        object oPCArea;
        object oPartyMember = GetFirstFactionMember( oTarget, TRUE );
        string sMemberInfo;

        SendMessageToPC( oDM, "Party members:");

        while(GetIsObjectValid(oPartyMember) == TRUE){

            oPCArea=GetArea(oPartyMember);

            if(oPartyMember == oLeader){
                sMemberInfo=GetName(oPartyMember)+" (L"+IntToString(GetHitDice(oPartyMember) )+", Leader";
            }
            else{
                sMemberInfo=GetName(oPartyMember)+" (L"+IntToString(GetHitDice(oPartyMember) );
            }
            if (oPCArea==oDMArea){
                sMemberInfo=sMemberInfo+", this area)";
            }
            else{
                sMemberInfo=sMemberInfo+", "+GetName(oPCArea)+")";
            }
            SendMessageToPC( oDM, sMemberInfo);
            oPartyMember = GetNextFactionMember(oTarget, TRUE );
        }
    //}
}

void GetItemInfo( object oTarget, object oDM ){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  Type: Item");
    SendMessageToPC( oDM, "  Tag: "+GetTag(oTarget) );
    SendMessageToPC( oDM, "  ResRef: "+GetResRef(oTarget) );
    SendMessageToPC( oDM, "  Price:"+IntToString(GetIdentifiedGoldPieceValue(oTarget) ) );
    SendMessageToPC( oDM, "  Required level: "+GetItemLevel(GetIdentifiedGoldPieceValue(oTarget) ) );
    SendMessageToPC( oDM, "  Cursed flag: "+IntToString(GetItemCursedFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Drop flag (loot): "+IntToString(GetDroppableFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Plot flag: "+IntToString(GetPlotFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Stolen flag: "+IntToString(GetStolenFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Charges: "+IntToString(GetItemCharges(oTarget) ) );

    int nOwners = GetLocalInt( oTarget, "ds_os" );
    int i;

    SendMessageToPC( oDM, "Ownership History" );

    for( i=1; i<=nOwners; ++i ){

        SendMessageToPC( oDM, "  "+GetLocalString( oTarget, "ds_os_"+IntToString( i ) ) );
    }
}

void GetAreaInfo( object oDM, object oArea ){

    object oObject              = GetFirstObjectInArea(oArea);
    int iPlayers                = 0;
    int iCreatures              = 0;
    int iPlaceables             = 0;

    while (GetIsObjectValid(oObject) ){

        if (GetIsPC(oObject) ) {

            ++iPlayers;
        }
        else if (GetObjectType(oObject)==OBJECT_TYPE_CREATURE){

            ++iCreatures;
        }
        else if (GetObjectType(oObject)==OBJECT_TYPE_PLACEABLE){

            ++iPlaceables;
        }
        oObject = GetNextObjectInArea(oArea);
    }

    SendMessageToPC( oDM, GetName(oArea) );
    SendMessageToPC( oDM, "  Type: Area");
    SendMessageToPC( oDM, "  Tag: "+GetTag(oArea) );
    SendMessageToPC( oDM, "  ResRef: "+GetResRef(oArea) );
    SendMessageToPC( oDM, "  Area size: x="+IntToString(GetAreaSize(AREA_WIDTH,oArea) )+", y="+IntToString(GetAreaSize(AREA_HEIGHT,oArea) ) );
    SendMessageToPC( oDM, "  Players in area: "+IntToString(iPlayers) );
    SendMessageToPC( oDM, "  Creatures in area: "+IntToString(iCreatures) );
    SendMessageToPC( oDM, "  Placeables in area: "+IntToString(iPlaceables) );

    if ( GetIsAreaNatural( oArea ) == AREA_NATURAL ){

        SendMessageToPC(oDM,"  Natural Area");
    }
    else{

        SendMessageToPC(oDM,"  Artificial Area");

    }

    if ( GetIsAreaAboveGround( oArea ) == AREA_ABOVEGROUND ){

        SendMessageToPC(oDM,"  Surface Area");
    }
    else{

        SendMessageToPC(oDM,"  Underground Area");

    }
    if ( GetIsAreaInterior( oArea ) ){

        SendMessageToPC(oDM,"  Interior Area");
    }
    else{

        SendMessageToPC(oDM,"  Exterior Area");
    }

    SendMessageToPC( oDM, "  Free Respawn: "+IntToString(GetLocalInt(oArea,"FreeRespawn" )) );
    SendMessageToPC( oDM, "  Free Rest: "+IntToString(GetLocalInt(oArea,"FreeRest" )) );
    SendMessageToPC( oDM, "  No Casting: "+IntToString(GetLocalInt(oArea,"NoCasting" )) );
    SendMessageToPC( oDM, "  Prevent Port To Leader: "+IntToString(GetLocalInt(oArea,"PreventPortToLeader" )) );
    SendMessageToPC( oDM, "  Prevent Rod Of Porting: "+IntToString(GetLocalInt(oArea,"PreventRodOfPorting" )) );
    SendMessageToPC( oDM, "  Reveal Map: "+IntToString(GetLocalInt(oArea,"CS_MAP_REVEAL" )) );
    SendMessageToPC( oDM, "  Spawn Block: "+IntToString(GetLocalInt(oArea,"no_spawn" )) );
    // tileset information
    SendMessageToPC(oDM, "  Tileset ResRef: " + GetTilesetResRef(oArea));

    // dynamic area information
    int areaType = GetLocalInt(oArea, "area_type");
    SendMessageToPC(oDM,"  Dynamic Area Type: " + IntToString(areaType));

    if(GetLocalInt(oArea, "NoDestroy") == 0)
    {
        SendMessageToPC(oDM,"  Area Status: default");
    }
    else
    {
        SendMessageToPC(oDM,"  Area Status: permanent");
    }
}

void GetPlaceableInfo( object oTarget, object oDM){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  Type: Placeable Object");
    SendMessageToPC( oDM, "  Tag: "+GetTag(oTarget) );
    SendMessageToPC( oDM, "  ResRef: "+GetResRef(oTarget) );
    SendMessageToPC( oDM, "  Plot flag: "+IntToString(GetPlotFlag(oTarget) ) );
    SendMessageToPC( oDM, "  Useable flag: "+IntToString(GetUseableFlag(oTarget) ) );
}

void GetDoorInfo( object oTarget, object oDM){

    SendMessageToPC( oDM, GetName(oTarget) );
    SendMessageToPC( oDM, "  Type: Door");
    SendMessageToPC( oDM, "  Tag: "+GetTag(oTarget) );
    SendMessageToPC( oDM, "  ResRef: "+GetResRef(oTarget) );
    SendMessageToPC( oDM, "  Lock DC: "+IntToString(GetLockUnlockDC(oTarget) ) );
    SendMessageToPC( oDM, "  Hardness: "+IntToString(GetHardness(oTarget) ) );
    SendMessageToPC( oDM, "  Locked: "+IntToString(GetLocked(oTarget) ) );
    SendMessageToPC( oDM, "  Key Required: "+IntToString(GetLockKeyRequired(oTarget) ) );
    SendMessageToPC( oDM, "  Key tag: "+GetLockKeyTag(oTarget) );
    SendMessageToPC( oDM, "  Autoclose block: "+IntToString(GetLocalInt(oTarget,"blocked") ) );
    SendMessageToPC( oDM, "  Plot flag: "+IntToString(GetPlotFlag(oTarget) ) );
}

string GetRace_Name( object oTarget){

    string sRace="no clue";
    int nRace=GetRacialType(oTarget);

    if(nRace==RACIAL_TYPE_ABERRATION){sRace="aberration";}
    if(nRace==RACIAL_TYPE_ALL){sRace="ALL";}
    if(nRace==RACIAL_TYPE_ANIMAL){sRace="animal";}
    if(nRace==RACIAL_TYPE_BEAST){sRace="beast";}
    if(nRace==RACIAL_TYPE_CONSTRUCT){sRace="construct";}
    if(nRace==RACIAL_TYPE_DRAGON){sRace="dragon";}
    if(nRace==RACIAL_TYPE_DWARF){sRace="Dwarf";}
    if(nRace==RACIAL_TYPE_ELEMENTAL){sRace="elemental";}
    if(nRace==RACIAL_TYPE_ELF){sRace="Elf";}
    if(nRace==RACIAL_TYPE_FEY){sRace="fey";}
    if(nRace==RACIAL_TYPE_GIANT){sRace="giant";}
    if(nRace==RACIAL_TYPE_GNOME){sRace="Gnome";}
    if(nRace==RACIAL_TYPE_HALFELF){sRace="Half-Elf";}
    if(nRace==RACIAL_TYPE_HALFLING){sRace="Halfling";}
    if(nRace==RACIAL_TYPE_HALFORC){sRace="Half-Ork";}
    if(nRace==RACIAL_TYPE_HUMAN){sRace="Human";}
    if(nRace==RACIAL_TYPE_HUMANOID_GOBLINOID){sRace="goblinoid";}
    if(nRace==RACIAL_TYPE_HUMANOID_MONSTROUS){sRace="monster";}
    if(nRace==RACIAL_TYPE_HUMANOID_ORC){sRace="ork";}
    if(nRace==RACIAL_TYPE_HUMANOID_REPTILIAN){sRace="reptilian";}
    if(nRace==RACIAL_TYPE_INVALID){sRace="invalid";}
    if(nRace==RACIAL_TYPE_MAGICAL_BEAST){sRace="magical beast";}
    if(nRace==RACIAL_TYPE_OOZE){sRace="ooze";}
    if(nRace==RACIAL_TYPE_OUTSIDER){sRace="outsider";}
    if(nRace==RACIAL_TYPE_SHAPECHANGER){sRace="shapechanger";}
    if(nRace==RACIAL_TYPE_UNDEAD){sRace="undead";}
    if(nRace==RACIAL_TYPE_VERMIN){sRace="vermin";}
    return sRace;
}

string GetClassName(int i, object oTarget){
    string sClassName="no clue";
    int nClass=GetClassByPosition(i,oTarget);

    if (nClass==CLASS_TYPE_ABERRATION) {sClassName="aberration";}
    if (nClass==CLASS_TYPE_ANIMAL) {sClassName="animal";}
    if (nClass==CLASS_TYPE_ARCANE_ARCHER) {sClassName="arcane archer";}
    if (nClass==CLASS_TYPE_ASSASSIN) {sClassName="assassin";}
    if (nClass==CLASS_TYPE_BARBARIAN) {sClassName="barbarian";}
    if (nClass==CLASS_TYPE_BARD) {sClassName="bard";}
    if (nClass==CLASS_TYPE_BEAST) {sClassName="beast";}
    if (nClass==CLASS_TYPE_BLACKGUARD) {sClassName="blackguard";}
    if (nClass==CLASS_TYPE_CLERIC) {sClassName="cleric";}
    if (nClass==CLASS_TYPE_COMMONER) {sClassName="commoner";}
    if (nClass==CLASS_TYPE_CONSTRUCT) {sClassName="construct";}
    if (nClass==CLASS_TYPE_DIVINECHAMPION) {sClassName="divine champion";}
    if (nClass==CLASS_TYPE_DRAGON) {sClassName="dragon";}
    if (nClass==CLASS_TYPE_DRAGONDISCIPLE) {sClassName="dragon disciple";}
    if (nClass==CLASS_TYPE_DRUID) {sClassName="druid";}
    if (nClass==CLASS_TYPE_DWARVENDEFENDER) {sClassName="dwarven defender";}
    if (nClass==CLASS_TYPE_ELEMENTAL) {sClassName="elemental";}
    if (nClass==CLASS_TYPE_FEY) {sClassName="fey";}
    if (nClass==CLASS_TYPE_FIGHTER) {sClassName="fighter";}
    if (nClass==CLASS_TYPE_GIANT) {sClassName="giant";}
    if (nClass==CLASS_TYPE_HARPER) {sClassName="harper";}
    if (nClass==CLASS_TYPE_HUMANOID) {sClassName="humanoid";}
    if (nClass==CLASS_TYPE_INVALID) {sClassName="invalid";}
    if (nClass==CLASS_TYPE_MAGICAL_BEAST) {sClassName="magical_beast";}
    if (nClass==CLASS_TYPE_MONK) {sClassName="monk";}
    if (nClass==CLASS_TYPE_MONSTROUS) {sClassName="monstrous";}
    if (nClass==CLASS_TYPE_OUTSIDER) {sClassName="outsider";}
    if (nClass==CLASS_TYPE_PALADIN) {sClassName="paladin";}
    if (nClass==CLASS_TYPE_PALEMASTER) {sClassName="palemaster";}
    if (nClass==CLASS_TYPE_RANGER) {sClassName="ranger";}
    if (nClass==CLASS_TYPE_ROGUE) {sClassName="rogue";}
    if (nClass==CLASS_TYPE_SHADOWDANCER) {sClassName="shadowdancer";}
    if (nClass==CLASS_TYPE_SHAPECHANGER) {sClassName="shapechanger";}
    if (nClass==CLASS_TYPE_SHIFTER) {sClassName="shifter";}
    if (nClass==CLASS_TYPE_SORCERER) {sClassName="sorcerer";}
    if (nClass==CLASS_TYPE_UNDEAD) {sClassName="undead";}
    if (nClass==CLASS_TYPE_VERMIN) {sClassName="vermin";}
    if (nClass==CLASS_TYPE_WEAPON_MASTER) {sClassName="weapon master";}
    if (nClass==CLASS_TYPE_WIZARD) {sClassName="wizard";}
    if (nClass==28) {sClassName="master scout";}
    if (nClass==41) {sClassName="knight commander";}
    return sClassName;
}
string GetAlignmentName(int nAlignment){
    string sAlignmentName="no clue";
    if (nAlignment==ALIGNMENT_CHAOTIC) {sAlignmentName="C";}
    if (nAlignment==ALIGNMENT_EVIL) {sAlignmentName="E";}
    if (nAlignment==ALIGNMENT_GOOD) {sAlignmentName="G";}
    if (nAlignment==ALIGNMENT_LAWFUL) {sAlignmentName="L";}
    if (nAlignment==ALIGNMENT_NEUTRAL) {sAlignmentName="N";}
    return sAlignmentName;
}

string GetItemLevel(int nPrice){
    int nLevel=0;
    if (nPrice<=1000){nLevel=1;}
    else if (nPrice<=1500){nLevel=2;}
    else if (nPrice<=2500){nLevel=3;}
    else if (nPrice<=3500){nLevel=4;}
    else if (nPrice<=5000){nLevel=5;}
    else if (nPrice<=6500){nLevel=6;}
    else if (nPrice<=9000){nLevel=7;}
    else if (nPrice<=12000){nLevel=8;}
    else if (nPrice<=15000){nLevel=9;}
    else if (nPrice<=19500){nLevel=10;}
    else if (nPrice<=25000){nLevel=11;}
    else if (nPrice<=30000){nLevel=12;}
    else if (nPrice<=35000){nLevel=13;}
    else if (nPrice<=40000){nLevel=14;}
    else if (nPrice<=50000){nLevel=15;}
    else if (nPrice<=65000){nLevel=16;}
    else if (nPrice<=75000){nLevel=17;}
    else if (nPrice<=90000){nLevel=18;}
    else if (nPrice<=110000){nLevel=19;}
    else if (nPrice<=130000){nLevel=20;}
    else if (nPrice<=250000){nLevel=21;}
    else if (nPrice<=500000){nLevel=22;}
    else if (nPrice<=750000){nLevel=23;}
    if (nPrice==0 || nLevel==0){
        return "  ReqLvl:?";
    }
    else{
        return "ReqLvl:"+IntToString(nLevel);;
    }
}

int GetIdentifiedGoldPieceValue( object oItem){

    int bIdentified=GetIdentified(oItem);
    if (!bIdentified) SetIdentified(oItem, TRUE);
    int nGP=GetGoldPieceValue(oItem);
    SetIdentified(oItem, bIdentified);
    return nGP;
}

//from the DMFI package
void GetNetWorth( object oTarget, object oDM){

    int n;
    int i;
    object oItem = GetFirstItemInInventory(oTarget);

    while(GetIsObjectValid(oItem) ){

        ++i;
        n       = n + GetGoldPieceValue(oItem);
        oItem   = GetNextItemInInventory(oTarget);
    }
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_ARROWS, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BELT, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BOLTS, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BOOTS, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_BULLETS, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CLOAK, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_NECK, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget) );
    n = n + GetGoldPieceValue(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oTarget) );

    SendMessageToPC( oDM, "  PC item worth: "+IntToString(n)+" GC" );
    SendMessageToPC( oDM, "  PC cash worth: "+IntToString(GetGold(oTarget) )+" GC" );
    SendMessageToPC( oDM, "  number of items: "+IntToString( i ) );

    SendMessageToPC( oDM, " ");
}

// Report PC XP Info to the DM and toggles XP Debugging on the PC
void ReportXPStatus( object oTarget, object oDM){

    // Variables
    // Effective Character Level [ECL]
    float fECL=GetLocalFloat(oTarget,"CS_XP_PENALTY_ECL");

    // Effective Character Level XP Modifier
    float fECL_XP_Modifier=GetLocalFloat(oTarget,"CS_XP_PENALTY_ECL_MODIFIER");

    // Favored Class XP Modifier
    float fFavoredClass_XP_Modifier=GetLocalFloat(oTarget,"CS_XP_PENALTY_FAVORED_CLASS");

    // Formulate the Info
    string szMessage="  ECL: "+FloatToString(fECL,4,2)+"\n  XP Modifier: "+FloatToString(fECL_XP_Modifier,4,2)+"\n  Favored Class XP Modifier: "+FloatToString(fFavoredClass_XP_Modifier,4,2);

    // Relay the XP Info
    SendMessageToPC( oDM, szMessage);

    return;

}

string item_properties( object oTarget ){

    int nNumber             = IPGetNumberOfItemProperties( oTarget );
    int i                   = 0;
    int nProperty           = 0;
    string sMessage         = "Item has "+IntToString( nNumber )+" properties:\n";
    string sProperty        = "";
    string sSubProperty     = "";
    string sSubtype         = "";
    string sCostTable       = "";
    string sPropertyValue   = "";
    itemproperty ipLoop     = GetFirstItemProperty( oTarget );

    //Loop for as long as the ipLoop variable is valid
    while ( GetIsItemPropertyValid( ipLoop ) ){

        ++i;
        nProperty       = GetItemPropertyType( ipLoop );
        sProperty       = Get2DAString( "itempropdef", "Label", nProperty );

        sSubtype        = Get2DAString( "itempropdef", "SubTypeResRef", nProperty );
        sSubProperty    = Get2DAString( GetStringLowerCase( sSubtype ), "Label", GetItemPropertySubType( ipLoop ) );
        sCostTable      = Get2DAString( "iprp_costtable", "Name", GetItemPropertyCostTable( ipLoop ) );
        sPropertyValue  = Get2DAString( GetStringLowerCase( sCostTable ), "Label", GetItemPropertyCostTableValue( ipLoop ) );

        sMessage = sMessage + "Property "+IntToString( i )+": "+sProperty;

        if ( sSubProperty != "" ){

            sMessage = sMessage + ", " + sSubProperty;
        }
        if ( sPropertyValue != "" ){

            sMessage = sMessage + ", " + sPropertyValue;
        }

        sMessage = sMessage + "\n";

        ipLoop = GetNextItemProperty( oTarget );

    }

    return sMessage;

}

void ListEffects( object oPC, object oTarget ){

    effect eLoop = GetFirstEffect( oTarget );
    string sMessage;
    object oCaster;

    while ( GetIsEffectValid( eLoop ) ){

        sMessage = "Effect: "+GetEffectTypeName( GetEffectType( eLoop ) );
        sMessage = sMessage + " (" + Get2DAString( "spells", "Label", GetEffectSpellId( eLoop ) )+")";

        oCaster = GetEffectCreator( eLoop );

        if ( GetIsObjectValid( oCaster ) ){

            sMessage = sMessage + " cast by " + GetName( oCaster );
        }

        SendMessageToPC( oPC, sMessage );

        eLoop = GetNextEffect( oTarget );
    }
}

string GetEffectTypeName( int nEffectType ){

    if ( nEffectType == EFFECT_TYPE_INVALIDEFFECT ){ return "Invalid effect"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_RESISTANCE ){ return "Damage_resistance"; }
    //if ( nEffectType == EFFECT_TYPE_ABILITY_BONUS ){ return "Ability_bonus"; }
    if ( nEffectType == EFFECT_TYPE_REGENERATE ){ return "Regenerate"; }
    //if ( nEffectType == EFFECT_TYPE_SAVING_THROW_BONUS ){ return "Saving_throw_bonus"; }
    //if ( nEffectType == EFFECT_TYPE_MODIFY_AC ){ return "Modify_ac"; }
    //if ( nEffectType == EFFECT_TYPE_ATTACK_BONUS ){ return "Attack_bonus"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_REDUCTION ){ return "Damage_reduction"; }
    //if ( nEffectType == EFFECT_TYPE_DAMAGE_BONUS ){ return "Damage_bonus"; }
    if ( nEffectType == EFFECT_TYPE_TEMPORARY_HITPOINTS ){ return "Temporary_hitpoints"; }
    //if ( nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY ){ return "Damage_immunity"; }
    if ( nEffectType == EFFECT_TYPE_ENTANGLE ){ return "Entangle"; }
    if ( nEffectType == EFFECT_TYPE_INVULNERABLE ){ return "Invulnerable"; }
    if ( nEffectType == EFFECT_TYPE_DEAF ){ return "Deaf"; }
    if ( nEffectType == EFFECT_TYPE_RESURRECTION ){ return "Resurrection"; }
    if ( nEffectType == EFFECT_TYPE_IMMUNITY ){ return "Immunity"; }
    //if ( nEffectType == EFFECT_TYPE_BLIND ){ return "Blind"; }
    if ( nEffectType == EFFECT_TYPE_ENEMY_ATTACK_BONUS ){ return "Enemy_attack_bonus"; }
    if ( nEffectType == EFFECT_TYPE_ARCANE_SPELL_FAILURE ){ return "Arcane_spell_failure"; }
    //if ( nEffectType == EFFECT_TYPE_MOVEMENT_SPEED ){ return "Movement_speed"; }
    if ( nEffectType == EFFECT_TYPE_AREA_OF_EFFECT ){ return "Area_of_effect"; }
    if ( nEffectType == EFFECT_TYPE_BEAM ){ return "Beam"; }
    //if ( nEffectType == EFFECT_TYPE_SPELL_RESISTANCE ){ return "Spell_resistance"; }
    if ( nEffectType == EFFECT_TYPE_CHARMED ){ return "Charmed"; }
    if ( nEffectType == EFFECT_TYPE_CONFUSED ){ return "Confused"; }
    if ( nEffectType == EFFECT_TYPE_FRIGHTENED ){ return "Frightened"; }
    if ( nEffectType == EFFECT_TYPE_DOMINATED ){ return "Dominated"; }
    if ( nEffectType == EFFECT_TYPE_PARALYZE ){ return "Paralyze"; }
    if ( nEffectType == EFFECT_TYPE_DAZED ){ return "Dazed"; }
    if ( nEffectType == EFFECT_TYPE_STUNNED ){ return "Stunned"; }
    if ( nEffectType == EFFECT_TYPE_SLEEP ){ return "Sleep"; }
    if ( nEffectType == EFFECT_TYPE_POISON ){ return "Poison"; }
    if ( nEffectType == EFFECT_TYPE_DISEASE ){ return "Disease"; }
    if ( nEffectType == EFFECT_TYPE_CURSE ){ return "Curse"; }
    if ( nEffectType == EFFECT_TYPE_SILENCE ){ return "Silence"; }
    if ( nEffectType == EFFECT_TYPE_TURNED ){ return "Turned"; }
    if ( nEffectType == EFFECT_TYPE_HASTE ){ return "Haste"; }
    if ( nEffectType == EFFECT_TYPE_SLOW ){ return "Slow"; }
    if ( nEffectType == EFFECT_TYPE_ABILITY_INCREASE ){ return "Ability_increase"; }
    if ( nEffectType == EFFECT_TYPE_ABILITY_DECREASE ){ return "Ability_decrease"; }
    if ( nEffectType == EFFECT_TYPE_ATTACK_INCREASE ){ return "Attack_increase"; }
    if ( nEffectType == EFFECT_TYPE_ATTACK_DECREASE ){ return "Attack_decrease"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_INCREASE ){ return "Damage_increase"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_DECREASE ){ return "Damage_decrease"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ){ return "Damage_immunity_increase"; }
    if ( nEffectType == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ){ return "Damage_immunity_decrease"; }
    if ( nEffectType == EFFECT_TYPE_AC_INCREASE ){ return "Ac_increase"; }
    if ( nEffectType == EFFECT_TYPE_AC_DECREASE ){ return "Ac_decrease"; }
    if ( nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ){ return "Movement_speed_increase"; }
    if ( nEffectType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ){ return "Movement_speed_decrease"; }
    if ( nEffectType == EFFECT_TYPE_SAVING_THROW_INCREASE ){ return "Saving_throw_increase"; }
    if ( nEffectType == EFFECT_TYPE_SAVING_THROW_DECREASE ){ return "Saving_throw_decrease"; }
    if ( nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ){ return "Spell_resistance_increase"; }
    if ( nEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ){ return "Spell_resistance_decrease"; }
    if ( nEffectType == EFFECT_TYPE_SKILL_INCREASE ){ return "Skill_increase"; }
    if ( nEffectType == EFFECT_TYPE_SKILL_DECREASE ){ return "Skill_decrease"; }
    if ( nEffectType == EFFECT_TYPE_INVISIBILITY ){ return "Invisibility"; }
    if ( nEffectType == EFFECT_TYPE_IMPROVEDINVISIBILITY ){ return "Improvedinvisibility"; }
    if ( nEffectType == EFFECT_TYPE_DARKNESS ){ return "Darkness"; }
    if ( nEffectType == EFFECT_TYPE_DISPELMAGICALL ){ return "Dispelmagicall"; }
    if ( nEffectType == EFFECT_TYPE_ELEMENTALSHIELD ){ return "Elementalshield"; }
    if ( nEffectType == EFFECT_TYPE_NEGATIVELEVEL ){ return "Negativelevel"; }
    if ( nEffectType == EFFECT_TYPE_POLYMORPH ){ return "Polymorph"; }
    if ( nEffectType == EFFECT_TYPE_SANCTUARY ){ return "Sanctuary"; }
    if ( nEffectType == EFFECT_TYPE_TRUESEEING ){ return "Trueseeing"; }
    if ( nEffectType == EFFECT_TYPE_SEEINVISIBLE ){ return "Seeinvisible"; }
    if ( nEffectType == EFFECT_TYPE_TIMESTOP ){ return "Timestop"; }
    if ( nEffectType == EFFECT_TYPE_BLINDNESS ){ return "Blindness"; }
    if ( nEffectType == EFFECT_TYPE_SPELLLEVELABSORPTION ){ return "Spelllevelabsorption"; }
    if ( nEffectType == EFFECT_TYPE_DISPELMAGICBEST ){ return "Dispelmagicbest"; }
    if ( nEffectType == EFFECT_TYPE_ULTRAVISION ){ return "Ultravision"; }
    if ( nEffectType == EFFECT_TYPE_MISS_CHANCE ){ return "Miss_chance"; }
    if ( nEffectType == EFFECT_TYPE_CONCEALMENT ){ return "Concealment"; }
    if ( nEffectType == EFFECT_TYPE_SPELL_IMMUNITY ){ return "Spell_immunity"; }
    if ( nEffectType == EFFECT_TYPE_VISUALEFFECT ){ return "Visualeffect"; }
    if ( nEffectType == EFFECT_TYPE_DISAPPEARAPPEAR ){ return "Disappearappear"; }
    if ( nEffectType == EFFECT_TYPE_SWARM ){ return "Swarm"; }
    if ( nEffectType == EFFECT_TYPE_TURN_RESISTANCE_DECREASE ){ return "Turn_resistance_decrease"; }
    if ( nEffectType == EFFECT_TYPE_TURN_RESISTANCE_INCREASE ){ return "Turn_resistance_increase"; }
    if ( nEffectType == EFFECT_TYPE_PETRIFY ){ return "Petrify"; }
    if ( nEffectType == EFFECT_TYPE_CUTSCENE_PARALYZE ){ return "Cutscene_paralyze"; }
    if ( nEffectType == EFFECT_TYPE_ETHEREAL ){ return "Ethereal"; }
    if ( nEffectType == EFFECT_TYPE_SPELL_FAILURE ){ return "Spell_failure"; }
    if ( nEffectType == EFFECT_TYPE_CUTSCENEGHOST ){ return "Cutsceneghost"; }
    if ( nEffectType == EFFECT_TYPE_CUTSCENEIMMOBILIZE ){ return "Cutsceneimmobilize"; }

    return "";
}


