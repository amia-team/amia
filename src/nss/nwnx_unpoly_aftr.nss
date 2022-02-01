#include "nwnx_magic"

void RestoreSpellState( object oPC );

void main( ){

    object oPC = OBJECT_SELF;
    int ShifterID = GetLocalInt( OBJECT_SELF, "LAST_POLY_ID");
    object oPCKey       = GetItemPossessedBy(oPC, "ds_pckey");
    float fResize       = GetLocalFloat(oPCKey, "presize");

    DelayCommand( 0.5, RestoreSpellState( oPC ) );
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fResize);

}


void RestoreSpellState( object oPC ){

    int nClass,n,i;
    string sSpells;
    int nSpells, nMax;

    for( n=0;n<3;n++ ){

        nClass = GetClassByPosition( n+1, oPC );
        if( nClass == CLASS_TYPE_DRUID ||
            nClass == CLASS_TYPE_CLERIC ||
            nClass == CLASS_TYPE_RANGER ||
            nClass == CLASS_TYPE_PALADIN ||
            nClass == CLASS_TYPE_WIZARD ){

            for( i=0;i<10;i++ ){

                sSpells = GetLocalString( oPC, "spells_"+IntToString( n )+"_"+IntToString( i ) );

                if( sSpells != "" )
                    NWNX_Magic_UnPackSpellLevelString( oPC, n, i, sSpells );
            }
        }
        else if( nClass == CLASS_TYPE_SORCERER ||
                nClass == CLASS_TYPE_BARD ){

            for( i=0;i<10;i++ ){

                nSpells = GetLocalInt( oPC, "left_"+IntToString( n )+"_"+IntToString( i ) );
                nMax = NWNX_Magic_ModifySpellsPerDay( oPC, n, i, 2, -1 );

                if( nSpells > nMax )
                    nSpells = nMax;

                if( nSpells > 0 )
                    NWNX_Magic_ModifySpellsPerDay( oPC, n, i, 1, nSpells );
            }

        }
        else if( nClass == CLASS_TYPE_INVALID )
            return;
    }
}

