/*
    Simple Trigger that will mark when the PC is on sites

    - Maverick00053


*/

void main()
{
    object oPCEntering = GetEnteringObject();
    object oPCExiting = GetExitingObject();
    int nOnSite =  GetLocalInt(oPCEntering,"onsite");
    int nSiteType = GetLocalInt(OBJECT_SELF,"sitetype");  // 1 is digsite, 2 is fossile site, 3 is sarcophagus

    if(GetIsObjectValid(oPCEntering) && (nOnSite == 0))
    {
       SendMessageToPC(oPCEntering,"This land appears to hold something of interest.");
       SetLocalInt(oPCEntering,"onsite",1);

       if(nSiteType >= 1)
       {
        SetLocalInt(oPCEntering,"sitetype",nSiteType);
       }
    }

    if(GetIsObjectValid(oPCExiting) && (nOnSite == 1))
    {
       DeleteLocalInt(oPCExiting,"onsite");

       if(nSiteType >= 1)
       {
        DeleteLocalInt(oPCExiting,"sitetype");
       }
    }

}
