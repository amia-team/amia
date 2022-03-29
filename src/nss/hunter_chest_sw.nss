/*
   Hunter Job - Big Game Hunt Chest Spawner
   - Maverick00053
*/

void main()
{
   object oChest = OBJECT_SELF;
   string nResRef = GetResRef(oChest);
   int nOpened = GetLocalInt(oChest,"opened");
   int nRandom = Random(100)+1;

   if((nResRef=="hunter_chest_5") && (nOpened==0))
   {
     CreateItemOnObject("goldpiece",oChest,Random(2000));
     if(nRandom <= 50)
     {
       CreateItemOnObject("js_scho_anc",oChest);
     }
     else if(nRandom <= 100)
     {
       CreateItemOnObject("js_gem_ivor",oChest);
     }

     SetLocalInt(oChest,"opened",1);
   }
   else if((nResRef=="hunter_chest_15") && (nOpened==0))
   {
     CreateItemOnObject("goldpiece",oChest,Random(5000));
     SetLocalInt(oChest,"opened",1);
   }
   else if((nResRef=="hunter_chest_25") && (nOpened==0))
   {
     CreateItemOnObject("goldpiece",oChest,Random(10000));
     SetLocalInt(oChest,"opened",1);
   }


}
