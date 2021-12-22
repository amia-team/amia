/*   Script: op_qst_chest
By: Anatida

Spawn quest item it PC doesn't already have one.*/

//Put this script OnOpen
void main()
{

object oPC = GetLastOpenedBy();
string sItem = GetLocalString(OBJECT_SELF, "ResRef");

if (!GetIsPC(oPC)) return;

if (GetItemPossessedBy(oPC, sItem)!= OBJECT_INVALID)
   return;

CreateItemOnObject(sItem, OBJECT_SELF);

}

