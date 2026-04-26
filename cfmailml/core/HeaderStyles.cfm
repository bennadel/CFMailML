<cfscript>

	// Define custom tag attributes.
	param name="attributes.injectImportant" type="boolean" default=true;

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	switch ( thistag.executionMode ) {
		case "end":

			arrayAppend(
				getBaseTagData( "cf_email" ).headerStyleBlocks,
				prepareStyles( thistag.generatedContent, attributes.injectImportant )
			);

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I (optionally) inject the "!important" flag at the end of each CSS property line,
	* using the semi-colon as a hook into the placement.
	* 
	* @content I am the style content being augmented.
	*/
	public string function prepareStyles(
		required string content,
		required boolean injectImportLineFlag
		)
		cachedWithin = "request"
		{

		if ( ! arguments.injectImportLineFlag ) {

			return arguments.content;

		}

		if ( findNoCase( arguments.content, "!important" ) ) {

			throw(
				type = "CFMailML.UnexpectedImportant",
				message = "HeaderStyles cannot contain !important if it is also being injected.",
				extendedInfo = "Content: #arguments.content#"
			);

		}

		return reReplace( arguments.content, "(?m)(;[ \t]*$)", " !important \1", "all" );

	}

</cfscript>
