using System;
using System.Collections.Generic;
using Dapper;
using Npgsql;
using SectorBalanceShared;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using System.Linq;
using Dapper.FastCrud;

namespace SectorBalanceBLL
{
    public class EquityGroupManager : BaseManager
    {
        // this manager holds methods for equity_groups and equity_group_items tables
        // equity groups are collections of equities that are related by some criteria
        // these are different from user models which are collections of equities created
        // by users for whatever purposed
        
        public EquityGroupManager(IMemoryCache _cache, IConfiguration _config) : base(_cache, _config)
        {

        }

        public ManagerResult<List<EquityGroup>> GetList()
        {
            ManagerResult<List<EquityGroup>> mgrResult = new ManagerResult<List<EquityGroup>>();
            List<EquityGroup> equityGroupList = new List<EquityGroup>();
            
            try
            {  
                equityGroupList = cache.GetOrCreate<List<EquityGroup>>(CacheKeys.EQUITY_GROUP_LIST, entry =>
                {
                    using (NpgsqlConnection db = new NpgsqlConnection(connString))
                    {                    
                        return db.Query<EquityGroup>("SELECT * FROM equity_groups").ToList();
                    }
                });


                mgrResult.Entity = equityGroupList;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = default(List<EquityGroup>);
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

        public ManagerResult<EquityGroup> Save(EquityGroup equityGroup)
        {
            ManagerResult<EquityGroup> mgrResult = new ManagerResult<EquityGroup>();
            
            try
            {               
                if (equityGroup.Id == Guid.Empty)
                {
                    using (NpgsqlConnection db = new NpgsqlConnection(connString))
                    {
                        db.Insert(equityGroup);
                    }
                }
                else
                {
                    using (NpgsqlConnection db = new NpgsqlConnection(connString))
                    {
                        db.Update(equityGroup);
                    }
                }           
                mgrResult.Entity = equityGroup;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = default(EquityGroup);
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

        public ManagerResult<EquityGroup> ToggleActive(EquityGroup equityGroup)
        {
            ManagerResult<EquityGroup> mgrResult = new ManagerResult<EquityGroup>();
            
            try
            {
                equityGroup.Active = !equityGroup.Active;
                using (NpgsqlConnection db = new NpgsqlConnection(connString))
                {
                    bool ok = db.Update(equityGroup);               
                }
                mgrResult.Entity = equityGroup;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = default(EquityGroup);
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

   #region equity group items

        public ManagerResult<List<EquityGroupItem>> GetGroupItemsList(EquityGroup equityGroup)
        {
            ManagerResult<List<EquityGroupItem>> mgrResult = new ManagerResult<List<EquityGroupItem>>();
            List<EquityGroupItem> equityGroupItems = new List<EquityGroupItem>();
     
            try
            {  
                equityGroupItems = cache.GetOrCreate<List<EquityGroupItem>>(equityGroup.Id, entry =>
                {
                using (NpgsqlConnection db = new NpgsqlConnection(connString))
                {
                    return db.Query<EquityGroupItem>(@"SELECT * 
                                                        FROM equity_group_items 
                                                        WHERE group_id = @g",equityGroup.Id).ToList();                         
                }});

                mgrResult.Entity = equityGroupItems;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = default(List<EquityGroupItem>);
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

        public ManagerResult<EquityGroupItem> AddEquity(EquityGroup equityGroup, Guid equityId)
        {
            ManagerResult<EquityGroupItem> mgrResult = new ManagerResult<EquityGroupItem>();
            EquityGroupItem equityGroupItem = new EquityGroupItem();
            
            try
            {   
                equityGroupItem.GroupId = equityGroup.Id;
                equityGroupItem.EquityId = equityId;

                using (NpgsqlConnection db = new NpgsqlConnection(connString))
                {
                    db.Insert(equityGroupItem);                               
                }

                mgrResult.Entity = equityGroupItem;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = default(EquityGroupItem);
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

        public ManagerResult<bool> RemoveEquity(EquityGroup sysmbolGroup, Guid equitylId)
        {
            ManagerResult<bool> mgrResult = new ManagerResult<bool>();
            bool ok = false;

            try
            {
                var equityGroupItem = new EquityGroupItem();
                equityGroupItem.GroupId = sysmbolGroup.Id;
                equityGroupItem.EquityId = equitylId;

                using (NpgsqlConnection db = new NpgsqlConnection(connString))
                {
                    ok = db.Delete(equityGroupItem);                             
                }

                mgrResult.Entity = ok;
            }
            catch(Exception ex)
            {
                mgrResult.Entity = false;
                mgrResult.Exception = ex;
                mgrResult.Success = false;
                mgrResult.Message = ex.Message;
            } 

            return mgrResult;
        }

        #endregion
    }
}