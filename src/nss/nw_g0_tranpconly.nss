////////////////////////////////////////////////////////////
// OnClick/OnAreaTransitionClick  - No monsters!!!
// NW_G0_TranPCOnly.nss
// Copyright (c) 2001 Bioware Corp.
////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
//:: Modified By: Deva Winblood
//:: Modified On: April 12th, 2008
//:: Added Support for Keeping mounts out of no mount areas
//::////////////////////////////////////////////////////////

//2008-07-25     Disco      reverted to pre-1.69. Throw away if you want horses.

void main()
{
  object oClicker = GetClickingObject();


  // * Only PC's or associates of pc's can do this
  if (GetIsPC(oClicker) || GetIsPC(GetMaster(oClicker)) == TRUE)
  {

      object oTarget = GetTransitionTarget(OBJECT_SELF);

      SetAreaTransitionBMP(AREA_TRANSITION_RANDOM);

      AssignCommand(oClicker,JumpToObject(oTarget));
  }
 /* else
  This turned out to be unnecessary since GetIsPC returns true
  if a player controlled, which includes familiars.
  // * This is an NPC attempting to cross the transition
  // * Clear all actions on it (to prevent system
  // * resource eating by a creature trying to cross
  // * an area transition that it can't
  {
    AssignCommand(oClicker, ClearAllActions());
  }
  */
}

