declare @res table (
  name nvarchar(max), src nvarchar(max),
  isOk bit default (0),
  error nvarchar(max)
)

declare @name nvarchar(max), @error nvarchar(max)

insert into @res (name, src)
select name, data_source from sys.servers

declare cur cursor local static for
select name from @res

open cur

while 1 = 1
begin
  fetch next from cur into @name
  if @@FETCH_STATUS <> 0 break

  select @error = null
  begin try
    exec sp_testlinkedserver @servername = @name
    
    update @res set isOk = 1, error = null where name = @name
  end try
  begin catch
    select @error = ERROR_MESSAGE()
    update @res set error = @error where name = @name
  end catch
end

close cur
deallocate cur

select * from @res
