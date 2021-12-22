//::///////////////////////////////////////////////
//:: abl_an_blinkjmp.nss
//:: Copied from: nw_c2_dimdoor
//:://////////////////////////////////////////////
/*
     Creature randomly hops around
     to enemies during combat.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////

void JumpToWeakestEnemy(object oTarget)
{
    object oTargetVictim = GetFactionMostDamagedMember(oTarget);
    // * won't jump if closer than 4 meters to victim
    if ((GetDistanceToObject(oTargetVictim) > 4.0)   && (GetObjectSeen(oTargetVictim) == TRUE))
    {
        ClearAllActions();
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

//        SpeakString("Jump to " + GetName(oTargetVictim));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
        DelayCommand(0.3,ActionJumpToObject(oTargetVictim));
        DelayCommand(0.5,ActionAttack(oTargetVictim));
    }
}
void main()
{
   //a Removed UserDefined Check so action fires when script is called from
   // Creature's local variables ~Anatida

    // * During Combat try teleporting around
   //a if (GetUserDefinedEventNumber() == 1003)
  //a  {
        // * if random OR heavily wounded then teleport to next enemy
  //a  if ((Random(100) < 50)  ||  ( (GetCurrentHitPoints() / GetMaxHitPoints()) * 100 < 50) )
  //a  {
           JumpToWeakestEnemy(GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY));
  //a  }
  //a  }
}
