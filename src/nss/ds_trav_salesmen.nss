void ds_spawn_merchant( string sMerchant ){

    //variables
    string sDie         = IntToString( d4() );
    string sWaypoint    = sMerchant+"_"+sDie;
    location lLocation  = GetLocation( GetObjectByTag( sWaypoint ) );

    //create merchant and shop
    CreateObject( OBJECT_TYPE_CREATURE, sMerchant, lLocation );

}

void main(){
    if( GetLocalInt( OBJECT_SELF,"blocked") != 1 ){
        SetLocalInt( OBJECT_SELF,"blocked", 1 );
        DelayCommand( 0.2, ds_spawn_merchant("ds_fence") );
        DestroyObject( OBJECT_SELF, 1.0 );
    }
}
