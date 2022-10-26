//void main(){}
//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_td_appearanc
//description: holds appearance manipulation functions
//used as: library
//date:    091608
//author:  Terra

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// Saves oAppearanceToSaves's appearance to oItem
void SaveADVAppearanceToItem( object oAppearanceToSave, object oItem, string sAppearancePrefix,int iIgnoreName = 0 );
// Gets a saved appearance from oItem
void SetADVAppearanceFromItem( object oTarget, object oItem, string sAppearancePrefix, int iIgnoreName = 0 );
// Deletes all appearance variables from oItem with sAppearancePrefix
void DeleteADVAppearanceFromItem( object oItem, string sAppearancePrefix );
// Basic appearance, tail, name, portait and apperance
void SaveBasicAppearance( object oAppearanceToSave, string sAppearancePrefix, object oItem, int iIgnoreName = 0);
// Basic appearance, tail, name, portait and apperance
void SetBasicAppearance( object oTarget, string sAppearancePrefix, object oItem, int iIgnoreName = 0);
// Applies appearance to a summon. Returns 0 if not successful.
// type 1 = summons
// type 2 = companion
// type 3 = familar
int CustomSummonAppearance( object oPC , int iType, object oItem);
//Returns the appropriate eye VFX glow for oTarget
//Depending on sColor
//sColor can be:
//"cyan"
//"green"
//"orange"
//"purple"
//"red"
//"white"
//"yellow"
//"negred" ((Humans Only))
//sColor is automaticly turned to lowercase
int GetEyeVFX( object oTarget, string sColor );

