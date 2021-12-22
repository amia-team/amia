//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ai_include
//group:   ds_ai
//used as: include
//date:    dec 23 2007
//author:  disco

//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
//2008-08-03   disco   added Black Blade fix. Mind that the AI will attack Plot creatures now!
//2013-03-31   Glim    Added DoGrapple function.
//2013-11-12   Glim    Added FindNPCSpellTarget, GetRandomEnemy and GetRangedEnemy functions.
//2014-02-21   Glim    Added support for Custom Auras to OnSpawn events.
//2014-02-21   Glim    Added support for Custom spellcasting and abilities to OnSpawn events.


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_talent"
#include "ds_inc_randstore"


//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------

//local variable names
const string L_CURRENTTARGET    = "ds_ai_target";    //also used in amia_include!
const string L_ARCHETYPE        = "ds_ai_archetype";
const string L_LASTSPELL        = "ds_ai_last_spell";
const string L_FEATBUFF         = "ds_ai_featbuff";
const string L_DESTROY          = "ds_ai_destroy";
const string L_INACTIVE         = "ds_ai_i";
const string L_ISDEAD           = "ds_ai_dead";
const string L_LOCATION         = "ds_ai_location";
const string L_BLOCKED          = "ds_ai_blocked";
const string L_HEALED           = "ds_ai_healed";

//limit castings for each spell to this value
const int SPAM_LIMIT            = 2;

//Delay for applying buffs on spawn
const float SPAWNBUFFDELAY      = 1.0;

//Delay for applying buffs on spawn
const int HIPS_CHANCE           = 70;

//flags on critter
const string F_VFX              = "ds_ai_vfx";
const string F_SUNKILL          = "ds_ai_sunkill";
const string F_SPECIAL          = "ds_ai_special";

//parts of variables
const string L_USEDSPELL        = "ds_ai_used_";
const string L_CUSTSPELL        = "ds_ai_custom_";

//shouts
const string M_ATTACKED         = "ds_ai_attacked";




//-------------------------------------------------------------------------------
// struct
//-------------------------------------------------------------------------------
struct MyTarget {

    int nHostileStatus;
    int nReaction;
    object oTarget;
};


//-------------------------------------------------------------------------------
// prototypes: spawn & death functions
//-------------------------------------------------------------------------------

//perception doesn't work on spawning, so we just buff
void OnSpawnRoutines( object oCritter );

//safely cleanup oTarget
void SafeDestroyObject2( object oTarget );

//set onSpawn effects
void SetOnSpawnEffects( object oCritter );

// moves critter towards CURRENTTARGET
// this is used when the citter is spawned
int MoveToTriggerEvent( object oCritter );


//-------------------------------------------------------------------------------
// prototypes: targeting functions
//-------------------------------------------------------------------------------

//checks if current target is valid and attemps to find new one if not
//returns OBJECT_INVALID when it cannot find a new target
struct MyTarget GetTarget( object oCritter );

//quick test before perception can fire
//return values:
// -1: invalid, dead, or immortal
//  0: not hostile
//  1: hostile & undetectable
//  2: hostile & heard
//  3: hostile & seen
int PrePerceptionTest( object oCritter, object oTarget );

//safe version of GetIsEnemy
//return values:
// -3: error, no conditions met
// -2: error, invalid object
// -1: invalid, dead, or immortal
//  0: not hostile
//  1: hostile & undetectable
//  2: hostile & heard
//  3: hostile & seen
int GetIsValidHostile( object oCritter, object oTarget );

//tries to find a suitable enemy before or after perception event
// Set nPrePerception to 1 in MoveToTriggerEvent
object FindSingleTarget( object oCritter, int nPrePerception=0 );

//checks if oTarget really is (spell) invisible to oCritter
//  0: not invisible
//  1: invisible
//  2: invisible but too close
int GetIsInvisible( object oCritter, object oTarget );

//-------------------------------------------------------------------------------
// prototypes: action functions
//-------------------------------------------------------------------------------

//performs an action based on round and archetype
//return values:
//-1 when no valid target is around
// 0 when no action is performed
// 1 when an action is performed
int PerformAction( object oCritter, string sCallingScript="" );

//attempt to use melee type buff feats and return 1 if success
int DoFeatBuff( object oCritter );

//try to heal and return 1 if success
//each critter will only heal once
int DoHeal( object oCritter );

//simple attack and return 1 if attacking
//assign nValidHostile!
int DoAttack( object oCritter, object oTarget, int bPassive, int nValidHostile );

//perform special attack and return 1 if success
int DoSpecialAttack( object oCritter, object oTarget );

//grapple checks, returns 1 if successful
int DoGrapple( object oTarget, object oCritter );

//spell targetting for custom spells, returns oTarget depending on criteria
object FindNPCSpellTarget( object oCritter, int nTargetType );
object GetRandomEnemy( object oCritter );
object GetRangedEnemy( object oCritter );


//-------------------------------------------------------------------------------
// prototypes: spell functions
//-------------------------------------------------------------------------------

//try to cast a cached spell of sType and return 1 if casting
int DoSpellCast( object oCritter, object oTarget, string sType, int nInstant=FALSE );

//creates cache of spells on Critter
int CreateMySpellLists( object oCritter=OBJECT_SELF );

//returns spell from cache of spells on Critter
int ParseMySpellList( object oCritter=OBJECT_SELF, string sType="Attc" );

//return 1 when spells can be cast, 0 when not
int PreFilter( object oCritter, int nSpell );

//unfucks a few spells and polies
string PostFilter( object oCritter, int nSpell );

//-------------------------------------------------------------------------------
// prototypes: utility functions
//-------------------------------------------------------------------------------

//attempt to use feat and return TRUE if success
int SafeUseFeat( object oCritter, object oTarget, int nFeat );

// Wrapper around speakstring
// Feedback level is a local int on the critter that returns all nStatus messages.
// 1. Perceive events
// 2. Actions
// 3. Spells
void DebugMessage( string sMessage, int nStatus );

//Sets and returns general type
//C = Caster (has spells available)
//M = Melee (no spells and no ranged weapon)
//R = Ranged (no spells and ranged weapon)
//S = Sneak attacker
//H = HiPS-er
string SetArchetype( object oCritter, string sSpellList="" );

//checks if a spell is called from a single master spell
//returns one of the options so you don't just get the first 3 spells
int GetMultiOption( int nSpell );

//removes sType from the central sSpellList ('ds_ai_slst')
void RemoveSpellList( object oCritter, string sType );

//determines what to do in a fight
// 0 = nothing
// 1 = change target
// 2 = run away
int GetReaction( object oCritter, object oTarget );

//-------------------------------------------------------------------------------
// onspawn and death functions
//-------------------------------------------------------------------------------

