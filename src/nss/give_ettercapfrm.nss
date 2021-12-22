//::///////////////////////////////////////////////
//:: FileName give_ettercapfrm
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 22/03/2005 15:42:28
//:://////////////////////////////////////////////
void main()
{
	// Give the speaker the items
	CreateItemOnObject("ettercapform", GetPCSpeaker(), 1);


	// Remove items from the player's inventory
	object oItemToTake;
	oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "spiderseye");
	if(GetIsObjectValid(oItemToTake) != 0)
		DestroyObject(oItemToTake);
}
