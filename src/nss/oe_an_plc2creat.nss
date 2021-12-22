/*  Script: oe_an_plc2creat
    By: Anatida (much thanks to Faded Wings!!) 06/05/2014

    Deletes a placeable and spawns in the hostile creature. Respawns placeable
    after delay to reset for next round of PCs.

    Apply to trigger OnEnter*/


#include "nw_i0_generic"

void spawnCreature(string sCreature, location lTarget);
void spawnPLC(string sTemplate, location lTarget);

void main()
{

object oPC = GetEnteringObject();
string sMyWP = GetLocalString(OBJECT_SELF, "MyWP");   //Get tag of WP to mark location
string sMyPlace = GetLocalString(OBJECT_SELF, "MyPlace");   //Get tag of Placeable to destroy
string sMyCreature = GetLocalString(OBJECT_SELF, "MyCreature");  //Get resref of Creature to spawn
string sTemplate = GetLocalString(OBJECT_SELF, "MyTemplate"); //Template of Placeable to respawn
object oSpawn;

if (!GetIsPC(oPC)) return;
if (GetLocalInt(OBJECT_SELF, "Block")== 1)return;

// Make the vines move as the tree stirs to action
effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
object oTarget = GetWaypointByTag(sMyWP);
location lTarget = GetLocation(oTarget);
int nDuration = 1;
 ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

object oPlaceable =  GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_PLACEABLE, PERSISTENT_ZONE_ACTIVE);

SendMessageToPC(oPC, "The giant tree stirs to life!");
DestroyObject(oPlaceable, 1.0); //Destroy the placeable
SendMessageToPC(oPC, "Destroyed oPlaceable");

// Spawn the creature with a nice polymorph vfx
effect eEffect = EffectVisualEffect(VFX_IMP_POLYMORPH);
DelayCommand(1.95, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, lTarget));
DelayCommand(2.0, spawnCreature(sMyCreature, lTarget));
oSpawn = GetObjectByTag(sMyCreature);


SetIsTemporaryEnemy(oPC, oSpawn);
AssignCommand(oSpawn, ActionAttack(oPC));

SetLocalInt(OBJECT_SELF, "Block", 1);


//Wait 20 minutes and spawn a new placeable to reset for the next group
DelayCommand(1200.0, spawnPLC(sTemplate, lTarget));
DelayCommand(1201.0, SetLocalInt(OBJECT_SELF, "Block", 0));

}

void spawnCreature(string sCreature, location lTarget)
{
    CreateObject(OBJECT_TYPE_CREATURE, sCreature, lTarget, FALSE, "");
}

void spawnPLC(string sTemplate, location lTarget)
{
    CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lTarget, FALSE, "");
}