void OnSpawnRoutines( object oCritter ){

    //set effects
    SetOnSpawnEffects( oCritter );

    //function checks if critter should drop random stuff
    InjectIntoStore( oCritter );

    //get the ratio between fighter and mage levels
    string sArchetype = SetArchetype( oCritter );

    if ( sArchetype == "C" ){

        //set bonus buff
        int nSpell     = ParseMySpellList( oCritter, "buff" );

        ActionCastSpellAtObject( nSpell, oCritter, METAMAGIC_ANY, FALSE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE );

        SetLocalInt( oCritter, L_LASTSPELL, nSpell );
    }
    else if ( sArchetype == "S" || sArchetype == "H" ){

        //hide
        SetActionMode( oCritter, ACTION_MODE_STEALTH, TRUE );
    }

    if ( TalentBuffSelf() ){

        // take potion (if possible) and return
    }
    else if ( TalentBardSong() ){

        //Sing (if possible) and return
    }
    else if ( MoveToTriggerEvent( oCritter ) ){

        //move to trigger dude
        //Archetype C stays put and does nothing
    }
    else{

        if ( DoSpellCast( oCritter, oCritter, "summ" ) == 0 ){

            DoSpellCast( oCritter, FindSingleTarget( oCritter, 1 ), "attack" );
        }

        DelayCommand( 6.0, ExecuteScript( "ds_ai2_endround", oCritter ) );
    }
}

int MoveToTriggerEvent( object oCritter ){

    //object oTriggerer   = GetLocalObject( oCritter, L_CURRENTTARGET );
    object oTarget      = FindSingleTarget( oCritter, 1 );

    //get the ratio between fighter and mage levels
    string sArchetype = SetArchetype( oCritter );


    DebugMessage( "MoveToTriggerEvent: Target = "+GetName( oTarget ), 1 );

    if ( GetIsObjectValid( oTarget ) ){

        SetLocalObject( oCritter, L_CURRENTTARGET, oTarget );

        SetLocalInt( OBJECT_SELF, L_INACTIVE, -1 );

        if ( sArchetype == "C" && GetLocalInt( oCritter, L_LASTSPELL ) > 0 ){

            return 0;
        }
        else {

            DoAttack( oCritter, oTarget, FALSE, 3 );
        }

        return 1;
    }
    //else if ( GetLocalString( oCritter, L_ARCHETYPE ) == "M" ){

        //ActionMoveToObject( oTriggerer, TRUE, 5.0 );
        //return 1;
    //}
    else{

        DeleteLocalObject( oCritter, L_CURRENTTARGET );
        return 0;
    }
}

void SafeDestroyObject2( object oTarget ){

    if ( oTarget != OBJECT_INVALID ){

        object oItem = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oItem ) == TRUE ){

            SetPlotFlag( oItem, FALSE );

            DestroyObject( oItem );

            oItem = GetNextItemInInventory( oTarget );
        }

        DestroyObject( oTarget, 0.5 );
    }
}

void SetOnSpawnEffects( object oCritter ){

    int i       = 1;
    string sVar = F_VFX + "_" + IntToString( i );
    int nVal    = GetLocalInt( oCritter, sVar );
    effect eVis;

    while ( nVal > 0 ){
        FloatingTextStringOnCreature("Applying VFX", oCritter, FALSE);
        eVis    = EffectVisualEffect( nVal );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVis, oCritter );

        ++i;
        sVar    = F_VFX + "_" + IntToString( i );
        nVal    = GetLocalInt( oCritter, sVar );

    }

    //check for custom aura application
    int nAura = GetLocalInt( oCritter, "Aura" );
    if( nAura != 0 )
    {
        int nAuraBase = GetLocalInt( oCritter, "AuraBase" );
        string sAuraEnter = GetLocalString( oCritter, "AuraEnter" );
        string sAuraHeart = GetLocalString( oCritter, "AuraHeart" );
        string sAuraExit = GetLocalString( oCritter, "AuraExit" );
        int nAuraType = GetLocalInt( oCritter, "AuraType" );
        float fAuraTime = IntToFloat( GetLocalInt( oCritter, "AuraTime" ) );

        effect eAura = EffectAreaOfEffect( nAuraBase, sAuraEnter, sAuraHeart, sAuraExit );
        switch( nAuraType )
        {
            case 1:     eAura = MagicalEffect( eAura );         break;
            case 2:     eAura = ExtraordinaryEffect( eAura );   break;
            case 3:     eAura = SupernaturalEffect( eAura );    break;
            default:    break;
        }
        DelayCommand( 1.0, ApplyEffectToObject( nAura, eAura, oCritter, fAuraTime ) );
    }

    //Check for onspawn based spellcasitng or ability triggers
    if( GetLocalInt( oCritter, "SpellID_100" ) != 0 )
    {
        int nSpellID = GetLocalInt( oCritter, "SpellID_100" );
        int nTargetType = GetLocalInt( oCritter, "Target_100" );
        object oTarget = FindNPCSpellTarget( oCritter, nTargetType );

        SetLocalInt( oCritter, "OverrideAI", 1 );
        DelayCommand( 4.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );

        ClearAllActions( );

        AssignCommand( oCritter, ActionCastSpellAtObject( nSpellID, oTarget, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, FALSE ) );

        DeleteLocalInt( oCritter, "SpellID_100" );
    }
    else if( GetLocalString( oCritter, "AbilityID_100" ) != "" )
    {
        int nTargetType = GetLocalInt( oCritter, "Target_100" );
        object oTarget = FindNPCSpellTarget( oCritter, nTargetType );

        SetLocalInt( oCritter, "OverrideAI", 1 );
        DelayCommand( 4.0, SetLocalInt( oCritter, "OverrideAI", 0 ) );

        ClearAllActions( );

        SetLocalObject( oCritter, GetLocalString( oCritter, "AbilityID_100" ), oTarget );
        ExecuteScript( GetLocalString( oCritter, "AbilityID_100" ), oCritter );

        DeleteLocalString( oCritter, "AbilityID_100" );
    }
}

//-------------------------------------------------------------------------------
// targeting functions
//-------------------------------------------------------------------------------
struct MyTarget GetTarget( object oCritter ){

    struct MyTarget tTarget;
    object oTarget;
    object oCurrentTarget         = GetLocalObject( oCritter, L_CURRENTTARGET );
    int nIsCurrentValidHostile    = GetIsValidHostile( oCritter, oCurrentTarget );
    int nIsValidHostile;
    int nReaction                 = GetReaction( oCritter, oTarget );
    tTarget.oTarget               = oCurrentTarget;
    tTarget.nHostileStatus        = nIsCurrentValidHostile;
    tTarget.nReaction             = nReaction;

    DebugMessage( "CurrentTarget = "+GetName( oCurrentTarget ), 1 );
    DebugMessage( "nIsCurrentValidHostile = "+IntToString( nIsCurrentValidHostile ), 1 );

    //-------------------------------------------------------------------------------
    //option 1: the current target is available and a valid hostile
    //-------------------------------------------------------------------------------
    if ( nIsCurrentValidHostile > 1 && nReaction != 1 ){

        return tTarget;
    }

    //-------------------------------------------------------------------------------
    //option 2: oCurrentTarget is not suitable or there's a change of attention
    //-------------------------------------------------------------------------------
    oTarget         = GetNearestPerceivedEnemy();
    nIsValidHostile = GetIsValidHostile( oCritter, oTarget );

