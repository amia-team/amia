void main( ){

     object Ocreature = OBJECT_SELF;
     float fDur = 99999.0f;

        if ( GetIsObjectValid( Ocreature ) ) {

            ClearAllActions();
            PlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, fDur);
    }
}