//Private function
void SetSkinBits(object oTarget, string sAppearancePrefix, object oItem);
//Private function
void SetColorBits(object oTarget, string sAppearancePrefix, object oItem);

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
void SaveADVAppearanceToItem( object oAppearanceToSave, object oItem, string sAppearancePrefix,int iIgnoreName = 0 )
{
    int nPart = 0;
    int iLoop = 0;

    SetLocalInt( oItem, sAppearancePrefix+"_app", GetAppearanceType( oAppearanceToSave ) );

        do
        {
        nPart = GetCreatureBodyPart( iLoop, oAppearanceToSave );

            if ( nPart > 0 )
            {
            SetLocalInt( oItem, sAppearancePrefix+"_p_"+IntToString( iLoop ), nPart );
            }

        iLoop++;
        }while( iLoop < 21 );

        //Color
        SetLocalInt( oItem, sAppearancePrefix+"_c_skin", GetColor( oAppearanceToSave, COLOR_CHANNEL_SKIN ) );
        SetLocalInt( oItem, sAppearancePrefix+"_c_hair", GetColor( oAppearanceToSave, COLOR_CHANNEL_HAIR ) );
        SetLocalInt( oItem, sAppearancePrefix+"_c_tat1", GetColor( oAppearanceToSave, COLOR_CHANNEL_TATTOO_1 ) );
        SetLocalInt( oItem, sAppearancePrefix+"_c_tat2", GetColor( oAppearanceToSave, COLOR_CHANNEL_TATTOO_2 ) );

        //Wings
        SetLocalInt( oItem, sAppearancePrefix+"_wing", GetCreatureWingType( oAppearanceToSave ) );
        SetLocalInt( oItem, sAppearancePrefix+"_tail", GetCreatureTailType( oAppearanceToSave ) );

        //Bio
        SetLocalString( oItem, sAppearancePrefix+"_bio",  GetDescription( oAppearanceToSave ) );
        SetLocalString( oItem, sAppearancePrefix+"_port", GetPortraitResRef( oAppearanceToSave ) );
        if(!iIgnoreName)SetLocalString( oItem, sAppearancePrefix+"_name", GetName( oAppearanceToSave ) );

        SetLocalString(oItem, sAppearancePrefix+"_d", GetName(GetItemPossessor(oItem)));
        SetLocalInt(oItem, sAppearancePrefix+"_adv", 1);

}
//-----------------------------------------------------------------------------
void SetADVAppearanceFromItem( object oTarget, object oItem, string sAppearancePrefix, int iIgnoreName = 0 )
{
    SendMessageToPC( GetItemPossessor(oItem), "Loading appearance to "+GetName(oTarget));

    int nPart = GetLocalInt(oItem, sAppearancePrefix+"_app");
    SetCreatureAppearanceType( oTarget , nPart );

    SetPortraitResRef( oTarget, GetLocalString(oItem, sAppearancePrefix+"_port") );

    DelayCommand(1.0,SetCreatureTailType( GetLocalInt(oItem, sAppearancePrefix+"_tail" ) , oTarget ));
    DelayCommand(1.0,SetCreatureWingType( GetLocalInt(oItem, sAppearancePrefix+"_wing" ), oTarget ));
    DelayCommand(2.0,SetSkinBits( oTarget,sAppearancePrefix,oItem ));
    DelayCommand(3.0,SetColorBits( oTarget, sAppearancePrefix,oItem));
    DelayCommand(3.0,SendMessageToPC( GetItemPossessor(oItem), "Done loading appearance"));

    if( GetLocalInt(oItem, "summon_vfx" ) != 0 ) {
        DelayCommand(1.0,ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( GetLocalInt(oItem, "summon_vfx" ) ) ), oTarget ));
    }
    if( GetLocalInt(oItem, "summon_vfx2" ) != 0 ) {
        DelayCommand(1.0,ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( GetLocalInt(oItem, "summon_vfx2" ) ) ), oTarget ));
    }
    if( GetLocalInt(oItem, "summon_vfx3" ) != 0 ) {
        DelayCommand(1.0,ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( GetLocalInt(oItem, "summon_vfx3" ) ) ), oTarget ));
    }

    if(!GetIsPC(oTarget)){
    SetDescription( oTarget, GetLocalString(oItem, sAppearancePrefix+"_bio") );
    if(!iIgnoreName)SetName( oTarget, GetLocalString(oItem, sAppearancePrefix+"_name") );
    }
    return;

}
//-----------------------------------------------------------------------------
void SaveBasicAppearance( object oAppearanceToSave, string sAppearancePrefix, object oItem, int iIgnoreName = 0)
{

    SetLocalInt(oItem, sAppearancePrefix+"_a", GetAppearanceType(oAppearanceToSave));
    SetLocalInt(oItem, sAppearancePrefix+"_p", GetPortraitId(oAppearanceToSave));
    SetLocalInt(oItem, sAppearancePrefix+"_t", GetCreatureTailType(oAppearanceToSave));

    if(!iIgnoreName)SetLocalString(oItem, sAppearancePrefix+"_n", GetName(oAppearanceToSave));
    SetLocalString(oItem, sAppearancePrefix+"_d", GetName(GetItemPossessor(oItem)));
    SetLocalInt(oItem, sAppearancePrefix+"_adv", 0);

}
//-----------------------------------------------------------------------------
void SetBasicAppearance( object oTarget, string sAppearancePrefix, object oItem, int iIgnoreName = 0)
{
    SendMessageToPC( GetItemPossessor(oItem), "Loading appearance to "+GetName(oTarget));
        int nPart = GetLocalInt(oItem, sAppearancePrefix+"_a");
        SetCreatureAppearanceType( oTarget , nPart );
        SetPortraitId( oTarget, GetLocalInt( oItem, sAppearancePrefix+"_p" ) ) ;

        if(!iIgnoreName)SetName( oTarget, GetLocalString( oItem, sAppearancePrefix+"_n" ) );

        DelayCommand( 2.0, SetCreatureTailType( GetLocalInt( oItem, sAppearancePrefix+"_t" ), oTarget ) );
    DelayCommand(3.0,SendMessageToPC( GetItemPossessor(oItem), "Done loading appearance"));
}
//-----------------------------------------------------------------------------
void SetSkinBits(object oTarget, string sAppearancePrefix, object oItem)
{
    int iLoop = 0;
    int nPart = 0;
    do
    {
    nPart = GetLocalInt( oItem, sAppearancePrefix+"_p_"+IntToString( iLoop ) );

        if ( nPart > 0 && nPart != GetCreatureBodyPart( iLoop, oTarget ) )
        {
        SetCreatureBodyPart( iLoop, nPart, oTarget );
        }

    iLoop++;
    }while( iLoop < 21 );
}

