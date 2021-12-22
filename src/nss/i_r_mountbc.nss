/*
   Cav - Bottle Companion For Horse

*/

void main()
{

   object oPC          = GetItemActivator();
   object oWidget      = GetItemActivated();
   object oMountWidget = GetItemPossessedBy(oPC, "r_mountwidget");
   object oNPC;
   object oHorse       = GetLocalObject(oPC,"ds_horse");
   int horse           = GetLocalInt(oMountWidget, "horse");
   int mounted         = GetLocalInt(oMountWidget,"mounted");
   int nAppearance     = 0;
   string sName        = GetName(oPC);

   if(mounted == 1)
   {
     SendMessageToPC(oPC,"Cannot be mounted");
     return;
   }


   // If horse doesnt match one of the presents it must be a custom horse
   if((horse != 16) && (horse != 18) && (horse != 19) && (horse != 21) && (horse != 22) && (horse != 29)
   && (horse != 31) && (horse != 32) && (horse != 34) && (horse != 35) && (horse != 42) && (horse != 44)
   && (horse != 45) && (horse != 47) && (horse != 48) && (horse != 55) && (horse != 58) && (horse != 60)
   && (horse != 61) && (horse != 68) && (horse != 308) && (horse != 309) && (horse != 67))
   {
      if(horse == GetLocalInt(oWidget,"custom1"))
      {
        nAppearance = GetLocalInt(oWidget,"custom1BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom2"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom2BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom3"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom3BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom4"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom4BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom5"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom5BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom6"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom6BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom7"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom7BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom8"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom8BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom9"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom9BC");
      }
      else if(horse == GetLocalInt(oWidget,"custom10"))
      {
        nAppearance =  GetLocalInt(oWidget,"custom10BC");
      }

   }

   // Setting the appearance for Worg/Spider skins
   if(horse == (308)) // Worg
   {
       nAppearance = 185;
   }
   else if(horse == (309) ) // Spider
   {
       nAppearance = 159;
   }

   // Setting appearance if no choice is picked
   if(horse == 0)
   {
     nAppearance = 16 + 481;
   }

   // Setting appearance if it hasnt been set yet
   if(nAppearance == 0)
   {
     nAppearance = horse + 481;
   }

   if(!GetIsObjectValid(oHorse))  // If horse isn't present then release it
   {
   oNPC = CreateObject( OBJECT_TYPE_CREATURE, "mount_basehorse", GetLocation( oPC ), FALSE);
   SetCreatureAppearanceType(oNPC,nAppearance);
   SetName(oNPC, sName +"'s Mount");
   SetLocalObject( oNPC, "ds_master", oPC );
   SetLocalObject( oPC, "ds_horse", oNPC );
   AddHenchman(oPC,oNPC);
   }
   else // If horse is present, remove it
   {
     DestroyObject(oHorse,0.5);
     DeleteLocalObject(oPC, "ds_horse");
   }









}
