void main(){

    object oPC = GetLastAttacker();

    AssignCommand( oPC, ClearAllActions() );

    if ( GetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ) ) != 1 ){

        int nMod        = GetAbilityModifier( ABILITY_STRENGTH, oPC ) / 2;
        int nRoll       = d12( nMod );
        int nDC         = GetHitDice( oPC ) + 12;

        if ( nMod < 1 ){

            SendMessageToPC( oPC, "Bashing Door: Failure (0 vs DC " + IntToString( nDC ) + ")" );
        }
        else if ( nRoll < nDC ){

            SendMessageToPC( oPC, "Bashing Door: Failure (" + IntToString( nRoll ) + " vs DC " + IntToString( nDC ) + ")" );
        }
        else{

            SendMessageToPC( oPC, "Bashing Door: Success (" + IntToString( nRoll ) + " vs DC " + IntToString( nDC ) + ")" );

            PlayAnimation( ANIMATION_DOOR_OPEN1 );

            SetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ), 1 );
        }
    }
    else{


        SendMessageToPC( oPC, "[You have cracked this door during this session. Opening it for you.]" );

        PlayAnimation( ANIMATION_DOOR_OPEN1 );

        DelayCommand( 12.0, PlayAnimation(  ANIMATION_DOOR_CLOSE ) );

        DelayCommand( 13.0, SetLocked( OBJECT_SELF, TRUE ) );
    }




}
