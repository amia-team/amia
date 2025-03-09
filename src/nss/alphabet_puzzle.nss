/*
  Alphabet Puzzle Generation Script  - On Use Script for Puzzle PLC
- Maverick00053

*/
void PrimePuzzle(object oPLC);
void GeneratePuzzle(object oPLC, int nOptions, int nLetters);
void GenerateLetter(string sUniqueID, int nWP, string sLetter);
void ResetPuzzle(object oPLC, object oPC);

void main()
{
   object oPC = OBJECT_SELF;
   object oPLC = GetLocalObject(oPC,"alphabet");
   int nActivated = GetLocalInt(oPLC,"activated");
   int nBlock = GetLocalInt(oPLC,"block");
   int nDamage = GetMaxHitPoints(oPC)/2;
   effect eDamage = EffectDamage(nDamage,DAMAGE_TYPE_ELECTRICAL);
   effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
   string nWordSet;
   string sAnswer;

   if(nBlock==1)
   {
    AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device appears unusable at this time**</c>"));
    return;
   }

   if(nActivated==1)
   {
     nWordSet = GetLocalString(oPLC,"pickedWord");
     sAnswer = GetLocalString(oPC, "last_chat");
     if(GetStringLowerCase(sAnswer) != GetStringLowerCase(nWordSet))
     {
      AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device rejects your answer and shocks you**</c>"));
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);
     }
     else
     {
      ResetPuzzle(oPLC,oPC);
     }
   }
   else
   {
     AssignCommand(oPLC,ActionSpeakString("<c ¿ >**As you touch the device it shimmers with magic**</c>"));
     PrimePuzzle(oPLC);
     SetLocalInt(oPLC,"activated",1);
   }
}

void PrimePuzzle(object oPLC)
{
  string sWord = GetLocalString(oPLC,"word1");
  int nLetters = GetLocalInt(oPLC,"letterCount");

  int nOptions = 0;

  while(sWord != "")
  {
    nOptions++;
    sWord = GetLocalString(oPLC,"word" + IntToString(nOptions+1));
  }

  GeneratePuzzle(oPLC,nOptions,nLetters);
}

