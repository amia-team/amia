
int StartingConditional()
{
    object oPC = GetPCSpeaker( );
    int nAlign = GetAlignmentGoodEvil( oPC );

    return ( nAlign != ALIGNMENT_GOOD );
}
