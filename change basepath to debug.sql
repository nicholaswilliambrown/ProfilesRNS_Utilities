declare @old nvarchar(max)
select @old = value from [Framework.].Parameter where parameterID = 'BaseURI'

DECLARE              @return_value int

EXEC      @return_value = [Framework.].[ChangeBaseURI]
                                @oldBaseURI = @old,
                                @newBaseURI = N'http://localhost:55956/profile/'

SELECT  'Return Value' = @return_value

GO

update [Framework.].Parameter set Value = 'http://localhost:55956' where ParameterID = 'basePath'
