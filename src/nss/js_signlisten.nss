//::///////////////////////////////////////////////
//:: Tailoring - Turning Listening On
//:: tlr_listenon.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    object oItem = GetItemPossessedBy(oPC,"js_transign");

    SetListenPattern(oItem, "**", 8810);
    SetListening(oItem, TRUE);
}
