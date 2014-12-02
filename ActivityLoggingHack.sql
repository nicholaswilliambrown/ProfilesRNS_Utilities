declare @StartNode as bigint
select @StartNode = min(NodeID) FROM [User.Session].[Session] WHERE CreateDate > dateadd(year, -1, getdate())

select p.DisplayName as Name, nob.Value as Overview from [RDF.].Triple t
join [RDF.].Node np on t.Predicate = np.NodeID
and np.value = 'http://vivoweb.org/ontology/core#overview'
join [RDF.].Node nob on t.Object = nob.NodeID
and t.object > @StartNode
join [RDF.Stage].InternalNodeMap ns on t.Subject = ns.NodeID
and ns.InternalType = 'Person'
join [Profile.Data].Person p on p.PersonID = ns.InternalID


declare @StartNode as bigint
select @StartNode = min(NodeID) FROM [User.Session].[Session] WHERE CreateDate > dateadd(week, -1, getdate())

select p.DisplayName as Name, npub.Value as Award from [RDF.].Triple t
join [RDF.].Node np on t.Predicate = np.NodeID
and np.value = 'http://vivoweb.org/ontology/core#awardOrHonor'
join [RDF.].Node nob on t.Object = nob.NodeID
and t.object > @StartNode
join [RDF.].Triple t2 on t2.Subject = t.Object
join [RDF.].Node nlabel on t2.Predicate = nlabel.NodeID
and nlabel.Value = 'http://www.w3.org/2000/01/rdf-schema#label'
join [RDF.].Node nPub on t2.Object = nPub.NodeID
join [RDF.Stage].InternalNodeMap ns on t.Subject = ns.NodeID
and ns.InternalType = 'Person'
join [Profile.Data].Person p on p.PersonID = ns.InternalID


declare @StartNode as bigint
select @StartNode = min(NodeID) FROM [User.Session].[Session] WHERE CreateDate > dateadd(week, -1, getdate())

select p.DisplayName as Name, npmid2.value, nPub.* from [RDF.].Triple t
join [RDF.].Node np on t.Predicate = np.NodeID
and np.value = 'http://vivoweb.org/ontology/core#authorInAuthorship'
join [RDF.].Node nob on t.Object = nob.NodeID
and t.object > @StartNode
join [RDF.].Triple t2 on t2.Subject = t.Object
join [RDF.].Node nlir on t2.Predicate = nlir.NodeID
and nlir.Value = 'http://vivoweb.org/ontology/core#linkedInformationResource'
join [RDF.].Node nPub on t2.Object = nPub.NodeID
join [RDF.].Triple t3 on t3.subject = nPub.NodeID
join [RDF.].Node npmid on t3.Predicate = npmid.NodeID
and npmid.Value = 'http://purl.org/ontology/bibo/pmid'
join [RDF.].Node npmid2 on t3.object = npmid2.NodeID
join [RDF.Stage].InternalNodeMap ns on t.Subject = ns.NodeID
and ns.InternalType = 'Person'
join [Profile.Data].Person p on p.PersonID = ns.InternalID
join [Profile.Data].[Publication.Person.Add] a
on p.personID = a.PersonID and cast(a.PMID as nvarchar(max)) = npmid2.value