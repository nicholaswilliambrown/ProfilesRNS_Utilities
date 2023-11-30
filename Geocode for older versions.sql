/****** Object:  Table [Profile.Import].[PRNSWebservice.Log]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Job] [varchar](100) NOT NULL,
	[BatchID] [varchar](100) NOT NULL,
	[RowID] [int] NOT NULL,
	[HttpMethod] [varchar](10) NULL,
	[URL] [varchar](500) NULL,
	[PostData] [varchar](max) NULL,
	[ServiceCallStart] [datetime] NULL,
	[ServiceCallEnd] [datetime] NULL,
	[ProcessEnd] [datetime] NULL,
	[Success] [bit] NULL,
	[HttpResponseCode] [int] NULL,
	[HttpResponse] [varchar](max) NULL,
	[ResultCount] [int] NULL,
	[ErrorText] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Profile.Import].[PRNSWebservice.Log.Summary]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Log.Summary](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[Job] [varchar](100) NOT NULL,
	[BatchID] [varchar](100) NOT NULL,
	[RecordsCount] [int] NULL,
	[RowsCount] [int] NULL,
	[JobStart] [datetime] NULL,
	[JobEnd] [datetime] NULL,
	[ErrorCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Profile.Import].[PRNSWebservice.Options]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Options](
	[job] [varchar](100) NOT NULL,
	[url] [varchar](500) NULL,
	[options] [varchar](100) NULL,
	[apiKey] [varchar](100) NULL,
	[logLevel] [int] NULL,
	[batchSize] [int] NULL,
	[GetPostDataProc] [varchar](1000) NULL,
	[ImportDataProc] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[job] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Profile.Import].[PRNSWebservice.Options] ([job], [url], [options], [apiKey], [logLevel], [batchSize], [GetPostDataProc], [ImportDataProc]) VALUES (N'geocode', N'https://maps.googleapis.com/maps/api/geocode/xml?address=', NULL, NULL, 2, NULL, N'[Profile.Import].[GoogleWebservice.GetGeocodeAPIData]', N'[Profile.Import].[GoogleWebservice.ParseGeocodeResults]')
GO

/****** Object:  StoredProcedure [Profile.Import].[GoogleWebservice.GetGeocodeAPIData]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[GoogleWebservice.GetGeocodeAPIData]	 
	@Job varchar(55),
	@BatchID varchar(100)
AS
BEGIN
	SET NOCOUNT ON;	

	CREATE TABLE #tmp (LogID INT, BatchID VARCHAR(100), RowID INT IDENTITY, HttpMethod VARCHAR(10), URL VARCHAR(500), PostData VARCHAR(MAX)) 

	INSERT INTO #tmp(URL) 
	SELECT DISTINCT addressstring
	  FROM [Profile.Data].Person
	 WHERE (ISNULL(latitude ,0)=0
 			OR geoscore = 0)
	and addressstring<>''
	and IsActive = 1

	UPDATE t SET
		t.LogID = -1,
		t.BatchID = @BatchID, 
		t.HttpMethod = 'GET',
		t.URL = o.url + REPLACE(REPLACE(t.URL, '#', '' ), ' ', '+') + '&sensor=false' + isnull('&key=' + apikey, '') 
			FROM #tmp t
			JOIN [Profile.Import].[PRNSWebservice.Options] o ON o.job = 'geocode'

	IF EXISTS (SELECT 1 FROM [Profile.Import].[PRNSWebservice.Options] WHERE job = 'geocode' AND logLevel > 0)
	BEGIN
		DECLARE @LogIDTable TABLE (LogID int, RowID int)
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT 'Geocode', BatchID, RowID, HttpMethod, URL FROM #tmp

		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END

	SELECT * FROM #tmp
END
GO
/****** Object:  StoredProcedure [Profile.Import].[GoogleWebservice.ParseGeocodeResults]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[GoogleWebservice.ParseGeocodeResults]
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	SET NOCOUNT ON;	
	declare @x xml, @status varchar(100), @errorText varchar(max), @lat varchar(20), @lng varchar(20), @location_type varchar(100)

	begin try
		set @x = cast(@data	as xml)
	end try
	begin catch
		set @status = 'XML Parsing Error'
		set @errorText = ERROR_MESSAGE()
	end catch

	if @x is not null
	BEGIN
		select @status = nref.value('status[1]','varchar(100)'),
		@errorText = nref.value('error_message[1]','varchar(max)'),
		@lat = nref.value('result[1]/geometry[1]/location[1]/lat[1]','varchar(20)'),
		@lng = nref.value('result[1]/geometry[1]/location[1]/lng[1]','varchar(20)'),
		@location_type = nref.value('result[1]/geometry[1]/location_type[1]','varchar(100)')
		from @x.nodes('//GeocodeResponse[1]') as R(nref)
	END

	IF @status = 'OK' 
	BEGIN
		UPDATE t SET t.Latitude = @lat, t.Longitude = @lng, t.GeoScore = case when @location_type = 'ROOFTOP' then 9 when @location_type = 'RANGE_INTERPOLATED' then 6 when @location_type = 'GEOMETRIC_CENTER' then 4 else 3 end
			FROM [Profile.Data].Person t
			JOIN [Profile.Import].[PRNSWebservice.Options] o ON o.job = 'geocode'
			AND @URL = o.url + REPLACE(REPLACE(t.AddressString, '#', '' ), ' ', '+') + '&sensor=false' + isnull('&key=' + options, '') 
			AND isnull(t.GeoScore, 0) < 10
		update [Profile.Import].[PRNSWebservice.Log] set ResultCount = @@ROWCOUNT where LogID = @LogID
	END
	ELSE 
	BEGIN
		if @LogID > 0
		begin
			select @LogID = isnull(@LogID, -1) from [Profile.Import].[PRNSWebservice.Log] where BatchID = @BatchID and RowID = @RowID
		end

		if @LogID > 0
			update [Profile.Import].[PRNSWebservice.Log] set Success = 0, HttpResponse = @Data, ErrorText = isnull(@status, '') + ' : ' + isnull(@errorText, '') where LogID = @LogID
		else
			insert into [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, URL, HttpResponse, Success, ErrorText) Values ('Geocode', @BatchID, @RowID, @URL, @Data, 0, isnull(@status, '') + ' : ' + isnull(@errorText, ''))
	END
END
GO
/****** Object:  StoredProcedure [Profile.Import].[PRNSWebservice.AddLog]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.AddLog]
	@logID BIGINT = -1,
	@batchID varchar(100) = null,
	@rowID int = -1,
	@Job varchar(55),
	@action VARCHAR(200),
	@actionText varchar(max) = null,
	@newLogID BIGINT OUTPUT
AS
BEGIN
	DECLARE @LogLevel INT
	SELECT @LogLevel = LogLevel FROM [Profile.Import].[PRNSWebservice.Options] WHERE Job=@Job

	IF @LogLevel > 0 OR @action = 'Error'
	BEGIN 
		IF @logID < 0
		BEGIN
			SELECT @logID = ISNULL(LogID, -1) FROM [Profile.Import].[PRNSWebservice.Log] WHERE BatchID = @batchID AND RowID = @rowID

			if @logID < 0
			BEGIN
				DECLARE @LogIDTable TABLE (logID BIGINT)
				INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID)
				OUTPUT Inserted.LogID INTO @LogIDTable
				VALUES (@job, @batchID, @rowID)
				SELECT @logID = LogID from @LogIDTable
			END
		END

		IF @action='StartService'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ServiceCallStart = GETDATE()
				 WHERE LogID = @logID
			END
		IF @action='EndService'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ServiceCallEnd = GETDATE()
				 WHERE LogID = @logID
			END
		IF @action='RowComplete'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ProcessEnd  =GETDATE(),
					   Success= isnull(Success, 1)
				 WHERE LogID = @logID
			END
		IF @action='Error'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ErrorText = isnull(ErrorText + ' ', '') + @actionText,
					   ProcessEnd  =GETDATE(),
					   Success=0
				 WHERE LogID = @logID
			END
	END
	Select @newLogID = @logID
END
GO
/****** Object:  StoredProcedure [Profile.Import].[PRNSWebservice.CheckForErrors]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[PRNSWebservice.CheckForErrors]
	@BatchID varchar(100)
AS
BEGIN
	DECLARE @ErrorCount int
	select @ErrorCount = count(*) from  [Profile.Import].[PRNSWebservice.Log] WHERE BatchID = @BatchID AND Success = 0
	UPDATE [Profile.Import].[PRNSWebservice.Log.Summary] set JobEnd = GETDATE(), ErrorCount = @ErrorCount WHERE BatchID = @BatchID
	IF @ErrorCount > 0
		RAISERROR('%i Errors recorded in [Profile.Import].[PRNSWebservice.Log] for BatchID %s',16,1, @ErrorCount, @BatchID);
END
GO
/****** Object:  StoredProcedure [Profile.Import].[PRNSWebservice.GetPostData]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.GetPostData]
	@Job varchar(55)
AS
BEGIN
	DECLARE @batchID UNIQUEIDENTIFIER, @logLevel int, @proc varchar(100)

	select @batchID = NEWID()
	select @proc = GetPostDataProc, @logLevel = logLevel from [Profile.Import].[PRNSWebservice.Options] where job = @job

  	IF @logLevel >= 0
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log.Summary]  (Job, BatchID, JobStart)
		SELECT @Job, @BatchID, getdate()
	END

	if @proc is null
	BEGIN
		RAISERROR('Job doesn''t exist', 16, -1)
		return
	END

	exec @proc @Job=@Job, @BatchID=@BatchID
END
GO
/****** Object:  StoredProcedure [Profile.Import].[PRNSWebservice.ImportData]    Script Date: 11/30/2023 9:31:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.ImportData]
	@Job varchar(55),
	@BatchID varchar(100) = '',
	@RowID int = -1,
	@HttpResponseCode int = -1,
	@LogID int = -1,
	@URL varchar (500) = '',
	@Data varchar(max)
AS
BEGIN
	if EXISTS (SELECT 1 FROM [Profile.Import].[PRNSWebservice.Options] WHERE job = @Job AND logLevel = 2) OR @HttpResponseCode <> 200
	begin
		if @LogID > 0
		begin
			select @LogID = isnull(@LogID, -1) from [Profile.Import].[PRNSWebservice.Log] where BatchID = @BatchID and RowID = @RowID
		end

		if @LogID > 0
			update [Profile.Import].[PRNSWebservice.Log] set HttpResponseCode = @HttpResponseCode, 
															 HttpResponse = @Data, 
															 Success = Case when @HttpResponseCode = 200 then null else 0 end 
				where LogID = @LogID
		else
			insert into [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, URL, HttpResponseCode, HttpResponse, Success) Values (@Job, @BatchID, @RowID, @URL, @HttpResponseCode, @Data, Case when @HttpResponseCode = 200 then null else 0 end)
	end


	if @HttpResponseCode = 200
	begin
		declare @proc varchar(100), @sql nvarchar(2000)
		select @proc = ImportDataProc from [Profile.Import].[PRNSWebservice.Options] where job = @job
		if @proc is null
		BEGIN
			RAISERROR('Job doesn''t exist', 16, -1)
			return
		END

		exec @proc @data=@data, @URL=@URL, @BatchID=@BatchID, @RowID=@RowID, @LogID=@LogID, @Job=@Job
	END
END

GO
