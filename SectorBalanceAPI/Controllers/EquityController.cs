﻿using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using SectorBalanceBLL;
using SectorBalanceShared;

namespace SectorBalanceAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EquityController : ControllerBase
    {
        private readonly EquityManager eqMgr;

        public EquityController(IMemoryCache _cache, IConfiguration _config)
        {
            eqMgr = new EquityManager(_cache, _config);
        }

        [HttpGet]
        [Route("GetList")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public ActionResult<List<Equity>> GetList()
        {
            ManagerResult<List<Equity>> mgrResult =  eqMgr.GetList();
            if (!mgrResult.Success)
            {
                return BadRequest();
            }
            else
            {
                return Ok(mgrResult.Entity);
            }
        }

        [HttpGet]
        [Route("GetBySymbol")]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public ActionResult<Equity> Get(string symbol)
        {
            ManagerResult<Equity> mgrResult =  eqMgr.GetBySymbol(symbol);

            if (!mgrResult.Success)
            {
                return BadRequest();
            }
            else
            {
                return Ok(mgrResult.Entity);
            }
        }
    }
}