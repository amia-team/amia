void main()
{
    object oPC = GetLastUsedBy();
    string sWriting = GetLocalString(OBJECT_SELF, "Writing");
    SpeakString("There is Elven writing here. It reads: " + sWriting + ". *You copy it down.*");
    int iOrder = GetLocalInt(OBJECT_SELF,"Order");
    if (iOrder == 0) SendMessageToPC( oPC, "Order isn't set");
    object oWriting = CreateItemOnObject("jj_elvishwriting",oPC,1,"jj_elvishwriting_" + IntToString(iOrder));
    SetName(oWriting, sWriting);
}
