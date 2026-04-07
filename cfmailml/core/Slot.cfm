<cfscript>

	// Define custom tag attributes.
	param name="attributes.multi" type="boolean" default="false";
	param name="attributes.name" type="string";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	switch ( thistag.executionMode ) {
		case "end":

			slots = getParentSlots();

			if ( attributes.multi ) {

				arrayAppend( slots[ attributes.name ], thistag.generatedContent );

			} else {

				slots[ attributes.name ] = thistag.generatedContent;

			}

			// This tag doesn't generate output - it only manipulates variables.
			thistag.generatedContent = "";

		break;
	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I walk the custom tag list looking for the first ancestor that has a "slots"
	* property defined. Returns the slots property or throws an error if it can't be
	* found.
	*/
	public struct function getParentSlots() {

		var stack = getBaseTagData( "cf_email" )
			.getCustomTagStack()
		;

		for ( var element in stack ) {

			if ( structKeyExists( element.data, "slots" ) ) {

				return element.data.slots;

			}

		}

		throw(
			type = "CFMailML.NotSlotsFound",
			message = "No slots object could be found in a parent tag.",
			extendedInfo ="Base tag list: #getBaseTagList()#"
		);

	}

</cfscript>
