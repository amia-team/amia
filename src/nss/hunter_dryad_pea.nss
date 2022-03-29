

void main()
{

   object oPC = GetPCSpeaker();
   AssignCommand(OBJECT_SELF,ActionSpeakString("Take this and leave without causing any harm. *As you look down at the gift handed to you, the Dryad seems to disappear*"));
   CreateItemOnObject("js_hun_dryad",oPC);
   DestroyObject(OBJECT_SELF,0.5);
}
