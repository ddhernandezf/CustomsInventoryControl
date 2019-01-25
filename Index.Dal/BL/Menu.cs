using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal
{
    public static class Menu
    {
        public static List<spg_MenuByUser_Result> treeData;

        public static List<Commons.Menu> Get(String RoleName, String UserName)
        {
            List<Commons.Menu> obj = new List<Commons.Menu>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Menu_Result> allPremission = db.spg_Menu().ToList();
                List<spg_MenuByUser_Result> assignedPremission = db.spg_MenuByUser(RoleName,UserName).ToList();
                treeData = new List<spg_MenuByUser_Result>();
                OrderParents(allPremission, assignedPremission);
            }

            if (treeData != null && treeData.Count > 0)
            {
                treeData.ForEach(x => {
                    obj.Add(new Commons.Menu()
                    {
                        Id = x.Id,
                        Description = x.Description,
                        Name = x.Name,
                        Action = x.Action,
                        Area = x.Area,
                        Controller = x.Controller,
                        IdParent = x.IdParent,
                        Image = x.Image,
                        Order = x.Order,
                        Parameters = x.Parameters,
                        ShowMenu = x.ShowMenu,
                        HasCredentials = x.HasCredentials
                    });
                });
            }

            return obj.OrderBy(x=>x.Order).ToList();
        }

        private static void OrderParents(List<spg_Menu_Result> premissions, List<spg_MenuByUser_Result> assigned)
        {
            assigned.ForEach(x => {
                if (treeData.Where(a => a.Id == x.Id).ToList().Count == 0)
                {
                    treeData.Add(x);

                    if (x.IdParent != 0)
                    {
                        if (treeData.Where(y => y.Id == x.IdParent).ToList().Count == 0)
                        {
                            spg_Menu_Result item = premissions.Where(z => z.Id == x.IdParent).FirstOrDefault();
                            spg_MenuByUser_Result dataAdd = new spg_MenuByUser_Result()
                            {
                                Id = item.Id,
                                Description = item.Description,
                                Name = item.Name,
                                Action = item.Action,
                                Area = item.Area,
                                Controller = item.Controller,
                                IdParent = item.IdParent,
                                Image = item.Image,
                                Order = item.Order,
                                Parameters = item.Parameters,
                                ShowMenu = item.ShowMenu,
                                HasCredentials = item.HasCredentials
                            };
                            treeData.Add(dataAdd);
                            if (dataAdd.IdParent != 0)
                            {
                                OrderParents(premissions, assigned);
                            }
                        }
                        else
                        {
                            spg_Menu_Result parent = premissions.Where(z => z.Id == x.IdParent).FirstOrDefault();
                            if (treeData.Where(y => y.Id == parent.IdParent).ToList().Count == 0)
                            {
                                spg_Menu_Result item = premissions.Where(z => z.Id == parent.IdParent).FirstOrDefault();
                                if (item != null)
                                {
                                    spg_MenuByUser_Result dataAdd = new spg_MenuByUser_Result()
                                    {
                                        Id = item.Id,
                                        Description = item.Description,
                                        Name = item.Name,
                                        Action = item.Action,
                                        Area = item.Area,
                                        Controller = item.Controller,
                                        IdParent = item.IdParent,
                                        Image = item.Image,
                                        Order = item.Order,
                                        Parameters = item.Parameters,
                                        ShowMenu = item.ShowMenu,
                                        HasCredentials = item.HasCredentials
                                    };
                                    treeData.Add(dataAdd);
                                    if (dataAdd.IdParent != 0)
                                    {
                                        OrderParents(premissions, assigned);
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (x.IdParent != 0)
                    {
                        if (treeData.Where(y => y.Id == x.IdParent).ToList().Count == 0)
                        {
                            spg_Menu_Result item = premissions.Where(z => z.Id == x.IdParent).FirstOrDefault();
                            spg_MenuByUser_Result dataAdd = new spg_MenuByUser_Result()
                            {
                                Id = item.Id,
                                Description = item.Description,
                                Name = item.Name,
                                Action = item.Action,
                                Area = item.Area,
                                Controller = item.Controller,
                                IdParent = item.IdParent,
                                Image = item.Image,
                                Order = item.Order,
                                Parameters = item.Parameters,
                                ShowMenu = item.ShowMenu,
                                HasCredentials = item.HasCredentials
                            };
                            treeData.Add(dataAdd);
                            if (dataAdd.IdParent != 0)
                            {
                                OrderParents(premissions, assigned);
                            }
                        }
                        else
                        {
                            spg_Menu_Result parent = premissions.Where(z => z.Id == x.IdParent).FirstOrDefault();
                            if (treeData.Where(y => y.Id == parent.IdParent).ToList().Count == 0)
                            {
                                spg_Menu_Result item = premissions.Where(z => z.Id == parent.IdParent).FirstOrDefault();
                                if (item != null)
                                {
                                    spg_MenuByUser_Result dataAdd = new spg_MenuByUser_Result()
                                    {
                                        Id = item.Id,
                                        Description = item.Description,
                                        Name = item.Name,
                                        Action = item.Action,
                                        Area = item.Area,
                                        Controller = item.Controller,
                                        IdParent = item.IdParent,
                                        Image = item.Image,
                                        Order = item.Order,
                                        Parameters = item.Parameters,
                                        ShowMenu = item.ShowMenu,
                                        HasCredentials = item.HasCredentials
                                    };
                                    treeData.Add(dataAdd);
                                    if (dataAdd.IdParent != 0)
                                    {
                                        OrderParents(premissions, assigned);
                                    }
                                }
                            }
                        }
                    }
                }
            });
        }
    }
}
