/*  Verify BG NE Summon
   Maverick00053 - 2/15/25
*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    string sResRef      = GetResRef(oHenchy);

    if(sResRef=="bg_ne")
    {
       return TRUE;
    }
    else
    {
       return FALSE;
    }

}
