void main( ){

    object oTarget  = GetEnteringObject( );
    object oPC      = GetAreaOfEffectCreator( );

    //Don't think this is neasesary but we'll do it anyway
    if( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE )
        SendMessageToPC( oPC, "<cþ  >Someone entered your Eye of the Sand Tracker!</c>" );
}
