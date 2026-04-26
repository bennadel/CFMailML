<cfscript>

	switch ( thistag.executionMode ) {
		case "end":

			arrayAppend(
				getBaseTagData( "cf_email" ).headerContentBlocks,
				thistag.generatedContent
			);

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

</cfscript>
