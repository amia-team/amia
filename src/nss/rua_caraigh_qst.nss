void main(){

    object oPC  = GetPCSpeaker();
    object oNPC = OBJECT_SELF;
    string sTag = GetTag( oNPC );


    if ( sTag == "rua_wizard" ){

        int nPoly;

        switch ( d6() ){

            case 1: nPoly = POLYMORPH_TYPE_BADGER;
            case 2: nPoly = POLYMORPH_TYPE_BOAR;
            case 3: nPoly = POLYMORPH_TYPE_CHICKEN;
            case 4: nPoly = POLYMORPH_TYPE_COW;
            case 5: nPoly = POLYMORPH_TYPE_WOLF;
            case 6: nPoly = POLYMORPH_TYPE_PENGUIN;
        }

        effect ePoly = SupernaturalEffect( EffectPolymorph( nPoly, TRUE ) );
        effect eVis  = EffectVisualEffect( VFX_IMP_POLYMORPH );

        PlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, 3.0 );
        PlayVoiceChat( VOICE_CHAT_BADIDEA );

        DelayCommand( 2.5, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC ) );
        DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoly, oPC, 1200.0 ) );
        DelayCommand( 5.0, PlayVoiceChat( VOICE_CHAT_GOODBYE ) );
    }
}
