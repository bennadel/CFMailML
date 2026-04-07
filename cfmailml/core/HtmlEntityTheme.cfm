<cfscript>

	// Define custom tag attributes.
	param name="attributes.class" type="string" default="";
	param name="attributes.entity" type="string";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	switch ( thistag.executionMode ) {
		case "end":

			parentTag = getParentTagData();
			parentStyles = parentTag.styles = ( parentTag.styles ?: {} );

			for ( entityName in splitEntityNames( attributes.entity ) ) {

				themeVariableName = "$$entity:theme:#entityName#";

				if ( len( attributes.class ) ) {

					for ( className in splitClassNames( attributes.class ) ) {

						classVariableName = "#themeVariableName#.#className#";

						prefixContent = structKeyExists( parentStyles, classVariableName )
							? ( ";" & parentStyles[ classVariableName ] )
							: ""
						;

						parentStyles[ classVariableName ] = ( prefixContent & thistag.generatedContent );

					}

				} else {

					prefixContent = structKeyExists( parentStyles, themeVariableName )
						? ( ";" & parentStyles[ themeVariableName ] )
						: ""
					;

					parentStyles[ themeVariableName ] = ( prefixContent & thistag.generatedContent );

				}

			}

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I get the parent custom tag data.
	*/
	public struct function getParentTagData() {

		var stack = getBaseTagData( "cf_email" )
			.getCustomTagStack()
		;

		for ( var element in stack ) {

			// First level is the current custom tag (HtmlEntityTheme). We need to find
			// the closest non-current tag in which to store the theme settings.
			if ( element.level != 1 ) {

				return element.data;

			}

		}

	}


	/**
	* I take the given class value (which is a delimited list of classes) and splits it
	* up and returns the array of class name tokens.
	*/
	public array function splitClassNames( required string value )
		cachedWithin = "request"
		{

		return reMatch( "\S+", arguments.value );

	}


	/**
	* I take the given entity value (which is a delimited list of entity names) and splits
	* it up and returns the array of entity name tokens.
	*/
	public array function splitEntityNames( required string value )
		cachedWithin = "request"
		{

		return listToArray( arguments.value, ", " );

	}

</cfscript>
