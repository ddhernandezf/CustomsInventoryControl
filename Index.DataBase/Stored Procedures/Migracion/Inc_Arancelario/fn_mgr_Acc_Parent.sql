CREATE FUNCTION [dbo].[fn_mgr_Acc_Parent]
(
				@Acc nvarchar(50)
)
returns nvarchar(50)
as
begin
	declare @Long tinyint = len(@Acc),
			@Parent nvarchar(50) = NULL;

	while (@Long > 4)
	Begin
		set @Long = @Long -1;

		set @Parent = (select ts2.AccItem_Origen
					from tbl_mgr_partida ts2
					where ts2.AccItem_Clean = SUBSTRing(@Acc,1,@Long))

		if (@Parent is not null)
			break
	End
	return @Parent
end