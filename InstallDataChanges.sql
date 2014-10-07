/********************************************************************************
***
***   This query is designed to create an update script for all tables loaded
***   by the [Framework.].LoadInstallData stored procedure.
***
***   The script relies on the fact that each table will have a set of columns
***   that must be unique, and insert any rows that are missing using these
***   columns, and update any rows where other columns have changed.
***
***	  [Framework.].[Parameter] (ParameterID), (Value)
***   [Framework.].[RestPath] (ApplicationName), Resolver
***   [Framework.].[Job]  -- Skipping this for now,
***   [Framework.].[JobGroup]
***   [Ontology.].[ClassGroup]
***   [Ontology.].[ClassGroupClass]
***   [Ontology.].[ClassProperty]
***   [Ontology.].[DataMap]
***   [Ontology.].[Namespace]
***   [Ontology.].[PropertyGroup]
***   [Ontology.].[PropertyGroupProperty]
***   [Ontology.Presentation].[XML]
***   [RDF.Security].[Group]
***   [Utility.NLP].[ParsePorterStemming]
***   [Utility.NLP].[StopWord]
***   [Utility.NLP].[Thesaurus.Source]
***   [User.Session].Bot
***   [Direct.].[Sites]
***   [Profile.Data].[Publication.Type]
***   [Profile.Data].[Publication.MyPub.Category]
***   [ORCID.].[REF_Permission]
***   [ORCID.].[REF_PersonStatusType]
***   [ORCID.].[REF_WorkExternalType]
***   [ORCID.].[REF_RecordStatus]
***   [ORCID.].[REF_Decision]
***   [ORCID.].[RecordLevelAuditType]
***   [ORCID.].[DefaultORCIDDecisionIDMapping]
***   [ORNG.].[Apps]
***   [ORNG.].[AppViews]
***
***   Tables that have not been automated
***   select * from [Framework.].[Job]
***   select * from [User.Session].Bot
***
********************************************************************************/




create table #ColumnsToSync
( SyncTable nvarchar(255),
	IndexColumn nvarchar(255),
--	IndexColumnCompare nvarchar(255),
	SyncColumn nvarchar(255),
	IdentityColumn nvarchar(255)
--	SyncColumnCompare nvarchar(255)
	)

