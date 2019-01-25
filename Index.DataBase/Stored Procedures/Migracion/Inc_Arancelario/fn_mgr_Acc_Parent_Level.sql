CREATE FUNCTION [dbo].[fn_mgr_Acc_Parent_Level]
(
				@Acc nvarchar(50)
)
returns tinyint
as
begin
	declare @Long tinyint = len(@Acc),
			@Parent nvarchar(50) = NULL,
			@Nivel tinyint=1;

	while (@Long > 4)
	Begin
		set @Long = @Long -1;

		set @Parent = (select ts2.AccItem_Origen
					from tbl_mgr_partida ts2
					where ts2.AccItem_Clean = SUBSTRing(@Acc,1,@Long))

		if (@Parent is not null)
			set @Nivel += 1

	End
	return @Nivel
end