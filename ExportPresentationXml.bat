@echo off

if %1 equ Export (
	FOR /L %%A IN (1,1,18) DO (
	  sqlcmd -S . -d ProfilesRNS_HMS -E -y 0 -v PresentationID="%%A" -o %%A.xml -i ExportPresentationXml.sql
	)
)

if %1 equ Import (
	FOR /L %%A IN (1,1,18) DO (
	  sqlcmd -S . -d ProfilesRNS_HMS -E -y 0 -Q "update [Ontology.Presentation].XML set PresentationXML = CONVERT(xml, BulkColumn, 2) FROM OPENROWSET(BULK '%~dp0\%%A.xml', SINGLE_BLOB) t where PresentationID = %%A"
	)
)

