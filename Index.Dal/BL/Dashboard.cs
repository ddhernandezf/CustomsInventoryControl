using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Dashboard
    {
        public static Commons.Dashboard.Customer GetCustomer(Int32 IdCustomer)
        {
            Commons.Dashboard.Customer obj = new Commons.Dashboard.Customer();
            using (IndexEntities db = new IndexEntities())
            {
                spg_DashboardCustomer_Result result = db.spg_DashboardCustomer(IdCustomer).FirstOrDefault();
                obj.IdPerson = result.IdPerson;
                obj.EndDate = (DateTime)result.BondEndDate;
                obj.Days = (Int32)result.Days;
                obj.Label = result.Label;
            }

            return obj;
        }

        public static Commons.Dashboard.Expired GetExpired(Int32 IdCustomer, Int32 IdAccount)
        {
            Commons.Dashboard.Expired obj = new Commons.Dashboard.Expired();
            using (IndexEntities db = new IndexEntities())
            {
                spg_DashboardExpired_Result result = db.spg_DashboardExpired(IdCustomer, IdAccount).FirstOrDefault();
                obj.Total = (Int32)result.Total;
                obj.InTimePercent = (Decimal)result.InTimePercent;
                obj.InTimeQuantity = (Decimal)result.InTimeQuantity;
                obj.ToExpirePercent = (Decimal)result.ToExpirePercent;
                obj.ToExpireQuantity = (Decimal)result.ToExpireQuntity;
                obj.ExpiredPercent = (Decimal)result.ExpiredPercent;
                obj.ExpiredQuantity = (Decimal)result.ExpiredQuantity;
            }

            return obj;
        }

        public static Commons.Dashboard.Transmited GetTransmited(Int32 IdCustomer, Int32 IdAccount)
        {
            Commons.Dashboard.Transmited obj = new Commons.Dashboard.Transmited();
            using (IndexEntities db = new IndexEntities())
            {
                spg_DashboardTransmited_Result result = db.spg_DashboardTransmited(IdCustomer, IdAccount).FirstOrDefault();
                obj.Total = (Int32)result.Total;
                obj.SavedPercent = (Decimal)result.SavedPercent;
                obj.SavedQuantity = (Decimal)result.SavedQuantity;
                obj.QueuePercent = (Decimal)result.QueuePercent;
                obj.QueueQuantity = (Decimal)result.QueueQuantity;
                obj.TransmitedPercent = (Decimal)result.TransmitedPercent;
                obj.TransmitedQuantity = (Decimal)result.TransmitedQuantity;
            }

            return obj;
        }

        public static List<Commons.Dashboard.ExpiredDetail> GetExpiredDetail(Int32 IdCustomer, Int32 IdAccount)
        {
            List<Commons.Dashboard.ExpiredDetail> obj = new List<Commons.Dashboard.ExpiredDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DashboardExpiredDetail_Result> result = db.spg_DashboardExpiredDetail(IdCustomer, IdAccount).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Dashboard.ExpiredDetail()
                    {
                        IdFileHeader = x.IdFileHeader,
                        Document = x.Document,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        StartDate = x.StartDate,
                        EndDate = x.EndDate,
                        Days = x.Days,
                        Label = x.Label
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Dashboard.TransmitedDetail> GetTransmitedDetail(Int32 IdCustomer, Int32 IdAccount)
        {
            List<Commons.Dashboard.TransmitedDetail> obj = new List<Commons.Dashboard.TransmitedDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DashboardTransmitedDetail_Result> result = db.spg_DashboardTransmitedDetail(IdCustomer, IdAccount).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Dashboard.TransmitedDetail()
                    {
                        IdFileHeader = x.IdFileHeader,
                        Document = x.Document,
                        IdState = (Int32)x.IdState,
                        StateName = x.StateName
                    });
                });
            }

            return obj;
        }
    }
}
