void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sTag      = GetTag( oTarget );

    if ( sTag == "udb_lichcom" ){

        if ( nNode == 1 ){

            object oBook = GetLocalObject( oPC, "udb_book" );

            object oDoor = GetLocalObject( oTarget, "door" );

            if ( !GetIsObjectValid( oDoor ) ){

                oDoor = GetNearestObjectByTag( "udb_zhum_to_exit" );

                SetLocalObject( oTarget, "door", oDoor );
            }

            if ( GetIsObjectValid( oBook ) ){

                AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
                DelayCommand( 60.0, AssignCommand( oDoor, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );

                DeleteLocalObject( oPC, "udb_book" );
                DestroyObject( oBook );
             }
            else{

                AssignCommand( oTarget, SpeakString( "Don't try funny jokes with me, mortal!" ) );
            }
        }
    }


}
