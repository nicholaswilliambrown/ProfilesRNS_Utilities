/**
* This Script will load data from Profile.Export tables created using the ExtractProfileData Script
*
* This script is designed to be run against data from Profiles 2.5.0 or earlier without OpenSocial
* TODO - Update this to handle ORCID and Open Social data
*
**/


/**
* Create and populate import tables
*
* You will need to add a database name before [Profile.Export] in each of the next 7 queries
**/
Select *, 0 as PersonID into [Profile.Import].Award from [Profile.Export].[Award]
Select *, 0 as PersonID into [Profile.Import].Overview from [Profile.Export].[Overview]
Select *, 0 as PersonID into [Profile.Import].[Person.Photo] from [Profile.Export].[Person.Photo]
Select *, 0 as PersonID into [Profile.Import].[Publication.MyPub.General] from [Profile.Export].[Publication.MyPub.General]
Select *, 0 as PersonID into [Profile.Import].[Publication.Person.Add] from [Profile.Export].[Publication.Person.Add]
Select *, 0 as PersonID into [Profile.Import].[Publication.Person.Exclude] from [Profile.Export].[Publication.Person.Exclude]
Select * into [Profile.Import].[RDF.Security.NodeProperty] from [Profile.Export].[RDF.Security.NodeProperty]
select *, 0 as UserID into [Profile.Import].[DefaultProxy] from [Profile.Export].[DefaultProxy]
select *, 0 as UserID, 0 as ProxyForUserID into [Profile.Import].[DesignatedProxy] from [Profile.Export].[DesignatedProxy]

/**
* Update Import tables with PersonID and UserID Values as appropriate
**/
Update a set PersonID = p.PersonID from [Profile.Import].Award a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set PersonID = p.PersonID from [Profile.Import].Overview a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set PersonID = p.PersonID from [Profile.Import].[Person.Photo] a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set PersonID = p.PersonID from [Profile.Import].[Publication.MyPub.General] a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set PersonID = p.PersonID from [Profile.Import].[Publication.Person.Add] a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set PersonID = p.PersonID from [Profile.Import].[Publication.Person.Exclude] a join [Profile.Data].Person p on a.InternalUsername = p.InternalUsername
Update a set UserID = u.userID from [Profile.Import].[DefaultProxy] a join [User.Account].[User] u on a.InternalUsername = u.InternalUserName
Update a set UserID = u1.userID, ProxyForUserID = u2.UserID from [Profile.Import].[DesignatedProxy] a join [User.Account].[User] u1 on a.[User] = u1.InternalUserName join [User.Account].[User] u2 on a.ProxyForUser = u2.InternalUserName


/**
* Reconfigure the Beta Import values in the datamap to import Award data
* This needs to be done as the Unigue index doesn't allow us to simply add rows as it doesn't include DataMapGroup
**/
update [Ontology.].DataMap set [MapTable] = '[Profile.Import].[Award]' where MapTable = '[Profile.Import].[Beta.Award]'
update [Ontology.].DataMap set OrderBy = 'SortOrder' where Class = 'http://xmlns.com/foaf/0.1/Person' and NetworkProperty is null and Property = 'http://vivoweb.org/ontology/core#awardOrHonor' and sInternalType = 'Person'

/**
* Run ProcessDataMap for Award Data
**/
DECLARE @DMID int
DECLARE datamap_cursor CURSOR FOR  
SELECT DataMapID FROM [Ontology.].DataMap where MapTable = '[Profile.Import].[Award]' order by DataMapID
OPEN datamap_cursor   
FETCH NEXT FROM datamap_cursor INTO @DMID   

WHILE @@FETCH_STATUS = 0   
BEGIN   
       EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @DMID, @ShowCounts = 1

       FETCH NEXT FROM datamap_cursor INTO @DMID   
END   

CLOSE datamap_cursor   
DEALLOCATE datamap_cursor

/**
* Reconfigure the Beta Import values in the datamap to import Overview data
* Run ProcessDataMap for Overviews
**/
update [Ontology.].DataMap set MapTable = '[Profile.Import].Overview', oValue = 'cast(Overview as nvarchar(max))' where MapTable = '[Profile.Import].[Beta.Narrative]'
DECLARE @DMID_O int
select @DMID_O = DataMapID FROM [Ontology.].DataMap where MapTable = '[Profile.Import].Overview'
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @DMID_O, @ShowCounts = 1