void SetColorBits(object oTarget, string sAppearancePrefix, object oItem)
{
    int nPart = GetLocalInt(oItem, sAppearancePrefix+"_c_skin");
    if(nPart > -1 && nPart < 176 )SetColor(oTarget, COLOR_CHANNEL_SKIN, nPart);

    nPart = GetLocalInt(oItem, sAppearancePrefix+"_c_hair");
    if(nPart > -1 && nPart < 176 )SetColor(oTarget, COLOR_CHANNEL_HAIR, nPart);

    nPart = GetLocalInt(oItem, sAppearancePrefix+"_c_tat1");
    if(nPart > -1 && nPart < 176 )SetColor(oTarget, COLOR_CHANNEL_TATTOO_1, nPart);

    nPart = GetLocalInt(oItem, sAppearancePrefix+"_c_tat2");
    if(nPart > -1 && nPart < 176 )SetColor(oTarget, COLOR_CHANNEL_TATTOO_2, nPart);
}
//-----------------------------------------------------------------------------
int CustomSummonAppearance( object oPC , int iType, object oItem ){

    object oSummon;
    string szSummonResRef;
    int    iIgnoreName = 0;

        if( iType == 1 )
        {
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC );
        szSummonResRef = GetResRef(oSummon);
        }
        else if( iType == 2 )
        {
        oSummon = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC );
        szSummonResRef = "companion";
        iIgnoreName = 1;
        }
        else if( iType == 3 )
        {
        oSummon = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC );
        szSummonResRef = "familiar";
        iIgnoreName = 1;
        }

        if ( oSummon == OBJECT_INVALID  ){

        SendMessageToPC( oPC, "No summon found!" );
        return 0;
        }


        /*SendMessageToPC( oPC, GetName(oSummon)  );
        SendMessageToPC( oPC, GetName(oItem)  );
        SendMessageToPC( oPC, GetLocalString( oItem, szSummonResRef+"_d" ));
        SendMessageToPC( oPC, "ADV: "+IntToString(GetLocalInt( oItem, szSummonResRef+"_adv")));*/

    if( GetLocalString( oItem, szSummonResRef+"_d" ) == "" )return 0;

    int iChangerVersion = GetLocalInt( oItem, szSummonResRef+"_adv");

    //old version
    if( iChangerVersion <= 0 ){
    SetBasicAppearance( oSummon, szSummonResRef, oItem, iIgnoreName);
    return 1;
    }
    //advanced
    else if( iChangerVersion == 1 ){
    SetADVAppearanceFromItem( oSummon, oItem, szSummonResRef, iIgnoreName );
    return 1;
    }
    else return 1;

}
//-----------------------------------------------------------------------------
int GetEyeVFX( object oTarget, string sColor )
{

int iAppearance = GetAppearanceType( oTarget );
int iGender     = GetGender( oTarget );

int iReturn     = 0;

    sColor = GetStringLowerCase(sColor);

    if( iGender == GENDER_FEMALE )
    {
        switch( iAppearance )
        {
        case 0:
            if( sColor == "cyan" )return VFX_EYES_CYN_DWARF_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_DWARF_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_DWARF_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_DWARF_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_DWARF_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_DWARF_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_DWARF_FEMALE;
            else if( sColor == "blue" )return 327;
            else return -1;
        break;

        case 1:
            if( sColor == "cyan" )return VFX_EYES_CYN_ELF_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_ELF_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_ELF_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_ELF_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_ELF_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_ELF_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_ELF_FEMALE;
            else if( sColor == "blue" )return 329;
            else return -1;
        break;

        case 2:
            if( sColor == "cyan" )return VFX_EYES_CYN_GNOME_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_GNOME_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_GNOME_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_GNOME_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_GNOME_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_GNOME_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_GNOME_FEMALE;
            else if( sColor == "blue" )return 331;
            else return -1;
        break;

        case 3:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFLING_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFLING_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFLING_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFLING_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFLING_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFLING_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFLING_FEMALE;
            else if( sColor == "blue" )return 333;
            else return -1;
        break;

        case 4:
            if( sColor == "cyan" )return VFX_EYES_CYN_HUMAN_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HUMAN_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HUMAN_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HUMAN_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HUMAN_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HUMAN_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HUMAN_FEMALE;
            else if( sColor == "blue" )return 325;
            else if( sColor == "negred" )return 738;
            else return -1;
        break;

        case 5:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFORC_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFORC_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFORC_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFORC_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFORC_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFORC_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFORC_FEMALE;
            else if( sColor == "blue" )return 335;
            else return -1;
        break;

        case 6:
            if( sColor == "cyan" )return VFX_EYES_CYN_HUMAN_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HUMAN_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HUMAN_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HUMAN_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HUMAN_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HUMAN_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HUMAN_FEMALE;
            else if( sColor == "blue" )return 325;
            else if( sColor == "negred" )return 738;
            else return -1;
        break;
        default: return -1;
        }
    return -1;
    }
    else
    {
        switch( iAppearance )
        {
        case 0:
            if( sColor == "cyan" )return VFX_EYES_CYN_DWARF_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_DWARF_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_DWARF_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_DWARF_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_DWARF_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_DWARF_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_DWARF_MALE;
            else if( sColor == "blue" )return 326;
            else return -1;
        break;

        case 1:
            if( sColor == "cyan" )return VFX_EYES_CYN_ELF_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_ELF_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_ELF_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_ELF_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_ELF_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_ELF_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_ELF_MALE;
            else if( sColor == "blue" )return 328;
            else return -1;
        break;

        case 2:
            if( sColor == "cyan" )return VFX_EYES_CYN_GNOME_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_GNOME_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_GNOME_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_GNOME_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_GNOME_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_GNOME_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_GNOME_MALE;
            else if( sColor == "blue" )return 330;
            else return -1;
        break;

        case 3:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFLING_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFLING_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFLING_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFLING_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFLING_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFLING_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFLING_MALE;
            else if( sColor == "blue" )return 332;
            else return -1;
        break;

        case 4:
            if( sColor == "cyan" )return VFX_EYES_CYN_HUMAN_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HUMAN_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HUMAN_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HUMAN_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HUMAN_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HUMAN_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HUMAN_MALE;
            else if( sColor == "blue" )return 324;
            else if( sColor == "negred" )return 738;
            else return -1;
        break;

        case 5:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFORC_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFORC_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFORC_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFORC_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFORC_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFORC_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFORC_MALE;
            else if( sColor == "blue" )return 334;
            else return -1;
        break;

        case 6:
            if( sColor == "cyan" )return VFX_EYES_CYN_HUMAN_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HUMAN_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HUMAN_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HUMAN_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HUMAN_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HUMAN_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HUMAN_MALE;
            else if( sColor == "blue" )return 324;
            else if( sColor == "negred" )return 738;
            else return -1;
        break;
        default: return -1;
        }
    return -1;
    }
return -1;
}

