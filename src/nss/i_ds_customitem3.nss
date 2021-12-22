/*  i_ds_customitem3

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
122506    Disco       Added The Lighter
122706    Disco       Added the Summon Changer
010107    Disco       Removed the Summon Changer, added shoptracer and guard banner
010307    Disco       Added Ninjutsu technique
022507    Disco       Added Critter Tracker
20070421  Disco       Jewel of Vanity
20070530  Disco       Wiggan's Webbythinghy
20070605  Disco       Hairdo added
20070910  Disco       Racial Key added
20120627  Glim        Jarl Warden Badge Rod added
20120812  Glim        The Copper Catalogue Spawner added
20120815  Glim        Scissors for Hooded or Masked Cloak disposal added
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//main functions
void MorphPC( object oPC, object oItem, int nAltAppearance, string sAltAppearanceName );
void get_shop( object oPC, object oTarget );
void trace_item( object oPC, object oStore , object oArea , object oItem );
int GetIdentifiedGoldPieceValue(object oItem);
string item_properties( object oItem );
void ban_PC( object oPC, object oTarget );
void strip_armour( object oTarget );
void paralyse_plot( object oPC, object oTarget );
void GemOfVanity( object oPC );
void Webber( object oPC, location lTarget );
void Hairdo( object oPC );
void UnPlot( object oPC, object oTarget );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();


            if ( sItemName == "The Lighter" ){

                // ventjes_c DC item, also given to DMs

                //set scripts and vars used in convo
                SetLocalLocation( oPC, "ds_target", lTarget );
                SetLocalString( oPC, "ds_action", "ds_lightrod" );

                //fire convo
                AssignCommand( oPC, ActionStartConversation( oPC, "ds_light_rod", TRUE, FALSE ) );
            }

            else if ( sItemName == "Spell-like Ability: Dancing Lights" ){

                // Drow ability.

                //set scripts and vars used in convo
                SetLocalLocation( oPC, "ds_target", lTarget );
                SetLocalString( oPC, "ds_action", "ds_lightrod" );

                //fire convo
                AssignCommand( oPC, ActionStartConversation( oPC, "ds_light_rod", TRUE, FALSE ) );
            }

            else if ( GetResRef( oItem ) == "ds_summon_change" ){

                SendMessageToPC( oPC, "Summon Changer deleted. Ask a DM for replacement." );
            }
            else if ( sItemName == "The Big Shopper" ){

                get_shop( oPC, oTarget );
            }
            else if ( sItemName == "Guardsman's Ban Letter" ){

                ban_PC( oPC, oTarget );
            }
            else if ( sItemName == "Parting Mist Strike" ){

                AssignCommand( oPC, strip_armour( oTarget ) );
            }
            else if ( sItemName == "Otluke's Sphere" ){

                paralyse_plot( oPC, oTarget );
            }
            else if( sItemName == "Gem of Vanity" ){

                GemOfVanity( oPC );
            }
            else if( sItemName == "Webber" ){

                Webber( oPC, lTarget );
            }
            else if ( sItemName == "Hairdo" ){

                Hairdo( oPC );
            }
            else if ( sItemName == "(Un)plotter" ){

                UnPlot( oPC, oTarget );
            }
            else if ( sItemName == "Racial Key: Unset" ){

                if ( GetObjectType( oTarget ) != OBJECT_TYPE_DOOR ){

                    oTarget = GetNearestObjectToLocation( OBJECT_TYPE_DOOR, lTarget );
                }

                SetName( oItem, GetName( GetArea( oPC ) ) + " Key" );
                SetLocalString( oItem, "door", GetTag( oTarget ) );
                SendMessageToPC( oPC, "Racial Key attuned to "+GetName( oTarget ) );
            }

            else if ( sItemName == "Cordor Signet Ring Rod" ){

                string sUserRace   = GetStringLowerCase( GetSubRace( oPC ) );
                string sTargetRace = GetStringLowerCase( GetSubRace( oTarget ) );
                object oRing;

                if ( sTargetRace == "drow" ){

                    oRing = GetItemPossessedBy( oTarget, "ds_cordor_key" );

                    if ( !GetIsObjectValid( oRing ) ){

                        CreateItemOnObject( "ds_cordor_key", oTarget );
                        SendMessageToPC( oPC, "Created Signet Ring on "+GetName( oTarget )+"." );
                        log_to_exploits( oTarget, "Cordor Signet Ring ", "Given by: "+GetName( oPC ) );
                    }
                    else{

                        if ( GetLocalObject( oPC, "remove_ring" ) != oTarget ){

                            SendMessageToPC( oPC, GetName( oTarget )+" has a Signet Ring. Click this PC again to take it." );
                            SetLocalObject( oPC, "remove_ring", oTarget );
                        }
                        else{

                            DestroyObject( oRing );
                            SendMessageToPC( oPC, "Removed Signet Ring  from "+GetName( oTarget )+"." );
                            log_to_exploits( oTarget, "Cordor Signet Ring ", "Taken by: "+GetName( oPC ) );
                            DeleteLocalObject( oPC, "remove_ring" );
                        }
                    }
                }
                else {

                    SendMessageToPC( oPC, GetName( oTarget )+" is not a Drow." );
                }
            }

            else if ( sItemName == "Jarl Warden Badge Rod" ){

                object oBadge;

                oBadge = GetItemPossessedBy( oTarget, "glm_wiltunbadg" );

                if ( !GetIsObjectValid( oBadge ) ){

                    CreateItemOnObject( "glm_wiltunbadg", oTarget );
                    SendMessageToPC( oPC, "Created Warden Badge on "+GetName( oTarget )+"." );
                    log_to_exploits( oTarget, "Jarl Warden Badge ", "Given by: "+GetName( oPC ) );
                }
                else{

                    if ( GetLocalObject( oPC, "remove_badge" ) != oTarget ){

                        SendMessageToPC( oPC, GetName( oTarget )+" has a Warden Badge. Click this PC again to take it." );
                        SetLocalObject( oPC, "remove_badge", oTarget );
                    }
                    else{

                        DestroyObject( oBadge );
                        SendMessageToPC( oPC, "Removed Warden Badge from "+GetName( oTarget )+"." );
                        log_to_exploits( oTarget, "Jarl Warden Badge ", "Taken by: "+GetName( oPC ) );
                        DeleteLocalObject( oPC, "remove_badge" );
                    }
                }
            }

            else if ( sItemName == "The Copper Catalogue Spawner" ){

                object oCatalogue;
                string nName;

                oCatalogue = GetItemPossessedBy( oTarget, "tha_tradertool" );

                if ( !GetIsObjectValid( oCatalogue ) ){

                    nName = GetName( oCatalogue );

                    if ( nName == "The Copper Catalogue" )
                    {

                    }
                    else
                    {
                        CreateItemOnObject( "glm_coppercata", oTarget );
                        SendMessageToPC( oPC, "Created Copper Catalogue on "+GetName( oTarget )+"." );
                        log_to_exploits( oTarget, "The Copper Catalogue ", "Given by: "+GetName( oPC ) );
                    }
                }
                else{

                    if ( GetLocalObject( oPC, "remove_catalogue" ) != oTarget ){

                        SendMessageToPC( oPC, GetName( oTarget )+" has a Copper Catalogue. Click this PC again to take it." );
                        SetLocalObject( oPC, "remove_catalogue", oTarget );
                    }
                    else{

                        nName = GetName( oCatalogue );

                        if ( nName != "The Copper Catalogue" )
                        {

                        }
                        else
                        {
                            DestroyObject( oCatalogue );
                            SendMessageToPC( oPC, "Removed Copper Catalogue from "+GetName( oTarget )+"." );
                            log_to_exploits( oTarget, "The Copper Catalogue ", "Taken by: "+GetName( oPC ) );
                            DeleteLocalObject( oPC, "remove_catalogue" );
                        }
                    }
                }
            }

            else if ( sItemName == "Scissors: Hooded or Masked Cloak" ){

                string sIdentity = GetResRef(oTarget);

                if (sIdentity == "ds_j_hooded" || sIdentity == "ds_j_masked"){

                    if ( GetLocalObject( oPC, "remove_scissors" ) != oTarget ){

                        SendMessageToPC( oPC, GetName( oTarget )+" has been flagged. Use the Scissors again to destroy it." );
                        SetLocalObject( oPC, "remove_scissors", oTarget );
                    }
                    else{

                        DestroyObject( oTarget );
                        SendMessageToPC( oPC, "Removed "+GetName( oTarget )+" from your inventory." );
                    }
                }
            }




                else {

                    SendMessageToPC( oPC, GetName( oTarget )+" is not a Drow." );
                }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------

void MorphPC( object oPC, object oItem, int nAltAppearance, string sAltAppearanceName ){

    int nAppearanceSwitch = GetLocalInt(oItem,"ds_AppearanceSwitch");
    int nAppearance       = nAltAppearance;
    string szMessage      = "* Your body morphs ";

    if( nAppearanceSwitch == 0 ){

        //first time only  with a save to make sure the variables are stored
        szMessage += "into a " + sAltAppearanceName + "! *";
        SetLocalInt( oItem, "ds_OriginalAppearance", GetAppearanceType( oPC ) );
        SetLocalInt( oItem, "ds_AppearanceSwitch", 2 );
        ExportSingleCharacter(oPC);
    }
    else if( nAppearanceSwitch == 1 ){

        // disabled, enable form
        szMessage += "into a " + sAltAppearanceName + "! *";
        SetLocalInt( oItem, "ds_AppearanceSwitch", 2 );
    }
    else if( nAppearanceSwitch == 2 ){

        // enabled, disable form
        szMessage += "back to your original form. *";
        nAppearance = GetLocalInt( oItem, "ds_OriginalAppearance" );
        SetLocalInt( oItem, "ds_AppearanceSwitch", 1 );
    }

    // notify the player
    FloatingTextStringOnCreature(szMessage,oPC,FALSE);

    //morph effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    // morph
    SetCreatureAppearanceType(oPC,nAppearance);
}


void get_shop( object oPC, object oTarget ){

    object oStore;

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE || GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

        oStore = oTarget;
    }
    else{

        oStore = GetNearestObject( OBJECT_TYPE_STORE, oPC );
    }

    if ( oStore != OBJECT_INVALID ){

        SendMessageToPC( oPC, "Deleting current records for <c fþ>"+GetName( oStore )+"</c>." );
    }
    else{

        SendMessageToPC( oPC, "Can't detect a store or inventory." );
        return;
    }

    string  sQuery = "DELETE FROM shop_items WHERE shop_name = '"+SQLEncodeSpecialChars( GetName( oStore ) )+"'";
    SQLExecDirect(sQuery);

    object oArea  = GetArea( oPC );
    object oItem = GetFirstItemInInventory( oStore );
    int i;
    float fDelay;

    while (GetIsObjectValid(oItem) == TRUE){

        //nItems = nItems + GetNumStackedItems(oItem);
        ++i;
        fDelay = i/5.0;

        DelayCommand( fDelay, trace_item( oPC, oStore , oArea , oItem ) );

        oItem = GetNextItemInInventory( oStore );
    }
}

void trace_item( object oPC, object oStore , object oArea , object oItem ){

    if ( oItem == OBJECT_INVALID){

        return;
    }

    string  sQuery = "INSERT INTO shop_items VALUES ('" +
            SQLEncodeSpecialChars( GetName( oStore ) ) + "', '" +
            GetResRef( oStore ) + "', '" +
            SQLEncodeSpecialChars( GetName( oItem ) ) + "','" +
            GetTag( oItem ) + "','"+
            GetResRef( oItem ) + "','"+
            SQLEncodeSpecialChars( item_properties( oItem ) ) + "'," +
            IntToString( GetIdentifiedGoldPieceValue( oItem ) )+ ","+
            IntToString( GetBaseItemType( oItem ) )+ ","+
            "NOW())";

     SQLExecDirect(sQuery);
     SendMessageToPC( oPC, "Adding <c fþ>"+GetName( oItem )+"</c> to database." );
}

int GetIdentifiedGoldPieceValue( object oItem ){
    // Initial flag
    int nIdentified = GetIdentified(oItem);
    int nPlotted    = GetPlotFlag(oItem);

    // If not already, set to identfied
    if ( !nIdentified )     SetIdentified(oItem, TRUE);
    if ( nPlotted )         SetPlotFlag(oItem, FALSE);

    // Get the GP value
    int nGP         = GetGoldPieceValue(oItem);

    // Re-set the identification flag to its original
    if ( !nIdentified )     SetIdentified(oItem, FALSE);
    if ( nPlotted )         SetPlotFlag(oItem, TRUE);

    // Return the correct value
    return nGP;
}


string item_properties( object oItem ){

    int nNumber             = IPGetNumberOfItemProperties( oItem );
    int i                   = 0;
    int nProperty           = 0;
    string sMessage         = "";
    string sProperty        = "";
    string sSubProperty     = "";
    string sSubtype         = "";
    string sCostTable       = "";
    string sPropertyValue   = "";
    itemproperty ipLoop     = GetFirstItemProperty( oItem );

    //Loop for as long as the ipLoop variable is valid
    while ( GetIsItemPropertyValid( ipLoop ) ){

        ++i;
        nProperty       = GetItemPropertyType( ipLoop );
        sProperty       = Get2DAString( "itempropdef", "Label", nProperty );

        sSubtype        = Get2DAString( "itempropdef", "SubTypeResRef", nProperty );
        sSubProperty    = Get2DAString( GetStringLowerCase( sSubtype ), "Label", GetItemPropertySubType( ipLoop ) );
        sCostTable      = Get2DAString( "iprp_costtable", "Name", GetItemPropertyCostTable( ipLoop ) );
        sPropertyValue  = Get2DAString( GetStringLowerCase( sCostTable ), "Label", GetItemPropertyCostTableValue( ipLoop ) );

        sMessage = sMessage + sProperty;

        if ( sSubProperty != "" ){

            sMessage = sMessage + ", " + sSubProperty;
        }
        if ( sPropertyValue != "" ){

            sMessage = sMessage + ", " + sPropertyValue;
        }

        sMessage = sMessage + "\n";

        ipLoop = GetNextItemProperty( oItem );
    }

    return sMessage;

}

void ban_PC( object oPC, object oTarget ){

    //stamp PC as banned
    SetLocalInt( oTarget, "banned_cordor", 1 );

    //warn DMs
    SendMessageToAllDMs( GetName( oTarget )+" banned and expelled from Cordor by "+GetName( oPC ) );

    //trace item
    TrackItems( oPC, oTarget, "Guardsman's Ban Letter",  "Banned and expelled from Cordor" );

    //hook into travel scripts
    SetLocalString( oTarget, "travel_destination", "ds_throwout_"+IntToString( d2() ) );

    //fade to black
    FadeToBlack( oTarget );

    //damage
    int OrgHealth    = GetCurrentHitPoints( oTarget );
    effect eDamage   = EffectDamage( ( OrgHealth /2 ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL );
    DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );

    //convo finishes the routine
    DelayCommand( 3.0, AssignCommand( oTarget, ActionStartConversation( oTarget, "travel_thrownout", TRUE, FALSE ) ) );

}


void strip_armour( object oTarget ){

    object oPC = OBJECT_SELF;

    if ( TouchAttackMelee( oTarget ) == 0 ){

        SendMessageToPC( oPC, "[debug: TouchAttackMelee returned 0]" );

        return;
    }

    if ( GetHasFeat( FEAT_SHADOW_EVADE, oPC ) ){

        DecrementRemainingFeatUses( oPC, FEAT_SHADOW_EVADE );

        object oArmour = GetItemInSlot( INVENTORY_SLOT_CHEST, oTarget );

        int nAC = GetItemACValue( oArmour );

        int nDie = d20();

        SendMessageToPC( oPC, "Wind on Mist Strike: "+IntToString(nDie)+" vs DC "+IntToString(nAC) );
        SendMessageToPC( oTarget, "Wind on Mist Strike: "+IntToString(nDie)+" vs DC "+IntToString(nAC) );

        if ( nDie >= nAC ){

            AssignCommand( oTarget, ActionUnequipItem( oArmour ) );
            PlaySound( "gui_magbag_full" );
        }
    }
    else{

        SendMessageToPC( oPC, "[debug: GetHasFeat returned FALSE]" );
    }
}

void paralyse_plot( object oPC, object oTarget ){

    // Makes Target take a Save vs. Spells
    // Save is 10 + spell level (4) + Int Modifier. It also checks for the spell focus feats.

    int nDC = 14 + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC ) ){

        nDC = nDC + 6;
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC ) ){

        nDC = nDC + 4;
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oPC ) ){

        nDC = nDC + 2;
    }

    if ( ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_SPELL ) ){

        oTarget = GetItemActivatedTarget();
        // If Target passes save, it has a Visual effect, nothing else happens.
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE), oTarget);
        return;
    }
    // Checks the Size of the Creature. If it's Huge or Large, then it's too big for the spell
    if ( GetCreatureSize( oTarget ) == CREATURE_SIZE_HUGE || GetCreatureSize( oTarget ) == CREATURE_SIZE_LARGE ){

        SendMessageToPC(oPC, "Resilient Sphere cannot surround that!");
        return;

    }

    // Add "Globe"
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOBE_INVULNERABILITY ), oTarget, 120.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_GREY ), oTarget, 120.0 );

    //Paralyse
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectCutsceneParalyze() ), oTarget, 120.0 );

    //Plot & Immortal
    SetPlotFlag( oTarget, TRUE );
    SetImmortal( oTarget, TRUE );

    //remove after 120 secs
    DelayCommand( 120.0, SetPlotFlag( oTarget, FALSE ) );
    DelayCommand( 120.0, SetImmortal( oTarget, FALSE ) );
}



void GemOfVanity( object oPC ){

    effect eWard   = EffectVisualEffect( VFX_IMP_DEATH_WARD );
    effect eShield = EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWard, oPC, 12.0 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oPC, 12.0 );

    AssignCommand( oPC, SpeakString( GetName( oPC )+" uses Gem of Vanity." ) );
}

void Webber( object oPC, location lTarget ){

    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_WEB ), lTarget, 60.0 );
}


void Hairdo( object oPC ){

    int nHead = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );

    if ( nHead == 40 ){

        nHead = 37;
    }
    else if ( nHead == 37 ){

        nHead = 14;
    }
    else{

       nHead = 40;
    }

    SetCreatureBodyPart( CREATURE_PART_HEAD, nHead, oPC );
}



void UnPlot( object oPC, object oTarget ){

    //used on item
    if ( GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( GetPlotFlag( oTarget ) == TRUE ){

            SetPlotFlag( oTarget, FALSE );
            SendMessageToPC( oPC, GetName( oTarget ) + " set to non-Plot" );
        }
        else{

            SetPlotFlag( oTarget, TRUE );
            SendMessageToPC( oPC, GetName( oTarget ) + " set to Plot" );
        }

        return;
    }

    //used on PC

    if ( GetIsPC( oTarget ) ){

        object oItem    = GetFirstItemInInventory( oPC );
        string sTag;
        int i;
        int j;

        while ( GetIsObjectValid( oItem ) == TRUE ) {

            sTag = GetTag( oItem );

            if( sTag == "BonksLoinCloth" ||
                sTag == "ChieftonsBattleDrum" ||
                sTag == "FireChieftonsBelt" ||
                sTag == "MaximussLegBone" ||
                sTag == "XavierBoneShield" ||
                sTag == "amiajournal" ||
                sTag == "ds_dc_recom" ||
                sTag == "RodofPorting" ||
                sTag == "ds_pckey" ||
                sTag == "AngelsFolly" ){

                SetPlotFlag( oItem, TRUE );
                ++i;
            }
            else{

                SetPlotFlag( oItem, FALSE );
                ++j;
            }

            oItem = GetNextItemInInventory( oPC );
        }

        SendMessageToPC( oPC, IntToString( i ) + " items set to Plot, "+IntToString( j ) + " items set to non-Plot." );
    }
}


