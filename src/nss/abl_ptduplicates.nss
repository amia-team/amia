/*
    Custom NPC Ability:
    Past Time Duplicates
    - For each PC in the radius of effect, creates a shadowy
      duplicate (spawned mob) and adjusts details to match the
      PC in question. Stores the origin PC for later ability use.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );
    effect eSummon1 = EffectVisualEffect( VFX_IMP_BIGBYS_FORCEFUL_HAND, FALSE );
    string sSpook = "You're too late...";
    string sPCName;

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 100.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        if( GetIsPC( oTarget ) == TRUE && GetLocalInt( oTarget, "Time_Duplicated" ) != 1 )
        {
            if( GetResRef( oTarget ) != "reyes" )
            {
                location lTarget = GetLocation( oTarget );
                sPCName = GetName( oTarget );
                string sBio = "Peering through the writhing shadows, you see a second " + sPCName + " within the mists!";

                object oCopy = CreateObject( OBJECT_TYPE_CREATURE, "phanepccopy", lTarget );

                FloatingTextStringOnCreature( sSpook, oCopy, FALSE );
                SetLocalInt( oTarget, "Time_Duplicated", 1 );

                DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, eSummon1, oCopy ) );
                DelayCommand( 1.2, SetDescription( oCopy, sBio ) );
                DelayCommand( 1.3, SetName( oCopy, sPCName ) );
                DelayCommand( 1.4, ChangeToStandardFaction( oCopy, STANDARD_FACTION_HOSTILE ) );
                DelayCommand( 1.5, AssignCommand( oCopy, ActionAttack( oTarget ) ) );
                DelayCommand( 1.6, SetLocalObject( oCopy, "CopiedPC", oTarget ) );
                DelayCommand( 1.7, AssignCommand( oCopy, SpeakString( sSpook, TALKVOLUME_TALK ) ) );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 100.0, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
}
