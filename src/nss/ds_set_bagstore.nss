/*  OnSpawn bag merchant script

    --------
    Verbatim
    --------
    Fills the inventory of a dye merchant with dynamically generated bags.
    This counters adding 3x12 bags to the toolset.
    It uses three template bags stored in Other

    --------
    Use
    --------
    1. Paste the NPC "Bag Store Template" (Special 5) where you want the shop.
    2. Rename and customise the NPC.
    3. Test the shop.

    ---------
    Changelog
    ---------
    Date              Name        Reason
    ------------------------------------------------------------------
    05-28-2006        disco       start of header
    ------------------------------------------------------------------
*/


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void AddBags(object oStore);
void CreateBag(object oStore, string sTemplate, string sName);
string BagName(int nIndex);

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    //get store
    object oStore = GetNearestObjectByTag("ds_bag_store");

    //create store if it isn't available yet or too far away
    //the latter allows for multiple dye stores in one area
    if (oStore == OBJECT_INVALID || GetDistanceToObject(oStore)>1.0){
        oStore=CreateObject(OBJECT_TYPE_STORE,"ds_bag_store",GetLocation(OBJECT_SELF));
    }

    //add bags to store
    DelayCommand(1.0,AddBags(oStore));
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


//Adds cloth dyes to the store if they are not available
void AddBags(object oStore){


    string sBagName;
    float fDelay;
    int i;

    for (i = 0; i <= 24; i++){

        //get bag name
        sBagName=BagName(i);

        //set delay
        fDelay = i/3.0;

        //a bit unelegant
        DelayCommand( fDelay, CreateBag(oStore, "ds_container1", sBagName));
        DelayCommand( fDelay+0.1, CreateBag(oStore, "ds_container2", sBagName));
        DelayCommand( fDelay+0.2, CreateBag(oStore, "ds_container3", sBagName));
    }
}

void CreateBag(object oStore, string sTemplate, string sName){

    object oBag;

    //create the bag from a template on oStore
    oBag=CreateItemOnObject(sTemplate,oStore,1,sTemplate+sName);

    //set the right name
    SetName(oBag,GetName(oBag)+": "+sName);

    //set bag to infinite
    SetInfiniteFlag(oBag,TRUE);

}

//List of bag names
string BagName(int nIndex){

    string sBagName;

    if (nIndex == 00){ sBagName = "Ammunition"; }
    if (nIndex == 01){ sBagName = "Armour"; }
    if (nIndex == 02){ sBagName = "Bandages"; }
    if (nIndex == 03){ sBagName = "Books"; }
    if (nIndex == 04){ sBagName = "Camping Gear"; }
    if (nIndex == 05){ sBagName = "Crafting Components"; }
    if (nIndex == 07){ sBagName = "Clothing"; }
    if (nIndex == 08){ sBagName = "Drinks"; }
    if (nIndex == 06){ sBagName = "Dyes"; }
    if (nIndex == 09){ sBagName = "First Aid"; }
    if (nIndex == 10){ sBagName = "Food"; }
    if (nIndex == 11){ sBagName = "For sale"; }
    if (nIndex == 12){ sBagName = "Herbs"; }
    if (nIndex == 13){ sBagName = "Jewelry"; }
    if (nIndex == 14){ sBagName = "Junk"; }
    if (nIndex == 15){ sBagName = "Leather Dyes"; }
    if (nIndex == 16){ sBagName = "Memorabilia"; }
    if (nIndex == 17){ sBagName = "Misc. Items"; }
    if (nIndex == 18){ sBagName = "Potions"; }
    if (nIndex == 19){ sBagName = "Quest Items"; }
    if (nIndex == 20){ sBagName = "Scrolls"; }
    if (nIndex == 21){ sBagName = "Tools"; }
    if (nIndex == 22){ sBagName = "Traps"; }
    if (nIndex == 23){ sBagName = "Weapons"; }
    if (nIndex == 24){ sBagName = "Wands"; }


    return sBagName;
}


