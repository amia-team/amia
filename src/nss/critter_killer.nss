void main(){

    object oCritter = GetEnteringObject();

    if ( GetObjectType( oCritter ) !=  OBJECT_TYPE_CREATURE ){

        //not a creature
        return;
    }

    if ( GetIsPC( oCritter ) || GetIsPossessedFamiliar( oCritter ) ){

        //is a PC
        return;
    }

    if ( GetIsDM( oCritter )  || GetIsDMPossessed( oCritter ) ){

        //is a DM
        return;
    }

    if( GetMaster( oCritter ) != OBJECT_INVALID ){

        //is a companion or charmed
        return;
    }

    DestroyObject( oCritter );
}
