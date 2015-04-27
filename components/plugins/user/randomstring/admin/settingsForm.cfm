<cfoutput>
	<form method="post" action="#cgi.script_name#">
		<fieldset>
			<legend>Random String Content (each phrase on its own line)</legend>
			<textarea id="RandomStringContent" name="RandomStringContent" cols="50" rows="30">#variables.RandomStringContent#</textarea>
		</fieldset>
		<div class="actions">
			<input type="hidden" name="action" value="event" />
			<input type="hidden" name="event" value="showRandomStringSettings" />
			<input type="hidden" name="apply" value="true" />
			<input type="hidden" name="selected" value="RandomString" />
		    <input type="submit" class="primaryAction" value="Submit" />
		</div>
	</form>
</cfoutput>