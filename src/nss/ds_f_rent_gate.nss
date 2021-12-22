//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_f_rent_gate
//group: rentable gateway
//used as: convo activation target script
//date: 2017 August 27
//author: Maverick00053

void main(){

    object oPC          = OBJECT_SELF;
    string sAreaResRef  = GetResRef( GetArea( oPC ) );
    int    nNode        = GetLocalInt( oPC, "ds_node" );
    object oKey         = GetItemPossessedBy( oPC, sAreaResRef );
    location lGateway;
    object oGateway;
    int n = 1;
    if ( nNode == 1 )
    {
    oGateway = GetNearestObject(OBJECT_TYPE_PLACEABLE,oPC,n);
    while(GetIsObjectValid(oGateway))
    {

     if (GetResRef(oGateway) == "rentalgatewayope")
     {
      lGateway   = GetLocation( oGateway );
      // Checks to make sure the key is valid. If the key isnt of the same area the gate wont open
      if ( !GetIsObjectValid( oKey ) ) {
        AssignCommand( oGateway, SpeakString( "*You do not have the key for this gate.*" ));
        return;
      }
       //Replaces the plc and removes the old one
       DestroyObject( oGateway );
       CreateObject( OBJECT_TYPE_PLACEABLE, "rentalgateway", lGateway, TRUE );
       DeleteLocalInt( oPC, "ds_node" );
       DeleteLocalInt( oPC, "ds_action" );
       return;

     }


     if (GetResRef(oGateway) == "rentalgateway")
     {
      lGateway   = GetLocation( oGateway );
      // Checks to make sure the key is valid. If the key isnt of the same area the gate wont open
      if ( !GetIsObjectValid( oKey ) ) {
        AssignCommand( oGateway, SpeakString( "*You do not have the key for this gate.*" ));
        return;
      }
      //Replaces the plc and removes the old one
      DestroyObject( oGateway );
      CreateObject( OBJECT_TYPE_PLACEABLE, "rentalgatewayope", lGateway, TRUE );
      DeleteLocalInt( oPC, "ds_node" );
      DeleteLocalInt( oPC, "ds_action" );
      return;

     }

      n++;
      oGateway = GetNearestObject(OBJECT_TYPE_PLACEABLE,oPC,n);
    }
    }


}
