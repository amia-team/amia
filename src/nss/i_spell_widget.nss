#include "inc_nwnx_events"
#include "x2_inc_switches"
#include "nwnx_magic"

void AddSpellLike(object oPC, int nSpell, int nCL, int nUses){

    if(GetObjectType(oPC)!=OBJECT_TYPE_CREATURE)
        return;

    int n=0;
    string sList = NWNX_Magic_GetSpellLikeAbility(oPC,n);
    while(sList!=""){

        if(StringToInt(sList)==nSpell){
            NWNX_Magic_RemoveSpellLikeAbility(oPC,n);
            n=-1;
        }
        sList = NWNX_Magic_GetSpellLikeAbility(oPC,++n);
    }

    sList = IntToString(nSpell)+" 0 "+IntToString(nCL);

    SendMessageToPC(oPC,"Added Spelllike ability: "+sList);

    for(n=0;n<nUses;n++){
        NWNX_Magic_UnpackSpecialAbilityString(oPC, sList );
    }
}

void RemoveSpellLikeAbility(object oPC, int nSpell){

    if(GetObjectType(oPC)!=OBJECT_TYPE_CREATURE)
        return;

    int n=0;
    string sList = NWNX_Magic_GetSpellLikeAbility(oPC,n);
    while(sList!=""){

        if(StringToInt(sList)==nSpell){
            NWNX_Magic_RemoveSpellLikeAbility(oPC,n);
            n=-1;
        }
        sList = NWNX_Magic_GetSpellLikeAbility(oPC,++n);
    }

    SendMessageToPC(oPC,"Removed Spelllike ability: "+IntToString(nSpell));
}

void main(){

    int nEvent = GetUserDefinedItemEventNumber();

    if(nEvent==X2_ITEM_EVENT_INSTANT){

        EVENTS_Bypass();

        object oPC = OBJECT_SELF;
        object oItem = EVENTS_GetTarget(0);
        object oTarget = EVENTS_GetTarget(1);
        location lTarget = EVENTS_GetTargetLocation(0);

        SetLocalInt(oItem,"full_events",TRUE);

        //ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_ELEMENTAL_PROTECTION ), lTarget );

        if( GetStringLeft( GetName( oItem ), 7 ) != "Spell: " ){

            SetLocalString( oPC, "ds_action", "td_spellmaker" );
            SetLocalObject( oPC, "ds_target", oItem );
            AssignCommand( oPC, ActionStartConversation( oPC, "td_spellmaker", TRUE, FALSE ) );
            return;
        }

        int nUses   = GetLocalInt( oItem, "uses" );
        int nSpell  = GetLocalInt( oItem, "spell" );
        int nSelf   = GetLocalInt( oItem, "self" );
        int nCL     = GetLocalInt( oItem, "cl" );

        if( nCL == 0 )
            nCL = GetHitDice( oPC );
        else if( nCL < 0 )
            nCL = GetLevelByPosition( nCL*-1, oPC );

        if( nUses > 0 ){

            /*if( GetLocalInt( oItem, "left" ) <= 0 ){
                SendMessageToPC( oPC, "No uses left!" );
                return;
            }
            else
                SendMessageToPC( oPC, IntToString( GetLocalInt( oItem, "left" ) ) + " uses left!" );

            SetLocalInt( oItem, "left", GetLocalInt( oItem, "left" ) -1 );*/
            AddSpellLike(oPC, nSpell, nCL, nUses);
            return;
        }

        if( nSelf )
            oTarget = oPC;

        if(GetIsObjectValid(oTarget))
            AssignCommand( oPC, ActionCastSpellAtObject( nSpell, oTarget, METAMAGIC_ANY, TRUE, nCL ) );
        else
            AssignCommand( oPC, ActionCastSpellAtLocation( nSpell, lTarget, METAMAGIC_ANY, TRUE ) );
    }
    else if(nEvent == X2_ITEM_EVENT_ACQUIRE){

        return;

        object oItem = GetModuleItemAcquired();
        object oPC = GetModuleItemAcquiredBy();

        if( GetIsPC(oPC) && GetLocalInt( oItem, "uses" )>0){

            int nUses   = GetLocalInt( oItem, "uses" );
            int nSpell  = GetLocalInt( oItem, "spell" );
            int nCL     = GetLocalInt( oItem, "cl" );

            if( nCL == 0 )
                nCL = GetHitDice( oPC );
            else if( nCL < 0 )
                nCL = GetLevelByPosition( nCL*-1, oPC );

            DelayCommand(1.0,AddSpellLike(oPC,nSpell,nCL,nUses));
        }
    }
    else if(nEvent == X2_ITEM_EVENT_UNACQUIRE){

        object oItem = GetModuleItemLost();
        object oPC = GetModuleItemLostBy();

        if( GetIsPC(oPC) && GetLocalInt( oItem, "uses" )>0){
            RemoveSpellLikeAbility(oPC,GetLocalInt( oItem, "spell" ));
        }
    }
}

