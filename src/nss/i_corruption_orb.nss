/*
   Abyssal Corrupted Orb - Will grant the feat for the class on use
   ------------
   12/10/21 - Maverick00053
*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwnx_feat"
#include "nwnx_creature"

void main()
{
     object oPC = GetItemActivator();
     object oWidget = GetItemActivated();
     int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);

     if(nPaladin >= 1)
     {
       SendMessageToPC(oPC,"*You feel evil, and darkness fill you as you consume the orb. As the corruption tries to take you, your body heats up and you feel divine energy enter your body, stopping and then removing the corruption. Praise be to your god.*");
       return;
     }

     AdjustAlignment(oPC,ALIGNMENT_CHAOTIC,10);
     AdjustAlignment(oPC,ALIGNMENT_EVIL,10);
     DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1257) ); // 1249 Corruption
     SendMessageToPC(oPC,"*You feel evil, and darkness fill you as you consume the orb. As the corruption attacks, twists and mutates your body you begin to feel your brain itch, your morals change, and something grasps tightly onto the depths of your soul*");

}