--drop table #ColumnsToSync

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[Parameter]', 'ParameterID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Framework.].[Parameter]', 'Value')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[RestPath]', 'ApplicationName')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Framework.].[RestPath]', 'Resolver')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[Job]', 'JobGroup')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[Job]', 'Script')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Framework.].[Job]', 'IsActive')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Framework.].[Job]', 'Step')
Insert into #ColumnsToSync (SyncTable, IdentityColumn) values ('[Framework.].[Job]', 'JobID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[JobGroup]', 'JobGroup')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[JobGroup]', 'Name')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Framework.].[JobGroup]', 'Type')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Framework.].[JobGroup]', 'Description')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassGroup]', 'ClassGroupURI')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassGroup]', 'SortOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassGroup]', '_ClassGroupLabel')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassGroup]', 'IsVisible')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassGroupClass]', 'ClassGroupURI')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassGroupClass]', 'ClassURI')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassGroupClass]', 'SortOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassGroupClass]', '_ClassLabel')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassProperty]', 'Class')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassProperty]', 'NetworkProperty')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[ClassProperty]', 'Property')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'IsDetail')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'Limit')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'IncludeDescription')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'IncludeNetwork')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'SearchWeight')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'CustomDisplay')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'CustomEdit')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'ViewSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditPermissionsSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditExistingSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditAddNewSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditAddExistingSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'EditDeleteSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'MinCardinality')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'MaxCardinality')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'CustomDisplayModule')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', 'CustomEditModule')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', '_TagName')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', '_PropertyLabel')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[ClassProperty]', '_ObjectType')
Insert into #ColumnsToSync (SyncTable, IdentityColumn) values ('[Ontology.].[ClassProperty]', 'ClassPropertyID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'DataMapGroup')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'IsAutoFeed')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'Graph')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'Class')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'NetworkProperty')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'Property')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[DataMap]', 'MapTable')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'sInternalType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'sInternalID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'cClass')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'cInternalType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'cInternalID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oClass')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oInternalType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oInternalID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oValue')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oDataType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oLanguage')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oStartDate')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oStartDatePrecision')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oEndDate')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oEndDatePrecision')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'oObjectType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'Weight')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'OrderBy')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'ViewSecurityGroup')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[DataMap]', 'EditSecurityGroup')
Insert into #ColumnsToSync (SyncTable, IdentityColumn) values ('[Ontology.].[DataMap]', 'DataMapID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[Namespace]', 'URI')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[Namespace]', 'Prefix')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[PropertyGroup]', 'PropertyGroupURI')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[PropertyGroup]', 'SortOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[PropertyGroup]', '_PropertyGroupLabel')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[PropertyGroupProperty]', 'PropertyGroupURI')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.].[PropertyGroupProperty]', 'PropertyURI')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[PropertyGroupProperty]', 'SortOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[PropertyGroupProperty]', 'CustomDisplayModule')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.].[PropertyGroupProperty]', 'CustomEditModule')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.Presentation].[XML]', 'Type')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.Presentation].[XML]', 'Subject')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.Presentation].[XML]', 'Predicate')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Ontology.Presentation].[XML]', 'Object')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Ontology.Presentation].[XML]', 'PresentationXML')
Insert into #ColumnsToSync (SyncTable, IdentityColumn) values ('[Ontology.Presentation].[XML]', 'PresentationID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[RDF.Security].[Group]', 'SecurityGroupID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[RDF.Security].[Group]', 'Label')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[RDF.Security].[Group]', 'HasSpecialViewAccess')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[RDF.Security].[Group]', 'HasSpecialEditAccess')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[RDF.Security].[Group]', 'Description')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Utility.NLP].[ParsePorterStemming]', 'Step')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Utility.NLP].[ParsePorterStemming]', 'Ordering')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Utility.NLP].[ParsePorterStemming]', 'phrase1')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Utility.NLP].[ParsePorterStemming]', 'phrase2')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Utility.NLP].[StopWord]', 'word')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Utility.NLP].[StopWord]', 'stem')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Utility.NLP].[StopWord]', 'scope')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Utility.NLP].[Thesaurus.Source]', 'SourceName')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Utility.NLP].[Thesaurus.Source]', 'Source')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[User.Session].[Bot]', 'UserAgent')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Direct.].[Sites]', 'SiteName')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Direct.].[Sites]', 'BootstrapURL')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Direct.].[Sites]', 'QueryURL')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Direct.].[Sites]', 'SortOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Direct.].[Sites]', 'IsActive')
Insert into #ColumnsToSync (SyncTable, IdentityColumn) values ('[Direct.].[Sites]', 'SiteID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Profile.Data].[Publication.Type]', 'pubidtype_id')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Profile.Data].[Publication.Type]', 'name')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Profile.Data].[Publication.Type]', 'sort_order')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[Profile.Data].[Publication.MyPub.Category]', 'HmsPubCategory')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[Profile.Data].[Publication.MyPub.Category]', 'CategoryName')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_Permission]', 'PermissionScope')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_Permission]', 'PermissionDescription')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_Permission]', 'MethodAndRequest')
--Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_Permission]', 'PermissionID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_Permission]', 'SuccessMessage')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_Permission]', 'FailedMessage')

--Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_PersonStatusType]', 'PersonStatusTypeID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_PersonStatusType]', 'StatusDescription')

--Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_WorkExternalType]', 'WorkExternalTypeID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_WorkExternalType]', 'WorkExternalType')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_WorkExternalType]', 'WorkExternalDescription')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_RecordStatus]', 'StatusDescription')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_RecordStatus]', 'RecordStatusID')

--Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_Decision]', 'DecisionID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[REF_Decision]', 'DecisionDescription')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[REF_Decision]', 'DecisionDescriptionLong')

--Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[RecordLevelAuditType]', 'RecordLevelAuditTypeID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[RecordLevelAuditType]', 'AuditType')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORCID.].[DefaultORCIDDecisionIDMapping]', 'SecurityGroupID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORCID.].[DefaultORCIDDecisionIDMapping]', 'DefaultORCIDDecisionID')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORNG.].[Apps]', 'AppID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORNG.].[Apps]', 'Name')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'URL')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'PersonFilterID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'RequiresRegistration')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'UnavailableMessage')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'OAuthSecret')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[Apps]', 'Enabled')

Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORNG.].[AppViews]', 'AppID')
Insert into #ColumnsToSync (SyncTable, IndexColumn) values ('[ORNG.].[AppViews]', 'Page')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[AppViews]', '[View]')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[AppViews]', 'ChromeID')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[AppViews]', 'Visibility')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[AppViews]', 'DisplayOrder')
Insert into #ColumnsToSync (SyncTable, SyncColumn) values ('[ORNG.].[AppViews]', 'OptParams')


; with columns as (
	select '[' + s.name + '].[' + o.name + ']' as tableName, c.name as columnName, t.name as typeName, c.is_nullable as nullable from sys.columns c join sys.objects o 
	on o.object_id = c.object_id
	join sys.schemas s 
	on o.schema_id = s.schema_id
	join sys.types t
	on c.user_type_id = t.user_type_id
), columnsWithTypes as (
	select * from #ColumnsToSync cts join columns c
	on cts.SyncTable = c.tableName
	and (cts.IndexColumn = c.columnName or cts.SyncColumn = c.columnName or cts.IdentityColumn = c.columnName)
)
select SyncTable,
IndexColumn,
SyncColumn,
typeName,
nullable,
identityColumn,
'((old.' + IndexColumn + ' is null and new.' + IndexColumn + ' is null) or (old.' + IndexColumn + ' is not null and new.' + IndexColumn + ' is not null and old.' + IndexColumn + ' = new.' + IndexColumn + '))'  
as IndexColumnCompare,
	case when typename in ('xml', 'text') then '((old.' + SyncColumn + ' is null and new.' + SyncColumn + ' is not null) or (old.' + SyncColumn + ' is not null and new.' + SyncColumn + ' is null) or (old.' + SyncColumn + ' is not null and new.' + SyncColumn + ' is not null and cast(old.' + SyncColumn + ' as nvarchar(max)) <> cast(new.' + SyncColumn + ' as nvarchar(max))))'  
	else '((old.' + SyncColumn + ' is null and new.' + SyncColumn + ' is not null) or (old.' + SyncColumn + ' is not null and new.' + SyncColumn + ' is null) or (old.' + SyncColumn + ' is not null and new.' + SyncColumn + ' is not null and old.' + SyncColumn + ' <> new.' + SyncColumn + '))'  
