declare @id int = 

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [TripleID]
      ,[Subject]
      , b.Value
      ,[Predicate]
      , c.Value
      ,[Object]
      , d.Value
--      ,[TripleHash]
      ,[Weight]
  FROM [RDF.].[Triple] a 
  join [RDF.].[Node] b
  on (a.[Subject] = @id or a.Predicate = @id or a.[Object] = @id)
  and a.[Subject] = b.nodeid
  join [RDF.].[Node] c
  on a.[Predicate] = c.nodeid
  join [RDF.].[Node] d
  on a.[object] = d.nodeid