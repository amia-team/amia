// True if PC possesses some gold.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 07/31/2003  Artos              Initial Release
//

int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) > 0 );
}
