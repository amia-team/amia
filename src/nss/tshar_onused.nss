/*  Temple of Shar - Event script

    --------
    Verbatim
    --------
    Various temple effects.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    061406  Aleph       Initial release.
    ----------------------------------------------------------------------------

*/


/* Constants. */
const string BLOCKING       = "cs_blocking";
const string SHAR           = "cs_shar";

location GetTileLocation( location loc ) {


    vector vec = GetPositionFromLocation( loc );

    float fNewX = IntToFloat( FloatToInt( vec.x/10.0 ) );

    float fNewY = IntToFloat( FloatToInt( vec.y/10.0 ) );

    float fNewZ = IntToFloat( FloatToInt( vec.z/10.0 ) );

    //Construct the new tile-location

    vector vNew = Vector( fNewX, fNewY, fNewZ );

    location lNew = Location( GetAreaFromLocation( loc ),

        vNew, GetFacingFromLocation( loc ) );

    return lNew;

}




void main( )
{
    /////////////////////////////////////////////////
    // Pull chain, darkness is created
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_darkchain")
        {

        // Variables.
        object oChain           = OBJECT_SELF;
        location lOrigin        = GetLocation( GetWaypointByTag( "tshar_wp_tilecolor5" ) );
        int nBlocking           = GetLocalInt( oChain, BLOCKING );


        // Apply a field of Darkness, if the refresh timer is ok.
        if( nBlocking == 0 ){
            // Vfx.
            ApplyEffectAtLocation(
                                DURATION_TYPE_TEMPORARY,
                                EffectAreaOfEffect( AOE_PER_DARKNESS, "****", "****", "****" ),
                                lOrigin,
                                30. );
            // Timer.
            SetLocalInt( oChain, BLOCKING, 1 );
            // Reset timer in 31 seconds.
            DelayCommand( 31.0, SetLocalInt( oChain, BLOCKING, 0 ) );
        }

        return;
    }

    /////////////////////////////////////////////////
    // Controls the portal destinations.
    /////////////////////////////////////////////////


    if( GetTag( OBJECT_SELF) == "tshar_portal1")
        {
            object oPC = GetLastUsedBy();
            AssignCommand(oPC,JumpToObject(GetObjectByTag("tshar_wp_portal1")));
            return;
        }

    if( GetTag( OBJECT_SELF) == "tshar_portal2")
        {
            object oPC = GetLastUsedBy();
            AssignCommand(oPC,JumpToObject(GetObjectByTag("tshar_wp_portal2")));
            return;
        }

    /////////////////////////////////////////////////
    // Applies OnEnter effects to placeables.
    /////////////////////////////////////////////////


    if( GetTag( OBJECT_SELF) == "tshar_onenter")
        {


        int nCounter1        = 1;
        for( nCounter1 = 1; nCounter1 < 6; nCounter1 ++ )
            SetUseableFlag( GetObjectByTag( "tshar_hiddenitem" + IntToString( nCounter1 ) ), 0 );

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 6; nCounter2 ++ )
            SetUseableFlag( GetObjectByTag( "tshar_chest" + IntToString( nCounter2 ) ), 0 );

        SetUseableFlag( GetObjectByTag( "tshar_darkchain" ) , 0 );

        DestroyObject( OBJECT_SELF );
        return;
    }

    /////////////////////////////////////////////////
    // Require emblem for switch use.
    /////////////////////////////////////////////////

    object oPlayer = GetLastUsedBy( );
    object oItem = GetFirstItemInInventory( oPlayer );
    int nItemCheck = 0;

    while ( GetIsObjectValid( oItem ) == TRUE )
    {
        if( GetTag( oItem ) == "tshar_pendant" )
        {
            nItemCheck = 1;
        }
        oItem = GetNextItemInInventory( oPlayer );
    }

    if( nItemCheck != 1 )
    {
        FloatingTextStringOnCreature( "* Nothing happens. *", oPlayer );
        SetUseableFlag( OBJECT_SELF, 0 );
        DelayCommand(3.0, SetUseableFlag( OBJECT_SELF, 1 ) );
        return;
    }


    /////////////////////////////////////////////////
    // Controls the meeting table switch.
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_tableswitch" )
        {

        int nShar           = GetLocalInt( OBJECT_SELF, SHAR );

        if( nShar == 0 ){

            SetLocalInt( OBJECT_SELF, SHAR, 1 );
            SetUseableFlag( OBJECT_SELF, 0 );

            DestroyObject( GetNearestObjectByTag( "tshar_table" ) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ), GetNearestObjectByTag( "tshar_purplecircle" ) );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_GLOW_PURPLE ), GetNearestObjectByTag( "tshar_purplecircle" ) );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetNearestObjectByTag( "tshar_wp_iris" ) ) );

            DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
            return;
        }
        if( nShar == 1 ){

            SetLocalInt( OBJECT_SELF, SHAR, 0 );
            SetUseableFlag( OBJECT_SELF, 0 );

            object oTable = GetObjectByTag( "tshar_purplecircle" );
            effect eEffect = GetFirstEffect(oTable);
            while(GetIsEffectValid( eEffect ) )
            {
                if(GetEffectType(eEffect ) == EFFECT_TYPE_VISUALEFFECT)
                {
                RemoveEffect(oTable, eEffect);
                }
                eEffect = GetNextEffect(oTable);
            }

            CreateObject( OBJECT_TYPE_PLACEABLE, "x0_roundrugorien", GetLocation( GetNearestObjectByTag( "tshar_wp_table" ) ), TRUE, "tshar_table" );
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetNearestObjectByTag( "tshar_wp_table" ) ) );
            DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );

        }
        return;
    }


    /////////////////////////////////////////////////
    // Controls the portals and idol switch.
    /////////////////////////////////////////////////


    if( GetTag( OBJECT_SELF) == "tshar_altarswitch" )
        {

        SetUseableFlag( OBJECT_SELF, 0 );

        SetUseableFlag( GetObjectByTag( "idol_Shar" ), 1 );

        int nCounter1        = 1;
        for( nCounter1 = 1; nCounter1 < 8; nCounter1 ++ )
           {
           AssignCommand( GetObjectByTag( "tshar_altarcandle" + IntToString( nCounter1 ) ), PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
           DelayCommand( 30.0, AssignCommand( GetObjectByTag( "tshar_altarcandle" + IntToString( nCounter1 ) ), PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) ) );
           }

            DelayCommand( 3.0, RecomputeStaticLighting( GetArea( OBJECT_SELF ) ) );
            DelayCommand( 30.0, SetPlaceableIllumination( GetObjectByTag( "tshar_altarcandle1" ), 1 ) );
            DelayCommand( 30.0, SetPlaceableIllumination( GetObjectByTag( "tshar_altarcandle7" ), 1 ) );
            DelayCommand( 30.0, SetPlaceableIllumination( GetObjectByTag( "tshar_chandelier" ), 1 ) );
            DelayCommand( 33.0, RecomputeStaticLighting( GetArea( OBJECT_SELF ) ) );

            AssignCommand( GetObjectByTag( "tshar_chandelier" ), PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
            DelayCommand( 30.0, AssignCommand( GetObjectByTag( "tshar_chandelier" ), PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) ) );

            SetPlaceableIllumination( GetObjectByTag( "tshar_altarcandle1" ), 0 );
            SetPlaceableIllumination( GetObjectByTag( "tshar_altarcandle7" ), 0 );
            SetPlaceableIllumination( GetObjectByTag( "tshar_chandelier" ), 0 );

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 5; nCounter2 ++ )
           {
           ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ), GetObjectByTag( "tshar_portal" + IntToString( nCounter2 ) ), 30.0);
           ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK ), GetObjectByTag( "tshar_portal" + IntToString( nCounter2 ) ), 30.0);
           }


            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ), GetObjectByTag( "idol_Shar" ), 30.0);
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK ), GetObjectByTag( "idol_Shar" ), 30.0);
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_L ), GetLocation( GetObjectByTag( "tshar_portal1" )));
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_L ), GetLocation( GetObjectByTag( "tshar_portal2" )));
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetObjectByTag( "tshar_portal1" )));
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetObjectByTag( "tshar_portal2" )));
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetObjectByTag( "idol_Shar" )));
            DelayCommand( 30.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetObjectByTag( "idol_Shar" ))));
            SetUseableFlag( GetObjectByTag( "tshar_portal1" ), 1 );
            SetUseableFlag( GetObjectByTag( "tshar_portal2" ), 1 );
            DelayCommand(30.0, SetUseableFlag( OBJECT_SELF, 1 ) );
            DelayCommand( 30.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_3 ), GetLocation( GetObjectByTag( "tshar_portal1" ))));
            DelayCommand( 30.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SUMMON_MONSTER_3 ), GetLocation( GetObjectByTag( "tshar_portal2" ))));
            DelayCommand( 30.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGIC_PROTECTION ), GetLocation( GetObjectByTag( "tshar_portal1" ))));
            DelayCommand( 30.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGIC_PROTECTION ), GetLocation( GetObjectByTag( "tshar_portal2" ))));
            DelayCommand( 30.0, SetUseableFlag( GetObjectByTag( "tshar_portal1" ), 0 ));
            DelayCommand( 30.0, SetUseableFlag( GetObjectByTag( "tshar_portal2" ), 0 ));


            DelayCommand( 30.0, SetUseableFlag( GetObjectByTag( "idol_Shar" ), 0 ));

        return;
    }

    /////////////////////////////////////////////////
    // Controls the Circle of Secrets switch.
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_circleswitch")
    {

        int nShar           = GetLocalInt( OBJECT_SELF, SHAR );

        if( nShar == 0 ){

            SetLocalInt( OBJECT_SELF, SHAR, 1 );
            int nCounter1        = 1;
            for( nCounter1 = 1; nCounter1 < 13; nCounter1 ++ )
                 DelayCommand(2.0, ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK ), GetObjectByTag( "tshar_runepillar" + IntToString( nCounter1 ) )));

            int nCounter2        = 1;
            for( nCounter2 = 1; nCounter2 < 10; nCounter2 ++ )
               {

                location lTile = GetTileLocation( GetLocation( GetObjectByTag( "tshar_wp_tilecolor" + IntToString( nCounter2 ) ) ) );

                SetTileMainLightColor( lTile, TILE_MAIN_LIGHT_COLOR_DARK_PURPLE, TILE_MAIN_LIGHT_COLOR_BLACK );

               }

            int nCounter3        = 1;
            for( nCounter3 = 1; nCounter3 < 4; nCounter3 ++ )
            {
                SetUseableFlag( GetObjectByTag( "tshar_chest" + IntToString( nCounter3 ) ) , 1 );
            }

            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SCREEN_SHAKE ), OBJECT_SELF );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ), GetObjectByTag( "tshar_blackcircle" ));
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_AURA_PULSE_PURPLE_BLACK ), GetObjectByTag( "tshar_purplering" ));

            SetUseableFlag( GetObjectByTag( "tshar_darkchain" ) , 1 );

            SetUseableFlag( OBJECT_SELF, 0 );
            DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
            DelayCommand(3.0, RecomputeStaticLighting(GetArea(OBJECT_SELF)));
            return;
        }


        if( nShar == 1 ){

        SetLocalInt( OBJECT_SELF, SHAR, 0 );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SCREEN_SHAKE ), OBJECT_SELF );

        int nCounter1        = 1;
        for( nCounter1 = 1; nCounter1 < 13; nCounter1 ++ )
        {
            object oPillar = GetObjectByTag( "tshar_runepillar" + IntToString( nCounter1 ) );
            effect eEffect = GetFirstEffect(oPillar);

            while(GetIsEffectValid(eEffect))
            {
                if(GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
                {
                RemoveEffect(oPillar, eEffect);
                }
                eEffect = GetNextEffect(oPillar);
            }
        }

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 10; nCounter2 ++ )
           {

            location lTile = GetTileLocation( GetLocation( GetObjectByTag( "tshar_wp_tilecolor" + IntToString( nCounter2 ) ) ) );

            SetTileMainLightColor( lTile, TILE_MAIN_LIGHT_COLOR_PALE_YELLOW, TILE_MAIN_LIGHT_COLOR_BLACK );

           }

        object oCircle1 = GetObjectByTag( "tshar_blackcircle" );
        effect eEffect2 = GetFirstEffect(oCircle1);
        while(GetIsEffectValid( eEffect2 ) )
        {
            if(GetEffectType(eEffect2 ) == EFFECT_TYPE_VISUALEFFECT)
            {
            RemoveEffect(oCircle1, eEffect2);
            }
            eEffect2 = GetNextEffect(oCircle1);
        }

        object oRing = GetObjectByTag( "tshar_purplering" );
        effect eEffect3 = GetFirstEffect(oRing);
        while(GetIsEffectValid( eEffect3 ) )
        {
            if(GetEffectType(eEffect3 ) == EFFECT_TYPE_VISUALEFFECT)
            {
            RemoveEffect(oRing, eEffect3);
            }
            eEffect3 = GetNextEffect(oRing);
        }


        int nCounter3        = 1;
        for( nCounter3 = 1; nCounter3 < 4; nCounter3 ++ )
           {
           SetUseableFlag( GetObjectByTag( "tshar_chest" + IntToString( nCounter3 ) ) , 0 );
           ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), GetLocation( GetObjectByTag( "tshar_chest" + IntToString( nCounter3 ) ) ) );
           }

        SetUseableFlag( GetObjectByTag( "tshar_darkchain" ) , 0 );

        SetUseableFlag( OBJECT_SELF, 0 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
        DelayCommand(3.0, RecomputeStaticLighting(GetArea(OBJECT_SELF)));

        return;

        }

    }

    /////////////////////////////////////////////////
    // Controls the bookshelves/artifacts switch.
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_magicswitch")
    {

        int nShar           = GetLocalInt( OBJECT_SELF, SHAR );

        if( nShar == 0 ){

        SetLocalInt( OBJECT_SELF, SHAR, 1 );


        DestroyObject( GetObjectByTag( "tshar_bookshelf1" ) );
        DestroyObject( GetObjectByTag( "tshar_bookshelf2" ) );
        object oShelf1 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bookshelf", GetLocation( GetObjectByTag( "tshar_wp_bookshelf1b" ) ), FALSE, "tshar_bookshelf1");
        object oShelf2 = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bookshelf", GetLocation( GetObjectByTag( "tshar_wp_bookshelf2b" ) ), FALSE, "tshar_bookshelf2");
        AssignCommand( oShelf1, SetUseableFlag( oShelf1, 0 ));
        AssignCommand( oShelf2, SetUseableFlag( oShelf2, 0 ));
        SetUseableFlag( GetObjectByTag( "tshar_artifact1" ), 1 );
        SetUseableFlag( GetObjectByTag( "tshar_artifact2" ), 1 );
        AssignCommand( GetObjectByTag( "tshar_artifact1" ), PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );
        AssignCommand( GetObjectByTag( "tshar_artifact2" ), PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), GetLocation( GetObjectByTag( "tshar_wp_bookshelf1a" ) ) );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), GetLocation( GetObjectByTag( "tshar_wp_bookshelf2a" ) ) );


        SetUseableFlag( OBJECT_SELF, 0 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );

        return;
        }

        if( nShar == 1 ){

        SetLocalInt( OBJECT_SELF, SHAR, 0 );

        DestroyObject( GetObjectByTag( "tshar_bookshelf1" ) );
        DestroyObject( GetObjectByTag( "tshar_bookshelf2" ) );
        CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bookshelf", GetLocation( GetObjectByTag( "tshar_wp_bookshelf1a" ) ), FALSE, "tshar_bookshelf1");
        CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bookshelf", GetLocation( GetObjectByTag( "tshar_wp_bookshelf2a" ) ), FALSE, "tshar_bookshelf2");
        DelayCommand(2.0, SetUseableFlag( GetObjectByTag( "tshar_bookshelf1" ), 0 ) );
        DelayCommand(2.0, SetUseableFlag( GetObjectByTag( "tshar_bookshelf2" ), 0 ) );

        SetUseableFlag( GetObjectByTag( "tshar_artifact1" ), 0 );
        SetUseableFlag( GetObjectByTag( "tshar_artifact2" ), 0 );
        AssignCommand( GetObjectByTag( "tshar_artifact1" ), PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        AssignCommand( GetObjectByTag( "tshar_artifact2" ), PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), GetLocation( GetObjectByTag( "tshar_wp_bookshelf1a" ) ) );
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_KNOCK ), GetLocation( GetObjectByTag( "tshar_wp_bookshelf2a" ) ) );

        SetUseableFlag( OBJECT_SELF, 0 );
        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );

        return;
        }
    }

    /////////////////////////////////////////////////
    // Controls the cellar secrets switch.
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_cellarswitch")
    {
        int nShar           = GetLocalInt( OBJECT_SELF, SHAR );

        if( nShar == 0 ){

        SetLocalInt( OBJECT_SELF, SHAR, 1 );

        int nCounter1        = 1;
        for( nCounter1 = 1; nCounter1 < 7; nCounter1 ++ )
             DestroyObject( GetObjectByTag( "tshar_falsewall" + IntToString( nCounter1 ) ) );

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 4; nCounter2 ++ )
             {
             DestroyObject( GetObjectByTag( "tshar_shield" + IntToString( nCounter2 ) ) );
             ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DEATH_WARD ), GetLocation( GetObjectByTag( "tshar_wp_shield" + IntToString( nCounter2 ) ) ) );
             }

        int nCounter3        = 1;
        for( nCounter3 = 1; nCounter3 < 6; nCounter3 ++ )
            {
            SetUseableFlag( GetObjectByTag( "tshar_hiddenitem" + IntToString( nCounter3 ) ), 1 );
            }

        SetUseableFlag( OBJECT_SELF, 1 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
        DelayCommand(3.0, RecomputeStaticLighting(GetArea(OBJECT_SELF)));

        return;
        }

        if( nShar == 1 ){

        SetLocalInt( OBJECT_SELF, SHAR, 0 );

    //

        int nCounter1        = 1;
        for( nCounter1 = 1; nCounter1 < 7; nCounter1 ++ )
        {
            object oWall = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_doorway", GetLocation( GetObjectByTag( "tshar_wp_falsewall" + IntToString( nCounter1) ) ), FALSE, "tshar_falsewall" + IntToString( nCounter1));
            AssignCommand( oWall, SetUseableFlag( oWall, 0 ) );
        }

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 6; nCounter2 ++ )
            SetUseableFlag( GetObjectByTag( "tshar_hiddenitem" + IntToString( nCounter2 ) ), 0 );

        int nCounter3        = 1;
        for( nCounter3 = 1; nCounter3 < 7; nCounter3 ++ )
        {
            CreateObject(OBJECT_TYPE_PLACEABLE, "x0_hangshield", GetLocation( GetObjectByTag( "tshar_wp_shield" + IntToString( nCounter3) ) ), FALSE, "tshar_shield" + IntToString( nCounter3));
        }

        SetUseableFlag( OBJECT_SELF, 0 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );

        return;
        }
    }

    /////////////////////////////////////////////////
    // Controls the secret books switch.
    /////////////////////////////////////////////////

    if( GetTag( OBJECT_SELF) == "tshar_bookswitch")
    {

        int nShar           = GetLocalInt( OBJECT_SELF, SHAR );

        if( nShar == 0 ){

        SetLocalInt( OBJECT_SELF, SHAR, 1 );

        int nCounter        = 1;
        for( nCounter = 1; nCounter < 5; nCounter ++ )
            SetUseableFlag( GetObjectByTag( "tshar_book" + IntToString( nCounter ) ), 0 );

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 5; nCounter2 ++ )
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_CHARM ), GetLocation( GetObjectByTag( "tshar_book" + IntToString( nCounter2 ) ) ) );

        int nCounter3        = 1;
        for( nCounter3 = 1; nCounter3 < 5; nCounter3 ++ )
             ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_GLOW_PURPLE ), GetObjectByTag( "tshar_book" + IntToString( nCounter3 ) ));

        int nCounter4        = 1;
        for( nCounter4 = 1; nCounter4 < 5; nCounter4 ++ )
            SetUseableFlag( GetObjectByTag( "tshar_secbook" + IntToString( nCounter4 ) ), 1 );

        int nCounter5        = 1;
        for( nCounter5 = 1; nCounter5 < 5; nCounter5 ++ )
             ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_GLOW_PURPLE ), GetObjectByTag( "tshar_secbook" + IntToString( nCounter5 ) ));

        int nCounter6        = 1;
        for( nCounter6 = 1; nCounter6 < 5; nCounter6 ++ )
            DestroyObject( GetObjectByTag( "tshar_candle" + IntToString( nCounter6 ) ), 0.0 );

        int nCounter7        = 1;
        for( nCounter7 = 1; nCounter7 < 5; nCounter7 ++ )
            DestroyObject( GetObjectByTag( "tshar_woodbeam" + IntToString( nCounter7 ) ), 0.0 );

        SetUseableFlag( OBJECT_SELF, 0 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
        DelayCommand(3.0, RecomputeStaticLighting(GetArea(OBJECT_SELF)));

        return;
        }

        if( nShar == 1 ){

        SetLocalInt( OBJECT_SELF, SHAR, 0 );

        int nCounter        = 1;
        for( nCounter = 1; nCounter < 5; nCounter ++ )
            SetUseableFlag( GetObjectByTag( "tshar_book" + IntToString( nCounter ) ), 1 );

        int nCounter2        = 1;
        for( nCounter2 = 1; nCounter2 < 5; nCounter2 ++ )
            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEALING_L ), GetLocation( GetObjectByTag( "tshar_book" + IntToString( nCounter2 ) ) ) );

        int nCounter3        = 1;
        for( nCounter3 = 1; nCounter3 < 5; nCounter3 ++ )
        {
            object oBook = GetObjectByTag( "tshar_book" + IntToString( nCounter3 ) );
            effect eEffect = GetFirstEffect(oBook);
            while(GetIsEffectValid(eEffect))
            {
                if(GetEffectType(eEffect ) == EFFECT_TYPE_VISUALEFFECT)
                {
                RemoveEffect(oBook, eEffect);
                }
                eEffect = GetNextEffect(oBook);
            }
        }

        int nCounter4        = 1;
        for( nCounter4 = 1; nCounter4 < 5; nCounter4 ++ )
            SetUseableFlag( GetObjectByTag( "tshar_secbook" + IntToString( nCounter4 ) ), 0 );

        int nCounter5        = 1;
        for( nCounter5 = 1; nCounter5 < 5; nCounter5 ++ )
        CreateObject(OBJECT_TYPE_PLACEABLE, "plc_candelabra", GetLocation( GetObjectByTag( "tshar_wp_candle" + IntToString( nCounter5 ) ) ), FALSE, "tshar_candle" + IntToString( nCounter5 ));

        int nCounter6        = 1;
        for( nCounter6 = 1; nCounter6 < 5; nCounter6 ++ )
        CreateObject(OBJECT_TYPE_PLACEABLE, "x0_fallentimber", GetLocation( GetObjectByTag( "tshar_wp_woodbeam" + IntToString( nCounter6 ) ) ), FALSE, "tshar_woodbeam" + IntToString( nCounter6 ));

        int nCounter7        = 1;
        for( nCounter7 = 1; nCounter7 < 5; nCounter7 ++ )
        {
            object oBook = GetObjectByTag( "tshar_secbook" + IntToString( nCounter7 ) );
            effect eEffect2 = GetFirstEffect(oBook);
            while(GetIsEffectValid(eEffect2))
            {
                if(GetEffectType(eEffect2 ) == EFFECT_TYPE_VISUALEFFECT)
                {
                RemoveEffect(oBook, eEffect2);
                }
                eEffect2 = GetNextEffect(oBook);
            }
        }

        SetUseableFlag( OBJECT_SELF, 0 );

        DelayCommand(10.0, SetUseableFlag( OBJECT_SELF, 1 ) );
        DelayCommand(3.0, RecomputeStaticLighting(GetArea(OBJECT_SELF)));

        return;
        }

    }

}
