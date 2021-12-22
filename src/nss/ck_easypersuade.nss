// Conversation conditional to check if PC makes an easy persuade check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
//

#include "nw_i0_plot"


int StartingConditional( )
{
    return ( AutoDC(DC_EASY, SKILL_PERSUADE, GetPCSpeaker()) );
}
