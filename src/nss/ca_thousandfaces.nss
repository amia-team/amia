//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ca_thousandfaces
//description: used as action script in the thousandfaces convo
//used as: conversation action script
//date:    081706
//author:  Terra

//-----------------------------------------------------------------------------
// Includes
//-----------------------------------------------------------------------------
#include "inc_ds_actions"

//-----------------------------------------------------------------------------
// Prototype
//-----------------------------------------------------------------------------

//Changes the shape of a PC making sure weapon/size can't be exploited.
//If nHead = -1 it'll ignore the head otherwise it'll change that aswell.
//if nSkin = -1 it would change skin either
void SkinChangePC( object oPC , int nSkin , int nHead = -1, int nHairC = -1, int nSkinC = -1, int nTail = 0 );

const string PUR = "<cþ þ>";

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
    object  oPC                 = OBJECT_SELF;
    object  oItem               = GetLocalObject( oPC , "1kfaces" );
    int     iNode               = GetLocalInt( oPC , "ds_node" );
    int     iOriginalHead       = GetLocalInt( oItem , "cs_original_head" );
    int     iOriginalAppearance = GetLocalInt( oItem, "cs_original_appearance" );
    int     iOriginalTail       = GetLocalInt( oItem, "cs_original_tail" );
    int     iCurrentHead        = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
    int     iCurrentAppearance  = GetAppearanceType( oPC );
    int     iNewHead            = GetLocalInt( oItem, "td_1kfhead" );
    int     iNewAppearance      = 1;
    int     iSkinC              = -1;
    int     iHairC              = -1;
    int     iTail               = 0;

    if( GetLocalInt( oPC, "1kf_head_sel" ) )
    {
        switch( iNode )
        {
            case 1:
                if( GetGender( oPC ) == GENDER_MALE )
                    SetLocalInt( oItem, "td_1kfhead", 1 );
                else if ( GetGender( oPC ) == GENDER_FEMALE )
                    SetLocalInt( oItem, "td_1kfhead", 1 );
                else
                    SendMessageToPC( oPC, "Error: Your form has no gender!" );
            break;

            case 2:
                if( GetGender( oPC ) == GENDER_MALE )
                    SetLocalInt( oItem, "td_1kfhead", 13 );
                else if ( GetGender( oPC ) == GENDER_FEMALE )
                    SetLocalInt( oItem, "td_1kfhead", 5 );
                else
                    SendMessageToPC( oPC, "Error: Your form has no gender!" );
            break;

            case 3:
                if( GetGender( oPC ) == GENDER_MALE )
                    SetLocalInt( oItem, "td_1kfhead", 16 );
                else if ( GetGender( oPC ) == GENDER_FEMALE )
                    SetLocalInt( oItem, "td_1kfhead", 13 );
                else
                    SendMessageToPC( oPC, "Error: Your form has no gender!" );
            break;

            case 4:
                if( GetGender( oPC ) == GENDER_MALE )
                    SetLocalInt( oItem, "td_1kfhead", 20 );
                else if ( GetGender( oPC ) == GENDER_FEMALE )
                    SetLocalInt( oItem, "td_1kfhead", 15 );
                else
                    SendMessageToPC( oPC, "Error: Your form has no gender!" );
            break;

            case 5:
                if( GetGender( oPC ) == GENDER_MALE )
                    SetLocalInt( oItem, "td_1kfhead", 29 );
                else if ( GetGender( oPC ) == GENDER_FEMALE )
                    SetLocalInt( oItem, "td_1kfhead", 25 );
                else
                    SendMessageToPC( oPC, "Error: Your form has no gender!" );
            break;

            default:
            SetLocalInt( oItem, "td_1kfhead", 1 );
            break;
        }

        if( iNode == 6 ){

            SetLocalInt( oPC, "1kf_head_sel", 0 );
            return;
        }

        SendMessageToPC( oPC, PUR+"Head Set: "+IntToString( iNode ) );
        SetLocalInt( oPC, "1kf_head_sel", 0 );
        return;
    }

    //DEBUG
    //SendMessageToPC(oPC, "Used by: "+GetName( oPC ) );
    //SendMessageToPC(oPC, "Storage item: "+GetName( oItem ) );
    //SendMessageToPC(oPC, "Stored head: "+IntToString( iOriginalHead ) );
    //SendMessageToPC(oPC, "Stored Appearance: "+IntToString( iOriginalAppearance ) );
    //SendMessageToPC(oPC, "Current head: "+IntToString( iCurrentHead ) );
    //SendMessageToPC(oPC, "Current Appearance: "+IntToString( iCurrentAppearance ) );
    //-----

    switch( iNode )
    {
    case 1:
    iNewAppearance = APPEARANCE_TYPE_CHICKEN;
    iNewHead = -1;
    break;

    case 2:
    iNewAppearance = APPEARANCE_TYPE_DEER;
    iNewHead = -1;
    break;

    case 3:
    iNewAppearance = APPEARANCE_TYPE_DOG;
    iNewHead = -1;
    break;

    case 4: // Slicer beetle
    iNewAppearance = 896;
    iNewHead = -1;
    break;

    case 5:
    iNewAppearance = APPEARANCE_TYPE_CAT_JAGUAR;
    iNewHead = -1;
    break;

    case 6:
    iNewAppearance = APPEARANCE_TYPE_CAT_LION;
    iNewHead = -1;
    break;

    case 7:
    iNewAppearance = APPEARANCE_TYPE_PARROT;
    iNewHead = -1;
    break;

    case 8:
    iNewAppearance = APPEARANCE_TYPE_BEAR_POLAR;
    iNewHead = -1;
    break;

    case 9:
    iNewAppearance = APPEARANCE_TYPE_RAT;
    iNewHead = -1;
    break;

    case 10:
    iNewAppearance = APPEARANCE_TYPE_RAVEN;
    iNewHead = -1;
    break;

    case 11:
    iNewAppearance = APPEARANCE_TYPE_BEETLE_STINK;
    iNewHead = -1;
    break;

    case 12:
    iNewAppearance = APPEARANCE_TYPE_SPIDER_SWORD;
    iNewHead = -1;
    break;

    case 13:
    iNewAppearance = APPEARANCE_TYPE_DWARF;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 14:
    iNewAppearance = APPEARANCE_TYPE_ELF;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 15:
    iNewAppearance = APPEARANCE_TYPE_GNOME;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 16:
    iNewAppearance = APPEARANCE_TYPE_HALF_ELF;
        iSkinC = 1;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 17:
    iNewAppearance = APPEARANCE_TYPE_HALF_ORC;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 18:
    iNewAppearance = APPEARANCE_TYPE_HALFLING;
        iSkinC = 1;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = Random( 14+1 );
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 19:
    iNewAppearance = APPEARANCE_TYPE_BARTENDER;
    iNewHead = -1;
    break;

    case 20:
    iNewAppearance = APPEARANCE_TYPE_BEGGER;
    iNewHead = -1;
    break;

    case 21:
    iNewAppearance = 479; // Drow Female
    iNewHead = -1;
    break;

    case 22:
    iNewAppearance = 477; // Drow Male
    iNewHead = -1;
    break;

    case 23:
    iNewAppearance = APPEARANCE_TYPE_HOUSE_GUARD;
    iNewHead = -1;
    break;

    case 24:
    iNewAppearance = APPEARANCE_TYPE_INN_KEEPER;
    iNewHead = -1;
    break;

    case 25:
    iNewAppearance = APPEARANCE_TYPE_KID_FEMALE;
    iNewHead = -1;
    break;

    case 26:
    iNewAppearance = APPEARANCE_TYPE_KID_MALE;
    iNewHead = -1;
    break;

    case 27:
    iNewAppearance = APPEARANCE_TYPE_OLD_MAN;
    iNewHead = -1;
    break;

    case 28:
    iNewAppearance = APPEARANCE_TYPE_OLD_WOMAN;
    iNewHead = -1;
    break;

    case 29:
    iNewAppearance = APPEARANCE_TYPE_SHOP_KEEPER;
    iNewHead = -1;
    break;

    case 30:
    iNewAppearance  = iOriginalAppearance;
    iNewHead        = iOriginalHead;
    iTail           = iOriginalTail;
    iHairC          = GetLocalInt( oItem, "td_orginal_haircolor" );
    iSkinC          = GetLocalInt( oItem, "td_orginal_skincolor" );
    break;

    case 31:
    iNewAppearance = APPEARANCE_TYPE_DWARF;
        iSkinC = 43;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC= 166;
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
    iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 32:
    iNewAppearance = APPEARANCE_TYPE_ELF;
        iSkinC = 43;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC= 166;
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
    iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 33:
    iNewAppearance = APPEARANCE_TYPE_GNOME;
        iSkinC = 43;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC= 166;
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
    iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 34:
    iNewAppearance = APPEARANCE_TYPE_HALF_ORC;
        iSkinC = 43;
        if( GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair" ) == 0 ){
            iHairC = 166;
            SendMessageToPC( oPC, PUR+"Saving: "+IntToString( iHairC )+" to appearance: "+IntToString( iNewAppearance ) + "\nSee a hair dyer if you wish to change the color. Setting the hair color to 0 will cause this to happen again." );
            SetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair", iHairC );
        }
        iHairC = GetLocalInt( oItem, "td_1kf_"+IntToString( iNewAppearance )+"_"+IntToString( iSkinC )+"_hair");
    break;

    case 35:
    iNewHead = -1;
        switch( d2() ){
        case 1:iNewAppearance = APPEARANCE_TYPE_PROSTITUTE_01;break;
        case 2:iNewAppearance = APPEARANCE_TYPE_PROSTITUTE_02;break;
        }
    break;

    case 36:
    iNewHead = -1;

    if( iCurrentAppearance == APPEARANCE_TYPE_SEAGULL_FLYING || iCurrentAppearance == APPEARANCE_TYPE_SEAGULL_WALKING ){

        if( iCurrentAppearance == APPEARANCE_TYPE_SEAGULL_FLYING )
            iNewAppearance = APPEARANCE_TYPE_SEAGULL_WALKING;
        else
            iNewAppearance = APPEARANCE_TYPE_SEAGULL_FLYING;
    }
    else{

        switch( d2() ){
        case 1:iNewAppearance = APPEARANCE_TYPE_SEAGULL_FLYING;break;
        case 2:iNewAppearance = APPEARANCE_TYPE_SEAGULL_WALKING;break;
        }
    }

    break;

    case 37: // Bat
    iNewAppearance = 10;
    iNewHead = -1;
    break;

    case 38: // Black Bear
    iNewAppearance = 12;
    iNewHead = -1;
    break;

    case 39: // Boar
    iNewAppearance = 21;
    iNewHead = -1;
    break;

    case 40: // Cow
    iNewAppearance = 34;
    iNewHead = -1;
    break;

    case 41: // Frog
    iNewAppearance = 830;
    iNewHead = -1;
    iTail = 630;
    break;

    case 42: // Hawk
    iNewAppearance = 144;
    iNewHead = -1;
    break;

    case 43: // Pig
    iNewAppearance = 873;
    iNewHead = -1;
    break;

    case 44: // Rabbit
    iNewAppearance = 833;
    iNewHead = -1;
    iTail = 574;
    break;

    case 45: // Sheep
    iNewAppearance = 871;
    iNewHead = -1;
    break;

    case 46: // Wolf
    iNewAppearance = 181;
    iNewHead = -1;
    break;

    case 47: // Cougar
    iNewAppearance = 203;
    iNewHead = -1;
    break;

    case 48: // Funnelweb Spider
    iNewAppearance = 830;
    iNewHead = -1;
    iTail = 564;
    break;

    case 49: // Leech
    iNewAppearance = 830;
    iNewHead = -1;
    iTail = 502;
    break;

    case 50: // Snow Leopard
    iNewAppearance = 94;
    iNewHead = -1;
    break;

    case 51:// Ant
    iNewAppearance = 829;
    iNewHead = -1;
    iTail = 535;
    break;

    case 52: // White Wolf
    iNewAppearance = 184;
    iNewHead = -1;
    break;

    case 53: // Penguin
    iNewAppearance = APPEARANCE_TYPE_PENGUIN;
    iNewHead = -1;
    break;

    case 54: // Badger
    iNewAppearance = APPEARANCE_TYPE_BADGER;
    iNewHead = -1;
    break;

    //Head selectnode
    case 55:
        SetLocalInt( oPC, "1kf_head_sel", 1 );
        return;
    break;

    }
    //Block applying a aleady existing head.
    if( iCurrentHead == iNewHead )iNewHead = -1;
    //Block applying appearance if the appearance is alreay want we want
    if( iCurrentAppearance == iNewAppearance )iNewAppearance = -1;

    //DEBUG
    if(iNewHead == -1)
    SendMessageToPC(oPC, PUR+"Selected Head: no head change" );
    else
    SendMessageToPC(oPC, PUR+"Selected Head: "+IntToString( iNewHead ) );

    if(iNewAppearance == -1)
    SendMessageToPC(oPC, PUR+"Selected Appearance: no Appearance change" );
    else
    SendMessageToPC(oPC, PUR+"Selected Appearance: "+IntToString( iNewAppearance ) );

    if(iHairC == -1)
    SendMessageToPC(oPC, PUR+"Selected Hair Color: no change" );
    else
    SendMessageToPC(oPC, PUR+"Selected Hair Color: "+IntToString( iHairC ) );

    if(iSkinC == -1)
    SendMessageToPC(oPC, PUR+"Selected Skin Color: no change" );
    else
    SendMessageToPC(oPC, PUR+"Selected Skin Color: "+IntToString( iSkinC ) );

    if(iTail == 0)
    SendMessageToPC(oPC, PUR+"Resetting Tail to Default" );
    else
    SendMessageToPC(oPC, PUR+"Selected Tail: "+IntToString( iTail ) );
    //-----

    SkinChangePC( oPC, iNewAppearance, iNewHead, iHairC, iSkinC, iTail );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC );

    DelayCommand( 1.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );

    DelayCommand( 2.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );

    DelayCommand( 3.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );

}

