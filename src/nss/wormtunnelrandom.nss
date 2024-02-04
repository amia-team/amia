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
     int nRandom = Random(6)+1;

     switch(nRandom)
     {
      case 1: SetLocalInt(oTrigger,"setOne",1); SetLocalInt(oTrigger,"setTwo",3); break;
      case 2: SetLocalInt(oTrigger,"setOne",2); SetLocalInt(oTrigger,"setTwo",6); break;
      case 3: SetLocalInt(oTrigger,"setOne",3); SetLocalInt(oTrigger,"setTwo",4); break;
      case 4: SetLocalInt(oTrigger,"setOne",4); SetLocalInt(oTrigger,"setTwo",5); break;
      case 5: SetLocalInt(oTrigger,"setOne",5); SetLocalInt(oTrigger,"setTwo",2); break;
      case 6: SetLocalInt(oTrigger,"setOne",1); SetLocalInt(oTrigger,"setTwo",6); break;
     }
   }


}
