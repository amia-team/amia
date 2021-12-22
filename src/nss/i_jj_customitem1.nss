/*  i_jj_customitem1

--------
Verbatim
--------
Pools custom item request scripts

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2009-10-13   Disco       Start
2010-03-14   James       Added Fire! and Frost! DC Items
2010-03-15   James       Added White Wolf and White Were DC items
2010-03-24   James       Made Cloak Unequip/Reequip to fix cloak disappearing bug for White Wolf
2010-06-17   James       Made Mebrinade's Fake Tail and Wings
2010-06-20   James       Made Song of Winter's Wrath
2010-7-05    James       Made Werehawk
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x2_inc_itemprop"
//#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"



//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

void EmptyFunction( object oTarget );
void HybridLycan(object oItem);
void LargeWhiteWolf(object oItem);
void Werehawk(object oItem);
void WintersWrath();
void PolymorphFamilar(object oItem);


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName( oItem );
            location lTarget = GetItemActivatedTargetLocation();

            if ( sItemName == "Fire!" ){
                effect eShield = EffectVisualEffect( VFX_DUR_INFERNO );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oTarget, 1200.0 );

            }
            else if (sItemName == "Frost!"){
                effect eShield = EffectVisualEffect( VFX_DUR_ICESKIN );

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShield, oTarget, 1200.0 );

            }
            else if (sItemName == "Hybrid Lycan Form") {
                AssignCommand( oPC, HybridLycan(oItem));
            }
            else if (sItemName == "Larger Wolf Form") {
                AssignCommand( oPC, LargeWhiteWolf(oItem));
            }
            else if (sItemName == "Werehawk") {
                AssignCommand( oPC, Werehawk(oItem));
            }
            else if (sItemName == "Mebrinade's Fake Tail") {
                if (GetCreatureTailType( oPC ) == CREATURE_TAIL_TYPE_NONE)
                    SetCreatureTailType( 583 , oPC );
                else
                    SetCreatureTailType( CREATURE_TAIL_TYPE_NONE , oPC );
            }
            else if (sItemName == "Mebrinade's Fake Wings") {
                if (GetCreatureWingType( oPC ) == CREATURE_WING_TYPE_NONE)
                    SetCreatureWingType( 13 , oPC );
                else
                    SetCreatureWingType( CREATURE_WING_TYPE_NONE , oPC );
            }
            else if ( sItemName == "Song of Winter's Wrath" ){
                AssignCommand( oPC, WintersWrath() );
            }
            else if ( sItemName == "Polymorph Familar" ){
                AssignCommand( oPC, PolymorphFamilar( oItem ) );
            }
            else if ( sItemName == "" ){

                AssignCommand( oPC, EmptyFunction( oTarget ) );
            }


        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


//-------------------------------------------------------------------------------
//Definitions
//-------------------------------------------------------------------------------


void EmptyFunction( object oTarget ){

}


void HybridLycan(object oItem) {
    object oPC = OBJECT_SELF;
    //Find oPC's current appearance type
    int nAppear = GetAppearanceType( oPC );
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);

    if (nAppear == APPEARANCE_TYPE_WEREWOLF)
    {
        nAppear = GetLocalInt(oItem, "STORED_APPEARANCE");
        SetCreatureAppearanceType(oPC, nAppear);
        effect eEffect = GetFirstEffect( oPC );

        while ( GetIsEffectValid(eEffect) ) {

            if ( GetEffectCreator( eEffect ) == oPC && GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT ){

                RemoveEffect( oPC, eEffect );
            }

            eEffect = GetNextEffect( oPC );
        }
    }
    else
    {
        SetLocalInt(oItem, "STORED_APPEARANCE", nAppear);
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_WEREWOLF);
        effect eDur = SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDur,oPC);
    }
}
void Werehawk(object oItem){
    object oPC = OBJECT_SELF;
    //Find oPC's current appearance type
    int nAppear = GetAppearanceType( oPC );
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);
    PlaySound("as_an_hawk1");

    if (nAppear == 758)
    {
        nAppear = GetLocalInt(oItem, "STORED_APPEARANCE");
        SetCreatureTailType(GetLocalInt(oItem,"STORED_TAIL_TYPE"));
        SetCreatureWingType(GetLocalInt(oItem,"STORED_WING_TYPE"));
        SetCreatureAppearanceType(oPC, nAppear);
        SetPortraitResRef(oPC,GetLocalString(oItem,"STORED_PORTRAIT"));
        object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK);
        ActionUnequipItem(oCloak);
        ActionEquipItem(oCloak,INVENTORY_SLOT_CLOAK);
    }
    else
    {
        SetLocalInt(oItem, "STORED_APPEARANCE", nAppear);
        SetLocalInt(oItem, "STORED_TAIL_TYPE", GetCreatureTailType());
        SetLocalInt(oItem, "STORED_WING_TYPE", GetCreatureWingType());
        SetLocalString(oItem, "STORED_PORTRAIT",GetPortraitResRef());
        SetCreatureAppearanceType(oPC, 758);
        SetCreatureTailType(499);
        SetCreatureWingType(CREATURE_WING_TYPE_BIRD);
        SetPortraitResRef(oPC,"po_kenku_b");

//        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eDur),oPC);

    }
}


void LargeWhiteWolf(object oItem){
    object oPC = OBJECT_SELF;
    //Find oPC's current appearance type
    int nAppear = GetAppearanceType( oPC );
    effect eVis = EffectVisualEffect(685);
        eVis = EffectLinkEffects(EffectVisualEffect(683),eVis);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);
    PlaySound("as_an_wolfhowl2");

    if (nAppear == 843)
    {
        nAppear = GetLocalInt(oItem, "STORED_APPEARANCE");
        SetCreatureTailType(GetLocalInt(oItem,"STORED_TAIL_TYPE"));
        SetCreatureAppearanceType(oPC, nAppear);
        SetPortraitResRef(oPC,GetLocalString(oItem,"STORED_PORTRAIT"));
        object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK);
        ActionUnequipItem(oCloak);
        ActionEquipItem(oCloak,INVENTORY_SLOT_CLOAK);
    }
    else
    {
        SetLocalInt(oItem, "STORED_APPEARANCE", nAppear);
        SetLocalInt(oItem, "STORED_TAIL_TYPE", GetCreatureTailType());
        SetLocalString(oItem, "STORED_PORTRAIT",GetPortraitResRef());
        SetCreatureAppearanceType(oPC, 843);
        SetCreatureTailType(393);
        SetPortraitResRef(oPC,"po_wolfwint_");

//        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eDur),oPC);

    }
}
void WintersWrath() {
    location lLoc = GetLocation( OBJECT_SELF );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, DISTANCE_MEDIUM, lLoc);
    effect eVfx = EffectVisualEffect(VFX_DUR_BARD_SONG);
    eVfx = EffectLinkEffects(EffectVisualEffect(VFX_IMP_PULSE_COLD), eVfx);
    eVfx = EffectLinkEffects(EffectVisualEffect(356), eVfx);
    effect eImp = EffectVisualEffect(VFX_FNF_ICESTORM);
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVfx, OBJECT_SELF );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImp, OBJECT_SELF, 1.0);
    ActionSpeakString("Rise, Auril's might! Show what's yours, turn the lands to ice!");
    float fDelay;
    while ( GetIsObjectValid( oTarget ) )
    {
        if ( GetIsReactionTypeHostile( oTarget ) )
        {
            //AoE doing 10d6 (35av) Cold + 10d6 (35av) Sonic damage (saveless),
            effect eEffect = EffectDamage( d6(10), DAMAGE_TYPE_COLD );
            eEffect = EffectLinkEffects( EffectDamage( d6(10), DAMAGE_TYPE_SONIC ), eEffect);
            //Fort Save vs Knockdown @ DC 35. Affects Hostile.
            if (FortitudeSave( oTarget, 35 ) == 0)
            {
                 eEffect = EffectLinkEffects( EffectKnockdown(), eEffect );
            }
            fDelay = GetRandomDelay();
            DelayCommand ( fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImp, oTarget, 1.0 ) );
            DelayCommand( fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, eEffect, oTarget) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, DISTANCE_MEDIUM, lLoc);
    }
}

void PolymorphFamilar(object oItem)
{
    object oFamilar = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    if (!GetIsObjectValid(oFamilar)) return;
    int nAppear = GetAppearanceType( oFamilar );
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFamilar);

    if (nAppear == APPEARANCE_TYPE_NYMPH)
    {
        nAppear = GetLocalInt(oItem, "STORED_APPEARANCE");
        string sDesc = GetLocalString(oItem, "STORED_DESCRIPTION");
        string sPort = GetLocalString(oItem, "STORED_PORTRAIT");
        SetCreatureAppearanceType(oFamilar, nAppear);
        SetDescription(oFamilar,sDesc);
        SetPortraitResRef(oFamilar,sPort);
    }
    else
    {
        SetLocalInt(oItem, "STORED_APPEARANCE", nAppear);
        SetLocalString(oItem, "STORED_DESCRIPTION",GetDescription(oFamilar));
        SetLocalString(oItem, "STORED_PORTRAIT",GetPortraitResRef(oFamilar));
        SetCreatureAppearanceType(oFamilar, APPEARANCE_TYPE_NYMPH);
        SetDescription(oFamilar,"Nymphs are nature's embodiment of physical beauty: They are so unbearably lovely that even a glimpse can blind or kill unwary onlookers.");
        SetPortraitResRef(oFamilar,"po_Nymph_");

    }
}
