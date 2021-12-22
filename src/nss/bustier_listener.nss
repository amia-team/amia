void main()
{
    //Variables are set in 'bustier_dyebox'
    object oSpeaker = GetLocalObject(OBJECT_SELF, "oActivator");
    string sPassword = GetLocalString(OBJECT_SELF, "sPassword");

    //sets up which shouts the NPC will listen to.
    SetListenPattern(OBJECT_SELF, sPassword, 30440); //listen for password.
    SetListening(OBJECT_SELF, TRUE);          //be sure NPC is listening

}


