/*  dg_frplc_castat

--------
Verbatim
--------

A script for a fireplace.  Needs a usable object to light and a WP.  Both have
the same tag.  Useable object has a local int called "Lit" set to 0.  When a
player casts light on the object, it will create a large fire effect on the
object at the WP location.  When they do it a second time, it goes out.

---------
Changelog
---------


Date        Name        Reason
------------------------------------------------------------------
032008      dg          Initial Release
------------------------------------------------------------------

*/

void main()
{


object oFire    = GetWaypointByTag( GetTag( OBJECT_SELF ) );

location lFire  = GetLocation( oFire );

string sTag  = GetTag( OBJECT_SELF );

int nLit        = GetLocalInt( OBJECT_SELF, "Lit" );

    if( GetLastSpell() == SPELL_LIGHT &&
        nLit == 0 ){

        CreateObject( OBJECT_TYPE_PLACEABLE, "plc_flamelarge", lFire, FALSE, sTag );

        SetLocalInt( OBJECT_SELF, "Lit", 1 );

    }

    else{

        oFire = GetObjectByTag( sTag );

        SetPlotFlag( oFire, FALSE );

        DestroyObject( oFire );

        SetLocalInt( OBJECT_SELF, "Lit", 0 );

    }


}
