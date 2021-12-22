// True if PC possesses at least 500 gold.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 09/14/2003  jpavelch           Initial release.
//

int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) >= 500 );
}
