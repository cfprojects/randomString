<cfsetting enablecfoutputonly="true">

<cfif isdefined("thisTag.executionMode")>
	<cfif thisTag.executionMode is "start">
		<cftry>
			<cfset randomString = request.blogManager.getPluginQueue().getplugin("com.moonlitscript.randomstring").getRandomString() />
			<cfoutput>#randomString#</cfoutput>
			<cfcatch><cfoutput><!-- #cfcatch.message# --></cfoutput></cfcatch>
		</cftry>
	</cfif>
</cfif>

<cfsetting enablecfoutputonly="false">