//void main (){}

int GetCurrentCharges(object recallStone);

int GetStoneSize(object recallStone);

int ChargesToAdd(object mythal);

int CanAddCharges(object mythal, object recallStone);

void SafeAddCharges(object recallStone, object mythal, int charges);


//---------------------------
//===Functions===
//---------------------------

int GetCurrentCharges(object recallStone){
    return GetItemCharges(recallStone);
}
//---------------------------
int GetStoneSize(object recallStone){
    //Returns max uses
    return GetLocalInt(recallStone, "size");
}
//---------------------------
int ChargesToAdd(object mythal){
    string resRef = GetResRef(mythal);
    if (resRef == "mythal1"){
        return (1);
    }
    if (resRef == "mythal2"){
        return (2);
    }
    if (resRef == "mythal3"){
        return (3);
    }
    if (resRef == "mythal4"){
        return (5);
    }
    if (resRef == "mythal5"){
        return (15);
    }
    if (resRef == "mythal6"){
        return (20);
    }
    if (resRef == "mythal7"){
        return (100);
    }
    else{
        return 0;
    }
}
//---------------------------
int CanAddCharges(object mythal, object recallStone){
    return !((ChargesToAdd(mythal) + GetCurrentCharges(recallStone)) > GetStoneSize(recallStone));
}
//---------------------------
void SafeAddCharges(object recallStone, object mythal, int charges){
    int chargesAdded = (ChargesToAdd(mythal) + GetCurrentCharges(recallStone));
    SetItemCharges(recallStone, chargesAdded);
}
