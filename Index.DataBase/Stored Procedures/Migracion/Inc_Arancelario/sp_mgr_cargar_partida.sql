CREATE PROCEDURE [dbo].[sp_mgr_cargar_partida]
	@Result numeric(6,0) output
AS
BEGIN
	Declare @Nivel tinyint;

	update tbl_mgr_partida set accitem_clean = null, accitem_origen = null
	where len(accitem_clean) = 0

	DECLARE PartidaCursor CURSOR FOR
	select len(accitem_clean)
	from tbl_mgr_partida
	where len(accitem_clean) > 0
	group by len(accitem_clean)
	order by 1

    OPEN PartidaCursor
    FETCH NEXT FROM PartidaCursor INTO @Nivel
    WHILE @@FETCH_STATUS = 0
	Begin
		begin tran;
		INSERT INTO AccountingItem(AccountingItem,Description,Parent,Level,CustomDuties,Usable,RegisterDate,RegisterUser)
		select t1.AccItem_Origen,
				t1.descripcion,
				dbo.fn_mgr_Acc_Parent(t1.AccItem_Clean),
				dbo.fn_mgr_Acc_Parent_Level(t1.AccItem_Clean),
				t1.customdutie,
				case when (select count(1)
							from tbl_mgr_partida ts1
							where SUBSTRing(ts1.AccItem_Clean,1,@Nivel)= t1.AccItem_Clean
								and len(ts1.AccItem_Clean) > @Nivel) > 0
				then 0 else 1 end,
				getdate(),dbo.fn_mgr_user()
		from tbl_mgr_partida t1
		where t1.AccItem_Clean is not null
			and len(t1.AccItem_Clean) = @Nivel
		commit;
		FETCH NEXT FROM PartidaCursor INTO @Nivel
	end
END