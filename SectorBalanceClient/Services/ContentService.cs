﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SectorBalanceClient.Services
{
    public class ContentService
    {

        public ContentService()
        {

        }

        public string GetModelVersionDescription(int modelVersionId)
        {
            string desc = string.Empty;

            switch (modelVersionId)
            {
                case 1:

                    desc = "This is the first sector model. The model was created by selecting five of the available ETFs and balancing them in equal proportiion. The five sectors were energy, Technology, Consumer Staples, Consumer Discretionary and Materials. the start date for this model was December 1, 2014 and continued unti September 30,2015.  The selection of the five ETFs was based on some really cool criteria.";


                    /*

                    XLB :(20.0%)
                    XLE :(20.0%)
                    XLK :(20.0%)
                    XLY :(20.0%)
                    XLP :(20.0%)

                    */

                    break;

                case 2:

                    desc = "The second model reflects changing the allocation.";
                    break;

                case 3:

                    desc = "This is the third version of the Core model. The changes in this version ";
                    break;

                case 4:

                    desc = "This is the fourth description";
                    break;

                case 5:

                    desc = "This is the fifth version of the model.";
                    break;
            }

            return desc;
        }
    }
}
