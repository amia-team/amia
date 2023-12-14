/*
   Abyssal Corrupted Orb - Will grant the feat for the class on use
   ------------
   12/10/21 - Maverick00053
   12/13/23 - Mav - Updated to let people select their body part
*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwnx_feat"
#include "nwnx_creature"

void Corruption(object oPC);

void main()
{
     object oPC = OBJECT_SELF;
     object oWidget = GetItemActivated();
     int nNode = GetLocalInt( oPC, "ds_node");
     object oPCKEY = GetItemPossessedBy(oPC,"ds_pckey");

     if(nNode == 1)  // Wings
     {
       SetLocalString(oPCKEY, "abyssalBodyPart","wings");
       Corruption(oPC);
       DestroyObject(oWidget);
     }
     else if(nNode == 2)  // Tail
     {
       SetLocalString(oPCKEY, "abyssalBodyPart","tail");
       Corruption(oPC);
       DestroyObject(oWidget);
     }
     else if(nNode == 3)  // Horns
     {
       int nRandHorns = Random(6)+1;
       SetLocalInt(oPCKEY, "abyssalHorns",nRandHorns);
       SetLocalString(oPCKEY, "abyssalBodyPart","horns");
       Corruption(oPC);
       DestroyObject(oWidget);
     }
     else if(nNode == 4)  // Legs
     {
       SetLocalString(oPCKEY, "abyssalBodyPart","legs");
       Corruption(oPC);
       DestroyObject(oWidget);
     }
}

void Corruption(object oPC)
{
     AdjustAlignment(oPC,ALIGNMENT_CHAOTIC,10,FALSE);
     AdjustAlignment(oPC,ALIGNMENT_EVIL,10,FALSE);
     DelayCommand( 5.0, NWNX_Creature_AddFeat( oPC, 1257) ); // 1249 Corruption
     SendMessageToPC(oPC,"*You feel evil, and darkness fill you as you consume the orb. As the corruption attacks, twists and mutates your body you begin to feel your brain itch, your morals change, and something grasps tightly onto the depths of your soul*");
}