    if ( nIsValidHostile > 1 ){

        SetLocalObject( oCritter, L_CURRENTTARGET, oTarget );

        tTarget.oTarget         = oTarget;
        tTarget.nHostileStatus  = nIsValidHostile;

        return tTarget;
    }
    else if ( nIsCurrentValidHostile > 1 ){

        //no change in attention after all
        return tTarget;
    }
    else{

        //let's check for another enemy
        oTarget         = FindSingleTarget( oCritter );
        nIsValidHostile = GetIsValidHostile( oCritter, oTarget );

        if ( nIsValidHostile > 1 ){

            SetLocalObject( oCritter, L_CURRENTTARGET, oTarget );

            tTarget.oTarget         = oTarget;
            tTarget.nHostileStatus  = nIsValidHostile;

            //pick this target now
            return tTarget;
        }
    }

    //delete current target on critter
    DeleteLocalObject( oCritter, L_CURRENTTARGET );

    tTarget.oTarget         = OBJECT_INVALID;
    tTarget.nHostileStatus  = -2;

    return tTarget;
}

object FindSingleTarget( object oCritter, int nPrePerception=0 ){

    int nCount;
    int nValid;
    object oCount       = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oCritter ) );
    object oTarget1;
    object oTarget2;
    object oTarget3;

    if ( !GetIsObjectValid( oCount ) ){

        DebugMessage( "FindSingleTarget: No target within 30.0 meters!", 1 );
        return OBJECT_INVALID;
    }
    else{

        DebugMessage( "FindSingleTarget: Target within 30.0 meters!", 1 );
    }

    //cheack for close by targets
    while ( GetIsObjectValid( oCount ) ) {

        if ( oCount != oCritter ){

            if ( nPrePerception == 1 ){

                nValid = PrePerceptionTest( oCritter, oCount );
            }
            else{

                nValid = GetIsValidHostile( oCritter, oCount );
            }

            if ( nValid > 1 ){

                ++nCount;

                if ( nCount == 1 ){

                    oTarget1 = oCount;
                }
                else if ( nCount == 2 ){

                    oTarget2 = oCount;
                }
                else if ( nCount == 3 ){

                    oTarget3 = oCount;
                }
                else{

                    break;
                }
            }
        }

        oCount = GetNextObjectInShape( SHAPE_SPHERE, 30.0, GetLocation( oCritter ) );
    }

    //pick a random target out of the available list
    int nDie = Random( nCount ) + 1;

    if ( nDie == 1 ){

        return oTarget1;
    }
    else if ( nDie == 2 ){

        return oTarget2;
    }
    else if ( nDie == 3 ){

        return oTarget3;
    }

    return OBJECT_INVALID;
}

int GetIsValidHostile( object oCritter, object oTarget ){

    if ( oTarget == OBJECT_INVALID ){

        return -2;
    }
    else if ( GetIsDead( oTarget ) || GetImmortal( oTarget ) ){

        return -1;
    }
    else if ( !GetIsEnemy( oTarget, oCritter ) ){

        return 0;
    }
    else if ( GetHasEffect( EFFECT_TYPE_ETHEREAL, oTarget ) ){

        //GS-ed
        DebugMessage( "GetIsValidHostile: GS-ed target", 1 );
        return 1;
    }
    else {

        int nInvis = GetIsInvisible( oCritter, oTarget );

        if ( nInvis == 1 ){

            //invis
            DebugMessage( "GetIsValidHostile: Invis target", 1 );

            return 1;
        }
        else if ( nInvis == 2 ){

            //invis
            DebugMessage( "GetIsValidHostile: Invis target within detection range", 1 );

            return 3;
        }
        else if ( GetObjectSeen( oTarget, oCritter ) ){

            //invis
            DebugMessage( "GetIsValidHostile: target spotted", 1 );
            return 3;
        }
        else if ( GetObjectHeard( oTarget, oCritter ) ){

            //invis
            DebugMessage( "GetIsValidHostile: target heard", 1 );
            return 2;
        }
    }

    return -3;
}

int PrePerceptionTest( object oCritter, object oTarget ){

    if ( oTarget == OBJECT_INVALID || GetIsDead( oTarget ) || GetImmortal( oTarget ) ){

        return -1;
    }
    else if ( !GetIsEnemy( oCritter, oTarget ) ){

        return 0;
    }

    DebugMessage( "PrePerceptionTest: Is enemy", 1 );

    if ( GetHasEffect( EFFECT_TYPE_ETHEREAL, oTarget ) ){

        //GS-ed
        DebugMessage( "PrePerceptionTest: GS-ed target", 1 );
        return 1;
    }
    else if ( GetIsInvisible( oCritter, oTarget ) == 1 ){

        //invis
        DebugMessage( "GetIsValidHostile: Invis target", 1 );

        return 1;
    }

    //check stealth status
    float fDistance = GetDistanceBetween( oTarget, oCritter );

    if ( GetStealthMode( oTarget ) == STEALTH_MODE_ACTIVATED ){

        int nSpot = GetSkillRank( SKILL_SPOT, oCritter ) + d20();
        int nHide = GetSkillRank( SKILL_HIDE, oTarget ) + d20();

        if ( nSpot > nHide && fDistance < 15.0 ){

            //SendMessageToPC( oTarget,"[AI: "+GetName( oCritter )+" spotted you.]" );
            //SendMessageToPC( oTarget,"[AI: Spot roll "+IntToString( nSpot )+" vs Hide roll "+IntToString( nHide )+"]" );
            DebugMessage( "PrePerceptionTest: Spotted", 1 );
            return 3;
        }

        int nListen = GetSkillRank( SKILL_LISTEN, oCritter ) + d20();
        int nSneak  = GetSkillRank( SKILL_MOVE_SILENTLY, oTarget ) + d20();

        if ( nListen > nSneak && fDistance < 5.0 ){

            //SendMessageToPC( oTarget,"[AI: "+GetName( oCritter )+" heard you.]" );
            //SendMessageToPC( oTarget,"[AI: Listen roll "+IntToString( nListen )+" vs Sneak roll "+IntToString( nSneak )+"]" );
            DebugMessage( "PrePerceptionTest: Heard", 1 );
            return 2;
        }

        return 1;
    }

    return 3;
}

int GetIsInvisible( object oCritter, object oTarget ){

    //what about EFFECT_TYPE_SANCTUARY?

    if ( GetHasEffect( EFFECT_TYPE_TRUESEEING, oCritter ) ){

        DebugMessage( "CheckInvisibility: Invis target, True seeing", 1 );
        return 0;
    }
    else if ( GetHasEffect( EFFECT_TYPE_INVISIBILITY, oTarget )
           || GetHasEffect( EFFECT_TYPE_IMPROVEDINVISIBILITY, oTarget ) ) {

        if ( GetHasEffect( EFFECT_TYPE_SEEINVISIBLE, oCritter ) ){

            return 0;
        }

        //invis
        DebugMessage( "CheckInvisibility: Invis target", 1 );

        float fDistance = GetDistanceToObject( oTarget );

        if ( fDistance > 0.0 && fDistance < 4.0 ){

            //this is not really 'seen' but alas
            return 2;
        }
        else{

            return 1;
        }
    }

    return 0;
}

