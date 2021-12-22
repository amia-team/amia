/*
---------------------------------------------------------------------------------
NAME: i_arcmdnite
DESCRIPTION:  Once a day, the Knight of the Winter Fey can radiate the arctic cold from their very core. Any creature within a 10 meter radius suffers a 4d6 cold damage and must make a saving throw to not be frozen solid into a statue of ice.
LOG:
    Faded Wings [10/19/2015 - Created]
----------------------------------------------------------------------------------
*/

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

//This function is a reverse engineered copy of the MyResistSpell one with a few limitations
int MyResistSpellWidget( object oPC, object oTarget, int iCasterLvl );

void ActivateItem();

void main()
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}

void ActivateItem( )
{
    /*
    Range: personal: 4d6 cold damage
    Area of effect: 10 meter radius
    Limit: 1 creature per 2 BG levels (8)
    DC for the Fort save: 10 Base + CL + Cha mod = DC 35 IF the charisma is fully buffed.
    Duration:
    On PC Rounds/BG levels + wis mod (can do without the wis mod too if it makes it too complicated, it's just a 12 sec diffrence anyways)
    On NPC until Un-Petrified.
    Additional: Using this feat drains the use of Smite Good. By that it is by default limited to once per day.
    */
    object oPC = GetItemActivator();
    // get smite available
    int iFeat = FEAT_SMITE_GOOD;
    int iFeatUses = StringToInt(RunLua("return nwn.GetFeatUses('"+ObjectToString(oPC)+"',"+IntToString(iFeat)+")"));

    if( iFeatUses == 0 ){
        SendMessageToPC(oPC, "You do not have smite good use available!");
        return;
    }
    // remove feat use
    DecrementRemainingFeatUses( oPC, iFeat );

    // var
    int iDamage;
    int iDamageType = DAMAGE_TYPE_COLD;
    int iLvl = GetLevelByClass ( CLASS_TYPE_BLACKGUARD , oPC  );
    int iLimitCeil = 8;
    int iLimitScale = 2;
    int iLimitAmount = 1;
    int iLimit = iLvl / iLimitScale;
    if(iLimit > iLimitCeil) iLimit = iLimitCeil;

    int iSave = ( 10 + iLvl + GetAbilityModifier( ABILITY_CHARISMA, oPC ) );
    int iModifier = GetAbilityModifier( ABILITY_WISDOM, oPC );

    float iDuration = RoundsToSeconds ( iLvl + iModifier );

    // spell effects
    int iFNFVFX = VFX_FNF_GAS_EXPLOSION_MIND;
    int iSpellShape = SHAPE_SPHERE;
    int iDurVFX = VFX_DUR_AURA_BLUE;
    int iImpactVFX = VFX_IMP_FROST_L;
    int iAfflicted;
    float fDelay;
    float fRadius = RADIUS_SIZE_COLOSSAL;
    effect eDamage;
    effect eDur = EffectPetrify();
    effect eFNFVFX = EffectVisualEffect(iFNFVFX);
    effect eImpactVFX = EffectVisualEffect(iImpactVFX);
    effect eDurVFX = EffectVisualEffect(iDurVFX);
    location lPC = GetLocation(oPC);

    ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, eFNFVFX, lPC ) ;
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape ( iSpellShape, fRadius, lPC );
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid ( oTarget ) && ( iAfflicted < ( iLimit + 1 ) ) )
    {
        // do not target self
        if ( spellsIsTarget( oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC ) && oTarget != oPC && spellsIsImmuneToPetrification(oTarget) )
        {
            //Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt ( oPC, GetSpellId() ) );
            // random delay
            fDelay = GetRandomDelay ( 0.4, 1.1 );

            SendMessageToPC(oPC, "" + IntToString(MyResistSpell(oPC,oTarget,fDelay)));

            if ( !MyResistSpellWidget ( oPC, oTarget, iLvl ) )
            {
                if(/*Fort Failed*/ !MySavingThrow ( SAVING_THROW_FORT, oTarget, iSave, SAVING_THROW_TYPE_NONE, oPC, fDelay ) )
                {
                     // turn into special effect
                     if( GetIsPC ( oTarget ) ) {
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, iDuration ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDurVFX, oTarget ) );
                     }
                     else {
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eDur, oTarget ) );
                        DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDurVFX, oTarget ) );
                     }
                }
                iDamage = d6(4);

                //Increment affliction
                iAfflicted += 1;

                //Set the damage effect
                eDamage = EffectDamage ( iDamage, iDamageType ) ;

                // Apply effects to the currently selected target.
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
                // Apply vfx to target
                DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpactVFX, oTarget ) );
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape ( iSpellShape, fRadius, lPC ) ;
    }
}

int MyResistSpellWidget(object oPC, object oTarget, int iCasterLvl)
{
    // * Used to route the resist magic checks into this function to check for spell countering by SR, Globes or Mantles.

    //   Return value if oCaster or oTarget is an invalid object: FALSE
    if(!GetIsObjectValid(oPC) || !GetIsObjectValid(oTarget))
    {
        return TRUE;
    }
    //   Return value if spell resisted: 1
    int nSpellPen;
    if( GetHasFeat( FEAT_SPELL_PENETRATION, oPC ) == TRUE )
    {
        nSpellPen = 2;
    }
    if( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION, oPC ) == TRUE )
    {
        nSpellPen = 4;
    }
    if( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION, oPC ) == TRUE )
    {
        nSpellPen = 6;
    }

    if(GetSpellResistance(oTarget) > (d20(1) + nSpellPen +  iCasterLvl))
    {
        return TRUE;
    }
    //   Can't be spell immune to something that doesn't even exist.

    //   Return value if spell resisted via spell absorption: 3
    effect e = GetFirstEffect(oPC);
    while(GetIsEffectValid(e))
    {
        if(GetEffectType(e) == EFFECT_TYPE_SPELLLEVELABSORPTION)//if effect was created by this item
        {
            RemoveEffect(oPC,e);//remove it
            return TRUE;
        }
        e = GetNextEffect(oPC);
    }
    return FALSE;
}