/**
* Load Photo data and run ProcessDataMap for photo data
**/
insert into [Profile.Data].[Person.Photo] (PersonID, Photo, PhotoLink) select PersonID, Photo, PhotoLink from [Profile.Import].[Person.Photo]
DECLARE @DMID_P int
select @DMID_P = DataMapID FROM [Ontology.].DataMap where MapTable = '[Profile.Data].[vwPerson.Photo]'
EXEC [RDF.Stage].[ProcessDataMap] @DataMapID = @DMID_P, @ShowCounts = 1

/**
* Load Custom Publications
**/
Insert into [Profile.Data].[Publication.MyPub.General]
SELECT [MPID],[PersonID],[PMID],[HmsPubCategory],[NlmPubCategory],[PubTitle],[ArticleTitle],[ArticleType],[ConfEditors],[ConfLoc],[EDITION],[PlaceOfPub]
,[VolNum],[PartVolPub],[IssuePub],[PaginationPub],[AdditionalInfo],[Publisher],[SecondaryAuthors],[ConfNm],[ConfDTs],[ReptNumber],[ContractNum],[DissUnivNm]
,[NewspaperCol],[NewspaperSect],[PublicationDT],[Abstract],[Authors],[URL],[CreatedDT],[CreatedBy],[UpdatedDT],[UpdatedBy]
  FROM [Profile.Import].[Publication.MyPub.General]

/**
* Load Added and excluded publications
**/
Insert into [Profile.Data].[Publication.Person.Add]
select PubID, PersonID, PMID, MPID from [Profile.Import].[Publication.Person.Add]

Insert into [Profile.Data].[Publication.Person.Exclude]
select PubID, PersonID, PMID, MPID from [Profile.Import].[Publication.Person.Exclude] 

/**
* Load user configured privicy settings
**/
insert into [RDF.Security].[NodeProperty]
select inmp.NodeID, n.NodeID as Property, case when np.ViewSecurityGroup < 0 then np.ViewSecurityGroup else inm.NodeID end as ViewSecurityGroup from [Profile.Import].[RDF.Security.NodeProperty] np
join [User.Account].[User] u on np.InternalUsername = u.InternalUserName
--join [Profile.Data].Person u on np.InternalUsername = u.InternalUserName
join [RDF.Stage].InternalNodeMap inm on inm.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' and inm.InternalType = 'User'
and cast (u.UserID as nvarchar(55)) = inm.InternalID
join [RDF.Stage].InternalNodeMap inmp on inmp.Class = 'http://xmlns.com/foaf/0.1/Person' and inmp.InternalType = 'Person'
and cast (u.PersonID as nvarchar(55)) = inmp.InternalID
join [RDF.].Node n on np.PropertyURI = n.Value

/**
* Run ProcessDataMap for the entire datamap (This will only run datamap rows set to run automatically)
* and not the award and Overview rows we loaded earlier
**/
EXEC [RDF.Stage].[ProcessDataMap]

/**
* Update any custom security settings
* This has to be done after ProcessDataMap so that the triples exist
**/
update t
	set t.ViewSecurityGroup = n.ViewSecurityGroup
	from [RDF.Security].[NodeProperty] n, [RDF.].Triple t
	where n.NodeID = t.Subject and n.Property = t.Predicate

/**
* Load Proxies
**/
insert into [User.Account].[DefaultProxy] ([UserID], [ProxyForInstitution], [ProxyForDepartment], [ProxyForDivision], [IsVisible])
select [UserID], [ProxyForInstitution], [ProxyForDepartment], [ProxyForDivision], [IsVisible] from [Profile.Import].[DefaultProxy]

insert into [User.Account].[DesignatedProxy] ([UserID], [ProxyForUserID])
select [UserID], [ProxyForUserID] from [Profile.Import].DesignatedProxy

/**
* Run Job Group 3
* This will ensure that cache tables are updated etc.
**/
EXEC [Framework.].[RunJobGroup] @JobGroup = 3