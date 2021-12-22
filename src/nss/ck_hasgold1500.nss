// Conversation condition to check if PC has at least 1,500 gold.
//
// Revision History
// Date        Name               Description
// ----------  ------------------ ------------------------------------------
// 02/22/2004  jpavelch           Initial Release
//


int StartingConditional( )
{
    return ( GetGold(GetPCSpeaker()) >= 1500 );
}
