/*
Editted: Maverick00053 April 15 2019
Custom Horse Widget for Rider class

Edit: August 15th 2019 - Did a bug fix.
~~
*/
#include "x2_inc_switches"
#include "inc_ds_records"

void LaunchConvo( object oPC);
void SetCustomHorseTokens( object oPC);
void SetCheck( object oPC, object oWidget);
void AdjustHorse( object oPC, int nNode);

void LaunchConvo( object oPC){
    SetLocalString(oPC,"ds_action","i_r_mountwidget");
    SetCustomHorseTokens(oPC);
    AssignCommand(oPC, ActionStartConversation(oPC, "c_mountwidget", TRUE, FALSE));

}


void main()
{

    object oPC          = GetItemActivator();
    object oWidget      = GetItemActivated();
    int nNode           = GetLocalInt( oPC, "ds_node" );
    string sAction      = GetLocalString( oPC, "ds_action");
    int horse           = GetLocalInt( oWidget, "horse");

    SetCheck( oPC, oWidget );

    // Checks to see if the script has run once, if it did not it runs though the convo file
    if(sAction != "i_r_mountwidget")
    {
       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);

    }
    else if(nNode > 0)
    {

      if( 35 >= nNode >= 1)
      {
         AdjustHorse( oPC, nNode);
         SetLocalInt( oPC, "ds_node", 0 );
         SetLocalString( oPC, "ds_action", "" );
         return;
      }




    }
    else if(nNode == 0) // If the ds_action variable is set, but a choice wasn't made this will refire the convo script so they can make a choice
    {

       SetLocalInt( oPC, "ds_node", 0 );
       SetLocalString( oPC, "ds_action", "" );
       LaunchConvo(oPC);
    }


}

void SetCustomHorseTokens( object oPC)
{
  object oWidget = GetItemPossessedBy(oPC, "r_mountwidget");
  SetCustomToken(696969101,GetLocalString(oWidget,"custom1Name"));
  SetCustomToken(696969102,GetLocalString(oWidget,"custom2Name"));
  SetCustomToken(696969103,GetLocalString(oWidget,"custom3Name"));
  SetCustomToken(696969104,GetLocalString(oWidget,"custom4Name"));
  SetCustomToken(696969105,GetLocalString(oWidget,"custom5Name"));
  SetCustomToken(696969106,GetLocalString(oWidget,"custom6Name"));
  SetCustomToken(696969107,GetLocalString(oWidget,"custom7Name"));
  SetCustomToken(696969108,GetLocalString(oWidget,"custom8Name"));
  SetCustomToken(696969109,GetLocalString(oWidget,"custom9Name"));
  SetCustomToken(696969110,GetLocalString(oWidget,"custom10Name"));
}

void SetCheck( object oPC, object oWidget)
{
  int nRacialType = GetRacialType(oPC);
  int nBGLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD,oPC);


  SetLocalInt(oPC,"ds_check_1",1);


  if(nBGLevel >= 1)
  {
     SetLocalInt(oPC,"ds_check_2",1);
  }

  if(nRacialType == RACIAL_TYPE_HUMANOID_GOBLINOID || nRacialType == 38)
  {
     SetLocalInt(oPC,"ds_check_3",1);
     SetLocalInt(oPC,"ds_check_1",0);
  }

  int i;  // For loop, it loops through custom 1 to 10 and checks to see if there is a custom set mount
  for(i=1; i<=10; i++)
  {
   if(GetLocalInt(oWidget,"custom"+IntToString(i)) != 0)
   {
     SetLocalInt(oPC,"ds_check_"+IntToString(i+3),1);
   }
  }



}



