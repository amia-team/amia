//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_customit_act
//group: DC requests
//used as: convo action script
//date:
//author: disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );


    if ( nNode == 1 ){

        //trick coin
        AssignCommand( oPC, ActionSpeakString( "<c þ >[?] <c fþ>D2</c> = </c><cþ  >1</c><c þ > [?]</c>" ) );
    }
    else if ( nNode == 2 ){

        //trick coin
        AssignCommand( oPC, ActionSpeakString( "<c þ >[?] <c fþ>D2</c> = </c><cþ  >2</c><c þ > [?]</c>" ) );
    }
    else if ( nNode == 3 ){

        //trick coin
        AssignCommand( oPC, ActionSpeakString( "<c þ >[?] <c fþ>D2</c> = </c><cþ  >3</c><c þ > [?]</c>" ) );
    }
    else {

    }
}