//-------------------------------------------------------------------------------
// action functions
//-------------------------------------------------------------------------------

int PerformAction( object oCritter, string sCallingScript="" ){

    struct MyTarget tTarget = GetTarget( oCritter );
    object oTarget          = tTarget.oTarget;
    int nReaction           = tTarget.nReaction;
    int nResult;
    DebugMessage( "PerformAction Target = "+GetName( oTarget ), 2 );
    DebugMessage( "PerformAction Target = "+GetName( oTarget ), 3 );
    DebugMessage( "PerformAction Caller = "+sCallingScript, 2 );
    DebugMessage( "PerformAction Caller = "+sCallingScript, 3 );

    if ( oTarget == OBJECT_INVALID ){

        //stop doing what you are doing now.
        ClearAllActions( TRUE );

        return -1;
    }

    //run this when polied.
    if ( GetHasEffect( EFFECT_TYPE_POLYMORPH, oCritter ) ){

        ActionAttack( oTarget );
        return 1;
    }

    //stop doing what you are doing now.
    ClearAllActions( );

    //check for general reaction: flee!
    if ( nReaction == 2 ){

        //move away for one round
        ActionMoveAwayFromObject( oTarget, TRUE, 30.0 );

        return 1;
    }

    //always check if you can and will heal
    if ( DoHeal( oCritter ) ){

        //ActionAttack( oTarget, TRUE );

        return 1;
    }

    //check if there are spells to cast
    string  sArchetype = GetLocalString( oCritter, L_ARCHETYPE );
    int nDie           = d6();

    DebugMessage( "PerformAction sArchetype = "+sArchetype, 2 );

    if ( GetHasFeat( FEAT_CURSE_SONG ) ){

        if ( d2() == 1 ){

            if ( !GetHasFeatEffect( FEAT_CURSE_SONG, oTarget ) ){

                if ( GetDistanceBetween( oCritter, oTarget ) < 10.0 ){

                    SafeUseFeat( oCritter, oTarget, FEAT_CURSE_SONG );

                    return 1;
                }
            }
        }
    }

    if ( sArchetype == "C" ){

        DebugMessage( "AllowCasting", 2 );

        //random set of preferences
        if ( nDie == 3 ){

            nResult = DoSpellCast( oCritter, oTarget, "infl" );
        }
        else if ( nDie == 4 ){

            nResult = DoSpellCast( oCritter, oTarget, "buff" );
        }
        else if ( nDie == 5 ){

            nResult = DoSpellCast( oCritter, oTarget, "poly" );
        }
        else if ( nDie == 6 ){

            nResult = DoSpellCast( oCritter, oTarget, "summ" );
        }

        if ( nResult != 1 ){

            nResult = DoSpellCast( oCritter, oTarget, "attc" );
        }

        if ( nResult == 1 ){

            if ( !GetHasFeat( FEAT_COMBAT_CASTING ) ){

                //critters without combat casting will switch to hand-to-hand in melee
                ActionAttack( oTarget, TRUE );
            }

            return 1;
        }
    }

    //buff from feats
    if ( DoFeatBuff( oCritter ) == 1 ){

         return 1;
    }

    //Hips
    if ( sArchetype  == "H" && GetActionMode( oCritter, ACTION_MODE_STEALTH ) == FALSE ){

        //hide
        if ( d100() < HIPS_CHANCE ){

            ActionMoveAwayFromObject( oTarget, TRUE, 3.0 );

            DelayCommand( 1.0, SetActionMode( oCritter, ACTION_MODE_STEALTH, TRUE ) );
            DelayCommand( 2.0, ExecuteScript( "ds_ai2_endround", oCritter ) );

            return 0;

        }
    }

    //perform special attack
    if ( DoSpecialAttack( oCritter, oTarget ) == 1 ){

         return 1;
    }

    //basic attack
    int nAttack = DoAttack( oCritter, oTarget, FALSE, tTarget.nHostileStatus );


    DebugMessage( "PerformAction nAttack = "+IntToString( nAttack ), 2 );

    if ( nAttack == 1 ){

         return 1;
    }
    else if ( nAttack == -1 ){

        return 0;
    }

    //move towards critter if heard/seen
    if ( tTarget.nHostileStatus > 1 ){

         ActionMoveToObject( GetLocalObject( oCritter, L_CURRENTTARGET ), TRUE, 2.0 );

         return 1;
    }

    return 0;
}

int DoHeal( object oCritter ){

    DebugMessage( "DoHeal", 2 );

    if ( GetLocalInt( oCritter, L_HEALED ) ){

        return 0;
    }

    if ( GetCurrentHitPoints( oCritter ) < ( GetMaxHitPoints( oCritter ) / 2 ) ){

        if ( DoSpellCast( oCritter, oCritter, "heal" ) ){

            //block more heals
            SetLocalInt( oCritter, L_HEALED, 1 );

            //healed with spell
            return 1;
        }
        else if ( TalentHealingSelf() ){

            //block more heals
            SetLocalInt( oCritter, L_HEALED, 1 );

            //healed with potion
            return 1;
        }

        return 0;
    }

    return 0;
}

int DoFeatBuff( object oCritter ){

    DebugMessage( "DoFeatBuff", 2 );

    int nFeatBuffed = GetLocalInt( oCritter, L_FEATBUFF );

    if ( nFeatBuffed == 0 ){

        SetLocalInt( oCritter, L_FEATBUFF, 1 );

        if ( SafeUseFeat( oCritter, oCritter, FEAT_BARBARIAN_RAGE ) ){ return 1; }
        if ( SafeUseFeat( oCritter, oCritter, FEAT_DIVINE_SHIELD ) ){ return 1; }
        if ( SafeUseFeat( oCritter, oCritter, FEAT_DIVINE_MIGHT ) ){ return 1; }
        if ( SafeUseFeat( oCritter, oCritter, FEAT_DWARVEN_DEFENDER_DEFENSIVE_STANCE ) ){ return 1; }
    }

    return 0;
}


int DoSpecialAttack( object oCritter, object oTarget ){

    int nDie = d12();

    if ( nDie < 8 ){

        return FALSE;
    }

    DebugMessage( "SpecialAttack", 2 );

    if ( nDie > 10 && GetLocalInt( oCritter, F_SPECIAL ) > 0 ){

        DebugMessage( "Dragon Ability", 2 );
        ExecuteScript( "ds_ai2_special", oCritter );
        return 1;
    }

    if ( nDie == 08 && SafeUseFeat( oCritter, oTarget, FEAT_SAP ) ){ return 1; }
    if ( nDie == 09 && SafeUseFeat( oCritter, oTarget, FEAT_KNOCKDOWN ) ){ return 1; }
    if ( nDie == 10 && SafeUseFeat( oCritter, oTarget, FEAT_CALLED_SHOT ) ){ return 1; }
    if ( nDie == 11 && SafeUseFeat( oCritter, oTarget, FEAT_DISARM ) ){ return 1; }
    if ( nDie == 12 && SafeUseFeat( oCritter, oTarget, FEAT_TURN_UNDEAD ) ){ return 1; }

    return 0;
}

