//Settlment script to banish individuals and boot them from the area.
//Can only use the banishment feature in set settlement area.
//Can unban in any area.
#include "inc_settlements"

void DoTransition(object criminal, object dropoffpoint, string message);

void MoveAssociates(object criminal, object dropoffpoint);

void main()
{
    object pc             = GetItemActivator();
    object manacles       = GetItemActivated();
    object criminal       = GetItemActivatedTarget();
    object criminalpckey  = GetItemPossessedBy(criminal, "ds_pckey");
    string criminalname   = GetName(criminal, FALSE);
    int settlement        = GetLocalInt(manacles, "settlement");
    string settleName     = IntToString(settlement);
    string dropoff        = settleName+"_wp";
    object dropoffpoint   = GetObjectByTag(dropoff);
    object inArea         = GetArea(pc);
    int ban_area          = GetLocalInt(inArea, "settlement");
    string area_ban       = IntToString(ban_area);
    string fullName       = SettlementName(settlement);

    if(GetIsDM(pc)){
        SetName(manacles, fullName+" Guard Manacles");
        SetDescription(manacles, "These are guard manacles for "+fullName+"! Use these to banish unruly criminals. It will cast them out of the settlement and bar them from entry through the gates.\n\nUse the manacles on them again to remove their banishment.", TRUE);
        FloatingTextStringOnCreature("Manacles set to "+fullName+"!", pc, TRUE);
    }
    else if((GetIsPC(criminal)) && (GetLocalInt(criminalpckey, settleName+"_banish") != 1) && (area_ban == settleName) && (criminal != pc)){
        if(settlement >= 1){
            SetLocalInt(criminalpckey, settleName+"_banish", 1);
            DelayCommand(0.3, DoTransition(criminal, dropoffpoint, "You have been cast out of "+fullName+"! You may not re-enter until a guard revokes your banishment."));
            DelayCommand(3.0,AssignCommand(criminal,(ActionPlayAnimation(16, 1.0,5.0))));
            SendMessageToPC(pc, "You have cast "+criminalname+" out of "+fullName+"! Use the manacles on them again to revoke their banishment.");
        }
    }
    else if(criminal == pc){
        FloatingTextStringOnCreature("You cannot ban yourself!", pc, TRUE);
    }
    else if(!GetIsPC(criminal)){
        FloatingTextStringOnCreature("You have to use this on another player!", pc, TRUE);
    }
    else{
        DeleteLocalInt(criminalpckey, settleName+"_banish");
        FloatingTextStringOnCreature("You have revoked "+criminalname+"'s banishment.", pc, TRUE);
    }
}

void DoTransition(object criminal, object dropoffpoint, string message){
    if ((GetArea(criminal) == GetArea(dropoffpoint)) && (GetIsPC(criminal))){
        MoveAssociates(criminal, dropoffpoint);
        DelayCommand(1.0, AssignCommand(criminal, ClearAllActions()));
        DelayCommand(1.1, AssignCommand(criminal, JumpToObject(dropoffpoint)));
    }
    else{
        SendMessageToPC(criminal, message);
        DelayCommand(1.0, AssignCommand(criminal, ClearAllActions()));
        DelayCommand(1.1, AssignCommand(criminal, JumpToObject(dropoffpoint)));
    }
}

void MoveAssociates(object pc, object dropoffpoint){
    int i;
    object associate;
    location jump = GetLocation(dropoffpoint);
    for (i=1; i<6; ++i){
        associate = GetAssociate(i, pc);
        if (GetIsObjectValid(associate)){
            AssignCommand(associate, JumpToObject(dropoffpoint));
        }
    }
}
