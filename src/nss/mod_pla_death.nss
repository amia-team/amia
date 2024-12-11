//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_pla_death
//group: module events
//used as: OnPlayerDeath
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)
// Editted: Added in Escape Artist vanish features. 14 Jun 2019 - Maverick00053

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_ds_died"
#include "X0_I0_SPELLS"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// If a PC had Retribution Prayer bonus, a fireball explodes at their location
// dealing 1d6 divine damage per praying cleric level to any hostiles who
// fail a reflex save.
void RetributionFireballs( object oPC, int nCasterLvl, int nDC );

//Unshift the PC. This does nothing if the PC doesnt have 1kfaces
void ThousandFacesUnshift( object oPC );

// Remove Monk Effects on Death
void RemoveMonkEffects( object oPC );

// Remove Henchmen if they're there.
int HenchCount(object oPC);

// Checks for Merc and removes it
void CheckMerc(object oPC);


//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
 void main(){

    object oVictim = GetLastPlayerDied();
    object oKiller = ResolveKiller( GetLastHostileActor( oVictim ), oVictim );
    object oModule = GetModule();
    int nVanish    = GetLocalInt(oVictim, "vanish");
    int nClass     = GetLevelByClass(42, oVictim);
    int nIsDead    = GetPCKEYValue( oVictim, "dead_in" );
    int nRelog     = FALSE;
    int nTwist     = GetLocalInt( oVictim, "TwistOfFate" );

   // Vanish feat stuff
    int nHp = GetMaxHitPoints(oVictim)/2;
    effect eHeal = EffectHeal(nHp);
    effect eHealFull = EffectHeal(GetMaxHitPoints(oVictim));
    effect eRez = EffectResurrection();
    effect eVFX = EffectVisualEffect( VFX_IMP_RAISE_DEAD );
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

    // Vanish feat will activate for Escape Artist
    if(nClass == 10 && nVanish != 1)
    {
        SendMessageToPC(oVictim, "Vanish activated!");
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eRez, oVictim ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oVictim, 10.0 ) );
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF),GetLocation(oVictim));
        DelayCommand( 0.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eHealFull, oVictim));
        SetLocalInt(oVictim, "vanish", 1);
        DelayCommand(300.0,DeleteLocalInt(oVictim, "vanish"));
        DelayCommand(300.0,SendMessageToPC(oVictim, "Vanish has now refreshed!"));
        return;

    }
    else if(nClass >= 5 && nVanish != 1)
    {
        SendMessageToPC(oVictim, "Vanish activated!");
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eRez, oVictim ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oVictim ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eInvis, oVictim, 10.0 ) );
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF),GetLocation(oVictim));
        DelayCommand( 0.2, ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eHeal, oVictim));
        SetLocalInt(oVictim, "vanish", 1);
        DelayCommand(300.0,DeleteLocalInt(oVictim, "vanish"));
        DelayCommand(300.0,SendMessageToPC(oVictim, "Vanish has now refreshed!"));
        return;

    }
    else
    {

    if( nTwist == 1 ) {
        DeleteLocalInt( oVictim, "TwistOfFate" );
        if( WillSave( oVictim, 30, SAVING_THROW_TYPE_NONE ) == 1 ) {
            DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_HOLY_10 ), oVictim ) );
            DelayCommand( 4.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_HOLY_20 ), oVictim ) );
            DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_HOLY_30 ), oVictim ) );
            DelayCommand( 5.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_TIME_STOP ), oVictim ) );
            DelayCommand( 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_RAISE_DEAD ), oVictim ) );
            DelayCommand( 6.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), oVictim ) );

        }
    }

    // remove monk effects
    RemoveMonkEffects( oVictim );

    // hack for 1kfaces
    ThousandFacesUnshift( oVictim );

    //dead is dead
    SetLocalInt( oVictim, DIED_IS_DEAD, 1 );

    // hack for Master Scout
    DeleteLocalInt( oVictim, "SCOUT_DASH_SET" );
    DeleteLocalInt( oVictim, "SCOUT_STRIDE_SET" );

    //Remove any Mercs
    CheckMerc(oVictim);

    //Check for Retribution prayer effects
    int nRetribution = GetLocalInt( oVictim, "jj_retribution_domain" );
    int nWisdom = GetAbilityModifier( ABILITY_WISDOM, oVictim );

    if ( nRetribution > 0 ){

        DelayCommand( 1.0, RetributionFireballs( oVictim, nRetribution, 19 + nWisdom ) );
        //Remove the bonus so that it can't be fired until another prayer.
        DeleteLocalInt( oVictim, "jj_retribution_domain" );
    }

    //deal with being so dead
    if ( ResolvePvpModeDeath( oKiller, oVictim ) )
    {
        SetBlockTime( oVictim, 5, 0, "ressurection_block" );
        SetLocalObject( oVictim, "my_ressurector", oKiller );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectVisualEffect( VFX_DUR_PARALYZED ) ), oVictim, 300.0 );
        FloatingTextStringOnCreature( GetName( oVictim )+" cannot be raised until five minutes has passed!", oVictim, TRUE );
        DelayCommand( 300.0, FloatingTextStringOnCreature( GetName( oVictim )+" can now be brought back to life!", oVictim, TRUE ) );
        return;
    }
    else
    {
        if( nIsDead == 0 ) // if the PC died on the other server, don't lose track of this
        {
            SetPCKEYValue( oVictim, "dead_in", GetLocalInt( oModule, "Module" ) );
        }
        //SetBlockTime( oVictim, 2, 0, "ressurection_block" );
        //ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SupernaturalEffect( EffectVisualEffect( VFX_DUR_PARALYZED ) ), oVictim, 120.0 );
        //FloatingTextStringOnCreature( GetName( oVictim )+" cannot be raised until two minutes has passed!", oVictim, TRUE );
        //DelayCommand( 120.0, FloatingTextStringOnCreature( GetName( oVictim )+" can now be brought back to life!", oVictim, TRUE ) );
        ResolveNormalDeath( oKiller, oVictim );
    }



}// End for vanish

    int dieQty = HenchCount(oVictim);
    int i = (dieQty);
    while (i > 0){
        object henchDie = GetHenchman(oVictim,i);
        effect unsummon = EffectVisualEffect(VFX_IMP_PDK_RALLYING_CRY);
        location henchSpot = GetLocation(henchDie);

        if(GetIsObjectValid(henchDie)){
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT,unsummon,henchSpot);
            RemoveHenchman(oVictim,henchDie);
            DestroyObject(henchDie,0.1);
        }
        i = (i - 1);
    }

}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

