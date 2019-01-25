update item
 set IdAccount = tmc.id_Account
from tbl_mgr_materia_producto tmmp, tbl_mgr_cliente tmc
where tmc.id_cliente = tmmp.id_Cliente
 and tmmp.IdItem = item.Id