void AdjustHorse( object oPC, int nNode)
{

      object oWidget = GetItemPossessedBy(oPC, "r_mountwidget");

      if(nNode == 1)  // 16 "Horse, Walnut, saddle"
      {
        SetLocalInt(oWidget,"horse",16);
        SetName(oWidget,"Mount: Horse, Walnut, Saddle");
      }
      else if(nNode == 2) // 18 "Horse, Walnut, leather barding"
      {
        SetLocalInt(oWidget,"horse",18);
        SetName(oWidget,"Mount: Horse, Walnut, Leather Barding");
      }
      else if(nNode == 3) // 19 "Horse, Walnut, scale mail barding"
      {
        SetLocalInt(oWidget,"horse",19);
        SetName(oWidget,"Mount: Horse, Walnut, Scale Mail Barding");
      }
      else if(nNode == 4) // 21 "Horse, Walnut, purple barding"
      {
        SetLocalInt(oWidget,"horse",21);
        SetName(oWidget,"Mount: Horse, Walnut, Purple Barding");
      }
      else if(nNode == 5)// 22 "Horse, Walnut, red barding"
      {
        SetLocalInt(oWidget,"horse",22);
        SetName(oWidget,"Mount: Horse, Walnut, Red Barding");
      }
      else if(nNode == 6)// 29 "Horse, Gunpowder, saddle"
      {
        SetLocalInt(oWidget,"horse",29);
        SetName(oWidget,"Mount: Horse, Gunpowder, Saddle");
      }
      else if(nNode == 7)//31 "Horse, Gunpowder, leather barding"
      {
        SetLocalInt(oWidget,"horse",31);
        SetName(oWidget,"Mount: Horse, Gunpowder, Leather Barding");
      }
      else if(nNode == 8)//32 "Horse, Gunpowder, scale mail barding"
      {
        SetLocalInt(oWidget,"horse",32);
        SetName(oWidget,"Mount: Horse, Gunpowder, Scale Mail Barding");
      }
      else if(nNode == 9)// 34 "Horse, Gunpowder, purple barding"
      {
        SetLocalInt(oWidget,"horse",34);
        SetName(oWidget,"Mount: Horse, Gunpowder, Purple Barding");
      }
      else if(nNode == 10)// 35 "Horse, Gunpowder, red barding"
      {
        SetLocalInt(oWidget,"horse",35);
        SetName(oWidget,"Mount: Horse, Gunpowder, Red Barding");
      }
      else if(nNode == 11)//42 "Horse, Spotted, saddle"
      {
        SetLocalInt(oWidget,"horse",42);
        SetName(oWidget,"Mount: Horse, Spotted, Saddle");
      }
      else if(nNode == 12)//44 "Horse, Spotted, leather barding"
      {
        SetLocalInt(oWidget,"horse",44);
        SetName(oWidget,"Mount: Horse, Spotted, Leather Barding");
      }
      else if(nNode == 13)//45 "Horse, Spotted, scale mail barding"
      {
        SetLocalInt(oWidget,"horse",45);
        SetName(oWidget,"Mount: Horse, Spotted, Scale Mail Barding");
      }
      else if(nNode == 14)//47 "Horse, Spotted, purple barding"
      {
        SetLocalInt(oWidget,"horse",47);
        SetName(oWidget,"Mount: Horse, Spotted, Purple Barding");
      }
      else if(nNode == 15)//48 "Horse, Spotted, red barding"
      {
        SetLocalInt(oWidget,"horse",48);
        SetName(oWidget,"Mount: Horse, Spotted, Red Barding");
      }
      else if(nNode == 16)//55 "Horse, Black, saddle"
      {
        SetLocalInt(oWidget,"horse",55);
        SetName(oWidget,"Mount: Horse, Black, Saddle");
      }
      else if(nNode == 17)//57 "Horse, Black, leather barding"
      {
        SetLocalInt(oWidget,"horse",57);
        SetName(oWidget,"Mount: Horse, Black, Leather Barding");
      }
      else if(nNode == 18)//58 "Horse, Black, scale mail barding"
      {
        SetLocalInt(oWidget,"horse",58);
        SetName(oWidget,"Mount: Horse, Black, Scale Mail Barding");
      }
      else if(nNode == 19)//60 "Horse, Black, purple barding"
      {
        SetLocalInt(oWidget,"horse",60);
        SetName(oWidget,"Mount: Horse, Black, Purple Barding");
      }
      else if(nNode == 20)//61 "Horse, Black, red barding"
      {
        SetLocalInt(oWidget,"horse",61);
        SetName(oWidget,"Mount: Horse, Black, Red Barding");
      }
      else if(nNode == 21)//Nightmare
      {
        SetLocalInt(oWidget,"horse",68);
        SetName(oWidget,"Mount: Nightmare, Saddle");
      }
      else if(nNode == 22)//Goblin Wolf
      {
        SetLocalInt(oWidget,"horse",308);
        SetName(oWidget,"Mount: Worg");
      }
      else if(nNode == 23)//Goblin Spider
      {
        SetLocalInt(oWidget,"horse",309);
        SetName(oWidget,"Mount: Giant Spider");
      }
      else if(nNode == 24)//Nightmare
      {
        SetLocalInt(oWidget,"horse",67);
        SetName(oWidget,"Mount: Nightmare, Barding");
      }
      else if(nNode == 25)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom1"));
        SetName(oWidget,GetLocalString(oWidget,"custom1Name"));
      }
      else if(nNode == 26)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom2"));
        SetName(oWidget,GetLocalString(oWidget,"custom2Name"));
      }
      else if(nNode == 27)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom3"));
        SetName(oWidget,GetLocalString(oWidget,"custom3Name"));
      }
      else if(nNode == 28)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom4"));
        SetName(oWidget,GetLocalString(oWidget,"custom4Name"));
      }
      else if(nNode == 29)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom5"));
        SetName(oWidget,GetLocalString(oWidget,"custom5Name"));
      }
      else if(nNode == 30)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom6"));
        SetName(oWidget,GetLocalString(oWidget,"custom6Name"));
      }
      else if(nNode == 31)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom7"));
        SetName(oWidget,GetLocalString(oWidget,"custom7Name"));
      }
      else if(nNode == 32)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom8"));
        SetName(oWidget,GetLocalString(oWidget,"custom8Name"));
      }
      else if(nNode == 33)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom9"));
        SetName(oWidget,GetLocalString(oWidget,"custom9Name"));
      }
      else if(nNode == 34)//Custom
      {
        SetLocalInt(oWidget,"horse",GetLocalInt(oWidget,"custom10"));
        SetName(oWidget,GetLocalString(oWidget,"custom10Name"));
      }


      SetLocalInt( oPC, "ds_node", 0 );
      SetLocalString( oPC, "ds_action", "" );
      SetLocalInt( oPC, "ds_check_1", 0 );
      SetLocalInt( oPC, "ds_check_2", 0 );
      SetLocalInt( oPC, "ds_check_3", 0 );
      SetLocalInt( oPC, "ds_check_4", 0 );
      SetLocalInt( oPC, "ds_check_5", 0 );
      SetLocalInt( oPC, "ds_check_6", 0 );
      SetLocalInt( oPC, "ds_check_7", 0 );
      SetLocalInt( oPC, "ds_check_8", 0 );
      SetLocalInt( oPC, "ds_check_9", 0 );
      SetLocalInt( oPC, "ds_check_10", 0 );
      SetLocalInt( oPC, "ds_check_11", 0 );
      SetLocalInt( oPC, "ds_check_12", 0 );
      SetLocalInt( oPC, "ds_check_13", 0 );

}
