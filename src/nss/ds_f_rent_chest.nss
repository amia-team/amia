/*
  Faction area rental chest script.

  The idea is that job system items are converted into reputation points
  for the players to unlock and progress their settlement.

  Author: Maverick00053
  Date: October 2017

//colors and codes
const string CLR_ORANGE             = "<c�� >";
const string CLR_RED                = "<c�  >";
const string CLR_GRAY               = "<c���>";
const string CLR_BLUE               = "<c  �>";
const string CLR_END                = "</c>";



*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"


void main()
{
   object  oChest      = OBJECT_SELF;

   object oItem = GetFirstItemInInventory( oChest );
   string sItem = GetName(oItem);
   object oArea = GetArea(OBJECT_SELF);
   string sArea = GetResRef(oArea);
   int nCount = 0;
   int nStack = 1;
   int nRep = 0;

     // First check to see if they have any reputation, if not make one
     string sQuery = "SELECT int_1 FROM faction_reputation WHERE faction_id='"+sArea+"'";

     SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS )
        {
            nRep  = StringToInt(SQLGetData( 1 ));
        }
        else
        {
               sQuery = "INSERT INTO faction_reputation VALUES ( "
               + "'"+sArea+"', "
               + "'"+IntToString(0)+"', "
               + "'"+IntToString(0)+"', "
               + "'"+IntToString(0)+"')";

            SQLExecDirect( sQuery );

        }



   while(GetIsObjectValid(oItem))
   {
   // Check ore first
   if((sItem == "<c�� >Copper Ore</c>") || (sItem == "<c�� >Tin Ore</c>") || (sItem == "<c�� >Zinc Ore</c>") || (sItem == "<c�� >Adamantine Ore</c>") || (sItem == "<c�� >Gold Ore</c>") || (sItem == "<c�� >Iron Ore</c>") || (sItem == "<c�� >Black Iron Ore</c>") || (sItem == "<c�� >Cold Iron Ore</c>") || (sItem == "<c�� >Lead Ore</c>") || (sItem == "<c�� >Mithral Ore</c>") || (sItem == "<c�� >Platinum Ore</c>") || (sItem == "<c�� >Mercury Ore</c>"))
   {
       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);

   } // Check the ingots next
   else if((sItem == "<c�� >Copper Ingot</c>") || (sItem == "<c�� >Tin Ingot</c>") || (sItem == "<c�� >Zinc Ingot</c>") || (sItem == "<c�� >Adamantine Ingot</c>") || (sItem == "<c�� >Gold Ingot</c>") || (sItem == "<c�� >Iron Ingot</c>") || (sItem == "<c�� >Black Iron Ingot</c>") || (sItem == "<c�� >Cold Iron Ingot</c>") || (sItem == "<c�� >Lead Ingot</c>") || (sItem == "<c�� >Mithral Ingot</c>") || (sItem == "<c�� >Platinum Ingot</c>") || (sItem == "<c�� >Mercury Bottle</c>") || (sItem == "<c�� >Darksteel Ingot</c>") || (sItem == "<c�� >Steel Ingot</c>") || (sItem == "<c�� >Brass Ingot</c>") || (sItem == "<c�� >Bronze Ingot</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   } // Logs - Ash, Cedar, Darkwood, Duskwood, Ironwood, Oak, Pine, Yew
   else if((sItem == "<c�� >Logs</c>") || (sItem == "<c�� >Ash Logs</c>") || (sItem == "<c�� >Cedar Logs</c>") || (sItem == "<c�� >Darkwood Logs</c>") || (sItem == "<c�� >Duskwood Logs</c>") || (sItem == "<c�� >Ironwood Logs</c>") || (sItem == "<c�� >Oak Logs</c>") || (sItem == "<c�� >Pine Logs</c>") || (sItem == "<c�� >Yew Logs</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);

   }// Planks - Ash, Cedar, Darkwood, Duskwood, Ironwood, Oak, Pine, Yew
   else if((sItem == "<c�� >Planks</c>") || (sItem == "<c�� >Ash Planks</c>") || (sItem == "<c�� >Cedar Planks</c>") || (sItem == "<c�� >Darkwood Planks</c>") || (sItem == "<c�� >Duskwood Planks</c>") || (sItem == "<c�� >Ironwood Planks</c>") || (sItem == "<c�� >Oak Planks</c>") || (sItem == "<c�� >Pine Planks</c>") || (sItem == "<c�� >Yew Planks</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   }// Cloth
   else if((sItem == "<c�� >Cotton</c>") || (sItem == "<c�� >Rothe Wool</c>") || (sItem == "<c�� >Silk</c>") || (sItem == "<c�� >Spidersilk</c>") || (sItem == "<c�� >Wool</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);
   }//Bolts
   else if((sItem == "<c�� >Bolts</c>") || (sItem == "<c�� >Bolt of Cotton</c>") || (sItem == "<c�� >Bolt of Rothe Wool</c>") || (sItem == "<c�� >Bolts</c>") || (sItem == "<c�� >Bolt of Silk</c>")  || (sItem == "<c�� >Bolt of Woolen Cloth</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   }// Food
   else if((sItem == "<c�� >Apple Pie</c>") || (sItem == "<c�� >Bacon Omelette</c>") || (sItem == "<c�� >Bacon Salad</c>") || (sItem == "<c�� >Apple Pie</c>") || (sItem == "<c�� >Bangers 'n Shrooms</c>") || (sItem == "<c�� >Apple Pie</c>") || (sItem == "<c�� >Barrelstalk Hotpot</c>") || (sItem == "<c�� >Battered Bass</c>") || (sItem == "<c�� >Bread</c>") || (sItem == "<c�� >Cake</c>") || (sItem == "<c�� >Cabbage in a Jacket</c>") || (sItem == "<c�� >Cabbage with Apples</c>") || (sItem == "<c�� >Carrot Pie</c>") || (sItem == "<c�� >Carrot Soup</c>") || (sItem == "<c�� >Filled Dates</c>") || (sItem == "<c�� >Clubmoss Sandwich</c>") || (sItem == "<c�� >Coconut Cookies</c>") || (sItem == "<c�� >Deep Truffle Platter</c>") || (sItem == "<c�� >Flaming Beef Steak</c>") || (sItem == "<c�� >French Toast</c>") || (sItem == "<c�� >Fried Bass</c>") || (sItem == "<c�� >Honey Bread</c>") || (sItem == "<c�� >Honey Glazed Ham</c>") || (sItem == "<c�� >Hot Chicken Wings</c>") || (sItem == "<c�� >Meat Balls</c>") || (sItem == "<c�� >Onion Soup</c>") || (sItem == "<c�� >Porridge</c>") || (sItem == "<c�� >Quiche</c>") || (sItem == "<c�� >Raisin Cookies</c>") || (sItem == "<c�� >Roasted Rothe</c>") || (sItem == "<c�� >Rothe and Morels</c>") || (sItem == "<c�� >Salad</c>") || (sItem == "<c�� >Salmon Patties</c>") || (sItem == "<c�� >Scrambled Eggs</c>") || (sItem == "<c�� >Slave Soup</c>") || (sItem == "<c�� >Slippery Veggies</c>") || (sItem == "<c�� >Smoaked Salmon</c>") || (sItem == "<c�� >Spicy Spoorbread</c>")
   || (sItem == "<c�� >Spoorbread</c>") || (sItem == "<c�� >Stewed Boletes</c>") || (sItem == "<c�� >Stewed Trout</c>") || (sItem == "<c�� >Sugared Fruit</c>") || (sItem == "<c�� >Sweet Carrots</c>") || (sItem == "<c�� >Wonderball</c>") || (sItem == "<c�� >Zurkstalk Jerky</c>") || (sItem == "<c�� >Fire Sauce</c>") || (sItem == "<c�� >Hot Sauce</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 2*nStack;
       DestroyObject(oItem);

   }//Stone, Bricks, Sandstone, misc etc
   else if((sItem == "<c�� >Stone</c>") || (sItem == "<c�� >Bricks</c>") || (sItem == "<c�� >Sandstone</c>") || (sItem == "<c�� >Empty Pages</c>") || (sItem == "<c�� >Empty Book</c>") )
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   } // Clay, Mortar, Sand, Granite, misc etc
    else if((sItem == "<c�� >Clay</c>") || (sItem == "<c�� >Mortar</c>") || (sItem == "<c�� >Sand</c>") || (sItem == "<c�� >Granite</c>") || (sItem == "<c�� >Leather</c>") || (sItem == "<c�� >Hide</c>") || (sItem == "<c�� >Umber Hulk Hide</c>") || (sItem == "<c�� >Wyvern Hide</c>") || (sItem == "<c�� >Wyvern Leather</c>") || (sItem == "<c�� >Steak (Beef)</c>") || (sItem == "<c�� >Sugar</c>") || (sItem == "<c�� >Sugar Cane</c>") || (sItem == "<c�� >Trout</c>") || (sItem == "<c�� >Sirloin (Beef)</c>") || (sItem == "<c�� >Shoulder(Mutton)</c>") || (sItem == "<c�� >Salmon</c>") || (sItem == "<c�� >Sausages (Game)</c>")
    || (sItem == "<c�� >Rothe Loin</c>") || (sItem == "<c�� >Rothe Filet</c>") || (sItem == "<c�� >Papyrus</c>") || (sItem == "<c�� >Onions</c>") || (sItem == "<c�� >Purple Chanterelles</c>") || (sItem == "<c�� >Mustard Moss</c>") || (sItem == "<c�� >Minced Mutton</c>") || (sItem == "<c�� >Meat (Game)</c>") || (sItem == "<c�� >Lesser Clubmoss</c>") || (sItem == "<c�� >Leg (Pork)</c>") || (sItem == "<c�� >Hops</c>") || (sItem == "<c�� >Honey</c>") || (sItem == "<c�� >Ham (Pork)</c>") || (sItem == "<c�� >Golden Bolete</c>") || (sItem == "<c�� >Flour</c>") || (sItem == "<c�� >Chicken (Poultry</c>") || (sItem == "<c�� >Chicken Wings (Poultry</c>")
    || (sItem == "<c�� >Almonds</c>") || (sItem == "<c�� >Apples</c>") || (sItem == "<c�� >Bananas</c>") || (sItem == "<c�� >Barley</c>") || (sItem == "<c�� >Bass</c>") || (sItem == "<c�� >Barrelstalk</c>") || (sItem == "<c�� >Bluecap</c>") || (sItem == "<c�� >Butter</c>") || (sItem == "<c�� >Cabbage</c>") || (sItem == "<c�� >Carrots</c>") || (sItem == "<c�� >Cheese</c>") || (sItem == "<c�� >Cherries</c>") || (sItem == "<c�� >Coconut</c>") || (sItem == "<c�� >Dates</c>") || (sItem == "<c�� >Eggs</c>") || (sItem == "<c�� >Deep Truffle</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);

   }


   oItem = GetNextItemInInventory(oChest);
}// End of while


    nRep = nRep + nCount;

    sQuery = "DELETE FROM faction_reputation WHERE faction_id='"+sArea+"'";
    SQLExecDirect( sQuery );

    sQuery = "INSERT INTO faction_reputation VALUES ( "
              + "'"+sArea+"', "
              + "'"+IntToString(nRep)+"', "
              + "'"+IntToString(0)+"', "
              + "'"+IntToString(0)+"')";

    SQLExecDirect( sQuery );

 string sRep = IntToString(nRep);
 AssignCommand( oChest, SpeakString("Current Reputation: " + sRep) );

}
