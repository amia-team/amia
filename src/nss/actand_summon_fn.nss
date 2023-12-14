/*
   Actand Demiplane Summoning Reward Final summon

  -Maverick00053 11/24/2023
*/

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC,"actandsummonitem");
    int nVFX = VFX_FNF_SUMMON_MONSTER_3;
    string sCreatureTag;
    location lTarget = GetLocalLocation(oPC,"actandsummonlocation");
    float fDuration = TurnsToSeconds(12);

    if(GetResRef(oItem)=="actand_demonic")
    {
      sCreatureTag = "ds_demon_summon";
    }
    else if(GetResRef(oItem)=="actand_angelic")
    {
      sCreatureTag = "ds_angel_summon";
    }

    // The summon creature effect.
    effect eSummonCreature = EffectSummonCreature( sCreatureTag, nVFX, 1.0, 0 );

    // Now we summon it.
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eSummonCreature, lTarget, fDuration );

    // Spit out some duration feedback to the PC.
    SendMessageToPC( oPC, "Duration: "+IntToString( FloatToInt( fDuration ) )+" seconds." );
}