//-----------------------------------------------------------------------------
int GetHornVFX( object oTarget, string sColor )
{

int iAppearance = GetAppearanceType( oTarget );
int iGender     = GetGender( oTarget );

int iReturn     = 0;

    sColor = GetStringLowerCase(sColor);

    if( iGender == GENDER_FEMALE )
    {
        switch( iAppearance )
        {
        case 0:
            if( sColor == "meph" )return 858;
            else if( sColor == "ox" )return 859;
            else if( sColor == "rothe" )return 860;
            else if( sColor == "balor" )return 861;
            else if( sColor == "antlers" )return 862;
            else if( sColor == "drag" )return 863;
            else if( sColor == "ram" )return 864;
            else return -1;
        break;

        case 1:
            if( sColor == "meph" )return 802;
            else if( sColor == "ox" )return 803;
            else if( sColor == "rothe" )return 804;
            else if( sColor == "balor" )return 805;
            else if( sColor == "antlers" )return 806;
            else if( sColor == "drag" )return 807;
            else if( sColor == "ram" )return 808;
            else return -1;
        break;

        case 2:
            if( sColor == "cyan" )return VFX_EYES_CYN_GNOME_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_GNOME_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_GNOME_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_GNOME_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_GNOME_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_GNOME_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_GNOME_FEMALE;
            else if( sColor == "blue" )return 331;
            else return -1;
        break;

        case 3:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFLING_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFLING_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFLING_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFLING_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFLING_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFLING_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFLING_FEMALE;
            else if( sColor == "blue" )return 333;
            else return -1;
        break;

        case 4:
            if( sColor == "meph" )return 745;
            else if( sColor == "ox" )return 746;
            else if( sColor == "rothe" )return 747;
            else if( sColor == "balor" )return 748;
            else if( sColor == "antlers" )return 749;
            else if( sColor == "drag" )return 750;
            else if( sColor == "ram" )return 751;
            else return -1;
        break;

        case 5:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFORC_FEMALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFORC_FEMALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFORC_FEMALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFORC_FEMALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFORC_FEMALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFORC_FEMALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFORC_FEMALE;
            else if( sColor == "blue" )return 335;
            else return -1;
        break;

        case 6:
            if( sColor == "meph" )return 745;
            else if( sColor == "ox" )return 746;
            else if( sColor == "rothe" )return 747;
            else if( sColor == "balor" )return 748;
            else if( sColor == "antlers" )return 749;
            else if( sColor == "drag" )return 750;
            else if( sColor == "ram" )return 751;
            else return -1;
        break;
        default: return -1;
        }
    return -1;
    }
    else
    {
        switch( iAppearance )
        {
        case 0:
            if( sColor == "meph" )return 830;
            else if( sColor == "ox" )return 831;
            else if( sColor == "rothe" )return 832;
            else if( sColor == "balor" )return 833;
            else if( sColor == "antlers" )return 834;
            else if( sColor == "drag" )return 835;
            else if( sColor == "ram" )return 836;
            else return -1;
        break;

        case 1:
            if( sColor == "meph" )return 773;
            else if( sColor == "ox" )return 774;
            else if( sColor == "rothe" )return 775;
            else if( sColor == "balor" )return 776;
            else if( sColor == "antlers" )return 777;
            else if( sColor == "drag" )return 778;
            else if( sColor == "ram" )return 779;
            else return -1;
        break;

        case 2:
            if( sColor == "cyan" )return VFX_EYES_CYN_GNOME_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_GNOME_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_GNOME_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_GNOME_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_GNOME_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_GNOME_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_GNOME_MALE;
            else if( sColor == "blue" )return 330;
            else return -1;
        break;

        case 3:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFLING_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFLING_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFLING_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFLING_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFLING_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFLING_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFLING_MALE;
            else if( sColor == "blue" )return 332;
            else return -1;
        break;

        case 4:
            if( sColor == "meph" )return 717;
            else if( sColor == "ox" )return 718;
            else if( sColor == "rothe" )return 719;
            else if( sColor == "balor" )return 720;
            else if( sColor == "antlers" )return 721;
            else if( sColor == "drag" )return 722;
            else if( sColor == "ram" )return 723;
            else return -1;
        break;

        case 5:
            if( sColor == "cyan" )return VFX_EYES_CYN_HALFORC_MALE;
            else if( sColor == "green" )return VFX_EYES_GREEN_HALFORC_MALE;
            else if( sColor == "orange" )return VFX_EYES_ORG_HALFORC_MALE;
            else if( sColor == "purple" )return VFX_EYES_PUR_HALFORC_MALE;
            else if( sColor == "red" )return VFX_EYES_RED_FLAME_HALFORC_MALE;
            else if( sColor == "white" )return VFX_EYES_WHT_HALFORC_MALE;
            else if( sColor == "yellow" )return VFX_EYES_YEL_HALFORC_MALE;
            else if( sColor == "blue" )return 334;
            else return -1;
        break;

        case 6:
            if( sColor == "meph" )return 717;
            else if( sColor == "ox" )return 718;
            else if( sColor == "rothe" )return 719;
            else if( sColor == "balor" )return 720;
            else if( sColor == "antlers" )return 721;
            else if( sColor == "drag" )return 722;
            else if( sColor == "ram" )return 723;
            else return -1;
        break;
        default: return -1;
        }
    return -1;
    }
return -1;
}

