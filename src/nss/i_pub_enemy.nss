void main()
{
    if (!GetIsDM(GetItemActivator())) {
        return;
    }

    string IS_PUBLIC_ENEMY = "IS_PUBLIC_ENEMY";
    string SIDE_DEF_OBJECT_REF = "sidesetter_defender";
    object oPC = GetItemActivatedTarget();

    if (GetIsPC(oPC)) {
        int iPublicEnemy = GetLocalInt(oPC, IS_PUBLIC_ENEMY);
            object oDefender = GetObjectByTag(SIDE_DEF_OBJECT_REF);

        if (iPublicEnemy == FALSE) {

            AdjustReputation(oPC, oDefender, -100);
            SetLocalInt(oPC,IS_PUBLIC_ENEMY,TRUE);
            SendMessageToPC(oPC,"You are now a Public Enemy and guards will be hostile!");

        } else {
            AdjustReputation(oPC, oDefender, 100);
            DeleteLocalInt(oPC,IS_PUBLIC_ENEMY);
            SendMessageToPC(oPC,"You are no longer a Public Enemy");
        }
    }
}
