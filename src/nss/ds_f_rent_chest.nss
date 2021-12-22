/*
  Faction area rental chest script.

  The idea is that job system items are converted into reputation points
  for the players to unlock and progress their settlement.

  Author: Maverick00053
  Date: October 2017

//colors and codes
const string CLR_ORANGE             = "<cþ¥ >";
const string CLR_RED                = "<cþ  >";
const string CLR_GRAY               = "<cŒŒŒ>";
const string CLR_BLUE               = "<c  þ>";
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
   if((sItem == "<cþ¥ >Copper Ore</c>") || (sItem == "<cþ¥ >Tin Ore</c>") || (sItem == "<cþ¥ >Zinc Ore</c>") || (sItem == "<cþ¥ >Adamantine Ore</c>") || (sItem == "<cþ¥ >Gold Ore</c>") || (sItem == "<cþ¥ >Iron Ore</c>") || (sItem == "<cþ¥ >Black Iron Ore</c>") || (sItem == "<cþ¥ >Cold Iron Ore</c>") || (sItem == "<cþ¥ >Lead Ore</c>") || (sItem == "<cþ¥ >Mithral Ore</c>") || (sItem == "<cþ¥ >Platinum Ore</c>") || (sItem == "<cþ¥ >Mercury Ore</c>"))
   {
       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);

   } // Check the ingots next
   else if((sItem == "<cþ¥ >Copper Ingot</c>") || (sItem == "<cþ¥ >Tin Ingot</c>") || (sItem == "<cþ¥ >Zinc Ingot</c>") || (sItem == "<cþ¥ >Adamantine Ingot</c>") || (sItem == "<cþ¥ >Gold Ingot</c>") || (sItem == "<cþ¥ >Iron Ingot</c>") || (sItem == "<cþ¥ >Black Iron Ingot</c>") || (sItem == "<cþ¥ >Cold Iron Ingot</c>") || (sItem == "<cþ¥ >Lead Ingot</c>") || (sItem == "<cþ¥ >Mithral Ingot</c>") || (sItem == "<cþ¥ >Platinum Ingot</c>") || (sItem == "<cþ¥ >Mercury Bottle</c>") || (sItem == "<cþ¥ >Darksteel Ingot</c>") || (sItem == "<cþ¥ >Steel Ingot</c>") || (sItem == "<cþ¥ >Brass Ingot</c>") || (sItem == "<cþ¥ >Bronze Ingot</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   } // Logs - Ash, Cedar, Darkwood, Duskwood, Ironwood, Oak, Pine, Yew
   else if((sItem == "<cþ¥ >Logs</c>") || (sItem == "<cþ¥ >Ash Logs</c>") || (sItem == "<cþ¥ >Cedar Logs</c>") || (sItem == "<cþ¥ >Darkwood Logs</c>") || (sItem == "<cþ¥ >Duskwood Logs</c>") || (sItem == "<cþ¥ >Ironwood Logs</c>") || (sItem == "<cþ¥ >Oak Logs</c>") || (sItem == "<cþ¥ >Pine Logs</c>") || (sItem == "<cþ¥ >Yew Logs</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);

   }// Planks - Ash, Cedar, Darkwood, Duskwood, Ironwood, Oak, Pine, Yew
   else if((sItem == "<cþ¥ >Planks</c>") || (sItem == "<cþ¥ >Ash Planks</c>") || (sItem == "<cþ¥ >Cedar Planks</c>") || (sItem == "<cþ¥ >Darkwood Planks</c>") || (sItem == "<cþ¥ >Duskwood Planks</c>") || (sItem == "<cþ¥ >Ironwood Planks</c>") || (sItem == "<cþ¥ >Oak Planks</c>") || (sItem == "<cþ¥ >Pine Planks</c>") || (sItem == "<cþ¥ >Yew Planks</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   }// Cloth
   else if((sItem == "<cþ¥ >Cotton</c>") || (sItem == "<cþ¥ >Rothe Wool</c>") || (sItem == "<cþ¥ >Silk</c>") || (sItem == "<cþ¥ >Spidersilk</c>") || (sItem == "<cþ¥ >Wool</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 1*nStack;
       DestroyObject(oItem);
   }//Bolts
   else if((sItem == "<cþ¥ >Bolts</c>") || (sItem == "<cþ¥ >Bolt of Cotton</c>") || (sItem == "<cþ¥ >Bolt of Rothe Wool</c>") || (sItem == "<cþ¥ >Bolts</c>") || (sItem == "<cþ¥ >Bolt of Silk</c>")  || (sItem == "<cþ¥ >Bolt of Woolen Cloth</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   }// Food
   else if((sItem == "<cþ¥ >Apple Pie</c>") || (sItem == "<cþ¥ >Bacon Omelette</c>") || (sItem == "<cþ¥ >Bacon Salad</c>") || (sItem == "<cþ¥ >Apple Pie</c>") || (sItem == "<cþ¥ >Bangers 'n Shrooms</c>") || (sItem == "<cþ¥ >Apple Pie</c>") || (sItem == "<cþ¥ >Barrelstalk Hotpot</c>") || (sItem == "<cþ¥ >Battered Bass</c>") || (sItem == "<cþ¥ >Bread</c>") || (sItem == "<cþ¥ >Cake</c>") || (sItem == "<cþ¥ >Cabbage in a Jacket</c>") || (sItem == "<cþ¥ >Cabbage with Apples</c>") || (sItem == "<cþ¥ >Carrot Pie</c>") || (sItem == "<cþ¥ >Carrot Soup</c>") || (sItem == "<cþ¥ >Filled Dates</c>") || (sItem == "<cþ¥ >Clubmoss Sandwich</c>") || (sItem == "<cþ¥ >Coconut Cookies</c>") || (sItem == "<cþ¥ >Deep Truffle Platter</c>") || (sItem == "<cþ¥ >Flaming Beef Steak</c>") || (sItem == "<cþ¥ >French Toast</c>") || (sItem == "<cþ¥ >Fried Bass</c>") || (sItem == "<cþ¥ >Honey Bread</c>") || (sItem == "<cþ¥ >Honey Glazed Ham</c>") || (sItem == "<cþ¥ >Hot Chicken Wings</c>") || (sItem == "<cþ¥ >Meat Balls</c>") || (sItem == "<cþ¥ >Onion Soup</c>") || (sItem == "<cþ¥ >Porridge</c>") || (sItem == "<cþ¥ >Quiche</c>") || (sItem == "<cþ¥ >Raisin Cookies</c>") || (sItem == "<cþ¥ >Roasted Rothe</c>") || (sItem == "<cþ¥ >Rothe and Morels</c>") || (sItem == "<cþ¥ >Salad</c>") || (sItem == "<cþ¥ >Salmon Patties</c>") || (sItem == "<cþ¥ >Scrambled Eggs</c>") || (sItem == "<cþ¥ >Slave Soup</c>") || (sItem == "<cþ¥ >Slippery Veggies</c>") || (sItem == "<cþ¥ >Smoaked Salmon</c>") || (sItem == "<cþ¥ >Spicy Spoorbread</c>")
   || (sItem == "<cþ¥ >Spoorbread</c>") || (sItem == "<cþ¥ >Stewed Boletes</c>") || (sItem == "<cþ¥ >Stewed Trout</c>") || (sItem == "<cþ¥ >Sugared Fruit</c>") || (sItem == "<cþ¥ >Sweet Carrots</c>") || (sItem == "<cþ¥ >Wonderball</c>") || (sItem == "<cþ¥ >Zurkstalk Jerky</c>") || (sItem == "<cþ¥ >Fire Sauce</c>") || (sItem == "<cþ¥ >Hot Sauce</c>"))
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 2*nStack;
       DestroyObject(oItem);

   }//Stone, Bricks, Sandstone, misc etc
   else if((sItem == "<cþ¥ >Stone</c>") || (sItem == "<cþ¥ >Bricks</c>") || (sItem == "<cþ¥ >Sandstone</c>") || (sItem == "<cþ¥ >Empty Pages</c>") || (sItem == "<cþ¥ >Empty Book</c>") )
   {

       nStack = GetItemStackSize(oItem);
       nCount = nCount + 3*nStack;
       DestroyObject(oItem);

   } // Clay, Mortar, Sand, Granite, misc etc
    else if((sItem == "<cþ¥ >Clay</c>") || (sItem == "<cþ¥ >Mortar</c>") || (sItem == "<cþ¥ >Sand</c>") || (sItem == "<cþ¥ >Granite</c>") || (sItem == "<cþ¥ >Leather</c>") || (sItem == "<cþ¥ >Hide</c>") || (sItem == "<cþ¥ >Umber Hulk Hide</c>") || (sItem == "<cþ¥ >Wyvern Hide</c>") || (sItem == "<cþ¥ >Wyvern Leather</c>") || (sItem == "<cþ¥ >Steak (Beef)</c>") || (sItem == "<cþ¥ >Sugar</c>") || (sItem == "<cþ¥ >Sugar Cane</c>") || (sItem == "<cþ¥ >Trout</c>") || (sItem == "<cþ¥ >Sirloin (Beef)</c>") || (sItem == "<cþ¥ >Shoulder(Mutton)</c>") || (sItem == "<cþ¥ >Salmon</c>") || (sItem == "<cþ¥ >Sausages (Game)</c>")
    || (sItem == "<cþ¥ >Rothe Loin</c>") || (sItem == "<cþ¥ >Rothe Filet</c>") || (sItem == "<cþ¥ >Papyrus</c>") || (sItem == "<cþ¥ >Onions</c>") || (sItem == "<cþ¥ >Purple Chanterelles</c>") || (sItem == "<cþ¥ >Mustard Moss</c>") || (sItem == "<cþ¥ >Minced Mutton</c>") || (sItem == "<cþ¥ >Meat (Game)</c>") || (sItem == "<cþ¥ >Lesser Clubmoss</c>") || (sItem == "<cþ¥ >Leg (Pork)</c>") || (sItem == "<cþ¥ >Hops</c>") || (sItem == "<cþ¥ >Honey</c>") || (sItem == "<cþ¥ >Ham (Pork)</c>") || (sItem == "<cþ¥ >Golden Bolete</c>") || (sItem == "<cþ¥ >Flour</c>") || (sItem == "<cþ¥ >Chicken (Poultry</c>") || (sItem == "<cþ¥ >Chicken Wings (Poultry</c>")
    || (sItem == "<cþ¥ >Almonds</c>") || (sItem == "<cþ¥ >Apples</c>") || (sItem == "<cþ¥ >Bananas</c>") || (sItem == "<cþ¥ >Barley</c>") || (sItem == "<cþ¥ >Bass</c>") || (sItem == "<cþ¥ >Barrelstalk</c>") || (sItem == "<cþ¥ >Bluecap</c>") || (sItem == "<cþ¥ >Butter</c>") || (sItem == "<cþ¥ >Cabbage</c>") || (sItem == "<cþ¥ >Carrots</c>") || (sItem == "<cþ¥ >Cheese</c>") || (sItem == "<cþ¥ >Cherries</c>") || (sItem == "<cþ¥ >Coconut</c>") || (sItem == "<cþ¥ >Dates</c>") || (sItem == "<cþ¥ >Eggs</c>") || (sItem == "<cþ¥ >Deep Truffle</c>"))
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