int DoAttack( object oCritter, object oTarget, int bPassive, int nValidHostile  ){

    DebugMessage( "DoAttack", 2 );

    if ( nValidHostile > 2 ){

        if ( GetIsMeleeAttacker( oCritter ) ){

            float fDistance  = GetDistanceBetween( oCritter, oTarget );
            object oBlocked  = GetLocalObject( oCritter, L_BLOCKED );

            if ( fDistance > 10.0 ){

                location lCurrentLoc    = GetLocation( oCritter );
                location lPreviousLoc   = GetLocalLocation( oCritter, L_LOCATION );

                //previous location has been set
                if ( GetArea( oCritter ) == GetAreaFromLocation( lPreviousLoc ) ){

                    float fMoved = GetDistanceBetweenLocations( lCurrentLoc, lPreviousLoc );

                    if ( oBlocked != oTarget && GetIsObjectValid( oBlocked ) ){

                        //switched targets
                        DeleteLocalFloat( oCritter, L_LOCATION );
                        DeleteLocalObject( oCritter, L_BLOCKED );
                        ActionAttack( oTarget );

                        return 1;
                    }
                    else if ( fMoved < 0.5 ){

                        //is standing still
                        DeleteLocalObject( oCritter, L_CURRENTTARGET );
                        SetLocalObject( oCritter, L_BLOCKED, oTarget );
                        SetLocalLocation( oCritter, L_LOCATION, GetLocation( oCritter ) );

                        return 0;
                    }
                }
            }
            else{

                DeleteLocalLocation( oCritter, L_LOCATION );
                DeleteLocalObject( oCritter, L_BLOCKED );
            }
        }

        //ClearAllActions( );
        ActionAttack( oTarget );
        DebugMessage( "DoAttack Target = "+GetName( oTarget ), 2 );

        return 1;
    }

    ClearAllActions( TRUE );

    return 0;
}

int DoGrapple(object oTarget, object oCritter)
{
    // Creature Statistics
    int nCBAB = GetBaseAttackBonus( oCritter );
    int nCSTR = GetAbilityModifier( ABILITY_STRENGTH, oCritter );
    int nCRoll = d20(1);
    int nCSizeMod = GetLocalInt( oCritter, "SizeModifier" );
    int nCGrapple = nCBAB + nCSTR + nCRoll + nCSizeMod;

    string sCBAB = IntToString( nCBAB );
    string sCSTR = IntToString( nCSTR );
    string sCRoll = IntToString( nCRoll );
    string sCSizeMod = IntToString( nCSizeMod );
    string sCTotal = IntToString( nCGrapple );

    string sCName = GetName( oCritter );

    // Target Statistics
    int nTBAB = GetBaseAttackBonus( oTarget );
    int nTSTR = GetAbilityModifier( ABILITY_STRENGTH, oTarget );
    int nTRoll = d20(1);
    int nTSize = GetCreatureSize( oTarget );
    int nTSizeMod;
    switch (nTSize)
    {
        case 1:     nTSizeMod = -8;      break;
        case 2:     nTSizeMod = -4;      break;
        case 3:     nTSizeMod = 0;       break;
        case 4:     nTSizeMod = 4;       break;
        case 5:     nTSizeMod = 8;       break;
        default:    nTSizeMod = 0;       break;
    }
    int nTGrapple = nTBAB + nTSTR + nTSizeMod + nTRoll;

    string sTBAB = IntToString( nTBAB );
    string sTSTR = IntToString( nTSTR );
    string sTRoll = IntToString( nTRoll );
    string sTSizeMod = IntToString( nTSizeMod );
    string sTTotal = IntToString( nTGrapple );

    string sTName = GetName( oTarget );

    if( TouchAttackMelee( oTarget, TRUE ) <= 1 )
    {
        if( nCGrapple > nTGrapple )
        {
            SendMessageToPC( oTarget, "<c¥  >"+sCName+"</c> <cÂ† > attempts Grapple on "+sTName+" : *success* : (d20:"+sCRoll+" + BAB:"+sCBAB+" + STR:"+sCSTR+" + Size:"+sCSizeMod+" = "+sCTotal+") <cþ  >vs</c> (d20:"+sTRoll+" + BAB:"+sTBAB+" + STR:"+sTSTR+" + Size:"+sTSizeMod+" = "+sTTotal+")</c>" );

            // Apply Paralysis to indicate grapple status
            effect eGrapple = EffectCutsceneImmobilize();
            effect eParaVis1 = EffectVisualEffect( VFX_DUR_PARALYZE_HOLD );
            effect eParaVis2 = EffectVisualEffect( VFX_DUR_PARALYZED );
            eGrapple = EffectLinkEffects( eParaVis1, eGrapple );
            eGrapple = EffectLinkEffects( eParaVis2, eGrapple );
            eGrapple = SupernaturalEffect( eGrapple);

            DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGrapple, oTarget, 5.8 ) );

            return 1;
        }
        else
        {
           SendMessageToPC( oTarget, "<c¥  >"+sCName+"</c> <cÂ† > attempts Grapple on "+sTName+" : *failure* : (d20:"+sCRoll+" + BAB:"+sCBAB+" + STR:"+sCSTR+" +  Size:"+sCSizeMod+" = "+sCTotal+") <cþ  >vs</c> (d20:"+sTRoll+" + BAB:"+sTBAB+" + STR:"+sTSTR+" + Size:"+sTSizeMod+" = "+sTTotal+")</c>" );

            return 0;
        }
    }
    else
    {
        return 0;
    }
}

object FindNPCSpellTarget( object oCritter, int nTargetType )
{
/*
    if nTargetType = ...
    1 = Cast on Self
    2 = Cast on Current Target
    3 = Cast on Random Enemy
    4 = Cast on Ranged Enemy (within 30m but outside 3m)
    5 = Cast on Nearest Friendly
    Or defaults to Self
*/
    object oTarget;

    switch( nTargetType )
    {
        case 1:     oTarget = oCritter;                             break;
        case 2:     oTarget = GetAttackTarget( oCritter );          break;
        case 3:     oTarget = GetRandomEnemy( oCritter );           break;
        case 4:     oTarget = GetRangedEnemy( oCritter );           break;
        case 5:     oTarget = GetNearestSeenFriend( oCritter );     break;
        default:    oTarget = oCritter;                             break;
    }

