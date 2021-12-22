/*
    OnSpellCastAt script for Wall of Ice custom spell PLCs.
*/

void main()
{
    object oWall = OBJECT_SELF;

    // if it's a dispel, do a contested CL check to see if the wall is destroyed
    if( GetLastSpell() == SPELL_MORDENKAINENS_DISJUNCTION ||
        GetLastSpell() == SPELL_GREATER_DISPELLING ||
        GetLastSpell() == SPELL_DISPEL_MAGIC ||
        GetLastSpell() == SPELL_LESSER_DISPEL )
    {
        object oCaster = GetLastSpellCaster();
        int nCasterCL = GetCasterLevel( oCaster );

        //adjust CL based on spell used
        if( GetLastSpell() == SPELL_LESSER_DISPEL && nCasterCL > 5 )
        {
            nCasterCL = 5;
        }
        if( GetLastSpell() == SPELL_DISPEL_MAGIC  && nCasterCL > 10 )
        {
            nCasterCL = 10;
        }
        if( GetLastSpell() == SPELL_GREATER_DISPELLING && nCasterCL > 15 )
        {
            nCasterCL = 15;
        }

        int nWallCL = GetLocalInt( oWall, "CasterLevel" );

        int nCasterDC = ( d20(1) + nCasterCL );
        int nWallDC = ( 12 + nWallCL );

        if( nCasterDC >= nWallDC )
        {
            //if one Sphere PLC dies, they all do, but no aura from the others
            if( GetResRef( oWall ) == "pc_ice_sphere" )
            {
                string sSphereTag = GetTag( oWall );
                string sSphere = IntToString( GetLocalInt( oWall, "SphereNumber" ) );

                DestroyObject( GetNearestObjectByTag( "SphereFR_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereFL_"+sSphere ), 1.0 );
                DestroyObject( GetNearestObjectByTag( "SphereBR_"+sSphere ), 1.0 );
            }
            DestroyObject( oWall );
        }
    }
}


