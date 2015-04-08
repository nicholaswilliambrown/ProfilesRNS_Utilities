Create schema [Profile.Export]
GO

CREATE TABLE [Profile.Export].[Award](
	[AwardID] [int] IDENTITY(1,1) NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[Yr] [int] NULL,
	[Yr2] [int] NULL,
	[AwardNM] [varchar](100) NULL,
	[AwardingInst] [varchar](100) NULL,
	[SortOrder] [int],
PRIMARY KEY CLUSTERED 
(
	[AwardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

declare @label int, @awardConferredBy int, @endDate int, @startDate int
select @label = nodeID from [RDF.].Node where value = 'http://www.w3.org/2000/01/rdf-schema#label'
select @awardConferredBy = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/prns#awardConferredBy'
select @endDate = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/prns#endDate'
select @startDate = nodeID from [RDF.].Node where value = 'http://profiles.catalyst.harvard.edu/ontology/prns#startDate'

insert into [Profile.Export].[Award] (InternalUsername ,AwardNM, AwardingInst, Yr, Yr2, SortOrder)
select p.InternalUsername, nl.Value as AwardNM, nc.Value as AwardingInst, ns.Value as Yr, ne.Value as Yr2, t.SortOrder
from [RDF.].Triple t
join [RDF.].Node np on t.Predicate = np.NodeID and np.Value = 'http://vivoweb.org/ontology/core#awardOrHonor'
join [RDF.].Node nob on t.Object = nob.NodeID  
join [RDF.Stage].InternalNodeMap i on t.Subject = I.NodeID
and i.Class = 'http://xmlns.com/foaf/0.1/Person' and i.InternalType = 'Person'
join [Profile.Data].Person p on i.InternalID = p.PersonID 
left join [RDF.].Triple tl on t.Object = tl.Subject and tl.Predicate = @label
left join [RDF.].Node nl on tl.Object = nl.NodeID
left join [RDF.].Triple tc on t.Object = tc.Subject and tc.Predicate = @awardConferredBy
left join [RDF.].Node nc on tc.Object = nc.NodeID
left join [RDF.].Triple te on t.Object = te.Subject and te.Predicate = @endDate
left join [RDF.].Node ne on te.Object = ne.NodeID
left join [RDF.].Triple ts on t.Object = ts.Subject and ts.Predicate = @startDate 
left join [RDF.].Node ns on ts.Object = ns.NodeID

--select * from [Profile.Export].[Award]

Create table [Profile.Export].Overview (
[InternalUsername] [nvarchar](50) NULL,
[Overview] [text] null
)

insert into [Profile.Export].Overview (InternalUsername, Overview)
select /*t.sortorder, t.graph,*/ p.InternalUsername, nob.Value as Overview
from [RDF.].Triple t
join [RDF.].Node np on t.Predicate = np.NodeID and np.Value = 'http://vivoweb.org/ontology/core#overview'
join [RDF.].Node nob on t.Object = nob.NodeID  
join [RDF.Stage].InternalNodeMap i on t.Subject = I.NodeID
and i.Class = 'http://xmlns.com/foaf/0.1/Person' and i.InternalType = 'Person'
join [Profile.Data].Person p on i.InternalID = p.PersonID 

--select * from [Profile.Export].Overview



CREATE TABLE [Profile.Export].[Person.Photo](
	[PhotoID] [int] IDENTITY(1,1) NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[Photo] [varbinary](max) NULL,
	[PhotoLink] [nvarchar](max) NULL,
 CONSTRAINT [PK_photo] PRIMARY KEY CLUSTERED 
(
	[PhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

insert into [Profile.Export].[Person.Photo] (InternalUsername, Photo, Photolink)
select p.InternalUsername, ph.photo, ph.PhotoLink from [Profile.Data].[Person.Photo] ph 
join [Profile.Data].Person p on ph.PersonID = p.PersonID

--add, exclude

CREATE TABLE [Profile.Export].[Publication.MyPub.General](
	[MPID] [nvarchar](50) NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[PMID] [nvarchar](15) NULL,
	[HmsPubCategory] [nvarchar](60) NULL,
	[NlmPubCategory] [nvarchar](250) NULL,
	[PubTitle] [nvarchar](2000) NULL,
	[ArticleTitle] [nvarchar](2000) NULL,
	[ArticleType] [nvarchar](30) NULL,
	[ConfEditors] [nvarchar](2000) NULL,
	[ConfLoc] [nvarchar](2000) NULL,
	[EDITION] [nvarchar](30) NULL,
	[PlaceOfPub] [nvarchar](60) NULL,
	[VolNum] [nvarchar](30) NULL,
	[PartVolPub] [nvarchar](15) NULL,
	[IssuePub] [nvarchar](30) NULL,
	[PaginationPub] [nvarchar](30) NULL,
	[AdditionalInfo] [nvarchar](2000) NULL,
	[Publisher] [nvarchar](255) NULL,
	[SecondaryAuthors] [nvarchar](2000) NULL,
	[ConfNm] [nvarchar](2000) NULL,
	[ConfDTs] [nvarchar](60) NULL,
	[ReptNumber] [nvarchar](35) NULL,
	[ContractNum] [nvarchar](35) NULL,
	[DissUnivNm] [nvarchar](2000) NULL,
	[NewspaperCol] [nvarchar](15) NULL,
	[NewspaperSect] [nvarchar](15) NULL,
	[PublicationDT] [smalldatetime] NULL,
	[Abstract] [varchar](max) NULL,
	[Authors] [varchar](max) NULL,
	[URL] [varchar](1000) NULL,
	[CreatedDT] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDT] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK__my_pubs_general__03BB8E22] PRIMARY KEY CLUSTERED 
(
	[MPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

Insert into [Profile.Export].[Publication.MyPub.General]
SELECT [MPID],p.InternalUsername,[PMID],[HmsPubCategory],[NlmPubCategory],[PubTitle],[ArticleTitle],[ArticleType],[ConfEditors],[ConfLoc],[EDITION],[PlaceOfPub]
,[VolNum],[PartVolPub],[IssuePub],[PaginationPub],[AdditionalInfo],[Publisher],[SecondaryAuthors],[ConfNm],[ConfDTs],[ReptNumber],[ContractNum],[DissUnivNm]
,[NewspaperCol],[NewspaperSect],[PublicationDT],[Abstract],[Authors],[URL],[CreatedDT],[CreatedBy],[UpdatedDT],[UpdatedBy]
  FROM [Profile.Data].[Publication.MyPub.General] g join [Profile.Data].Person p on G.PersonID = p.PersonID
--select * from [Profile.Data].[Publication.MyPub.General]


CREATE TABLE [Profile.Export].[Publication.Person.Add](
	[PubID] [uniqueidentifier] NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_add__37703C52] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

Insert into [Profile.Export].[Publication.Person.Add]
select PubID, p.InternalUsername, PMID, MPID from [Profile.Data].[Publication.Person.Add] a join [Profile.Data].Person p on a.PersonID = p.PersonID


CREATE TABLE [Profile.Export].[Publication.Person.Exclude](
	[PubID] [uniqueidentifier] NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_exc__3587F3E0] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

Insert into [Profile.Export].[Publication.Person.Exclude]
select PubID, p.InternalUsername, PMID, MPID from [Profile.Data].[Publication.Person.Exclude] a join [Profile.Data].Person p on a.PersonID = p.PersonID



CREATE TABLE [Profile.Export].[RDF.Security.NodeProperty](
	[InternalUsername] [nvarchar](50) NULL,
	[PropertyURI] nvarchar(max) NOT NULL,
	[ViewSecurityGroup] [bigint] NULL
) ON [PRIMARY]

GO


insert into [Profile.Export].[RDF.Security.NodeProperty]
select p.InternalUsername, n.value as PropertyURI, np.ViewSecurityGroup from [RDF.Security].NodeProperty np
join [RDF.].Node n on np.Property = n.NodeID
join [RDF.Stage].InternalNodeMap i on np.nodeID = I.NodeID
and i.Class = 'http://xmlns.com/foaf/0.1/Person' and i.InternalType = 'Person'
join [Profile.Data].Person p on i.InternalID = p.PersonID 
  

CREATE TABLE [Profile.Export].[DefaultProxy](
	[DefaultProxyID] [int] IDENTITY(0,1) NOT NULL,
	[InternalUsername] [nvarchar](50) NULL,
	[ProxyForInstitution] [nvarchar](500) NULL,
	[ProxyForDepartment] [nvarchar](500) NULL,
	[ProxyForDivision] [nvarchar](500) NULL,
	[IsVisible] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[DefaultProxyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

insert into [Profile.Export].[DefaultProxy] (InternalUserName, ProxyForInstitution, ProxyForDepartment, ProxyForDivision, IsVisible)
select InternalUserName, ProxyForInstitution, ProxyForDepartment, ProxyForDivision, IsVisible from [User.Account].DefaultProxy p join [User.Account].[User] u
on p.UserID = u.UserID


CREATE TABLE [Profile.Export].[DesignatedProxy](
	[User] [nvarchar](50) NULL,
	[ProxyForUser]  [nvarchar](50) NULL
	) ON [PRIMARY]

GO

insert into [Profile.Export].[DesignatedProxy] ([User], ProxyForUser)
  SELECT p.Internalusername as [User], p2.Internalusername as ProxyForUser
  FROM [User.Account].[DesignatedProxy] d
  join [User.Account].[User] p
  on d.UserID = p.UserID
  join [User.Account].[User] p2
  on d.ProxyForUserID = p2.UserID