<cfcomponent displayname="Handler">

	<cfset variables.name = "RandomString">
	<cfset variables.id = "com.moonlitscript.randomstring">
	<cfset variables.package = "com/moonlitscript/randomstring"/>

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />
		
			<cfset var blogId = arguments.mainManager.getBlog().getId() />
			<cfset var path = blogId & "/" & variables.package />
			<cfset variables.preferencesManager = arguments.preferences />
			<cfset variables.manager = arguments.mainManager />
			<cfset variables.title = variables.preferencesManager.get(path,"podTitle","") />
			
			<cfset variables.RandomStringContent = variables.preferencesManager.get(path,"RandomStringContent","") />
			
		<cfreturn this/>
	</cffunction>


	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>


	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
		<cfreturn />
	</cffunction>


	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>


	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
		<cfreturn />
	</cffunction>


	<cffunction name="setup" access="public" output="false" returntype="any" hint="This is run when a plugin is activated">
		<cfset var path = variables.manager.getBlog().getId() & "/" & variables.package />
		<cfset var confirmMessage = 'The RandomString plugin activated. Would you like to <a href="generic_settings.cfm?event=showRandomStringSettings&amp;owner=RandomString&amp;selected=showRandomStringSettings">configure it now</a>?' />
		<cfset variables.preferencesManager.put(path,"RandomStringContent","") />
		
		<cfreturn confirmMessage />
	</cffunction>
	
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn />
	</cffunction>


	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />	
		<!--- this plugin does not have any asynchronous handling --->	
		<cfreturn />
	</cffunction>
	
	
	<cffunction name="getRandomString" hint="I get a random string from the list" access="public" output="false" returntype="String">
		<cfset var delimiters = "#chr(13)##chr(10)#" />
		<!--- MH20090531: get the current length of the list of random strings --->
		<cfset var currentListLength = listlen(variables.RandomStringContent,delimiters) />
		<cfset var thisIndex = "" />
		<cfset var thisString = "" />
		
		<cfif currentListLength GT 0>
			<!--- MH20090531: select a random number between one and the current list length ---> 
			<cfset thisIndex = randrange(1,currentListLength) />
			<!--- MH20090531: use that random number to get a random element of the list --->
			<cfset thisString = listgetat(variables.RandomStringContent,thisIndex,delimiters) />
		</cfif>
		
		<!--- MH20090531: my shameless name drop. please leave in place 
			  or link back to my site, http://www.moonlitscript.com. thank you --->
		<cfset thisString = thisString & "<!-- RandomString plugin copyright 2009 by Matt Hill, http://www.moonlitscript.com -->" />

		<cfreturn thisString />
	</cffunction>


	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

		<cfset var outputData = "" />
		<cfset var pod = structnew() />
		<cfset var link = structnew() />
		<cfset var page = "" />
		<cfset var data = ""/>
		<cfset var path = "" />
		<cfset var eventName = arguments.event.name />
		<cfset var thisString = getRandomString() />

		<cfswitch expression="#eventName#">
			<cfcase value="getPods">
				<cfset outputData = arguments.event.getOutputData() />
				
				<cfset arguments.event.setOutputData(outputData & thisString) />
				
				<cfset pod.title = variables.title />
				<cfset pod.content = thisString />
				<cfset pod.id = "RandomString" />
				<cfset arguments.event.addPod(pod)>
			</cfcase>
			
			<cfcase value="settingsNav">
				<cfset link.owner = "RandomString">
				<cfset link.page = "settings" />
				<cfset link.title = "RandomString" />
				<cfset link.eventName = "showRandomStringSettings" />
				
				<cfset arguments.event.addLink(link)>
			</cfcase>
			
			<cfcase value="showRandomStringSettings">
				<cfset data = arguments.event.getData() />				
				<cfif structkeyexists(data.externaldata,"apply")>
					<cfset variables.RandomStringContent = data.externaldata.RandomStringContent />
					
					<cfset path = variables.manager.getBlog().getId() & "/" & variables.package />
					<cfset variables.preferencesManager.put(path,"RandomStringContent",variables.RandomStringContent) />
			
					<cfset data.message.setstatus("success") />
					<cfset data.message.setType("settings") />
					<cfset data.message.settext("RandomString updated successfully")/>
				</cfif>
				
				<cfsavecontent variable="page">
					<cfinclude template="admin/settingsForm.cfm" />
				</cfsavecontent>
				
				<cfset data.message.setTitle("RandomString Settings") />
				<cfset data.message.setData(page) />
			</cfcase>
			
			<cfcase value="getPodsList">
				<cfset pod.title = "RandomString" />
				<cfset pod.id = "RandomString" />
				
				<cfset arguments.event.addPod(pod)>
			</cfcase>
		</cfswitch>
		
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>