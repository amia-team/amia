
void main( ){

    object oTarget = GetNearestObjectByTag( "ds_seat" );

    if ( GetIsObjectValid( oTarget ) ) {

        ClearAllActions();
        ActionSit( oTarget );
    }
}
