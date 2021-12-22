// OnSpawn event of Chosen of Kilmaroc.  Creates his altar and makes him
// plot to start.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/02/2004 jpavelch         Initial release.
// 07/04/2004 jpavelch         Added combat convo.

#include "x0_i0_anims"
#include "logger"

void main( )
{
    object oChosen = OBJECT_SELF;

    // Execute default OnSpawn script.
    ExecuteScript("ds_ai2_spawn", OBJECT_SELF);

    ActionCastSpellAtObject(
        SPELL_SPELL_MANTLE,
        oChosen,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_ELEMENTAL_SHIELD,
        oChosen,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ActionCastSpellAtObject(
        SPELL_STONESKIN,
        oChosen,
        METAMAGIC_ANY,
        TRUE,
        0,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE
    );

    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1),
        GetLocation(oChosen)
    );


    if(GetResRef(oChosen) != "chosenofkilma002")
    {

    object oAltar = GetNearestObjectByTag( "ChosenAltar" );
    if ( GetIsObjectValid(oAltar) ) {
        ApplyEffectAtLocation(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_HOLY_AID),
            GetLocation(oAltar)
        );
        DestroyObject( oAltar );
    }

    object oWaypoint = GetNearestObjectByTag( "wp_chosenaltar" );
    if ( !GetIsObjectValid(oWaypoint) ) {
        LogError( "sp_chosen", "Could not find waypoint for Chosen's altar!" );
        return;
    }

    oAltar = CreateObject(
                 OBJECT_TYPE_PLACEABLE,
                 "chosenaltar",
                 GetLocation(oWaypoint)
             );
    if ( !GetIsObjectValid(oAltar) ) {
        LogError( "sp_chosen", "Could not create Chosen's altar!" );
        return;
    }

    SetLocalObject( oAltar, "Chosen", oChosen );
    SetPlotFlag( oChosen, TRUE );
    }
}
