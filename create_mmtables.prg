lParameters tcDB, tlRecreate

psp_closealldata(.t.)
open data xc2mm_map
set strcompare on

if !used("DDM")
	use DDM in 0 && assumes we are in dev environment
endif

select * from ddm into cursor myddm order by d_name, number
select myddm
index on d_name + str(number,5) tag mytag

select d_name from ddm into cursor ddmtables where lKeep group by 1

psp_createdb(tcDB, tlRecreate)
open database &tcDB
select ddmtables
scan
	loTableDef = object()
	select ddmtables
	with loTableDef
		.cTablename = "mm" + substr(alltrim(d_name),3)
		.cPKFieldList = ""
	endwith
	psp_addtable(tcDB,loTableDef)
	
	select myddm
	lcOldTableName = alltrim(ddmtables.d_name)
	lcTableName = alltrim(loTableDef.cTablename)
	seek lcOldTableName
	scan rest while d_name = lcOldTableName for lKeep
		loDDMObj = psp_recordobj("myddm")
		loFieldInfo = fieldobject(loDDMObj)
		psp_addfield(tcDB,loTableDef.cTableName,loFieldInfo)
	endscan
endscan

psp_usein("ddmtables")


set textmerge off
set textmerge to

procedure fieldobject
	lparameters toDDMObj
	local loRetObj
	
	loRetObj = object()
	loRetObj.cType = toDDMObj.type
	if loRetObj.cType = "O" && xcase uses this for certain memofields for internal use, I think
		loRetObj.cType = "M"
	endif
	loRetObj.cFieldName = toDDMObj.cnewname
	loRetObj.nLen = toDDMObj.length
	loRetObj.nDec = toDDMObj.dec
	loRetObj.nOrder = toDDMObj.number
	loRetObj.cCaption = toDDMObj.title
	loRetObj.cTooltip = toDDMObj.descript
	loRetObj.cDefault = toDDMObj.def_value
	//.cRange = toDDMObj.
	//.cValid = toDDMObj.
	//.cValidError = toDDMObj.
	//.cInputMask = toDDMObj.
	//.cCalculated = toDDMObj.
	//.lRecalculate = toDDMObj.
	//.lPrimary = toDDMObj.
	//.lUnique = toDDMObj.
	//.lAllowNull = toDDMObj.
	//.lAutoIncrement = toDDMObj.
	//.nIncNextValue = toDDMObj.
	//.nIncStep = toDDMObj.
	//.lNoCpTrans = toDDMObj.
return loRetObj