void GeneratePuzzle(object oPLC, int nOptions, int nLetters)
{
  int nRandomOptions = Random(nOptions)+1;
  int nRandomPlacement = Random(nLetters)+1;
  string sWord = GetLocalString(oPLC,"word" + IntToString(nRandomOptions));
  string sUniqueID = GetLocalString(oPLC,"ID");
  sWord = GetStringLowerCase(sWord);
  int nCount;

  if(nLetters == 2)
  {
    switch(Random(2)+1)
    {
      case 1: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); break;
      case 2: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); break;
    }
  }
  else if(nLetters == 3)
  {
    switch(Random(6)+1)
    {
      case 1: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); break;
      case 2: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); break;
      case 3: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); break;
      case 4: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); break;
      case 5: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); break;
      case 6: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); break;
    }
  }
  else if(nLetters == 4)
  {
    switch(Random(20)+1)
    {
      case 1: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); break;
      case 2: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); break;
      case 3: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); break;
      case 4: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 5: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
      case 6: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); break;
      case 7: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
      case 8: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
      case 9: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); break;
      case 10: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
      case 11: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); break;
      case 12: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 13: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 14: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); break;
      case 15: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
      case 16: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 17: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 18: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); break;
      case 19: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); break;
      case 20: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); break;
    }

  }
  else if(nLetters == 5)
  {
    switch(Random(20)+1)
    {
      case 1: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1)); break;
      case 2: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1));  break;
      case 3: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,4,1));  break;
      case 4: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1));  break;
      case 5: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,4,1));  break;
      case 6: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1));  break;
      case 7: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1));  break;
      case 8: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,4,1));  break;
      case 9: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1));  break;
      case 10: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1));  break;
      case 11: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1));  break;
      case 12: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1));  break;
      case 13: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1));  break;
      case 14: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1));  break;
      case 15: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1));  break;
      case 16: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1));  break;
      case 17: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,4,1));  break;
      case 18: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1));  break;
      case 19: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1));  break;
      case 20: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1));  break;
    }

  }
  else if(nLetters == 6)
  {
    switch(Random(20)+1)
    {
      case 1: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,5,1)); break;
      case 2: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,3,1));  GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,5,1));  break;
      case 3: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,4,1));  GenerateLetter(sUniqueID,1,GetSubString(sWord,5,1));  break;
      case 4: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,5,1));  break;
      case 5: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,2,1));  GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,5,1));  break;
      case 6: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,2,1));  GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,5,1));  break;
      case 7: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,5,1));   break;
      case 8: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,4,1));  GenerateLetter(sUniqueID,3,GetSubString(sWord,5,1));  break;
      case 9: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,1,1));  GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,5,1));  break;
      case 10: GenerateLetter(sUniqueID,1,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,5,1));   break;
      case 11: GenerateLetter(sUniqueID,6,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,5,1));  break;
      case 12: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,4,1));  GenerateLetter(sUniqueID,4,GetSubString(sWord,5,1));  break;
      case 13: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,4,1));  GenerateLetter(sUniqueID,5,GetSubString(sWord,5,1));  break;
      case 14: GenerateLetter(sUniqueID,3,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,5,1));   break;
      case 15: GenerateLetter(sUniqueID,2,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,2,1));  GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,5,1));  break;
      case 16: GenerateLetter(sUniqueID,4,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,1,1));  GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,5,1));  break;
      case 17: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,2,1));  GenerateLetter(sUniqueID,1,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,5,1));  break;
      case 18: GenerateLetter(sUniqueID,5,GetSubString(sWord,0,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,6,GetSubString(sWord,3,1));  GenerateLetter(sUniqueID,4,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,5,1));  break;
      case 19: GenerateLetter(sUniqueID,6,GetSubString(sWord,0,1));  GenerateLetter(sUniqueID,2,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,1,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,5,1));  break;
      case 20: GenerateLetter(sUniqueID,6,GetSubString(sWord,0,1));  GenerateLetter(sUniqueID,1,GetSubString(sWord,1,1)); GenerateLetter(sUniqueID,3,GetSubString(sWord,2,1)); GenerateLetter(sUniqueID,5,GetSubString(sWord,3,1)); GenerateLetter(sUniqueID,2,GetSubString(sWord,4,1)); GenerateLetter(sUniqueID,4,GetSubString(sWord,5,1));  break;
    }


  }

  SetLocalString(oPLC,"pickedWord",sWord);
}

void GenerateLetter(string sUniqueID, int nWP, string sLetter)
{
   object WP = GetWaypointByTag("alphabet"+sUniqueID+IntToString(nWP));
   location lWP = GetLocation(WP);
   CreateObject(OBJECT_TYPE_PLACEABLE,"puzzle_"+sLetter,lWP);
}


void ResetPuzzle(object oPLC, object oPC)
{
  string sResRef = GetLocalString(oPLC,"resref");
  string sUniqueID = GetLocalString(oPLC,"ID");
  float fDelay = GetLocalFloat(oPLC,"delay");
  int nLetters = GetLocalInt(oPLC,"letterCount");

  AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device shines bright and you are able to pull free the sealed away item**</c>"));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(184),GetLocation(oPLC));
  CreateItemOnObject(sResRef,oPC);

  SetLocalInt(oPLC,"block",1);
  DelayCommand(fDelay,DeleteLocalInt(oPLC,"block"));
  DeleteLocalInt(oPLC,"activated");

  object oWP;
  object oPuzzleLetter;
  int i;
  for(i=1;i<=nLetters;i++)
  {
   oWP = GetWaypointByTag("alphabet"+sUniqueID+IntToString(i));
   oPuzzleLetter = GetNearestObject(OBJECT_TYPE_PLACEABLE,oWP);

   if(GetSubString(GetResRef(oPuzzleLetter),0,7) == "puzzle_")
   {
    DestroyObject(oPuzzleLetter);
   }
  }

}
