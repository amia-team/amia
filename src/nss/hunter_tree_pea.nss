

void main()
{

   object oPC = GetPCSpeaker();
   AssignCommand(OBJECT_SELF,ActionSpeakString("Take this and leave without causing any harm. *As you look down at the gift handed to you, the Treant steps away slowly and then blends into the trees, disappearing*"));
   CreateItemOnObject("js_hun_treant",oPC);
   DestroyObject(OBJECT_SELF,0.5);
}
