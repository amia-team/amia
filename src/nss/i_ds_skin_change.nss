/*  i_ds_summ_change

--------
Verbatim
--------
Gives PC a custom skin change widget

---------
Changelog
---------

Date         Name        Reason
------------------------------------------------------------------
2007-05-02   Disco       Start of header
2011-02-12   PoS         Added more features.
2011-03-19   PoS         Added yet more features.
2023-02-02   Frozen
2023-05-11   Frozen      Changed script to check on current appearance to deside-
                         -if to change or revert rather then on/off when using
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
//#include "aps_include"
//#include "amia_include"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void change_skin( object oPC, object oItem );
void change_scale( object oPC, float fScale);

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

            if ( GetResRef( oItem ) == "ds_skin_change" ){

                change_skin( oPC, oItem );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------


void change_skin( object oPC, object oItem ){

    int nInitialised =GetLocalInt( oItem, "initialised" );

    if ( nInitialised < 1 ){

        //first clicks
        if ( !GetIsDM( oPC ) ){

            SendMessageToPC( oPC, "Only DMs can initialise this item!" );
            return;
        }
    }

    if ( nInitialised == 0 ){

        //get creature skin and portrait
        object oTarget = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC );

        if ( oTarget == OBJECT_INVALID ){

            AssignCommand( oPC, SpeakString( "You can only use this close to a non-PC creature!" ) );
            return;
        }
        if ( GetAppearanceType( oTarget ) < 7 ){

            AssignCommand( oPC, SpeakString( "You cannot use a playable race appearance as a template!" ) );
            return;
        }

        //store creature stuff on item
        SetLocalInt( oItem, "cr_appearance", GetAppearanceType( oTarget ) );
        SetLocalString( oItem, "cr_portrait", GetPortraitResRef( oTarget ) );
        SetLocalInt( oItem, "cr_pheno", GetPhenoType( oTarget ) );
        SetLocalInt( oItem, "cr_tail", GetCreatureTailType( oTarget ) );
        SetLocalInt( oItem, "cr_wings", GetCreatureWingType( oTarget ) );
        SetLocalFloat( oItem, "cr_scale", GetObjectVisualTransform(oTarget, 10) );
        SetLocalInt( oItem, "initialised", 1 );

        //set item name
        SetName( oItem, "Skin Changer: "+GetName( oTarget ) );

        //feedback
        AssignCommand( oPC, SpeakString( "Skin Changer initialised with "+GetName( oTarget ) ) );

        //log
        //TrackItems( oPC, oTarget, GetName( oItem ), "Initialised" );
    }
    else if ( nInitialised == 1 ){

        //get PC skin and portrait

        //store pc stuff on item
        SetLocalInt( oItem, "pc_appearance", GetAppearanceType( oPC ) );
        SetLocalString( oItem, "pc_portrait", GetPortraitResRef( oPC ) );
        SetLocalInt( oItem, "pc_pheno", GetPhenoType( oPC ) );
        SetLocalInt( oItem, "pc_tail", GetCreatureTailType( oPC ) );
        SetLocalInt( oItem, "pc_wings", GetCreatureWingType( oPC ) );
        SetLocalFloat( oItem, "pc_scale", GetObjectVisualTransform(oPC, 10) );
        SetLocalInt( oItem, "initialised", 2 );

        //save character
        DelayCommand( 1.0, ExportSingleCharacter( oPC ) );

        //feedback
        AssignCommand( oPC, SpeakString( "Skin Changer attuned to "+GetName( oPC ) ) );

        //log
        //TrackItems( oPC, oPC, GetName( oItem ), "Attuned" );
    }
    else if ( nInitialised == 2 ){

        //variables
        float fDelay            = GetLocalFloat( oItem, "delay" );
        int nAppearanceSwitch   = GetLocalInt( oItem, "switch" );
        int nVisual             = GetLocalInt( oItem, "pc_vfx" );
        int nVisual2            = GetLocalInt( oItem, "pc_vfx2" );
        int nVisual3            = GetLocalInt( oItem, "pc_vfx3" );
        int nVisualDur          = GetLocalInt( oItem, "pc_vfx_dur" );
        int nVisualDur2         = GetLocalInt( oItem, "pc_vfx_dur2" );
        int nVisualDur3         = GetLocalInt( oItem, "pc_vfx_dur3" );
        int iCRskin             = GetLocalInt( oItem, "cr_appearance" );
        int iPCSkin             = GetAppearanceType (oPC);
        int nAppearance         = -1;
        int nPheno              = -1;
        int nTail               = -1;
        int nWing               = -1;
        float fScale            = 1.0;
        string sPortrait        = "";
        string sSFX1            = GetLocalString( oItem, "pc_sfx1" );
        string sSFX2            = GetLocalString( oItem, "pc_sfx2" );
        string sSFX3            = GetLocalString( oItem, "pc_sfx3" );

        if( iPCSkin == iCRskin ){

            // original form
            nAppearance = GetLocalInt( oItem, "pc_appearance" );
            sPortrait   = GetLocalString( oItem, "pc_portrait" );
            nPheno      = GetLocalInt( oItem, "pc_pheno" );
            nTail       = GetLocalInt( oItem, "pc_tail" );
            nWing       = GetLocalInt( oItem, "pc_wings" );
            fScale      = GetLocalFloat( oItem, "pc_scale");
            //SetLocalInt( oItem, "switch", 0 );
        }
        else {
            // alternate form
            nAppearance = GetLocalInt( oItem, "cr_appearance" );
            sPortrait   = GetLocalString( oItem, "cr_portrait" );
            nPheno      = GetLocalInt( oItem, "cr_pheno" );
            nTail       = GetLocalInt( oItem, "cr_tail" );
            nWing       = GetLocalInt( oItem, "cr_wings" );
            fScale      = GetLocalFloat(oItem, "cr_scale");
            SetLocalString( oItem, "pc_portrait", GetPortraitResRef( oPC ) );
        }

        //morph effect
        if( nVisual == 0 ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );
        }
        else {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual ), oPC );
        }

        if( nVisual2 != 0 ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual2 ), oPC );
        }

        if( nVisual3 != 0 ) {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVisual3 ), oPC );
        }

        // Permanent VFX effect
        if( iPCSkin == iCRskin ) {

            effect eEffect = GetFirstEffect( oPC );
            while ( GetIsEffectValid(eEffect) ) {

                if ( GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT && GetEffectSubType( eEffect ) == SUBTYPE_SUPERNATURAL )
                {
                    RemoveEffect( oPC, eEffect );
                }

                eEffect = GetNextEffect( oPC );
            }
        }
        else if( iPCSkin != iCRskin )
        {
            if( nVisualDur != 0 )
            {
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur ) ), oPC );
            }

            if( nVisualDur2 != 0 )
            {
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur2 ) ), oPC );
            }

            if( nVisualDur3 != 0 )
            {
                ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( nVisualDur3 ) ), oPC );
            }
        }

        // Play any defined custom sounds.
        if( sSFX1 != "" ) {
            AssignCommand( oPC, PlaySound( sSFX1 ) );
        }
        if( sSFX2 != "" ) {
            AssignCommand( oPC, PlaySound( sSFX2 ) );
        }
        if( sSFX3 != "" ) {
            AssignCommand( oPC, PlaySound( sSFX3 ) );
        }

        // morph
        DelayCommand( fDelay, SetCreatureAppearanceType( oPC, nAppearance ) );
        DelayCommand( fDelay, SetPortraitResRef( oPC, sPortrait ) );
        DelayCommand( fDelay, SetPhenoType( nPheno, oPC ) );
        DelayCommand( fDelay, SetCreatureTailType( nTail, oPC ) );
        DelayCommand( fDelay, SetCreatureWingType( nWing, oPC ) );
        DelayCommand( fDelay, change_scale( oPC, fScale) );
        if( fDelay < 0.5 )
            DelayCommand( fDelay+1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectPolymorph( POLYMORPH_TYPE_NULL_HUMAN ), oPC, 0.5 ) );

    }
}

void change_scale(object oPC, float fScale){
    if (fScale == 0.0) {
        SetObjectVisualTransform( oPC, 10, 1.0);
    }
    if (fScale > 0.0) {
        SetObjectVisualTransform( oPC, 10, fScale);
    }
}
