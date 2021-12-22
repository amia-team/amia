// Conversation action to open the Grundi's favoriate merchant.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/01/2004 jpavelch         Initial Release.
//

#include "nw_i0_plot"


void main()
{
    object oMerchant = GetNearestObjectByTag( "grundifavorstore" );
    if ( !GetIsObjectValid(oMerchant) )
        oMerchant = CreateObject( OBJECT_TYPE_STORE, "grundistore001", GetLocation(OBJECT_SELF) );

    if ( GetObjectType(oMerchant) == OBJECT_TYPE_STORE )
        gplotAppraiseOpenStore( oMerchant, GetPCSpeaker() );
    else
        ActionSpeakStringByStrRef( 53090 );
}
