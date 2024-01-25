//Settlment script to banish individuals and boot them from the area.
//Can only use the banishment feature in set settlement area.
//Can unban in any area.
//Settlement variables must be capitalized. Example: Greengarden settlement variables must be "Greengarden".

void DoTransition(object criminal, object dropoffpoint, string message);

void MoveAssociates(object criminal, object dropoffpoint);

void main()
{
    object pc             = GetItemActivator();
    object manacles       = GetItemActivated();
    object criminal       = GetItemActivatedTarget();
    object criminalpckey  = GetItemPossessedBy(criminal, "pckey");
    string criminalname   = GetName(criminal, FALSE);
    string settlement     = GetLocalString(manacles, "settlement");
    string dropoff        = settlement+"_wp";
    object dropoffpoint   = GetObjectByTag(dropoff);
    object settlementarea = GetArea(pc);
    string area_ban       = GetLocalString(settlementarea, "settlement");

    if(GetIsDM(pc)){
        SetName(manacles, settlement+" Guard Manacles");
        SetDescription(manacles, "These are guard manacles for "+settlement+"! Use these to banish unruly criminals. It will cast them out of the settlement and bar them from entry through the gates.\n\nUse the manacles on them again to remove their banishment.", TRUE);
    }
    else if((GetIsPC(criminal)) && (GetLocalInt(criminalpckey, settlement+"_ban") && (area_ban == settlement) != 1)){
        SetLocalInt(criminalpckey, settlement+"_ban", 1);
        DelayCommand(3.0,DoTransition(criminal, dropoffpoint, "You have been cast out of "+settlement+"! You may not re-enter until a guard revokes your banishment."));
        FloatingTextStringOnCreature("You have cast "+criminalname+" out of your city! Use the manacles on them again to revoke their banishment.", pc, TRUE);
    }
    else if(!GetIsPC(criminal)){
        FloatingTextStringOnCreature("You cannot use this on an NPC!", pc, TRUE);
    }
    else{
        SetLocalInt(criminalpckey, settlement+"_ban", 0);
        FloatingTextStringOnCreature("You have revoked "+criminalname+"'s banishment.", pc, TRUE);
    }
}

void DoTransition(object criminal, object dropoffpoint, string message){
    if (GetArea(criminal) == GetArea(dropoffpoint) && GetIsPC(criminal)){
        MoveAssociates(criminal, dropoffpoint);
    }
    if (message != ""){
        SendMessageToPC(criminal, message);
    }
    else{
        DelayCommand(1.0, AssignCommand(criminal, ClearAllActions()));
        DelayCommand(1.1, AssignCommand(criminal, JumpToObject(dropoffpoint, 0)));
    }
}

void MoveAssociates(object pc, object dropoffpoint){
    int i;
    object associate;
    for (i=1; i<6; ++i){
        associate = GetAssociate(i, pc);
        if (GetIsObjectValid(associate)){
            AssignCommand(associate, JumpToObject(dropoffpoint));
        }
    }
}
