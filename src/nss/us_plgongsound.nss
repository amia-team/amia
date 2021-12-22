void main()
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    PlaySound( "as_cv_gongring2" );
}
