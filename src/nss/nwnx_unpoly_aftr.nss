#include "nwnx_magic"
#include "amia_include"
#include "x2_inc_itemprop"
#include "x0_i0_spells"

void RemoveShapeEffects(object oPC, int nPoly);
void RestoreSpellState( object oPC );

void main( ){

    object oPC = OBJECT_SELF;
    int ShifterID = GetLocalInt( OBJECT_SELF, "LAST_POLY_ID");
    object oPCKey       = GetItemPossessedBy(oPC, "ds_pckey");
    float fResize       = GetLocalFloat(oPCKey, "presize");

    DelayCommand( 0.5, RestoreSpellState( oPC ) );
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fResize);


    if(GetLocalInt(OBJECT_SELF,"POLY_COOLDOWN") == 0)
    {
    //Poly cool down
    SetLocalInt( OBJECT_SELF, "POLY_COOLDOWN", 1 );
    DelayCommand(24.0,DeleteLocalInt(OBJECT_SELF,"POLY_COOLDOWN"));
    DelayCommand(24.0,SendMessageToPC(OBJECT_SELF,"You may now shift to another form!"));
    }

    if(GetPCKEYValue(OBJECT_SELF,"lycanTailTransform")==1)
    {
     SetPCKEYValue(OBJECT_SELF,"lycanTailTransform",0);
     DelayCommand(0.1,SetCreatureTailType(GetPCKEYValue(OBJECT_SELF,"lycanTail"),OBJECT_SELF));
    }

    /*   Removed the Nerf for the time being to counteract nerf from poly delay in place now - Maverick 7/24/22

    // Nerf so they dont retain spells from previous shapes
    RemoveShapeEffects(oPC,GetLocalInt(oPC, "LAST_POLY_ID"));

    */

}

void RemoveShapeEffects(object oPC, int nPoly)
{
    object oCreator = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    effect eEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(eEffect))
    {

        // New code to remove effects only castable by that form they currently are using
        // Added in all the forms for future adding/removing - Maverick00053
        if(nPoly == 123) // Red Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 665) || (GetEffectSpellId(eEffect) == 299))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 124) // Epic Red Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 665) || (GetEffectSpellId(eEffect) == 300))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 125) // Blue Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 667))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 126) // Epic Blue Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 667) || (GetEffectSpellId(eEffect) == 222))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 127) // Black Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 664))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 128) // Black Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 664) || (GetEffectSpellId(eEffect) == 224))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 129) // Green Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 666) || (GetEffectSpellId(eEffect) == 273))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 130) // Epic Green Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 666) || (GetEffectSpellId(eEffect) == 274))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 131) // White Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 663) || (GetEffectSpellId(eEffect) == 247))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 132) // Epic White Wyrmling
        {
          if((GetEffectSpellId(eEffect) == 663) || (GetEffectSpellId(eEffect) == 248))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 133) // Harpy
        {
        }
        else if(nPoly == 134) // Epic Harpy
        {
        }
        else if(nPoly == 135) // Gargoyle
        {
        }
        else if(nPoly == 136) // Epic Gargoyle
        {
        }
        else if(nPoly == 137) // Minotaur
        {
          if((GetEffectSpellId(eEffect) == 422))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 138) // Epic Minotaur
        {
          if((GetEffectSpellId(eEffect) == 422))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 139) //Basilisk
        {
        }
        else if(nPoly == 140) // Epic Basilisk
        {
          if((GetEffectSpellId(eEffect) == 172))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 141) //Drider
        {
          if((GetEffectSpellId(eEffect) == 365))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 142) // Epic Drider
        {
          if((GetEffectSpellId(eEffect) == 365))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 143) //Manticore
        {
        }
        else if(nPoly == 144) // Epic Manticore
        {
        }
        else if(nPoly == 145 || nPoly == 147) // Drow (Male + Female)
        {
        }
        else if(nPoly == 146 || nPoly == 148) // Epic Drow (Male + Female)
        {
          if((GetEffectSpellId(eEffect) == 102))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 149) //Lizardfolk
        {
        }
        else if(nPoly == 150) // Epic Lizardfolk
        {
          if((GetEffectSpellId(eEffect) == 124))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 151) // Kobold
        {
          if((GetEffectSpellId(eEffect) == 420))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 152) // Epic Kobold
        {
          if((GetEffectSpellId(eEffect) == 420) || (GetEffectSpellId(eEffect) == 455))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 153) //Dire Tiger
        {
          if((GetEffectSpellId(eEffect) == 647))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 154) // Epic Dire Tiger
        {
          if((GetEffectSpellId(eEffect) == 647))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 155) // Medusa
        {
        }
        else if(nPoly == 156) // Epic Medusa
        {
        }
        else if(nPoly == 157) // Mindflayer
        {
          if((GetEffectSpellId(eEffect) == 741))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 158) // Epic Mindflayer
        {
          if((GetEffectSpellId(eEffect) == 741))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 159) // Risenlord
        {
          if((GetEffectSpellId(eEffect) == 519))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 160 || nPoly == 161) // Vampire (Male + Female)
        {
          if((GetEffectSpellId(eEffect) == 370))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 162) // Spectre
        {
          if((GetEffectSpellId(eEffect) == 88))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 163  || nPoly == 164) // Azer (Male + Female)
        {
          if((GetEffectSpellId(eEffect) == 542) || (GetEffectSpellId(eEffect) == 300))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 165  || nPoly == 166) // Rakshasa (Male + Female)
        {
        }
        else if(nPoly == 167) // Death Slaad
        {
        }
        else if(nPoly == 168) // Stone Golem
        {
          if((GetEffectSpellId(eEffect) == 113))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 169) // Iron Golem
        {
        }
        else if(nPoly == 170) // Demonflesh Golem
        {
          if((GetEffectSpellId(eEffect) == 99))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 253  || nPoly == 255) // Dwarven Defender (Male + Female)
        {
        }
        else if(nPoly == 254  || nPoly == 256) // Epic Dwarven Defender (Male + Female)
        {
        }
        else if(nPoly == 257) // Ogre Stomper
        {
          if((GetEffectSpellId(eEffect) == 299))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 258) // Epic Ogre Stomper
        {
          if((GetEffectSpellId(eEffect) == 299) || (GetEffectSpellId(eEffect) == 247))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 259) // Yuan Ti
        {
          if((GetEffectSpellId(eEffect) == 62))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 260) // Epic Yuan Ti
        {
          if((GetEffectSpellId(eEffect) == 62))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 261) //Cyclops
        {
          if((GetEffectSpellId(eEffect) == 273) || (GetEffectSpellId(eEffect) == 247) || (GetEffectSpellId(eEffect) == 299))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 262 || nPoly == 263) //Fire Giant HC (Male + Female)
        {
        }
        else if(nPoly == 264) // Gaint Bruiser
        {
          if((GetEffectSpellId(eEffect) == 74))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 265) // Garguantuan Grick
        {
        }
        else if(nPoly == 266) // Demon Overlord
        {
          if((GetEffectSpellId(eEffect) == 168))
          {
            RemoveEffect(oPC, eEffect);
          }
        }
        else if(nPoly == 267) // Pyroclastic Dragon
        {
        }

        eEffect = GetNextEffect(oPC);
    }
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