end as SyncColumnCompare,
--xml cast(isnull([table].CustomEditModule, '') as nvarchar(max))
case when typeName in ('varchar', 'nvarchar', 'char') then 'isnull(''''''''+ replace([table].' + IndexColumn + ','''''''', '''''''''''')+'''''''', ''null'')'
	when typeName in ('int', 'bit', 'bigint', 'float', 'tinyint') then 'isnull(cast([table].' + IndexColumn + ' as nvarchar(max)), ''null'')'
	when typeName in ('xml', 'text') then 'isnull(''''''''+  replace(cast([table].' + IndexColumn  + ','''''''', '''''''''''') as nvarchar(max)) +'''''''', ''null'')'
	else null
end as IndexColumnCastAsNVarchar,
case when typeName in ('varchar', 'nvarchar', 'char') then 'isnull(''''''''+ replace([table].' + SyncColumn + ','''''''', '''''''''''')+'''''''', ''null'')'
	when typeName in ('int', 'bit', 'bigint', 'float', 'tinyint') then 'isnull(cast([table].' + SyncColumn + ' as nvarchar(max)), ''null'')'
	when typeName in ('xml', 'text') then 'isnull(''''''''+ replace(cast([table].' + SyncColumn  + ' as nvarchar(max)),'''''''', '''''''''''') +'''''''', ''null'')'
	else null
end as SyncColumnCastAsNVarchar,
case when typeName in ('varchar', 'nvarchar', 'char') then 'case when ' + IndexColumn + ' is null then ''' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '''''' + replace(' + IndexColumn + ','''''''', '''''''''''') + '''''''' end '
	when typeName in ('int', 'bit', 'bigint', 'float', 'tinyint') then 'case when ' + IndexColumn + ' is null then ''' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '' +  cast(' + IndexColumn + ' as nvarchar(max)) + '''' end '
	when typeName in ('xml', 'text') then 'case when ' + IndexColumn + 'is null then ''' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '''''' + ' + IndexColumn + ' + '''''''' end '
	else null
end as IndexColumnUpdate,
case when typeName in ('varchar', 'nvarchar', 'char') then 'case when old.' + IndexColumn + ' is null then ''' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '''''' + replace(old.' + IndexColumn + ','''''''', '''''''''''') + '''''''' end '
	when typeName in ('int', 'bit', 'bigint', 'float', 'tinyint') then 'case when old.' + IndexColumn + ' is null then ''' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '' +  cast(old.' + IndexColumn + ' as nvarchar(max)) + '''' end '
	when typeName in ('xml', 'text') then 'case when ' + IndexColumn + 'is null then ''old.' + IndexColumn + ' is null'' else ''' + IndexColumn  + '= '''''' + old.' + IndexColumn + ' + '''''''' end '
	else null
end as IndexColumnDelete,
case when typeName in ('varchar', 'nvarchar', 'char') then 'case when ' + syncColumn + '_changed = 1 then '' ' + syncColumn + ' = ''''''+ replace(' + syncColumn  + ','''''''', '''''''''''') +'''''','' else ''''  end'
	when typeName in ('int', 'bit', 'bigint', 'float', 'tinyint') then 'case when ' + syncColumn + '_changed = 1 then '' ' + syncColumn + ' =  ''+ cast(' + syncColumn  + ' as nvarchar(max)) +  '','' else ''''  end'
	when typeName in ('xml', 'text') then 'case when ' + syncColumn + '_changed = 1 then '' ' + syncColumn + ' =  '''''' + cast(' + syncColumn  + ' as nvarchar(max))  +'''''','' else ''''  end'
	else null
end as SyncColumnUpdate
into #columnsWithCompareStrings from columnsWithTypes
-- select * from #ColumnsToSync where identitycolumn is not null
 -- select * from #columnsWithCompareStrings where synctable like '%bot%'

