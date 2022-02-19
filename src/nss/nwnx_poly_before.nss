#include "nwnx_magic"

void SaveSpellState( object oPC );
void RestoreSpellState( object oPC );

void main( ){

    object oPC = OBJECT_SELF;
    int ShifterID = GetLocalInt( OBJECT_SELF, "LAST_POLY_ID");
    float fPolySizePre   = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
    object oPCKey        = GetItemPossessedBy(oPC, "ds_pckey");

    SaveSpellState( oPC );
    SetLocalFloat(oPCKey, "presize", fPolySizePre);


}

void SaveSpellState( object oPC ){

    int nClass,n,i;
    string sSpells;

    for( n=0;n<3;n++ ){

        nClass = GetClassByPosition( n+1, oPC );
        if( nClass == CLASS_TYPE_DRUID ||
            nClass == CLASS_TYPE_CLERIC ||
            nClass == CLASS_TYPE_RANGER ||
            nClass == CLASS_TYPE_PALADIN ||
            nClass == CLASS_TYPE_WIZARD ){

            for( i=0;i<10;i++ ){

                sSpells = NWNX_Magic_PackSpellLevelIntoString( oPC, n, i );

                if( sSpells != "" )
                    SetLocalString( oPC, "spells_"+IntToString( n )+"_"+IntToString( i ), sSpells );
            }
        }
        else if( nClass == CLASS_TYPE_SORCERER ||
                nClass == CLASS_TYPE_BARD ){

            for( i=0;i<10;i++ ){

                SetLocalInt( oPC, "left_"+IntToString( n )+"_"+IntToString( i ), NWNX_Magic_ModifySpellsPerDay( oPC, n, i, 1, -1 ) );
            }

        }
        else if( nClass == CLASS_TYPE_INVALID )
            return;
    }
}

