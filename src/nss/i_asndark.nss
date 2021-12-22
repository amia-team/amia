/*  i_asndark

    --------
    Verbatim
    --------
    Description

    ---------
    Changelog
    ---------

    Date    Name        Reason
    ------------------------------------------------------------------
    050106  Disco       Corrected OnActivate event
    ------------------------------------------------------------------


*/

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void Darkness()
{
    ActionCastSpellAtLocation( SPELL_DARKNESS, GetItemActivatedTargetLocation(), METAMAGIC_NONE, TRUE,
        PROJECTILE_PATH_TYPE_DEFAULT, TRUE );
}

void ActivateItem(){
    object oUsed=GetItemActivated();

    if (GetTag(oUsed)== "asndark"){
        object oPC = GetItemActivator();
        //int iFail = GetArcaneSpellFailure(oPC);
        //int iRoll = d100(1);

        //RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oPC);

        //if (iFail < iRoll)
        //{
        SetLocalInt(oPC,"darkduration",GetLevelByClass(CLASS_TYPE_ASSASSIN,oPC));
        //RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oPC);
        AssignCommand(oPC,Darkness());
        //}
        //else{
        //     FloatingTextStringOnCreature("*Arcane Spell Failure*", oPC);
        //}
    }
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


