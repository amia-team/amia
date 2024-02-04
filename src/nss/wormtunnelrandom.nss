/*
  Randomizes the tunnel exits that lead to the Purple Worm Arena
  - Maverick00053
*/

void main()
{
   object oTrigger = OBJECT_SELF;
   object oPC = GetEnteringObject();
   int nSet = GetLocalInt(oTrigger,"set");

   if(nSet==0)
   {
     SetLocalInt(oTrigger,"set",1);
     int nRandom1 = Random(3)+1;
     int nRandom2 = Random(3)+1;

     switch(nRandom1)
     {
      case 1: SetLocalInt(oTrigger,"setOne",1); break;
      case 2: SetLocalInt(oTrigger,"setOne",2); break;
      case 3: SetLocalInt(oTrigger,"setOne",3); break;
     }

     switch(nRandom2)
     {
      case 1: SetLocalInt(oTrigger,"setTwo",4); break;
      case 2: SetLocalInt(oTrigger,"setTwo",5); break;
      case 3: SetLocalInt(oTrigger,"setTwo",6); break;
     }
   }


}
