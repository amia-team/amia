// TRUE when PC has no money.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 07/31/2003  Artos              Initial Release
//

int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) == 0 );
}
