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
        AssignCommand( oPC, ActionSpeakString( "<c � >[?] <c f�>D2</c> = </c><c�  >1</c><c � > [?]</c>" ) );
    }
    else if ( nNode == 2 ){

        //trick coin
        AssignCommand( oPC, ActionSpeakString( "<c � >[?] <c f�>D2</c> = </c><c�  >2</c><c � > [?]</c>" ) );
    }
    else if ( nNode == 3 ){

        //trick coin
        AssignCommand( oPC, ActionSpeakString( "<c � >[?] <c f�>D2</c> = </c><c�  >3</c><c � > [?]</c>" ) );
    }
    else {

    }
}
