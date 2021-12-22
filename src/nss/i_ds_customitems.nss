/*  i_ds_customitems

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date    Name        Reason
------------------------------------------------------------------
061406  Disco       Start of header
061706  Disco       Bugfix
------------------------------------------------------------------


*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "aps_include"
#include "amia_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//functions
void ArenaTrumpet(object oPC, object oTarget, string sItemName);
void Jukebox(object oPC, object oItem, object oTarget);
void WeatherStaff(object oPC, object oTarget, location lTarget);
void BirdMorph(object oPC);
void MorphPC(object oPC, object oItem, int nAltAppearance, string sAltAppearanceName);

//helper functions
string GetSound(int iNum);
string GetMssage(int iNum);

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){
    int nEvent = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){
        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);
            location lTarget = GetItemActivatedTargetLocation();

            if( sItemName == "The Jukebox" ){

                Jukebox(oPC,oItem,oTarget );
            }

            else if ( sItemName == "Hawk's Feather" ){

                MorphPC( oPC, oItem, APPEARANCE_TYPE_FALCON, "falcon" );
            }

            else if ( sItemName == "Staff of Thunder and Charming" ){

                WeatherStaff( oPC, oTarget, lTarget);
            }

            else if ( sItemName == "Greater Rod of the Jelly IV" ){
                if (GetName(oPC) == "Krastitch"){
                    MorphPC( oPC, oItem, APPEARANCE_TYPE_GELATINOUS_CUBE, "gelatinuous cube" );
                }
                else{
                    SendMessageToPC(oPC, "This item shouldn't belong in your inventory and you might have reached that conclusion yourself. See a DM to cure your current condition.");
                    DestroyObject(oItem);
                    MorphPC( oPC, oItem, APPEARANCE_TYPE_ARCH_TARGET, "target of laughter." );
                    TrackItems( oPC, oTarget, sItemName, "User turned into an archery target");
                }
            }

            else if ( sItemName == "Arena Trumpet" ){

                ArenaTrumpet( oPC, oTarget, sItemName );
            }

            else if( sItemName == "Desmond's Diamond Earring" ){

                int nMod        = GetAbilityModifier( ABILITY_CHARISMA, oPC );
                string sMessage = "<c þ >[?] <c fþ>Charisma Check</c> = D20: </c><cþ  >20</c><c þ > + Modifier ( <cþ  > " +IntToString( nMod ) +"</c><c þ > ) = <cþ  >" +IntToString( 20 + nMod ) +"</c><c þ > [?]</c>";
                AssignCommand ( oPC, ActionSpeakString( sMessage ) );
            }

            else if( sItemName == "Infernal Disguise" ){

                MorphPC( oPC, oItem, APPEARANCE_TYPE_DEVIL, "demon" );
            }

            else if( sItemName == "Treeclimber's Rope" && GetTag( oTarget ) == "ds_apples"){

                int nDie = d10();

                if ( nDie < 5 ){

                    CreateItemOnObject( "ds_apple", oPC );
                }
                else if ( nDie < 7 ){

                    CreateItemOnObject( "ds_apple1", oPC );
                }
                else if ( nDie < 9 ){

                    CreateItemOnObject( "ds_apple2", oPC );
                }
                else {

                    CreateItemOnObject( "ds_apple3", oPC );
                }

                AssignCommand ( oPC, ActionSpeakString( "*" + GetName( oPC ) + " climbs up the tree and picks an apple*" ) );
            }

            else if( sItemName == "Apple" && GetIsPC( oTarget ) ){

                if ( ( d10() + GetAbilityModifier( ABILITY_DEXTERITY, oPC ) ) > 5 ){

                    CreateItemOnObject( "ds_apple", oTarget );
                    SendMessageToPC( oTarget, "You have been hit by an apple!" );
                    SendMessageToPC( oPC, "Bull's Eye!" );
                }
                else{

                    SendMessageToPC( oPC, "A near miss!" );
                }
            }
            else if( sItemName == "Apple, Stinky" ){

                AssignCommand( oPC, ActionCastSpellAtLocation( SPELL_STINKING_CLOUD, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_BALLISTIC, TRUE ) );
                AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_LOOK_FAR ) );
            }
            else if( sItemName == "Apple, Healing" && GetIsPC( oTarget ) ){

               effect eHeal = EffectHeal( d6(3) );
               ApplyEffectToObject( DURATION_TYPE_INSTANT, eHeal, oTarget );
            }
            else if( sItemName == "Apple, Exploding" ){

                AssignCommand( oPC, ActionCastSpellAtLocation( SPELL_FIREBALL, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_BALLISTIC, TRUE ) );
                AssignCommand( oPC, ActionPlayAnimation( ANIMATION_LOOPING_LOOK_FAR ) );
            }
            else if( sItemName == "Mariha's Love" ){

                // Create the effects to apply
                effect ePoly = EffectPolymorph(POLYMORPH_TYPE_PANTHER);
                effect eVis  = EffectVisualEffect(VFX_IMP_POLYMORPH);

                // Apply the effects to the target
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoly, oPC, 600.0 );
            }

            else if( sItemName == "Ruce's Crippling Hangover" ){

                // Create the effects to apply
                effect eVis1   = EffectVisualEffect( VFX_IMP_DAZED_S );
                effect eVis2   = EffectVisualEffect( VFX_DUR_FLIES );
                effect eBA     = EffectAttackDecrease( 10 );
                effect eInt    = EffectAbilityDecrease( ABILITY_INTELLIGENCE, 5 );
                effect eStr    = EffectAbilityDecrease( ABILITY_STRENGTH, 10 );
                effect eListen = EffectSkillIncrease( SKILL_LISTEN, 30 );

                // Apply the effects to the target
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis1, oPC );
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis2, oPC );
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBA, oPC );
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInt, oPC );
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oPC );
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eListen, oPC );
            }

            else if ( sItemName == "Polymorph: Elf" ){

                MorphPC( oPC, oItem, APPEARANCE_TYPE_ELF, "elf" );
            }

            else if( sItemName == "Seagull Feather" ){

                MorphPC(oPC, oItem, APPEARANCE_TYPE_SEAGULL_WALKING, "seagull" );
            }

            else if( sItemName == "Cat's Tooth" ){

                MorphPC(oPC, oItem, APPEARANCE_TYPE_WERECAT, "cat-man" );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void ArenaTrumpet(object oPC, object oTarget, string sItemName){
    if (oPC==oTarget){
        DelayCommand(0.0,AssignCommand(oPC,SpeakString("On the count of three...")));
        DelayCommand(2.0,AssignCommand(oPC,SpeakString("1...")));
        DelayCommand(3.5,AssignCommand(oPC,SpeakString("2...")));
        DelayCommand(5.0,AssignCommand(oPC,SpeakString("3...")));
        DelayCommand(6.5,AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_GREETING)));
        DelayCommand(6.5,AssignCommand(oPC,SpeakString("Let the match begin!")));
    }
    else if (GetIsPC(oTarget)){
        TrackItems(oPC, oTarget, sItemName, "Give "+IntToString(GetHitDice(oTarget)*100)+" gold.");
        AssignCommand(oPC,SpeakString(GetName(oTarget)+" won this round!"));
        GiveGoldToCreature(oTarget,(GetHitDice(oTarget)*100));
    }
    else if(GetLocalInt(oPC, "trumpet_block")!=1){
        string sArea=GetName(GetArea(oPC));

        //clicked area for the first time this session
        if (GetLocalString(oPC, "trumpet_area")==""){
            //first click
            SetLocalString(oPC, "trumpet_area",sArea);
            SendMessageToPC(oPC, "Warning: if you click on this area a second time you will broadcast a match.");
        }
        else{
            //second click
            if (GetLocalString(oPC, "trumpet_area")==sArea){
                TrackItems(oPC, oTarget, sItemName, "Advertise match.");
                AssignCommand(oPC,SpeakString("Attention! There's a fighting match in 15 minutes. Location: "+sArea+".",TALKVOLUME_SHOUT));
                SetLocalInt(oPC, "trumpet_block",1);
                DeleteLocalString(oPC, "trumpet_area");
            }
            else{
                SendMessageToPC(oPC, "Warning: this isn't the same area you selected before. Item has been reset. Try again.");
                DeleteLocalString(oPC, "trumpet_area");
            }
        }
    }
}

void Jukebox(object oPC,object oItem,object oTarget){
    int nStacked=GetNumStackedItems(oTarget);
    if (GetName(oTarget)=="Gold Piece"){
        if (nStacked>13){
            AssignCommand(oPC,ActionSpeakString("I can't accept THAT amount of money for a simple song!",TALKVOLUME_TALK));
        }
        else{
            AssignCommand(oPC,ActionPickUpItem(oTarget));
            AssignCommand(oPC,ActionSpeakString(GetMssage(nStacked),TALKVOLUME_TALK));
            AssignCommand(oPC, PlaySound(GetSound(nStacked)));
        }
    }
}

void WeatherStaff(object oPC, object oTarget, location lTarget){

    object oArea=GetArea(oPC);

    if(GetTag(oTarget)=="forestheart"){

        SetWeather(oArea,WEATHER_CLEAR);
        DestroyObject(oTarget);
    }
    else if(GetTag(oTarget)=="butterflymush"){

        SetWeather(oArea,WEATHER_RAIN);
        DestroyObject(oTarget);
    }
    else if(GetTag(oTarget)=="perfectionseeds"){

        SetWeather(oArea,WEATHER_SNOW);
        DestroyObject(oTarget);
    }
    else if ( oTarget == oPC ){

        SetWeather(oArea,WEATHER_USE_AREA_SETTINGS);
    }
    else{

        effect eLightning=EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eLightning,lTarget,2.0);
    }
}

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
        szMessage += "into a graceful " + sAltAppearanceName + "! *";
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


//-------------------------------------------------------------------------------
//helper functions
//-------------------------------------------------------------------------------

string GetSound(int iNum) {
    switch (iNum) {
        case 01: return "as_cv_barglass1";
        case 02: return "as_cv_barglass2";
        case 03: return "as_cv_flute1";
        case 04: return "as_cv_flute2";
        case 05: return "as_cv_lute1";
        case 06: return "as_cv_lute2";
        case 07: return "as_cv_drums1";
        case 08: return "as_cv_drums2";
        case 09: return "as_cv_eulpipe1";
        case 10: return "as_cv_eulpipe2";
        case 11: return "al_pl_x2bongolp1";
        case 12: return "al_pl_x2bongolp2";
        case 13: return "al_pl_x2tablalp";
    }
    return "";
}

string GetMssage(int iNum) {
    switch (iNum) {
        case 01: return "*Niamh lazily ticks your coin on a bottle...*";
        case 02: return "*Niamh lazily ticks your coins on a bottle...*";
        case 03: return "*Niamh plays a short song on her flute.*";
        case 04: return "*Niamh plays the flute like an exotic songbird!*";
        case 05: return "*Niamh picks up her lute and plays a bit.*";
        case 06: return "*Niamh tunes her lute and plays a nice madrigal.*";
        case 07: return "*Niamh hits the drums.*";
        case 08: return "*Niamh bangs the drums!*";
        case 09: return "*Niamh takes out a bagpipe and plays it.*";
        case 10: return "*Niamh plays the bagpipes like her last name is McGuinness!*";
        case 11: return "*Niamh plays Variations on the Bongo in D-minor.*";
        case 12: return "*Niamh is the queen of the bongo!*";
        case 13: return "*Niamh just invented a symphony for tablas!*";
    }
    return "";
}


