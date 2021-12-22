// Conversation action to give the PC speaker a free ale.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2003 Artos            First recorded version.
//

void main()
{
    // Give the speaker the items
    CreateItemOnObject("nw_it_mpotion021", GetPCSpeaker(), 1);

    ExecuteScript( "ca_openstore", OBJECT_SELF );
}
