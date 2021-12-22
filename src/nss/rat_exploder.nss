void main()
{
       object oLever=OBJECT_SELF;
       object oArea=GetArea(oLever);

       object oRat=GetFirstObjectInArea(oArea);

        while(oRat!=OBJECT_INVALID){

            if(GetTag(oRat)=="cs_ud_rat1"){

                effect eExplode=EffectDeath(
                    TRUE,
                    TRUE);

                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    eExplode,
                    oRat,
                    0.0);

      }

      oRat=GetNextObjectInArea(oArea);

      }

      return;

}
