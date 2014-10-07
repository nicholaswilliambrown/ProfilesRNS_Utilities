DECLARE              @return_value int

EXEC      @return_value = [Framework.].[ChangeBaseURI]
                                @oldBaseURI = N'http://dev-profiles.example.com/profile/',
                                @newBaseURI = N'http://profiles.example.com/profile/'

SELECT  'Return Value' = @return_value

GO

update [Framework.].Parameter set Value = 'http://profiles.example.com' where ParameterID = 'basePath'
