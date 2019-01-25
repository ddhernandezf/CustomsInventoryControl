using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal
{
    public static class AccountingItem
    {
        public static Boolean Assign(Int32? IdResolution, Int32? IdAccountingItem)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_AccountingItemAssing(IdResolution, IdAccountingItem);
            }

            return true;
        }

        public static Boolean Unassign(Int32? IdResolution, Int32? IdAccountingItem)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_AccountingItemUnassing(IdResolution, IdAccountingItem);
            }

            return true;
        }

        public static List<Commons.AccountingItem> Get(Int32? IdAccountingItem, Int32? IdResolution)
        {
            List<Commons.AccountingItem> obj = new List<Commons.AccountingItem>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_AccountingItems_Result> result = db.spg_AccountingItems(IdAccountingItem, IdResolution).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.AccountingItem()
                    {
                        Id = x.Id,
                        IdResolution = x.IdResolution,
                        ResolutionName = x.ResolutionName,
                        AccountingItem_ = x.AccountingItem,
                        Description = x.Description,
                        Parent = x.Parent,
                        IdParent = x.IdParent,
                        ParentDescription = x.ParentDescription,
                        Level = x.Level,
                        CustomDuties = x.CustomDuties,
                        Usable = x.Usable,
                        AccountingItemDisplay = x.AccountingItemDisplay,
                        ParentAccountingItem = x.ParentAccountingItem,
                        ParentAccountingItemDisplay = x.ParentAccountingItemDisplay
                    });
                });
            }

            return obj;
        }

        public static List<Commons.AccountingItemTree> getTree(Int32? IdResolution)
        {
            List<Commons.AccountingItemTree> obj = new List<Commons.AccountingItemTree>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_AccountingItemTree_Result> result = db.spg_AccountingItemTree(IdResolution).ToList();
                List<spg_AccountingItemTree_Result> childs = result;

                result.Where(z => z.Parent == null).ToList().ForEach(x =>
                {
                    obj.Add(new Commons.AccountingItemTree()
                    {
                        Id = x.Id,
                        AccountingItem_ = x.AccountingItem,
                        Description = x.AccountingItem + " - " + x.Description,
                        Parent = x.Parent,
                        Level = x.Level,
                        CustomDuties = x.CustomDuties,
                        Usable = x.Usable,
                        Assigned = x.Assigned,
                        HasChildren = getChilds(childs.Where(a => a.Parent == x.AccountingItem).ToList(), IdResolution, result)
                    });
                });
            }

            return obj;
        }

        private static List<Commons.AccountingItemTree> getChilds(List<spg_AccountingItemTree_Result> data, Int32? IdResolution,
                                                                    List<spg_AccountingItemTree_Result> totalData)
        {
            List<Commons.AccountingItemTree> result = new List<Commons.AccountingItemTree>();

            using (IndexEntities db = new IndexEntities())
            {
                data.ForEach(x =>
                {
                    result.Add(new Commons.AccountingItemTree()
                    {
                        Id = x.Id,
                        AccountingItem_ = x.AccountingItem,
                        Description = x.AccountingItem + " - " + x.Description,
                        Parent = x.Parent,
                        Level = x.Level,
                        CustomDuties = x.CustomDuties,
                        Usable = x.Usable,
                        Assigned = x.Assigned,
                        //HasChildren = getChilds(db.spg_AccountingItemTree(IdResolution).Where(b => b.Parent == x.AccountingItem).ToList(), IdResolution)
                        HasChildren = getChilds(totalData.Where(y=>y.Parent == x.AccountingItem).ToList(), IdResolution, totalData)
                    });
                });
            }

            return result;
        }
    }
}
