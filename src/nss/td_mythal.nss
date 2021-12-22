//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_td_mythal
//description: The whole mythal system on a void long as your arm
//used as: action script
//date:    080901
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_td_mythal"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
ActionPauseConversation();

    object  oPC     = OBJECT_SELF;
    int     iNode   = GetLocalInt( oPC, "ds_node" );
    int     iChoise = GetLocalInt( oPC, "myth_node" );

    itemproperty IP;
    object oItem    = GetLocalObject( oPC, "myth_target");
    object oRegent  = GetLocalObject( oPC, "myth_regent");

    //List setting
    int     i2DA    = 0;
    int     iCost   = 0;
    int     iDC     = 0;

    int nItemPropDur            = GetItemPropertyDurationType( IP );
    int nItemPropType           = GetItemPropertyType( IP );
    //THIS IS THE APPLY ACTION
    //DO NOTHING BUT CRAFT
    if( iNode == 35 ){

    ActionResumeConversation( );

    iNode = GetLocalInt( oPC , "myth_node");

    iDC             = GetLocalInt( oPC, "myth_dc" );
    iCost           = GetLocalInt( oPC, "myth_cost" );
    //Renaming
    if( iNode == 9 ){

        if( GetGold( oPC ) < iCost )
        {

            SendMessageToPC( oPC, "Not enough gold.");

            return;

        }

        int iCraft = GetLocalInt( oPC, "myth_craft" );
        string sCraft = GetLocalString( oPC, "myth_s_craft" );
        iCraft = GetSkillRank( iCraft, oPC );

        int iRoll = d20();

        if( iRoll == 20 || iRoll+iCraft >= iDC )
        {

            SendMessageToPC( oPC, "(D20 = "+IntToString(iRoll)+") + " +
            IntToString(iCraft)+" = "+
            IntToString(iRoll+iCraft)+
            " VS DC:  "+IntToString(iDC)+
            " *SUCCESS*");

            SetName( oItem, GetLocalString( oPC , "td_color_chat"));

            TakeGoldFromCreature( iCost, oPC, TRUE );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION ), oPC );

            DestroyObject( oRegent );

            ExportSingleCharacter( oPC );
        }

        else{

            TakeGoldFromCreature( iCost, oPC, TRUE );

            SendMessageToPC( oPC, "(D20 = " +
            IntToString(iRoll)+") + "       +
            IntToString(iCraft)+" = "       +
            IntToString(iRoll+iCraft)       +
            " VS DC:  "                     +
            IntToString(iDC)                +
            " *FAILURE*");

            ExportSingleCharacter( oPC );

        }

    return;
    }

    //Infusion
    IP = GetItemPropertyFromNode(  iNode , oPC );

    if( GetIsMythalInfusionSuccessful( oPC, oRegent, iCost, iDC, IP ) )

        if( GetItemPropertyType( IP ) == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N )
            AddItemProperty( DURATION_TYPE_PERMANENT, IP,  oItem );
        else
            IPSafeAddItemProperty( oItem, IP );

    return;
    }
    //------------------------


    //Prpoerty setting
    string sPropery ="";
    string sQuality ="";
    int     iType   = 0;
    int     iType_2 = 0;

    //---------------------
    //ITEMPROPERTY REMOVAGE
    //---------------------
    if( iChoise == 23 )
    {
        if( GetLocalInt( oPC , "myth_23") == 100 ){

        ActionResumeConversation( );

        //Recycling vars
        iType   = 0;
        iType_2 = GetLocalInt( oPC , "LoopsToDo_"+IntToString(iNode) );
        IP = GetFirstItemProperty( oItem );

            while( GetIsItemPropertyValid( IP ) ){

            nItemPropDur            = GetItemPropertyDurationType( IP );
            nItemPropType           = GetItemPropertyType( IP );

            if( nItemPropDur  != DURATION_TYPE_TEMPORARY                        &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP       &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_CLASS                 &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE           &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT    &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_TILESET               &&
            nItemPropType != ITEM_PROPERTY_TRAP                                 &&
            nItemPropType != ITEM_PROPERTY_DAMAGE_VULNERABILITY                 &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ABILITY_SCORE              &&
            nItemPropType != ITEM_PROPERTY_DECREASED_AC                         &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER            &&
            nItemPropType != ITEM_PROPERTY_DECREASED_DAMAGE                     &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER       &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS              &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC     &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SKILL_MODIFIER             &&
            nItemPropType != ITEM_PROPERTY_NO_DAMAGE                            &&
            nItemPropType != ITEM_PROPERTY_SPECIAL_WALK                         &&
            nItemPropType != ITEM_PROPERTY_WEIGHT_INCREASE                       ){

                if( iType == iType_2 )
                {

                    sPropery = Get2DAString("ItemPropDef", "Name", GetItemPropertyType(IP) );

                    SetCustomToken(10120, GetMythalItemPropertyDescriptor( IP ));

                    SetLocalInt( oPC , "myth_23", iNode );

                    return;
                }
            }

            iType++;
            IP = GetNextItemProperty( oItem );

            }

        return;

        }

        else{

        ActionResumeConversation( );

        //Recycling vars
        iType   = 0;
        iType_2 = GetLocalInt( oPC , "LoopsToDo_"+IntToString( GetLocalInt( oPC , "myth_23") ) );

        IP = GetFirstItemProperty( oItem );

            while( GetIsItemPropertyValid( IP ) ){

            nItemPropDur            = GetItemPropertyDurationType( IP );
            nItemPropType           = GetItemPropertyType( IP );

            if( nItemPropDur  != DURATION_TYPE_TEMPORARY                        &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP       &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_CLASS                 &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE           &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT    &&
            nItemPropType != ITEM_PROPERTY_USE_LIMITATION_TILESET               &&
            nItemPropType != ITEM_PROPERTY_TRAP                                 &&
            nItemPropType != ITEM_PROPERTY_DAMAGE_VULNERABILITY                 &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ABILITY_SCORE              &&
            nItemPropType != ITEM_PROPERTY_DECREASED_AC                         &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER            &&
            nItemPropType != ITEM_PROPERTY_DECREASED_DAMAGE                     &&
            nItemPropType != ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER       &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS              &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC     &&
            nItemPropType != ITEM_PROPERTY_DECREASED_SKILL_MODIFIER             &&
            nItemPropType != ITEM_PROPERTY_NO_DAMAGE                            &&
            nItemPropType != ITEM_PROPERTY_SPECIAL_WALK                         &&
            nItemPropType != ITEM_PROPERTY_WEIGHT_INCREASE                       ){

                if( iType == iType_2 ){

                RemoveItemProperty( oItem, IP );

                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_ELECTRIC_EXPLOSION ) , oPC );

                ExportSingleCharacter(oPC);

                return;

                }
            }

            iType++;
            IP = GetNextItemProperty( oItem );

            }

        return;
        }

    }

    //---------------------
    //END ITEMPROPERTY REMOVAGE
    //---------------------

    //First Tree (property type)
    if( iChoise <= 0 ){

        //----------------
        //SPEICAL---------
        //----------------

        switch( iNode ){

            //REMOVAL MODE
        case 23:
            clean_vars( oPC, 1 );

            SetLocalInt( oPC, "myth_node" , 23 );

            iType = 0;

            IP = GetFirstItemProperty( oItem );

            while( GetIsItemPropertyValid( IP ) ) {

                nItemPropDur            = GetItemPropertyDurationType( IP );
                nItemPropType           = GetItemPropertyType( IP );

                if( nItemPropDur  != DURATION_TYPE_TEMPORARY                            &&
                    nItemPropType != ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP       &&
                    nItemPropType != ITEM_PROPERTY_USE_LIMITATION_CLASS                 &&
                    nItemPropType != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE           &&
                    nItemPropType != ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT    &&
                    nItemPropType != ITEM_PROPERTY_USE_LIMITATION_TILESET               &&
                    nItemPropType != ITEM_PROPERTY_TRAP                                 &&
                    nItemPropType != ITEM_PROPERTY_DAMAGE_VULNERABILITY                 &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_ABILITY_SCORE              &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_AC                         &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER            &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_DAMAGE                     &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER       &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS              &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC     &&
                    nItemPropType != ITEM_PROPERTY_DECREASED_SKILL_MODIFIER             &&
                    nItemPropType != ITEM_PROPERTY_NO_DAMAGE                            &&
                    nItemPropType != ITEM_PROPERTY_SPECIAL_WALK                         &&
                    nItemPropType != ITEM_PROPERTY_WEIGHT_INCREASE                       ){

                        SetLocalInt( oPC ,"ds_check_"+IntToString( iType+1 ),1 );

                        SetCustomToken(10110+iType, GetMythalItemPropertyDescriptor( IP ));

                        SetLocalInt( oPC , "LoopsToDo_"+IntToString(iType+1), iType );
                    }
                iType++;
                IP = GetNextItemProperty( oItem );
                }

        SetLocalInt( oPC, "myth_node" , 23 );

        SetLocalInt( oPC , "myth_23", 100 );

        ActionResumeConversation();

        return;

        //LISTNER!
        case 9:

            AssignCommand( OBJECT_SELF, ActionPauseConversation( ) );

            SetLocalInt( oPC, "td_styler_listener", TRUE );

            FloatingTextStringOnCreature( "Speak the new name into the <c þ >SHOUT</c  channel now.",oPC,FALSE );

            SetLocalInt( oPC, "myth_node" , 0 );

        return;

        //LISTNER FEEDBACK/SET RENAMING DCS
        case 30:

            ActionResumeConversation();

            SendMessageToPC( oPC , "Name that will be appiled: " + GetLocalString( oPC, "td_color_chat" ) );

            sPropery = "Renaming: "+GetLocalString( oPC , "td_color_chat");

            iCost   = MYTHAL_COST_PERSONALIZE;

            iDC     = MYTHAL_DC_PERSONALIZE;

            //SET the single paremeter properties
            SetLocalInt( oPC, "myth_dc", iDC);

            SetLocalInt( oPC, "myth_cost", iCost);

            SetCustomToken(10106, IntToString(iDC));

            SetCustomToken(10107, IntToString(iCost));

            SetCustomToken(10108, sPropery);

            SetCustomToken( 10104, "Length: "+IntToString( GetStringLength( GetLocalString( oPC, "td_color_chat" ) ) ) );

            //Initilize second tree here

            SetLocalInt( oPC, "myth_node" , 9 );

        return;

        //----------------
        //SECONDARYCHECKS-
        //----------------

            //Set check visual evil/holy divine only
            case 11:

                if( GetLocalInt( oPC, "myth_11" ) == 2 )
                {
                SetLocalInt( oPC, "ds_check_1", 1 );
                SetLocalInt( oPC, "ds_check_2", 0 );
                }
                else
                {
                SetLocalInt( oPC, "ds_check_1", 0 );
                SetLocalInt( oPC, "ds_check_2", 1 );
                }

            break;

            //Set craftable spells
            case 22:
                if( GetLocalInt( oPC, "myth_22" ) == 1 )
                {
                SetLocalInt( oPC, "ds_check_1", 1 );
                SetLocalInt( oPC, "ds_check_2", 0 );
                SetLocalInt( oPC, "ds_check_3", 0 );
                }
                else if( GetLocalInt( oPC, "myth_22" ) == 2 )
                {
                SetLocalInt( oPC, "ds_check_1", 0 );
                SetLocalInt( oPC, "ds_check_2", 1 );
                SetLocalInt( oPC, "ds_check_3", 0 );
                }
                else if( GetLocalInt( oPC, "myth_22" ) == 3 )
                {
                SetLocalInt( oPC, "ds_check_1", 0 );
                SetLocalInt( oPC, "ds_check_2", 0 );
                SetLocalInt( oPC, "ds_check_3", 1 );
                }
                else
                {
                SetLocalInt( oPC, "ds_check_1", 0 );
                SetLocalInt( oPC, "ds_check_2", 0 );
                SetLocalInt( oPC, "ds_check_3", 0 );
                }
            break;

        //End checks

        //-------------------------------------
        //-------------------------------------
        //AB-----------------------------------
        case 2:

            i2DA    = GetLocalInt( oPC, "myth_2" );

            switch(i2DA){
            case 1:
            iCost   = MYTHAL_COST_AB_1;
            iDC     = MYTHAL_DC_AB_1;
            break;
            case 2:
            iCost   = MYTHAL_COST_AB_2;
            iDC     = MYTHAL_DC_AB_2;
            break;
            case 3:
            iCost   = MYTHAL_COST_AB_3;
            iDC     = MYTHAL_DC_AB_3;
            break;
            case 4:
            iCost   = MYTHAL_COST_AB_4;
            iDC     = MYTHAL_DC_AB_4;
            break;
            case 5:
            iCost   = MYTHAL_COST_AB_5;
            iDC     = MYTHAL_DC_AB_5;
            break;
            default:break;
            }
        sPropery = "attack bonus";
        break;
        //-------------------------------------
        //-------------------------------------
        //AC-----------------------------------
        case 3:

            i2DA    = GetLocalInt( oPC, "myth_3" );

            switch(i2DA){
            case 1:
            iCost   = MYTHAL_COST_AC_1;
            iDC     = MYTHAL_DC_AC_1;
            break;
            case 2:
            iCost   = MYTHAL_COST_AC_2;
            iDC     = MYTHAL_DC_AC_2;
            break;
            case 3:
            iCost   = MYTHAL_COST_AC_3;
            iDC     = MYTHAL_DC_AC_3;
            break;
            case 4:
            iCost   = MYTHAL_COST_AC_4;
            iDC     = MYTHAL_DC_AC_4;
            break;
            case 5:
            iCost   = MYTHAL_COST_AC_5;
            iDC     = MYTHAL_DC_AC_5;
            break;
            default:break;
            }
        sPropery = "armor bonus";
        break;

        //-------------------------------------
        //-------------------------------------
        //Enchantment--------------------------
        case 5:

            i2DA    = GetLocalInt( oPC, "myth_5" );

            switch(i2DA){

            case 1:
            iCost   = MYTHAL_COST_ENHANCEMENT_1;
            iDC     = MYTHAL_DC_ENHANCEMENT_1;
            break;

            case 2:
            iCost   = MYTHAL_COST_ENHANCEMENT_2;
            iDC     = MYTHAL_DC_ENHANCEMENT_2;
            break;

            case 3:
            iCost   = MYTHAL_COST_ENHANCEMENT_3;
            iDC     = MYTHAL_DC_ENHANCEMENT_3;
            break;

            case 4:
            iCost   = MYTHAL_COST_ENHANCEMENT_4;
            iDC     = MYTHAL_DC_ENHANCEMENT_4;
            break;

            case 5:
            iCost   = MYTHAL_COST_ENHANCEMENT_5;
            iDC     = MYTHAL_DC_ENHANCEMENT_5;
            break;

            default:break;
            }
        sPropery = "enchantment bonus";
        break;
        //-------------------------------------
        //-------------------------------------
        //Keen---------------------------------
        case 6:

            iCost   = MYTHAL_COST_KEEN;
            iDC     = MYTHAL_DC_KEEN;
            sPropery = "keen";
            sQuality =  sPropery;

        break;
        //-------------------------------------
        //-------------------------------------
        //Massive Critical---------------------
        case 7:
            i2DA    = GetLocalInt( oPC, "myth_7" );

            switch(i2DA){
            case IP_CONST_DAMAGEBONUS_1:
            sQuality = "+1";
            iCost   = MYTHAL_COST_MCRITICAL_1;
            iDC     = MYTHAL_DC_MCRITICAL_1;
            break;
            case IP_CONST_DAMAGEBONUS_1d4:
            sQuality = "+1d4";
            iCost   = MYTHAL_COST_MCRITICAL_2;
            iDC     = MYTHAL_DC_MCRITICAL_2;
            break;
            case IP_CONST_DAMAGEBONUS_1d6:
            sQuality = "+1d6";
            iCost   = MYTHAL_COST_MCRITICAL_3;
            iDC     = MYTHAL_DC_MCRITICAL_3;
            break;
            case IP_CONST_DAMAGEBONUS_1d8:
            sQuality = "+1d8";
            iCost   = MYTHAL_COST_MCRITICAL_4;
            iDC     = MYTHAL_DC_MCRITICAL_4;
            break;

            default:break;
            }
            sPropery = "massive critical";
        break;
        //-------------------------------------
        //-------------------------------------
        //-------------------------------------
        //VampReg------------------------------
        case 10:

        i2DA    = GetLocalInt( oPC, "myth_10" );

            switch(i2DA){

                case 1:

                iCost   = MYTHAL_COST_VREGEN_1;
                iDC     = MYTHAL_DC_VREGEN_1;
            break;

                case 2:

                iCost   = MYTHAL_COST_VREGEN_2;
                iDC     = MYTHAL_DC_VREGEN_2;
            break;

                case 3:

                iCost   = MYTHAL_COST_VREGEN_3;
                iDC     = MYTHAL_DC_VREGEN_3;
            break;

            default:break;
            }
        sPropery = "vampiric regeneration";
        break;
        //-------------------------------------
        //-------------------------------------
        //Mighty-------------------------------
        case 12:

        i2DA    = GetLocalInt( oPC, "myth_12" );

            switch(i2DA){

                case 1:

                iDC     = MYTHAL_DC_MIGHTY_1;
                iCost   = MYTHAL_COST_MIGHTY_1;
            break;

                case 2:

                iCost   = MYTHAL_COST_MIGHTY_2;
                iDC     = MYTHAL_DC_MIGHTY_2;
            break;

                case 3:

                iDC     = MYTHAL_DC_MIGHTY_3;
                iCost   = MYTHAL_COST_MIGHTY_3;
            break;

                case 4:

                iDC     = MYTHAL_DC_MIGHTY_4;
                iCost   = MYTHAL_COST_MIGHTY_4;
            break;

                case 5:

                iDC     = MYTHAL_DC_MIGHTY_5;
                iCost   = MYTHAL_COST_MIGHTY_5;
            break;
            default:break;
            }
        sPropery = "mighty";
        break;
        //-------------------------------------
        //-------------------------------------
        //DamageReduction----------------------
        case 15:

            i2DA    = GetLocalInt( oPC, "myth_15" );

            //Set type and apply the offset to match the constants
            SetLocalInt( oPC , "myth_type" , i2DA-1 );

            switch(i2DA){

                case 1:

                iCost   = MYTHAL_COST_DR_1;
                iDC     = MYTHAL_DC_DR_1;
            break;

                case 2:

                iCost   = MYTHAL_COST_DR_2;
                iDC     = MYTHAL_DC_DR_2;
            break;

                case 3:

                iCost   = MYTHAL_COST_DR_3;
                iDC     = MYTHAL_DC_DR_3;
            break;

                case 4:

                iCost   = MYTHAL_COST_DR_4;
                iDC     = MYTHAL_DC_DR_4;
            break;

                case 5:

                iCost   = MYTHAL_COST_DR_5;
                iDC     = MYTHAL_DC_DR_5;
            break;
            default:break;
            }
            sQuality = "+"+IntToString(i2DA)+"/5";
            sPropery = "damage reduction";
        break;
        //-------------------------------------
        //-------------------------------------
        //UniversalSave------------------------
        case 18:

            i2DA    = GetLocalInt( oPC, "myth_18" );

            switch(i2DA){
            case 1:
            iCost   = MYTHAL_COST_UNI_SAVE_1;
            iDC     = MYTHAL_DC_UNI_SAVE_1;
            break;
            case 2:
            iCost   = MYTHAL_COST_UNI_SAVE_2;
            iDC     = MYTHAL_DC_UNI_SAVE_2;
            break;
            default:break;
            }
        sPropery = "universal saving throw bonus";
        break;
        //-------------------------------------
        //-------------------------------------
        //SR20---------------------------------
        case 19:
        iCost   = MYTHAL_COST_SR;
        iDC     = MYTHAL_DC_SR;
        sPropery = "20 spell resistance";
        sQuality = "20 SR";
        break;
        //-------------------------------------
        //-------------------------------------
        //Regeneration-------------------------
        case 20:
        iCost   = MYTHAL_COST_REGEN_1;
        iDC     = MYTHAL_DC_REGEN_1;
        sPropery = "regeneration";
        break;

        default:break;
        }

        //SET the single paremeter properties
        SetLocalInt( oPC, "myth_dc", iDC );
        SetLocalInt( oPC, "myth_cost", iCost);

        iDC = iDC + 2 * GetMythalItemPowerWorth( oItem );

        SetCustomToken(10106, IntToString(iDC));
        SetCustomToken(10107, IntToString(iCost));
        SetCustomToken(10108, sPropery);

        //----------------
        //SINGLEPARAMETER-
        //----------------

        sQuality = "+"+IntToString(GetLocalInt( oPC, "myth_"+IntToString( iNode ) ) );

    //Initilize second tree here
    SetCustomToken( 10104, sQuality );
    SetLocalInt( oPC, "myth_node" , iNode );
    ActionResumeConversation();
    return;
    }

    //Second tree (Parameters)
    else if( iChoise >= 1 )
    {
        switch( iChoise )
        {
        //Abilities----------------------------
        case 1:
            switch( iNode )
            {
            case 1:iType = IP_CONST_ABILITY_STR; sQuality ="str"; break;
            case 2:iType = IP_CONST_ABILITY_DEX; sQuality ="dex";break;
            case 3:iType = IP_CONST_ABILITY_CON; sQuality ="con";break;
            case 4:iType = IP_CONST_ABILITY_INT; sQuality ="int";break;
            case 5:iType = IP_CONST_ABILITY_WIS; sQuality ="wis";break;
            case 6:iType = IP_CONST_ABILITY_CHA; sQuality ="cha";break;
            default:break;
            }
            i2DA    = GetLocalInt( oPC, "myth_1" );
            iDC     = 12 * i2DA;

            switch(i2DA){

            case 1:
            iCost   = MYTHAL_COST_ABILITY_1;
            iDC     = MYTHAL_DC_ABILITY_1;
            break;

            case 2:
            iCost   = MYTHAL_COST_ABILITY_2;
            iDC     = MYTHAL_DC_ABILITY_2;
            break;

            case 3:
            iCost   = MYTHAL_COST_ABILITY_3;
            iDC     = MYTHAL_DC_ABILITY_3;
            break;

            default:break;
            }
        SetCustomToken( 10104, "+"+IntToString(i2DA)+" "+sQuality );
        sPropery = "ability bonus";
        SetLocalInt( oPC , "myth_type" , iType );
        break;
        //-------------------------------------
        //-------------------------------------
        //AB-----------------------------------
        case 2:

        break;
        //-------------------------------------
        //-------------------------------------
        //AC-----------------------------------
        case 3:

        break;
        //-------------------------------------
        //-------------------------------------
        //Elemental----------------------------
        case 4:
            switch( iNode )
            {
            case 1:iType = IP_CONST_DAMAGETYPE_ACID;sQuality = "acid ";break;
            case 2:iType = IP_CONST_DAMAGETYPE_COLD;sQuality = "cold ";break;
            case 3:iType = IP_CONST_DAMAGETYPE_ELECTRICAL;sQuality = "electrical ";break;
            case 4:iType = IP_CONST_DAMAGETYPE_FIRE;sQuality = "fire ";break;
            case 5:iType = IP_CONST_DAMAGETYPE_SONIC;sQuality = "sonic ";break;
            case 6:iType = IP_CONST_DAMAGETYPE_NEGATIVE;sQuality = "negative ";break;
            default:break;
            }
        SetLocalInt( oPC , "myth_type" , iType );

        i2DA    = GetLocalInt( oPC, "myth_4" );

            switch(i2DA){

            case IP_CONST_DAMAGEBONUS_1:
            sQuality += "+1";
            iCost   = MYTHAL_COST_DAMAGE_1D;
            iDC     = MYTHAL_DC_DAMAGE_1D;
            break;

            case IP_CONST_DAMAGEBONUS_1d4:
            sQuality += "+1d4";
            iCost   = MYTHAL_COST_DAMAGE_1D4;
            iDC     = MYTHAL_DC_DAMAGE_1D4;
            break;

            case IP_CONST_DAMAGEBONUS_1d6:

            if( GetIsTwoHander( oItem ) && GetMythalType( oRegent ) == 4 ){

                sQuality += "+2d4";
                iCost   = MYTHAL_COST_DAMAGE_1D6 + 5000;
                iDC     = MYTHAL_DC_DAMAGE_1D6 + 5;
                SetLocalInt( oPC, "myth_4", IP_CONST_DAMAGEBONUS_2d4 );
            }
            else{

                sQuality += "+1d6";
                iCost   = MYTHAL_COST_DAMAGE_1D6;
                iDC     = MYTHAL_DC_DAMAGE_1D6;
            }
            break;

            default:break;
            }
        SetCustomToken( 10104, sQuality );
        sPropery = "elemental damage";
        break;
        //-------------------------------------
        //-------------------------------------
        //Enchantment--------------------------
        case 5:

        break;
        //-------------------------------------
        //-------------------------------------
        //Keen---------------------------------
        case 6:

        break;
        //-------------------------------------
        //-------------------------------------
        //Massive Critical---------------------
        case 7:

        break;
        //-------------------------------------
        //-------------------------------------
        //Onhit--------------------------------
        case 8:

            switch( iNode )
            {
            case 1:
            iType_2 = IP_CONST_ABILITY_STR;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain str";
            break;

            case 2:
            iType_2 = IP_CONST_ABILITY_DEX;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain dex";
            break;

            case 3:
            iType_2 = IP_CONST_ABILITY_CON;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain con";
            break;

            case 4:
            iType_2 = IP_CONST_ABILITY_INT;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain int";
            break;

            case 5:
            iType_2 = IP_CONST_ABILITY_WIS;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain wis";
            break;

            case 6:
            iType_2 = IP_CONST_ABILITY_CHA;
            iType   = IP_CONST_ONHIT_ABILITYDRAIN;
            sQuality = "drain cha";
            break;

            case 7:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_BLINDNESS;
            sQuality = "blindness";
            break;

            case 8:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_CONFUSION;
            sQuality = "confusion";
            break;

            case 9:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_DAZE;
            sQuality = "daze";
            break;

            case 10:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_DEAFNESS;
            sQuality = "deafness";
            break;

            case 11:
            iType_2 = DISEASE_BURROW_MAGGOTS;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease burrow maggots";
            break;

            case 12:
            iType_2 = DISEASE_CACKLE_FEVER;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease cackle fever";
            break;

            case 13:
            iType_2 = DISEASE_DREAD_BLISTERS;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease dread blisters";
            break;

            case 14:
            iType_2 = DISEASE_MINDFIRE;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease mindfire";
            break;

            case 15:
            iType_2 = DISEASE_SHAKES;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease shakes";
            break;

            case 16:
            iType_2 = DISEASE_VERMIN_MADNESS;
            iType   = IP_CONST_ONHIT_DISEASE;
            sQuality = "disease vermin madness";
            break;

            case 17:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_DOOM;
            sQuality = "doom";
            break;

            case 18:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_FEAR;
            sQuality = "fear";
            break;

            case 19:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_HOLD;
            sQuality = "hold";
            break;

            case 20:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_SILENCE;
            sQuality = "silence";
            break;

            case 21:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_SLOW;
            sQuality = "slow";
            break;

            case 22:
            iType_2 = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            iType   = IP_CONST_ONHIT_STUN;
            sQuality = "stun";
            break;

            default:break;
            }

        iCost   = MYTHAL_COST_OHIT;
        iDC     = MYTHAL_DC_OHIT;
        sPropery = "on hit";
        SetCustomToken( 10104, sPropery+": "+sQuality );
        SetLocalInt( oPC , "myth_type_2" , iType_2 );
        SetLocalInt( oPC , "myth_type" , iType );
        break;
        //-------------------------------------
        //-------------------------------------
        //Rename-------------------------------
        case 9:

        break;
        //-------------------------------------
        //-------------------------------------
        //-------------------------------------
        //VampReg------------------------------
        case 10:

        break;
        //-------------------------------------
        //-------------------------------------
        //Visual-------------------------------
        case 11:

            switch( iNode )
            {
            case 1:iType = ITEM_VISUAL_ACID;sQuality = "vfx acid";break;
            case 2:iType = ITEM_VISUAL_COLD;sQuality = "vfx cold";break;
            case 3:iType = ITEM_VISUAL_ELECTRICAL;sQuality = "vfx electrical";break;
            case 4:iType = ITEM_VISUAL_FIRE;sQuality = "vfx fire";break;
            case 5:iType = ITEM_VISUAL_SONIC;sQuality = "vfx sonic";break;
            case 6:iType = ITEM_VISUAL_HOLY;sQuality = "vfx holy";break;
            case 7:iType = ITEM_VISUAL_EVIL;sQuality = "vfx evil";break;
            default:break;
            }

        iCost   = MYTHAL_COST_VFX;
        iDC     = MYTHAL_DC_VFX;
        SetCustomToken( 10104, sQuality );
        SetLocalInt( oPC , "myth_type" , iType );
        sPropery = "visual effect";
        break;
        //-------------------------------------
        //-------------------------------------
        //Mighty-------------------------------
        case 12:

        break;
        //-------------------------------------
        //-------------------------------------
        //UnlimitedAmmo------------------------
        case 13:

            switch( iNode )
            {
            case 1:iType = IP_CONST_UNLIMITEDAMMO_1D6COLD;sQuality = "1d6 cold ammo";break;
            case 2:iType = IP_CONST_UNLIMITEDAMMO_1D6FIRE;sQuality = "1d6 fire ammo";break;
            case 3:iType = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;sQuality = "1d6 electrical ammo";break;
            case 4:iType = IP_CONST_UNLIMITEDAMMO_PLUS5;sQuality = "+5 ammo";break;
            default:break;
            }

        SetCustomToken( 10104, sQuality );
        iCost   = MYTHAL_COST_UAMMO;
        iDC     = MYTHAL_DC_UAMMO;
        sPropery = "unlimited ammo";
        SetLocalInt( oPC , "myth_type" , iType );

        break;
        //-------------------------------------
        //-------------------------------------
        //BonusSpellSlot-----------------------
        case 14:

            switch( iNode )
            {
            case 1:
            iType_2 = IP_CONST_SPELLLEVEL_3;
            iType   = IP_CONST_CLASS_BARD;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "bard level 3 slot";
            break;

            case 2:
            iType_2 = IP_CONST_SPELLLEVEL_4;
            iType   = IP_CONST_CLASS_BARD;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "bard level 4 slot";
            break;

            case 3:
            iType_2 = IP_CONST_SPELLLEVEL_5;
            iType   = IP_CONST_CLASS_BARD;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "bard level 5 slot";
            break;

            case 4:
            iType_2 = IP_CONST_SPELLLEVEL_4;
            iType   = IP_CONST_CLASS_CLERIC;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "cleric level 4 slot";
            break;

            case 5:
            iType_2 = IP_CONST_SPELLLEVEL_5;
            iType   = IP_CONST_CLASS_CLERIC;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "cleric level 5 slot";
            break;

            case 6:
            iType_2 = IP_CONST_SPELLLEVEL_6;
            iType   = IP_CONST_CLASS_CLERIC;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "cleric level 6 slot";
            break;

            case 7:
            iType_2 = IP_CONST_SPELLLEVEL_4;
            iType   = IP_CONST_CLASS_DRUID;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "druid level 4 slot";
            break;

            case 8:
            iType_2 = IP_CONST_SPELLLEVEL_5;
            iType   = IP_CONST_CLASS_DRUID;
           iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "druid level 5 slot";
            break;

            case 9:
            iType_2 = IP_CONST_SPELLLEVEL_6;
            iType   = IP_CONST_CLASS_DRUID;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "druid level 6 slot";
            break;

            case 10:
            iType_2 = IP_CONST_SPELLLEVEL_2;
            iType   = IP_CONST_CLASS_PALADIN;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "paladin level 2 slot";
            break;

            case 11:
            iType_2 = IP_CONST_SPELLLEVEL_3;
            iType   = IP_CONST_CLASS_PALADIN;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "paladin level 3 slot";
            break;

            case 12:
            iType_2 = IP_CONST_SPELLLEVEL_4;
            iType   = IP_CONST_CLASS_PALADIN;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "paladin level 4 slot";
            break;

            case 13:
            iType_2 = IP_CONST_SPELLLEVEL_2;
            iType   = IP_CONST_CLASS_RANGER;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "ranger level 2 slot";
            break;

            case 14:
            iType_2 = IP_CONST_SPELLLEVEL_3;
            iType   = IP_CONST_CLASS_RANGER;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "ranger level 3 slot";
            break;

            case 15:
            iType_2 = IP_CONST_SPELLLEVEL_4;
            iType   = IP_CONST_CLASS_RANGER;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "ranger level 4 slot";
            break;

            case 16:
            iType_2 = IP_CONST_SPELLLEVEL_5;
            iType   = IP_CONST_CLASS_SORCERER;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "sorcerer level 5 slot";
            break;

            case 17:
            iType_2 = IP_CONST_SPELLLEVEL_6;
            iType   = IP_CONST_CLASS_SORCERER;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "sorcerer level 6 slot";
            break;

            case 18:
            iType_2 = IP_CONST_SPELLLEVEL_7;
            iType   = IP_CONST_CLASS_SORCERER;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "sorcerer level 7 slot";
            break;

            case 19:
            iType_2 = IP_CONST_SPELLLEVEL_5;
            iType   = IP_CONST_CLASS_WIZARD;
            iCost   = MYTHAL_COST_BSLOT_1;
            iDC     = MYTHAL_DC_BSLOT_1;
            sQuality = "wizard level 5 slot";
            break;

            case 20:
            iType_2 = IP_CONST_SPELLLEVEL_6;
            iType   = IP_CONST_CLASS_WIZARD;
            iCost   = MYTHAL_COST_BSLOT_2;
            iDC     = MYTHAL_DC_BSLOT_2;
            sQuality = "wizard level 6 slot";
            break;

            case 21:
            iType_2 = IP_CONST_SPELLLEVEL_7;
            iType   = IP_CONST_CLASS_WIZARD;
            iCost   = MYTHAL_COST_BSLOT_3;
            iDC     = MYTHAL_DC_BSLOT_3;
            sQuality = "wizard level 7 slot";
            break;

            default:break;
            }
        SetCustomToken( 10104, sQuality );
        SetLocalInt( oPC , "myth_type_2" , iType_2 );
        SetLocalInt( oPC , "myth_type" , iType );
        sPropery = "bonus spellslot";
        break;
        //-------------------------------------
        //-------------------------------------
        //DamageReduction----------------------
        case 15:

        break;
        //-------------------------------------
        //-------------------------------------
        //DamageResistance---------------------
        case 16:
            sQuality = "5/- ";
            switch( iNode )
            {
            case 1:iType = IP_CONST_DAMAGETYPE_BLUDGEONING;sQuality+="bludgeoning";break;
            case 2:iType = IP_CONST_DAMAGETYPE_PIERCING;sQuality+="piercing";break;
            case 3:iType = IP_CONST_DAMAGETYPE_SLASHING;sQuality+="slashing";break;
            case 4:iType = IP_CONST_DAMAGETYPE_ACID;sQuality+="acid";break;
            case 5:iType = IP_CONST_DAMAGETYPE_COLD;sQuality+="cold";break;
            case 6:iType = IP_CONST_DAMAGETYPE_FIRE;sQuality+="fire";break;
            case 7:iType = IP_CONST_DAMAGETYPE_ELECTRICAL;sQuality+="electrical";break;
            case 8:iType = IP_CONST_DAMAGETYPE_NEGATIVE;sQuality+="negative";break;
            case 9:iType = IP_CONST_DAMAGETYPE_SONIC;sQuality+="sonic";break;
            default:break;
            }

        iCost   = MYTHAL_COST_DMGRES;
        iDC     = MYTHAL_DC_DMGRES;
        sPropery = "damage resistance";
        SetCustomToken( 10104, sQuality );
        SetLocalInt( oPC , "myth_type" , iType );
        break;
        //-------------------------------------
        //-------------------------------------
        //SavingThrowBonus---------------------
        case 17:
            switch( iNode )
            {
            case 1:iType = IP_CONST_SAVEBASETYPE_FORTITUDE;sQuality ="fortitude";break;
            case 2:iType = IP_CONST_SAVEBASETYPE_REFLEX;sQuality ="reflex";break;
            case 3:iType = IP_CONST_SAVEBASETYPE_WILL;sQuality ="will";break;
            default:break;
            }

            i2DA    = GetLocalInt( oPC, "myth_17" );

            switch(i2DA){
            case 1:
            iCost   = MYTHAL_COST_SAVING_1;
            iDC     = MYTHAL_DC_SAVING_1;
            break;
            case 2:
            iCost   = MYTHAL_COST_SAVING_2;
            iDC     = MYTHAL_DC_SAVING_2;
            break;
            case 3:
            iCost   = MYTHAL_COST_SAVING_3;
            iDC     = MYTHAL_DC_SAVING_3;
            break;
            default:break;
            }
            SetCustomToken( 10104, sQuality+" +"+IntToString( i2DA ) );
        sPropery = "saving throw bonus";
        SetLocalInt( oPC , "myth_type" , iType );
        break;
        //-------------------------------------
        //-------------------------------------
        //UniversalSave------------------------
        case 18:

        break;
        //-------------------------------------
        //-------------------------------------
        //SR20---------------------------------
        case 19:

        break;
        //-------------------------------------
        //-------------------------------------
        //Regeneration-------------------------
        case 20:

        break;
        //-------------------------------------
        //-------------------------------------
        //SkillBonus---------------------------
        case 21:
            switch( iNode )
            {
            case 1:iType = SKILL_ANIMAL_EMPATHY;sQuality="Animal Empathy";break;
            case 2:iType = SKILL_APPRAISE;sQuality="Appraise";break;
            case 3:iType = SKILL_BLUFF;sQuality="bluff";break;
            case 4:iType = SKILL_CONCENTRATION;sQuality="concentration";break;
            case 5:iType = SKILL_CRAFT_ARMOR;sQuality="craft armor";break;
            case 6:iType = SKILL_CRAFT_TRAP;sQuality="craft trap";break;
            case 7:iType = SKILL_CRAFT_WEAPON;sQuality="craft weapon";break;
            case 8:iType = SKILL_DISABLE_TRAP;sQuality="disable trap";break;
            case 9:iType = SKILL_DISCIPLINE;sQuality="discipline";break;
            case 10:iType = SKILL_HEAL;sQuality="heal";break;
            case 11:iType = SKILL_HIDE;sQuality="hide";break;
            case 12:iType = SKILL_INTIMIDATE;sQuality="intimidate";break;
            case 13:iType = SKILL_LISTEN;sQuality="listen";break;
            case 14:iType = SKILL_LORE;sQuality="lore";break;
            case 15:iType = SKILL_MOVE_SILENTLY;sQuality="move silently";break;
            case 16:iType = SKILL_OPEN_LOCK;sQuality="open lock";break;
            case 17:iType = SKILL_PARRY;sQuality="parry";break;
            case 18:iType = SKILL_PERFORM;sQuality="preform";break;
            case 19:iType = SKILL_PERSUADE;sQuality="persuage";break;
            case 20:iType = SKILL_PICK_POCKET;sQuality="pick pocket";break;
            case 21:iType = SKILL_SEARCH;sQuality="seatch";break;
            case 22:iType = SKILL_SET_TRAP;sQuality="set trap";break;
            case 23:iType = SKILL_SPELLCRAFT;sQuality="spellcraft";break;
            case 24:iType = SKILL_SPOT;sQuality="spot";break;
            case 25:iType = SKILL_TAUNT;sQuality="taunt";break;
            case 26:iType = SKILL_USE_MAGIC_DEVICE;sQuality="use magic device";break;
            default:break;
            }

            i2DA    = GetLocalInt( oPC, "myth_21" );

            switch(i2DA){
            case 1:
            iDC     = MYTHAL_DC_SKILL_1;
            iCost   = MYTHAL_COST_SKILL_1;
            break;
            case 3:
            iDC     = MYTHAL_DC_SKILL_2;
            iCost   = MYTHAL_COST_SKILL_2;
            break;
            case 5:
             iDC     = MYTHAL_DC_SKILL_3;
            iCost   = MYTHAL_COST_SKILL_3;
            break;
            default:break;
            }
            SetCustomToken( 10104, sQuality+" +"+IntToString( i2DA ) );
        sPropery = "skill bonus";
        SetLocalInt( oPC , "myth_type" , iType );
        break;
        //-------------------------------------
        //-------------------------------------
        //SpellCast----------------------------
        case 22:

            switch( iNode )
            {
            case 1:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_BLESS_2;
            iCost   = MYTHAL_COST_CSPELL_1;
            iDC     = MYTHAL_DC_CSPELL_1;
            sQuality = "Bless (2) 3 Uses/Day";
            break;

            case 2:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_PROTECTION_FROM_ALIGNMENT_5;
            iCost   = MYTHAL_COST_CSPELL_1;
            iDC     = MYTHAL_DC_CSPELL_1;
            sQuality = "Protection From Alignment (5) 3 Uses/Day";
            break;

            case 3:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_SUMMON_CREATURE_I_5;
            iCost   = MYTHAL_COST_CSPELL_1;
            iDC     = MYTHAL_DC_CSPELL_1;
            sQuality = "Summon Creature I (5) 3 Uses/Day";
            break;

            case 4:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_ENDURE_ELEMENTS_2;
            iCost   = MYTHAL_COST_CSPELL_2;
            iDC     = MYTHAL_DC_CSPELL_2;
            sQuality = "Endure Elements (2) 2 Uses/Day";
            break;

            case 5:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3;
            iCost   = MYTHAL_COST_CSPELL_2;
            iDC     = MYTHAL_DC_CSPELL_2;
            sQuality = "Ghostly Visage (3) 2 Uses/Day";
            break;

            case 6:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_LESSER_RESTORATION_3;
            iCost   = MYTHAL_COST_CSPELL_2;
            iDC     = MYTHAL_DC_CSPELL_2;
            sQuality = "Lesser Restoration (3) 2 Uses/Day";
            break;

            case 7:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            iType   = IP_CONST_CASTSPELL_SUMMON_CREATURE_II_3;
            iCost   = MYTHAL_COST_CSPELL_2;
            iDC     = MYTHAL_DC_CSPELL_2;
            sQuality = "Summon Creature II (3) 2 Uses/Day";
            break;

            case 8:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_ANIMATE_DEAD_10;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Animate Dead (10) 1 Use/Day";
            break;

            case 9:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_DARKNESS_3;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Darkness (3) 1 Use/Day";
            break;

            case 10:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_FEAR_5;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Fear (5) 1 Use/Day";
            break;

            case 11:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_HASTE_5;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Haste (5) 1 Use/Day";
            break;

            case 12:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_LIGHTNING_BOLT_10;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Lightning Bolt (10) 1 Use/Day";
            break;

            case 13:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_SUMMON_CREATURE_III_5;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Summon Creature III (5) 1 Use/Day";
            break;

            case 14:
            iType_2 = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            iType   = IP_CONST_CASTSPELL_VAMPIRIC_TOUCH_5;
            iCost   = MYTHAL_COST_CSPELL_3;
            iDC     = MYTHAL_DC_CSPELL_3;
            sQuality = "Vampiric Touch (5) 1 Use/Day";
            break;

            default:break;
            }
        SetCustomToken( 10104, sQuality );
        SetLocalInt( oPC , "myth_type_2" , iType_2 );
        SetLocalInt( oPC , "myth_type" , iType );
        sPropery = "spell casting";
        break;
        //-------------------------------------
        //-------------------------------------
        //DEFAULT------------------------------
        default:

        break;
        //-------------------------------------
        //-------------------------------------
        //-------------------------------------

        }

        //SET
        SetLocalInt( oPC, "myth_dc", iDC);
        SetLocalInt( oPC, "myth_cost", iCost);

        iDC = iDC + 2 * GetMythalItemPowerWorth( oItem );

        SetCustomToken(10106, IntToString(iDC));
        SetCustomToken(10107, IntToString(iCost));
        SetCustomToken(10108, sPropery);

    }
    else return;
    ActionResumeConversation();
}

