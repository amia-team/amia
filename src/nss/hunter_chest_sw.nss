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
     CreateItemOnObject("goldpiece",oChest,(500 + Random(1500)));
     if(nRandom <= 15)
     {
       CreateItemOnObject("js_scho_anc",oChest);
     }
     else if(nRandom <= 50)
     {
       CreateItemOnObject("js_gem_ivor",oChest);
     }

     SetLocalInt(oChest,"opened",1);
   }
   else if((nResRef=="hunter_chest_15") && (nOpened==0))
   {
     CreateItemOnObject("goldpiece",oChest,(1000 + Random(4000)));

     if(nRandom <= 30)
     {
       CreateItemOnObject("js_scho_anc",oChest);
     }
     else if(nRandom <= 75)
     {
       CreateItemOnObject("js_gem_ivor",oChest);
     }

     SetLocalInt(oChest,"opened",1);
   }
   else if((nResRef=="hunter_chest_25") && (nOpened==0))
   {
     CreateItemOnObject("goldpiece",oChest,(2000 + Random(8000)));

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


}
