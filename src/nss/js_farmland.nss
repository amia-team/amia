/*
    Simple Trigger that will mark when the PC is on farmland

    - Maverick00053


*/

void main()
{
    object oPCEntering = GetEnteringObject();
    object oPCExiting = GetExitingObject();
    int nFarmland =  GetLocalInt(oPCEntering,"onfarmland");
    int nUD = GetLocalInt(OBJECT_SELF,"underdark");

    if(GetIsObjectValid(oPCEntering) && (nFarmland == 0))
    {
       SendMessageToPC(oPCEntering,"This land appears to be extremely fertile.");
       SetLocalInt(oPCEntering,"onfarmland",1);
       if(nUD == 1)
       {
        SetLocalInt(oPCEntering,"underdark",1);
       }
    }

    if(GetIsObjectValid(oPCExiting) && (nFarmland == 1))
    {
       DeleteLocalInt(oPCExiting,"onfarmland");
       if(nUD == 1)
       {
        DeleteLocalInt(oPCExiting,"underdark");
       }
    }

}