select * into #tablesWithCompareStrings
From
    (
        Select distinct ST2.SyncTable, '#' + replace(replace(replace(ST2.SyncTable, '[', ''), ']', ''),'.', '_')  as tmpTableName,
            (
                Select ST1.IndexColumnCompare + ' and ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
            ) [joinOn],
			(
                Select 'new.' + ST1.IndexColumn + ' is null and ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[newIsNull],
			(
                Select 'old.' + ST1.IndexColumn + ' is null and ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[oldIsNull],
			(
                Select ST1.SyncColumnCompare + ' OR ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[changedRows],
			(
                Select 'Case when ' + ST1.SyncColumnCompare + ' then 1 else 0 end as ' + ST1.SyncColumn + '_changed, ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[changedRowsDetail],
			(
                Select ST1.IndexColumn + ', ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[indexColumns],
			(
                Select 'new.' + ST1.IndexColumn + ', ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[newIndexColumns],
			(
                Select ST1.SyncColumn + ', ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[syncColumns],
			(
                Select 'new.' + ST1.SyncColumn + ', ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[newSyncColumns],
			(
                Select ' + ' + IndexColumnCastAsNVarchar + '+'', ''' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[indexValues],
			(
                Select ' + ' + SyncColumnCastAsNVarchar + '+'', ''' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[syncValues],
			(
                Select ST1.IndexColumnUpdate + ' + '' and  '' + ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[indexColumnsUpdate],
			(
                Select ST1.SyncColumnUpdate + ' + ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[syncColumnsUpdate],
			(
                Select ST1.IndexColumnDelete + ' + '' and  '' + ' AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)[indexColumnsDelete],
			(
				Select ST1.identityColumn AS [text()]
                From #columnsWithCompareStrings ST1
                Where ST1.SyncTable = ST2.SyncTable
                ORDER BY ST1.SyncTable
                For XML PATH ('')
			)identityColumn,
			cast ('' as nvarchar(max)) as changedRowTmpTableSelect,
			cast ('' as nvarchar(max)) as changedRowUpdateStmt,
			cast ('' as nvarchar(max)) as newRowsInsertStmt,
			cast ('' as nvarchar(max)) as deletedRowDeleteStmt
        From #columnsWithCompareStrings ST2
    ) [Main]
	/*
Declare @oldDB varchar(255) = 'Profiles_2_0_0'
select SyncTable,
'Select * from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' +  LEFT([oldIsNull], len([oldIsNull]) - 4) as AddedRows,
'Select ''insert into '+ SyncTable + ' ( ' + indexColumns + Left(syncColumns, len(syncColumns) - 1) + ') values (''' + replace([indexValues], '[table]', 'new') + replace(LEFT([syncValues], len([syncValues]) - 5), '[table]', 'new') + '+'')'''
+ ' from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' +  LEFT([oldIsNull], len([oldIsNull]) - 4) as AddedRows,
'Select * from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' + LEFT([newIsNull], len([newIsNull]) - 4) as DeletedRows,
'Select * from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' + replace(replace(LEFT([changedRows], len([changedRows]) - 3), '&lt;', '<'), '&gt;', '>') as DeletedRow
from #tablesWithCompareStrings
*/
/*
Declare @oldDB varchar(255) = 'Profiles_2_0_0'
select synctable, tmpTableName, syncColumnsUpdate,'select ' + newIndexColumns + syncColumns + replace(replace(LEFT(changedRowsDetail, len(changedRowsDetail) - 1), '&lt;', '<'), '&gt;', '>')  
+ ' into ' + tmpTableName + ' from ' + syncTable + ' new join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' + replace(replace(LEFT(changedRows, len(changedRows) - 3), '&lt;', '<'), '&gt;', '>') as changedRows
  from #tablesWithCompareStrings
*/

Declare @oldDB varchar(255) = 'Profiles_2_0_0'
update #tablesWithCompareStrings set changedRowTmpTableSelect = 'select ' + newIndexColumns + newSyncColumns + replace(replace(LEFT(changedRowsDetail, len(changedRowsDetail) - 1), '&lt;', '<'), '&gt;', '>')  
+ ' into ' + tmpTableName + ' from ' + syncTable + ' new join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' + replace(replace(LEFT(changedRows, len(changedRows) - 3), '&lt;', '<'), '&gt;', '>') where syncColumns <> ''


/* 
select 'Select ''update ' + syncTable + ' set '' + replace(' + syncColumnsUpdate + ' + ''nwbreptxt'', '',nwbreptxt'', '''')' + ' + '' where '' + ' + left(indexColumnsUpdate, len(indexColumnsUpdate) - 13) + ' from ' + tmpTableName
from #tablesWithCompareStrings


select * From #tablesWithCompareStrings where syncColumns = ''
*/

update #tablesWithCompareStrings set changedRowUpdateStmt = 'Select ''' + syncTable + ''', ''update ' + syncTable + ' set '' + replace(' + syncColumnsUpdate + ' + ''nwbreptxt'', '',nwbreptxt'', '''')' + ' + '' where '' + ' + left(indexColumnsUpdate, len(indexColumnsUpdate) - 13) + ' from ' + tmpTableName 
where syncColumns <> ''

update #tablesWithCompareStrings set newRowsInsertStmt =
'Select ''' + syncTable + ''', ''insert into '+ SyncTable + ' ( ' + identityColumn + ',' + indexColumns + Left(syncColumns, len(syncColumns) - 1) + ') 
select '' + ' + '''max(' + identityColumn + ') + 1, ''' + 
replace([indexValues], '[table]', 'new') + replace(LEFT([syncValues], len([syncValues]) - 5), '[table]', 'new') + ' +'' from '+ SyncTable +''''
+ ' from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' +  LEFT([oldIsNull], len([oldIsNull]) - 4)
where syncColumns <> '' and identityColumn <> ''

update #tablesWithCompareStrings set newRowsInsertStmt =
'Select ''' + syncTable + ''', ''insert into '+ SyncTable + ' ( ' + indexColumns + Left(syncColumns, len(syncColumns) - 1) + ') 
values ('' + ' + replace([indexValues], '[table]', 'new') + replace(LEFT([syncValues], len([syncValues]) - 5), '[table]', 'new') + '+'')'''
+ ' from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' +  LEFT([oldIsNull], len([oldIsNull]) - 4)
where syncColumns <> '' and identityColumn = ''

update #tablesWithCompareStrings set newRowsInsertStmt =
'Select ''' + syncTable + ''', ''insert into '+ SyncTable + ' ( ' + Left(indexColumns, len(indexColumns) - 1) + ') values (''' + replace(LEFT([indexValues], len(indexValues) - 5), '[table]', 'new') + '+'')'''
+ ' from ' + SyncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' +  LEFT([oldIsNull], len([oldIsNull]) - 4)
where syncColumns = ''

update #tablesWithCompareStrings set deletedRowDeleteStmt =
'select ''' + syncTable + ''', ''delete from ' + SyncTable + ' where '' + ' +  left(indexColumnsDelete, len(indexColumnsDelete) - 13) + ' from ' + syncTable + ' new full outer join ' + @oldDB + '.' + SyncTable + ' old on ' + LEFT(joinon, len(joinon) - 4)
+ ' where ' + LEFT([newIsNull], len([newIsNull]) - 4)


create table #updateQueries (
	tableName nvarchar(max),
	query nvarchar(max)
)

--select * from #updateQueries
--truncate table #updateQueries

Declare @sql nvarchar(MAX)
Declare @update1 nvarchar(MAX)
Declare @update2 nvarchar(MAX)
Declare @update3 nvarchar(MAX)
Declare @insert1 nvarchar(MAX)
Declare @delete1 nvarchar(MAX)
DECLARE db_cursor CURSOR FOR  
SELECT changedRowTmpTableSelect, changedRowUpdateStmt, tmpTableName, newRowsInsertStmt, deletedRowDeleteStmt
FROM #tablesWithCompareStrings

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @update1, @update2, @update3, @insert1, @delete1

WHILE @@FETCH_STATUS = 0   
BEGIN   
		if @update1 <> ''
		begin
			select @sql = @update1 + '; insert into #updateQueries (tableName, query) ' + @update2 + '; drop table ' + @update3
			exec sp_executesql @stmt = @sql
		end
		select @sql = 'insert into #updateQueries (tableName, query) ' + @insert1
		exec sp_executesql @stmt = @sql
		select @sql = 'insert into #updateQueries (tableName, query) ' + @delete1
		exec sp_executesql @stmt = @sql
       FETCH NEXT FROM db_cursor INTO @update1, @update2, @update3, @insert1, @delete1
END   

CLOSE db_cursor   
DEALLOCATE db_cursor

select * from #updateQueries order by TableName, query


/**
-- Delete Temp tables

drop table #ColumnsToSync
drop table #columnsWithCompareStrings
drop table #tablesWithCompareStrings
drop table #updateQueries

**/