    return oTarget;
}
object GetRandomEnemy( object oCritter )
{
    //checks all targets in range and stores target data
    location lCritter = GetLocation( oCritter );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 40.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    int nEnemies = 0;

    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsEnemy( oTarget, oCritter ) == TRUE && !GetIsDM( oTarget ) )
        {
            ++nEnemies;
            SetLocalObject( oCritter, "pc_"+IntToString( nEnemies ), oTarget );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 40.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }

    //chooses target randomly from available targets
    object oLastValid;
    object oEnemy;
    int nRandom = Random( nEnemies ) + 1;
    int i;

    for (i=1; i<=nEnemies; ++i)
    {
        object oEnemy = GetLocalObject( oCritter, "pc_"+IntToString( i ) );

        if( i == nRandom && GetIsObjectValid( oEnemy ) && !GetIsDead( oEnemy ) )
        {
            return oEnemy;
        }
        else if( GetIsObjectValid(oEnemy) && !GetIsDead(oEnemy) )
        {
             oLastValid = oEnemy;
        }
    }
    return oLastValid;
}
object GetRangedEnemy( object oCritter )
{
    object oTarget = FindSingleRangedTarget();

    if( !GetIsObjectValid( oTarget ) || GetDistanceBetween( oTarget, oCritter ) < 3.3 )
    {
        oTarget = GetNearestPerceivedEnemy( oCritter );
    }

    if( !GetObjectSeen( oTarget, oCritter ) && !GetObjectHeard( oTarget, oCritter ) )
    {
        return OBJECT_INVALID;
    }
    return oTarget;
}


//-------------------------------------------------------------------------------
// spell functions
//-------------------------------------------------------------------------------
int DoSpellCast( object oCritter, object oTarget, string sType, int nInstant=FALSE ){

    DebugMessage( "CastSpell", 2 );

    int nResult         = FALSE;
    int nLastSpell      = GetLocalInt( oCritter, L_LASTSPELL );
    int nSpell          = ParseMySpellList( oCritter, sType );
    int nAltSpell       = -1;
    int nCritterUndead  = ( GetRacialType( oCritter ) == IP_CONST_RACIALTYPE_UNDEAD );
    int nTargetUndead   = ( GetRacialType( oTarget ) == IP_CONST_RACIALTYPE_UNDEAD );
    string sCustomSlot  = L_CUSTSPELL+GetStringLeft( sType, 1 );
    int nCustomSpell    = GetLocalInt( oCritter, sCustomSlot );

    DebugMessage( "DoSpellCast: nSpell="+IntToString( nSpell ), 3 );
    DebugMessage( "DoSpellCast: sType="+sType, 3 );


    //custom spells follow a different routine
    if ( nCustomSpell > 0 ){

        if ( sType != "attc" ){

            oTarget = oCritter;
        }

        //custom spells must be cheated
        ActionDoCommand( ActionCastSpellAtObject( nCustomSpell, oTarget, METAMAGIC_ANY, TRUE ) );
        return 1;
    }

    //indicate that this spell has been used
    SetLocalInt( oCritter, L_LASTSPELL, nSpell );

    if ( nSpell == -1 ){

        //there are no spells of this type
        return 0;
    }

    if ( sType == "attc" ){

        if ( GetHasSpellEffect( nSpell, oTarget ) ){

            return 0;
        }

        //Dismissal and Banishment are useless against PCs
        if ( ( nSpell == 40 || nSpell == 430 ) && GetAssociateType( oTarget )!= ASSOCIATE_TYPE_SUMMONED ){

            nAltSpell = ParseMySpellList( oCritter, "attc" );

            if ( nAltSpell != 40 && nAltSpell != 430 ){

                 nSpell = nAltSpell;
            }
            else{

                return 0;
            }
        }

        ActionDoCommand( ActionCastSpellAtObject( nSpell, oTarget, METAMAGIC_ANY ) );
        PostFilter( oCritter, nSpell );
        return 1;
    }
    else if ( sType == "buff" ){

        if ( nSpell == nLastSpell || GetHasSpellEffect( nSpell, oCritter ) ){

            return 0;
        }

        ActionDoCommand( ActionCastSpellAtObject( nSpell, oCritter, METAMAGIC_ANY ) );
        PostFilter( oCritter, nSpell );
        return 1;
    }
    else if ( sType == "heal" ){

        if ( nCritterUndead ){

            nAltSpell = ParseMySpellList( oCritter, "infl" );

            if ( nAltSpell != -1 ){

                ActionDoCommand( ActionCastSpellAtObject( nAltSpell, oCritter, METAMAGIC_ANY ) );
                return 1;
            }

            return 0;
        }

        //ClearAllActions( TRUE );
        ActionDoCommand( ActionCastSpellAtObject( nSpell, oCritter, METAMAGIC_ANY ) );
        PostFilter( oCritter, nSpell );

        DebugMessage( "Return == 1", 2 );

        return 1;
    }
    else if ( sType == "infl" ){

        if ( nTargetUndead ){

            nAltSpell = ParseMySpellList( oCritter, "heal" );

            if ( nAltSpell != -1 ){

                ActionDoCommand( ActionCastSpellAtObject( nAltSpell, oTarget, METAMAGIC_ANY ) );
                PostFilter( oCritter, nSpell );
                return 1;
            }

            return 0;
        }

        ActionDoCommand( ActionCastSpellAtObject( nSpell, oTarget, METAMAGIC_ANY ) );
        PostFilter( oCritter, nSpell );
        return 1;
    }
    else if ( sType == "poly" ){

        //ClearAllActions();
        ActionDoCommand( ActionCastSpellAtObject( nSpell, oCritter, METAMAGIC_ANY ) );
        PostFilter( oCritter, nSpell );
        return 1;
    }
    else if ( sType == "summ" ){

        if ( GetAssociate( ASSOCIATE_TYPE_SUMMONED, oCritter ) != OBJECT_INVALID ){

            return 0;
        }

        ActionDoCommand( ActionCastSpellAtLocation( nSpell, GetLocation( oTarget ), METAMAGIC_NONE ) );
        PostFilter( oCritter, nSpell );
        return 1;
    }

    return 0;
}

