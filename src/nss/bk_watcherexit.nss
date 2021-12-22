
void main()
{
    object oPC = GetExitingObject();
    effect eLoop = GetFirstEffect(oPC);
    int eLoopSpellID;

       // Checks for and removes the class bonus
         while(GetIsEffectValid(eLoop))
         {
          eLoopSpellID = GetEffectSpellId(eLoop);

            if ((GetEffectTag(eLoop) == "watcherts"))
            {
                 RemoveEffect(oPC, eLoop);
            }
                eLoop=GetNextEffect(oPC);
         }

}
