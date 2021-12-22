void main(){

    object oTrigger = OBJECT_SELF;
    object oEnter   = GetEnteringObject();
    object oArea    = GetArea( oTrigger );
    string sTag     = GetTag( oTrigger );


    if ( sTag == "bf_finish" ){

        string sRat = GetTag( oEnter );

        if ( sRat == "bf_rat_1" || sRat == "bf_rat_2" ){

            int nStatus = GetLocalInt( oArea, "bf_rats" );

            if ( nStatus == 1 ){

                DestroyObject( oEnter, 1.0 );

                SetLocalInt( oArea, "bf_rats", 0 );

                AssignCommand( GetLocalObject( oArea, "bf_rathin" ), SpeakString( GetName( oEnter )+" has won the match!" ) );

                if ( GetLocalString( oArea, "bf_rat" ) == sRat ){

                    GiveGoldToCreature( GetLocalObject( oArea, "bf_racer" ), ( GetLocalInt( oArea, "bf_rats_gp" ) * 2 ) );
                }

                if ( sRat == "bf_rat_1" ){

                    DestroyObject( GetNearestObjectByTag( "bf_rat_2" ) );
                }
                else{

                    DestroyObject( GetNearestObjectByTag( "bf_rat_1" ) );
                }

                DeleteLocalInt( oArea, "bf_rats_gp" );
                DeleteLocalString( oArea, "bf_rat" );
                DeleteLocalObject( oArea, "bf_racer" );
            }
            else{

                DestroyObject( oEnter, 1.0 );
            }
        }
    }


}