int CreateMySpellLists( object oCritter=OBJECT_SELF ){

    object oListStorage     = GetWaypointByTag( "ds_slst_storage" );
    string sResRef          = GetResRef( oCritter );
    string sList            = GetLocalString( oListStorage, sResRef );

    string sAttcSpellList   = "";
    string sBuffSpellList   = "";
    string sHealSpellList   = "";
    string sInflSpellList   = "";
    string sPolySpellList   = "";
    string sSummSpellList   = "";

    if ( sList != "" ){

        SetLocalString( oCritter, "ds_ai_slst", sList );

        if ( sList == "------" ){

            return -1;
        }

        if ( FindSubString( sList, "a" ) != -1 ){

            sAttcSpellList   = GetLocalString( GetWaypointByTag( "ds_attc_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_attc", sAttcSpellList );
        }

        if ( FindSubString( sList, "b" ) != -1 ){

            sBuffSpellList   = GetLocalString( GetWaypointByTag( "ds_buff_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_buff", sBuffSpellList );
        }

        if ( FindSubString( sList, "h" ) != -1 ){

            sHealSpellList   = GetLocalString( GetWaypointByTag( "ds_heal_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_heal", sHealSpellList );
        }

        if ( FindSubString( sList, "i" ) != -1 ){

            sInflSpellList   = GetLocalString( GetWaypointByTag( "ds_infl_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_infl", sInflSpellList );
        }

        if ( FindSubString( sList, "p" ) != -1 ){

            sPolySpellList   = GetLocalString( GetWaypointByTag( "ds_poly_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_poly", sPolySpellList );
        }

        if ( FindSubString( sList, "s" ) != -1 ){

            sSummSpellList   = GetLocalString( GetWaypointByTag( "ds_summ_storage" ), sResRef );
            SetLocalString( oCritter, "ds_ai_summ", sSummSpellList );
        }

        return 1;
    }

    int i                   = 0;
    int j                   = 0;
    int nHasSpells          = 0;
    int nSpell              = -1;
    string sType            = "";

    //update spells to 1.69!

    for ( i=0; i<802; ++i ){

        if ( GetHasSpell( i ) ){

            nHasSpells = 1;

            break;
        }
    }

    if ( nHasSpells ){

        for ( j=1; j<=516; ++j ){

            nSpell = StringToInt( Get2DAString( "ds_ai_spells", "Spell", j ) );

            if ( GetHasSpell( nSpell ) ){

                sType = Get2DAString( "ds_ai_spells", "Category", j );

                if ( sType == "a" ){

                    sAttcSpellList = sAttcSpellList + IntToString( nSpell ) + "_";
                }
                else if ( sType == "b" ){

                    sBuffSpellList = sBuffSpellList + IntToString( nSpell ) + "_";
                }
                else if ( sType == "h" ){

                    sHealSpellList = sHealSpellList + IntToString( nSpell ) + "_";
                }
                else if ( sType == "i" ){

                    sInflSpellList = sInflSpellList + IntToString( nSpell ) + "_";
                }
                else if ( sType == "p" ){

                    sPolySpellList = sPolySpellList + IntToString( nSpell ) + "_";
                }
                else if ( sType == "s" ){

                    sSummSpellList = sSummSpellList + IntToString( nSpell ) + "_";
                }
            }
        }

        if ( sAttcSpellList != "" ){

            DebugMessage( "Attack="+sAttcSpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_attc_storage" ), sResRef, sAttcSpellList );
            SetLocalString( oCritter, "ds_ai_attc", sAttcSpellList );
            sList = "a";
        }
        else{

            sList = "-";
        }

        if ( sBuffSpellList != "" ){

            DebugMessage( "Buff="+sBuffSpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_buff_storage" ), sResRef, sBuffSpellList );
            SetLocalString( oCritter, "ds_ai_buff", sBuffSpellList );
            sList = sList + "b";
        }
        else{

            sList = sList + "-";
        }

        if ( sHealSpellList != "" ){

            DebugMessage( "Heal="+sHealSpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_heal_storage" ), sResRef, sHealSpellList );
            SetLocalString( oCritter, "ds_ai_heal", sHealSpellList );
            sList = sList + "h";
        }
        else{

            sList = sList + "-";
        }

        if ( sInflSpellList != "" ){

            DebugMessage( "Inflict="+sInflSpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_infl_storage" ), sResRef, sInflSpellList );
            SetLocalString( oCritter, "ds_ai_infl", sInflSpellList );
            sList = sList + "i";
        }
        else{

            sList = sList + "-";
        }

        if ( sPolySpellList != "" ){

            DebugMessage( "Poly="+sPolySpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_poly_storage" ), sResRef, sPolySpellList );
            SetLocalString( oCritter, "ds_ai_poly", sPolySpellList );
            sList = sList + "p";
        }
        else{

            sList = sList + "-";
        }

        if ( sSummSpellList != "" ){

            DebugMessage( "Summon="+sSummSpellList, 3 );
            SetLocalString( GetWaypointByTag( "ds_summ_storage" ), sResRef, sSummSpellList );
            SetLocalString( oCritter, "ds_ai_summ", sSummSpellList );
            sList = sList + "s";
        }
        else{

            sList = sList + "-";
        }

        SetLocalString( oListStorage, sResRef, sList );
        SetLocalString( oCritter, "ds_ai_slst", sList );
        return 1;
    }
    else {

        sList = "------";
        SetLocalString( oCritter, "ds_ai_slst", sList );
        return -1;
    }
}

int ParseMySpellList( object oCritter=OBJECT_SELF, string sType="attc" ){

    string sSpellList       = "";
    string sLocalSpellList  = "";
    string sSpellId         = "";
    string sReturn          = "";
    int nPointer            = 0;
    int nLength             = 0;
    int i                   = 0;
    int nSpell              = -1;
    int nUsed               = 0;
    int nSelectedSpells     = 0;
    int nSelectedSpell1     = -1;
    int nSelectedSpell2     = -1;
    int nSelectedSpell3     = -1;
    int nReturnSpell        = -1;

    //get locally stored spell list
    sLocalSpellList = "ds_ai_" + sType;
    sSpellList      = GetLocalString( oCritter, sLocalSpellList );

    DebugMessage( "List: "+sLocalSpellList+"="+sSpellList, 3 );

    if ( sSpellList != "" ){

        //start parsing if there's a spell list
        nPointer        = FindSubString( sSpellList, "_" );

        while ( nPointer != -1 && i < 3 ){

            nLength     = GetStringLength( sSpellList ) - nPointer + 1;
            sSpellId    = GetSubString( sSpellList, 0, nPointer );
            sSpellList  = GetSubString( sSpellList, (nPointer+1), nLength );
            nPointer    = FindSubString( sSpellList, "_" );
            nSpell      = -1;
            ++i;

            DebugMessage( "sSpellId="+sSpellId, 3 );
            DebugMessage( "sSpellList="+sSpellList, 3 );

            if ( sSpellId != "" ){

                nSpell = StringToInt( sSpellId );

                nUsed = GetLocalInt( oCritter, L_USEDSPELL+IntToString( nSpell ) );

                //remove used or spammed spells
                if ( GetHasSpell( nSpell ) && nUsed < SPAM_LIMIT ){

                    sReturn = sReturn + sSpellId + "_";
                }
                else{

                    nSpell = -1;
                    DeleteLocalInt( oCritter, L_USEDSPELL+IntToString( nSpell ) );
                }
            }

            if ( nSpell != -1 && nSelectedSpells == 0 ){

                nSelectedSpell1     = GetMultiOption( nSpell );
                nSelectedSpells     = 1;
            }
            else if ( nSpell != -1 && nSelectedSpells == 1 ){

                nSelectedSpell2     = GetMultiOption( nSpell );
                nSelectedSpells     = 2;
            }
            else if ( nSpell != -1 && nSelectedSpells == 2 ){

                nSelectedSpell3     = GetMultiOption( nSpell );
                nSelectedSpells     = 3;
            }
        }

        DebugMessage( "nSelectedSpell1="+IntToString( nSelectedSpell1 ), 3 );
        DebugMessage( "nSelectedSpell2="+IntToString( nSelectedSpell2 ), 3 );
        DebugMessage( "nSelectedSpell3="+IntToString( nSelectedSpell3 ), 3 );

        //recombine spell list parts
        sReturn = sReturn + sSpellList;
        DebugMessage( "sReturnList="+sReturn, 3 );

        if ( sReturn != "" ){

            SetLocalString( oCritter, sLocalSpellList, sReturn );
        }
        else{

            RemoveSpellList( oCritter, sType );
        }
    }

    nReturnSpell = Random( nSelectedSpells ) + 1;


    DebugMessage( "nReturnSpell="+IntToString( nReturnSpell ), 3 );


    switch ( nReturnSpell ) {

        case 1:    return nSelectedSpell1;    break;
        case 2:    return nSelectedSpell2;    break;
        case 3:    return nSelectedSpell3;    break;
    }

    return -1;
}

int PreFilter( object oCritter, int nSpell ){

    //precast fixes
    int nLastSpell = GetLocalInt( oCritter, L_LASTSPELL );

    if( nLastSpell == nSpell ){

        return 0;
    }

    return 1;
}

string PostFilter( object oCritter, int nSpell ){

    //change to full cheat, decrement by hand
    //DecrementRemainingSpellUses( oCritter, nSpell );

    //polies need stopping spells
    if ((  nSpell >= 387 && nSpell <= 391 ) || ( nSpell >= 392 && nSpell <= 396 ) ){

        DelayCommand( 3.0, SetLocalString( oCritter, L_ARCHETYPE, "M" ) );
    }

    //polies also need their spell uses corrected (for heals)
    int nIsPolymorphed  =  GetHasEffect( EFFECT_TYPE_POLYMORPH, oCritter );

    if ( nIsPolymorphed ){

        //DelayCommand( 5.0, DecrementRemainingSpellUses( oCritter, nSpell ) );
        SetArchetype( oCritter, "------" );
    }

    //Update spell uses. They all get SPAM_LIMIT uses if the NPC is a Bard or Sorceror.
    int nClasses = GetLevelByClass( CLASS_TYPE_BARD ) + GetLevelByClass( CLASS_TYPE_SORCERER );

    if ( nClasses > 0 ){

        string sLocalSpellUsed  = L_USEDSPELL+IntToString( nSpell );
        int nSpellUsed          = GetLocalInt( oCritter, sLocalSpellUsed );
        SetLocalInt( oCritter, sLocalSpellUsed, nSpellUsed+1 );
    }

    return "";
}

//-------------------------------------------------------------------------------
// utility functions
//-------------------------------------------------------------------------------
void DebugMessage( string sMessage, int nStatus ){

    int nFeedbackLevel = GetLocalInt( GetArea(OBJECT_SELF), "testing" );
    //int nFeedbackLevel = 1;

    if ( nFeedbackLevel == nStatus ){

        //SpeakString( sMessage );
        SendMessageToPC( GetFirstPC(), "<c þ >"+GetName( OBJECT_SELF )+"</c> "+sMessage );
    }
}

int SafeUseFeat( object oCritter, object oTarget, int nFeat ){

    if ( GetHasFeat( nFeat ) ){

        DebugMessage( "SafeUseFeat="+IntToString(nFeat), 2 );

        AssignCommand( oCritter, ActionUseFeat( nFeat, oTarget ) );
        return TRUE;
    }

    return FALSE;
}

string SetArchetype( object oCritter, string sSpellList="" ){

    if ( sSpellList == "" ){

        sSpellList = GetLocalString( oCritter, "ds_ai_slst" );
    }

    //archetype can only change from C to M/R not vice versa
    string sArchetype = GetLocalString( oCritter, L_ARCHETYPE );
    int nHasSpellList = ( sSpellList != "" && sSpellList != "------" && sSpellList != "--h---" );
    int nLevel        = GetHitDice( oCritter );

    if ( nHasSpellList ){

        //first run. Set to Caster if spell lists are available
        sArchetype = "C";
    }
    else if ( GetHasFeat( FEAT_HIDE_IN_PLAIN_SIGHT ) ){

        sArchetype = "H";
    }
    else if ( sArchetype == "" && GetSkillRank( SKILL_HIDE ) > nLevel && GetSkillRank( SKILL_MOVE_SILENTLY ) > nLevel ){

        //only use this at the start of the routine
        sArchetype = "S";
    }
    else if ( sArchetype != "M" && sArchetype != "R" ){

        if ( GetWeaponRanged( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oCritter ) ) ){

            sArchetype = "R";
        }
        else{

            sArchetype = "M";
        }
    }

    //set magic/melee factor on critter
    SetLocalString( oCritter, L_ARCHETYPE, sArchetype );

    return sArchetype;
}

//checks if a spell is called from a single master spell
//returns one of the options so you don't just get the first 3 spells
int GetMultiOption( int nSpell ){

    DebugMessage( "GetMultiOption="+IntToString(nSpell), 2 );

    if ( nSpell >= 387 && nSpell <= 391 ){

        //PolyMorph Self
        return 387 + Random( 5 );
    }
    else if ( nSpell >= 392 && nSpell <= 396 ){

        //PolyMorph Self
        return 392 + Random( 5 );
    }

    return nSpell;
}

//removes sType from the central sSpellList ('ds_ai_slst')
void RemoveSpellList( object oCritter, string sType ){

    string sSpellList         = GetLocalString( oCritter, "ds_ai_slst" );
    string sShortType         = GetSubString( sType, 0, 1 );
    int nPosition             = FindSubString( sSpellList, sShortType );

    if ( nPosition == -1 ){

        return;
    }

    string sFirstPart         = GetSubString( sSpellList, 0, nPosition );
    string sLastPart          = GetSubString( sSpellList, ( nPosition + 1 ), ( 5 - nPosition ) );
    sSpellList                = sFirstPart + "-" + sLastPart;

    SetLocalString( oCritter, "ds_ai_slst", sSpellList );

    SetArchetype( oCritter, sSpellList );
}

int GetReaction( object oCritter, object oTarget ){

    //no change in reaction if there's no target
    if ( !GetIsObjectValid( oTarget ) ){

        return 0;
    }

    if ( GetIsPC( GetMaster( oTarget ) ) && d10() > 5 ){

        return 1;
    }

    //get health status of both fighters
    string sArchetype       = GetLocalString( oCritter, L_ARCHETYPE );
    float fCritterStatus    = 100 * IntToFloat( GetCurrentHitPoints( oCritter ) ) / IntToFloat( GetMaxHitPoints( oCritter ) + 1 );
    float fTargetStatus     = 100 * IntToFloat( GetCurrentHitPoints( oTarget ) ) / IntToFloat( GetMaxHitPoints( oTarget ) + 1 );
    int nRoll               = d10();

    //add bonus to fickleness for rangers and casters
    if ( sArchetype == "C" || sArchetype == "R" ){

        nRoll = nRoll - 2;
    }

    //Critter is badly wounded, target not: run away on roll > 9
    if ( fCritterStatus < 25.0 && fTargetStatus > 75.0 && nRoll > 9 ){

        return 2;
    }

    //Target is not badly wounded, and critter is very healthy: try new target on roll > 9
    if ( fCritterStatus > 75.0 && fTargetStatus > 50.0 && nRoll > 5 ){

        return 1;
    }

    //no change in reaction
    return 0;
}


