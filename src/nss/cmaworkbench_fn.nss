/*
   Craft Magical Arms Workbench finish script
   - Maverick00053 2/20/24

*/

const int GOLD_COST = 50000; // Gold Cost


void CraftMagicalArms(object oPC, object oItems,object oPLC);

void main()
{
    object oPC = OBJECT_SELF;
    object oPLC = GetNearestObjectByTag("cmaworkbench");
    int nFound;
    int nGold = GetGold(oPC);

    if(nGold < GOLD_COST)
    {
     SendMessageToPC(oPC,"You do not have enough gold.");
     return;
    }

    object oItems = GetFirstItemInInventory(oPLC);

    while(GetIsObjectValid(oItems))
    {
      if(GetTag(oItems)=="cmarequired")
      {
         nFound=1;
         break;
      }
      oItems = GetNextItemInInventory(oPLC);
    }

    if(nFound==1)
    {
      CraftMagicalArms(oPC, oItems,oPLC);
      TakeGoldFromCreature(GOLD_COST,oPC,TRUE);
    }
    else
    {
     SendMessageToPC(oPC,"There are no craftable objects inside.");
    }
}

void CraftMagicalArms(object oPC, object oItems,object oPLC)
{
   string sResRef = GetLocalString(oItems,"finalResRef");
   effect eVFX1 = EffectVisualEffect(459); // On workbench VFX
   effect eVFX2 = EffectVisualEffect(74); // On NPC caster
   object oNPC = GetNearestObjectByTag("cmanpc",oPLC);


   if(sResRef=="")
   {
    SendMessageToPC(oPC,"ERROR: Varible not set on item properly. Report to DMs.");
    return;
   }

   AssignCommand(oNPC,PlayAnimation(ANIMATION_LOOPING_CONJURE2,1.0,2.0));
   DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX2,oNPC));
   DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX1,oPLC));
   DelayCommand(2.0,AssignCommand(oNPC,SpeakString("There! The process is now complete.")));

   CreateItemOnObject(sResRef,oPLC);
   DestroyObject(oItems);



}
