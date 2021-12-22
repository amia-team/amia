/*
---------------------------------------------------------------------------------
NAME: obscuring_ex
Description: This is the onexit script of the obscuring aura.
LOG:
    Faded Wings [1/9/2016 - born]
----------------------------------------------------------------------------------
*/

/* Original Description

Obscuring Aura (Su): Sepulchral thieves are shrouded in a mind- and senses-clouding aura of negative energy.
Living creatures in a 30-foot radius must succeed on a Will save or be affected by the aura.
Creatures with fewer than one-half the sepulchral thief's Hit Dice are blinded and deafened.
For example, if the sepulchral thief has 9 HD, this applies to creatures of 4 HD or fewer.
All other creatures take a -2 penalty on Listen, Search, and Spot checks.
A creature that successfully saves cannot be affected again by the same thief's aura for 24 hours.

*/

void main( ){

    // Variables.
    object oCreature     = GetExitingObject( );
    object effectCreator = OBJECT_SELF;

    effect eEffects      = GetFirstEffect( oCreature );


    if( GetLocalInt( oCreature, "fw_obscuring" ) ){

        while( GetIsEffectValid( eEffects ) ){

            if( GetEffectCreator( eEffects ) == effectCreator ) {
                RemoveEffect( oCreature, eEffects );
                break;
            }
            eEffects = GetNextEffect( oCreature );
        }
    }

    DeleteLocalInt( oCreature, "fw_obscuring" );

    return;

}