//-----------------------------------------------------------------------------
// Functions
//-----------------------------------------------------------------------------

//Changes the shape of a PC making sure weapon/size can't be exploited
//if nHead = 0 it'll ignore the head otherwise it'll change that aswell
void SkinChangePC( object oPC , int nSkin , int nHead = -1, int nHairC = -1, int nSkinC = -1, int nTail = 0 )
{

    AssignCommand( oPC , ClearAllActions( TRUE ) );

    object oItem = GetItemInSlot( INVENTORY_SLOT_LEFTHAND , oPC );

    if( GetIsObjectValid( oItem ) )
        AssignCommand( oPC , ActionUnequipItem( oItem ) );

    oItem = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND , oPC );

    if( GetIsObjectValid( oItem ) )
        AssignCommand( oPC , ActionUnequipItem( oItem ) );

    //FREEZE!
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oPC, 3.5 );

    if( nSkin != -1)
        SetCreatureAppearanceType( oPC , nSkin );

    if( nHead != -1 )
        DelayCommand( 2.0 ,SetCreatureBodyPart( CREATURE_PART_HEAD , nHead , oPC ) );

    if( nSkinC != -1 )
        DelayCommand( 2.5 ,SetColor( oPC, COLOR_CHANNEL_SKIN, nSkinC ) );

    if( nHairC != -1 )
        DelayCommand( 2.5 ,SetColor( oPC, COLOR_CHANNEL_HAIR, nHairC ) );

    DelayCommand( 1.0, SetCreatureTailType( nTail, oPC ) );

    DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectPolymorph( POLYMORPH_TYPE_NULL_HUMAN ), oPC, 0.5 ) );

}

