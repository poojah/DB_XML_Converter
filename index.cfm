<!--- Please insert your code here --->
<cfset adminAPI = createObject( 'component', 'cfide.adminapi.administrator' ) />
<cfset adminAPI.login( 'aaaa' ) />
<cfset theFile="C:\Users\vadiraja\Documents\xmldoc.xls">
<cfset sheet = SpreadsheetRead(theFile)>   
<cfset info = SpreadSheetInfo(sheet)>
<cfset strPath = ExpandPath( "./" ) />

<cfset SpreadsheetSetActiveSheetNumber(sheet, 1) >
<!---datasource--->
<cfscript>
	dsnAPI = createObject( 'component', 'cfide.adminapi.datasource' );

	dsn = {
		name="#sheet.SHEETNAME#", database="#strPath#db\#sheet.SHEETNAME#", isnewdb=true
	};

	dsnAPI.setDerbyEmbedded( argumentCollection = dsn );
</cfscript>
<cfset datasrc ="#sheet.SHEETNAME#">
<cfspreadsheet action="read" src="#theFile#" sheetname="#sheet.SHEETNAME#" query="queryData"> 
<cfloop query="queryData">
	<cfloop list="#ArrayToList(queryData.getColumnNames())#" index="col">
			<!---table name--->
					 
	</cfloop>
</cfloop>

<!--- process each sheet --->
<cfloop from="2" to="#info.SHEETS#" index="num">
     <!--- make the sheet active --->
     <cfset SpreadsheetSetActiveSheetNumber(sheet, num)>
     <cfdump var="#sheet.SHEETNAME#" >
     <cfspreadsheet action="read" src="#theFile#" sheetname="#sheet.SHEETNAME#" rows="1" query="queryData">
     <cfset str="create table #sheet.SHEETNAME# (">
     <cfloop query="queryData">
     	<cfloop list="#ArrayToList(queryData.getColumnNames())#" index="col">
     	    <!---table column name--->
			<cfset str= str & #queryData[col][currentrow]# & " VARCHAR(50),">
		</cfloop>
     </cfloop>
	<cfset str= Left(str, len(str)-1)>
	<cfset str= str & ")">
	<cfdump var="#str#" >
	<cfoutput >
		<cfquery datasource="#datasrc#" >
			#str#
		</cfquery>
	</cfoutput>
	<cfspreadsheet action="read" src="#theFile#" sheetname="#sheet.SHEETNAME#" query="quData" excludeheaderrow="true" headerrow = "1"> 
	<cfdump var="#quData#" >
	<!---entries in table--->
	<cfloop query="quData">
		<cfset str="INSERT INTO #sheet.SHEETNAME# VALUES (">
		<cfloop list="#ArrayToList(quData.getColumnNames())#" index="col">
				<cfdump var="#quData[col][currentrow]#" > 
				<cfif IsNull(#quData[col][currentrow]#)>
					<cfset str = str & "null" & ",">
				<cfelse>
				<cfset whatever=quData[col][currentrow]>
						<cfset str = str & "'" & #Replace(quData[col][currentrow],"'","","ALL")# & "'" & ",">
				</cfif>
		</cfloop>
		<cfset str= Left(str, len(str)-1)>
		<cfset str= str & ")">
		<cfdump var="#str#" >
			<cfquery datasource="#datasrc#" >
			#preserveSingleQuotes(str)#
			</cfquery>
	</cfloop>

</cfloop>


