// Conversation conditional for a low persuade skill check.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/15/2004 jpavelch         Initial release.
//

#include "nw_i0_plot"

int StartingConditional( )
{
    return AutoDC( DC_EASY, SKILL_PERSUADE, GetPCSpeaker() );
}