void RetributionFireballs( object oPC, int nCasterLvl, int nDC ){

    int nDamage;
    effect eDam;
    float fDelay;

    location lTarget = GetLocation( oPC );

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, SPELL_FIREBALL));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //Roll damage for each target
            nDamage = d6(nCasterLvl);

            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_DIVINE);
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);

            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }


}

void ThousandFacesUnshift( object oPC ){

    object oItem = GetItemPossessedBy( oPC, "100faces_init" );

    //Doesnt have 1kfaces
    if( !GetIsObjectValid( oItem ) )
        return;

    int     iOriginalHead       = GetLocalInt( oItem , "cs_original_head" );
    int     iOriginalAppearance = GetLocalInt( oItem, "cs_original_appearance" );
    int     iOriginalTail       = GetLocalInt( oItem, "cs_original_tail" );
    int     iHairC              = GetLocalInt( oItem, "td_orginal_haircolor" );
    int     iSkinC              = GetLocalInt( oItem, "td_orginal_skincolor" );

    //Its unset
    if( iOriginalHead == 0 &&
        iOriginalAppearance == 0 &&
        iOriginalTail == 0 &&
        iHairC == 0 &&
        iSkinC == 0 ){
            return;
        }

    if( iOriginalAppearance != -1)
        SetCreatureAppearanceType( oPC , iOriginalAppearance );

    if( iOriginalHead != -1 )
        DelayCommand( 1.0 ,SetCreatureBodyPart( CREATURE_PART_HEAD , iOriginalHead , oPC ) );

    if( iSkinC != -1 )
        DelayCommand( 2.0 ,SetColor( oPC, COLOR_CHANNEL_SKIN, iSkinC ) );

    if( iHairC != -1 )
        DelayCommand( 2.0 ,SetColor( oPC, COLOR_CHANNEL_HAIR, iHairC ) );

    DelayCommand( 0.5, SetCreatureTailType( iOriginalTail, oPC ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC );

    DelayCommand( 1.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );

    DelayCommand( 2.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );

    DelayCommand( 3.0 ,ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), oPC ) );
}

void RemoveMonkEffects(object oPC)
{

   effect eLoop = GetFirstEffect(oPC);
   int    eLoopSpellID;


     // Checks for and removes the feat buff
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectType(eLoop)==EFFECT_TYPE_ATTACK_INCREASE) && (eLoopSpellID == 948))
            {
                 RemoveEffect(oPC, eLoop);
            }

                eLoop=GetNextEffect(oPC);
         }


     DeleteLocalInt(oPC,"monkprc");
}

int HenchCount(object oPC){
    int henchCount;
    int h = 1;
    while (GetIsObjectValid(GetHenchman(oPC,h))){
        henchCount = h;
        h = h + 1;
    }
    return henchCount;
}

void CheckMerc(object oPC)
{
   int i=1;
   object oHench = GetHenchman(oPC,i);
   int nMax = GetMaxHenchmen();

   while(GetIsObjectValid(oHench))
   {

    if((GetLocalInt(oHench,"IsMerc")==1))
    {
      RemoveHenchman(oPC,oHench);
    }
    i++;
    oHench = GetHenchman(oPC,i);
   }
}
