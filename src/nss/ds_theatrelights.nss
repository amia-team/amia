//for Nekh's cordor theatre

void main(){

    object oArea=GetArea(OBJECT_SELF);
    int nColour=StringToInt(GetTag(OBJECT_SELF));
    vector vLocation;
    location lTile;
    int i;
    int j;
    float fX;
    float fY;



    if( GetName(OBJECT_SELF)=="Main Lights" ){


        //check toggle status
        if(GetLocalInt(oArea,"floodlight")==1){
            nColour=0;
            SetLocalInt(oArea,"floodlight",0);
            PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
        }
        else{
            nColour=5;
            SetLocalInt(oArea,"floodlight",1);
            PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
        }

        for (i=0; i<4; i++){
            for (j=0; j<4; j++){

                //walk through the area and set lights tile by tile
                fX=IntToFloat(i);
                fY=IntToFloat(j);

                //Make a location a tile
                vLocation = Vector(fX, fY, 0.0);
                lTile = Location(oArea, vLocation, 0.0);

                //set both types of mainlight colours in one go
                SetTileMainLightColor(lTile,nColour,nColour);
            }
        }

    }
    else if ( GetName(OBJECT_SELF)=="Central Light" ){

        object oLight = GetObjectByTag( "ds_central_light" );

        if ( GetLocalInt( oLight ,"NW_L_AMION" ) == 0 ) {

            PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
            AssignCommand( oLight, PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );

            SetLocalInt( oLight, "NW_L_AMION", 1 );

            effect eLight = EffectVisualEffect( VFX_DUR_LIGHT_YELLOW_20 );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oLight );
        }
        else{

            PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
            AssignCommand( oLight, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

            SetLocalInt( oLight, "NW_L_AMION", 0 );

            effect eEffect = GetFirstEffect( oLight );

            while ( GetIsEffectValid( eEffect ) == TRUE ){

                if ( GetEffectType( eEffect ) == EFFECT_TYPE_VISUALEFFECT ){

                    RemoveEffect( oLight, eEffect );
                }
                eEffect = GetNextEffect( oLight );
            }
        }
    }
    else{
        //check toggle status
        if(GetLocalInt(oArea,"spotlight")==nColour){
            nColour=0;
            SetLocalInt(oArea,"spotlight",0);
            PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
        }
        else{
            SetLocalInt(oArea,"spotlight",nColour);
            PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );
        }

        for (i=1; i<3; i++){
            for (j=1; j<3; j++){

                //walk through the area and set lights tile by tile
                fX=IntToFloat(i);
                fY=IntToFloat(j);

                //Make a location a tile
                vLocation = Vector(fX, fY, 0.0);
                lTile = Location(oArea, vLocation, 0.0);

                //set both types of mainlight colours in one go
                SetTileMainLightColor(lTile,nColour,nColour);
            }
        }

        //set both types of mainlight colours in one go
        SetTileMainLightColor(lTile,nColour,nColour);
    }

    RecomputeStaticLighting(oArea);
}
