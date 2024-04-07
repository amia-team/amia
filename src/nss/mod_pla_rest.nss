//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  m_playerrest
//description: Module OnPlayerRest Event script
//used as: Module script
//date:    2008-06-03
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "inc_td_rest"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main()
{
    object oPC   = GetLastPCRested();

    // Remove any lingering DD effects
    effect PCEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(PCEffect))
    {
     if(GetEffectTag(PCEffect) == "DDBonuses")
     {
       RemoveEffect(oPC, PCEffect);
     }
     PCEffect = GetNextEffect(oPC);
    }


    //RDD SR and Immunity Calculations
    int nDDLevels = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);
    int nSRIncrease = 0;
    int nImmunityIncrease = 0;
    int nImmunityType;

    // SR
    if(nDDLevels == 20)
    {
      nSRIncrease = 32;
    }
    else if(nDDLevels >= 18)
    {
      nSRIncrease = 24;
    }

    // Immunity % levels
    if(nDDLevels == 20)
    {
      nImmunityIncrease = 100;
    }
    else if(nDDLevels >= 15)
    {
      nImmunityIncrease = 75;
    }
    else if(nDDLevels >= 10)
    {
      nImmunityIncrease = 50;
    }

    // Immunity Type
    if( GetHasFeat( 965, oPC ) == 1 )
    {// Fire
      nImmunityType = DAMAGE_TYPE_FIRE;
    }
    else if( GetHasFeat( 1210, oPC ) == 1 )
    {// Fire
      nImmunityType = DAMAGE_TYPE_FIRE;
    }
    else if( GetHasFeat( 1211, oPC ) == 1 )
    {// Cold
      nImmunityType = DAMAGE_TYPE_COLD;
    }
    else if( GetHasFeat( 1212, oPC ) == 1 )
    {// Negative
      nImmunityType = DAMAGE_TYPE_NEGATIVE;
    }
    else if( GetHasFeat( 1213, oPC ) == 1 )
    {// Gas
      nImmunityType = DAMAGE_TYPE_ACID;
    }
    else if( GetHasFeat( 1214, oPC ) == 1 )
    {// Acid
      nImmunityType = DAMAGE_TYPE_ACID;
    }
    else if( GetHasFeat( 1215, oPC ) == 1 )
    {//Electric
      nImmunityType = DAMAGE_TYPE_ELECTRICAL;
    }

    effect eImmunityIncrease = EffectDamageImmunityIncrease(nImmunityType,nImmunityIncrease);
    effect eSR = EffectSpellResistanceIncrease(nSRIncrease);
    effect eLink = EffectLinkEffects(eImmunityIncrease, eSR);
    eLink = SupernaturalEffect(eLink);
    eLink = TagEffect(eLink,"DDBonuses");

    if(nDDLevels >= 10)
    {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLink,oPC);
    }
    //RDD SR and Immunity Calculations end

    // BG Aura of Despair
    int nClassBG = GetLevelByClass(31,oPC);

    if(nClassBG >= 3){
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ExtraordinaryEffect( EffectAreaOfEffect( 37, "bg_des_en", "****", "bg_des_ex" ) ), oPC );
    }

    int nRestType = GetLastRestEventType( );

    //set action script for emotes
    SetLocalString( oPC, "ds_action", "ds_emotes" );

    switch ( nRestType ) {

        case REST_EVENTTYPE_REST_STARTED:   AssignCommand( oPC, OnRestStarted  ( oPC ) ); break;
        case REST_EVENTTYPE_REST_FINISHED:  AssignCommand( oPC, OnRestFinished ( oPC ) ); break;
        default:                            AssignCommand( oPC, OnRestCancelled( oPC ) ); break;
    }

}
