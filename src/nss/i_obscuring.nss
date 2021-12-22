/*
---------------------------------------------------------------------------------
NAME: i_obscruing
Description: This is an item that toggles the obscuring aura on self.
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

/* includes */
#include "x2_inc_spellhook"

/* protoypes */
void toggleAura( );

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            toggleAura( );
            break;
    }
}
void toggleAura( )
{
    object oPC = OBJECT_SELF;
    object oItem = GetItemActivator();

    int iUsed = GetLocalInt( oItem, "fw_aur_ob" );

    if ( !iUsed ){
        SendMessageToPC( oPC, "<c¦ ¦>* * * Obscuring Aura Active * * *</c>" );
        SetLocalInt( oItem, "fw_aur_ob", 1 );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ExtraordinaryEffect( EffectAreaOfEffect( AOE_MOB_BLINDING, "obscuring_en", "****", "obscuring_ex" )), oItem );
    }
    else {
        effect eEffects     = GetFirstEffect( oPC );

        while( GetIsEffectValid( eEffects ) ){

            if( GetEffectCreator( eEffects ) == oPC ) {
                RemoveEffect( oPC, eEffects );
                SendMessageToPC( oPC, "<c¦ ¦>* * * Obscuring Aura Inactive * * *</c>" );
                DeleteLocalInt( oItem, "fw_aur_ob" );
                break;
            }

            eEffects = GetNextEffect( oPC );
        }
    }
}
