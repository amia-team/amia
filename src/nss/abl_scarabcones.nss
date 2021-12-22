/*
    Custom NPC Only Ability:
    Prismatic Scarab Swarm - Cone Spell Selection
    - Scarabs are built with all 4 elemental Cone spells available to them as
        special abilities, but we only want the scarabs to have one (randomized)
        cone ability to use, per individual scarab mob. So we randomly choose
        three of the others to decrement to zero uses remaining.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    int nRandom = d4();
    int nSpellID1;
    int nSpellID2;
    int nSpellID3;

    switch( nRandom )
    {
        case 0:
            nSpellID1 = 230;
            nSpellID2 = 232;
            nSpellID3 = 233;
            break;  //Keep Acid
        case 1:
            nSpellID1 = 229;
            nSpellID2 = 232;
            nSpellID3 = 233;
            break;  //Keep Cold
        case 2:
            nSpellID1 = 229;
            nSpellID2 = 230;
            nSpellID3 = 233;
            break;  //Keep Fire
        case 3:
            nSpellID1 = 229;
            nSpellID2 = 230;
            nSpellID3 = 232;
            break;  //Keep Elec
        default:
            nSpellID1 = 229;
            nSpellID2 = 230;
            nSpellID3 = 232;
            break;  //Keep Elec (default if error)
    }

    DecrementRemainingSpellUses( oCritter, nSpellID1 );
    DecrementRemainingSpellUses( oCritter, nSpellID2 );
    DecrementRemainingSpellUses( oCritter, nSpellID3 );
}
