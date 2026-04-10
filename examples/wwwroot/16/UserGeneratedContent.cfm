<cfscript>

	if ( thistag.executionMode == "end" ) {

		translateUserContent( thistag.generatedContent );

	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	/**
	* I parse the user generated content (UGC) into a DOM tree (using jSoup), then walks
	* the tree re-creating DOM elements using the CFMailML custom tags. This allows UGC to
	* take-on all of the styling and low-level hacks needed for some mail clients.
	*/
	private void function translateUserContent( required string generatedContent ) {

		// Note: JAR-path based instantiation only available in Adobe ColdFusion since
		// version 2025. Before then, the JavaLoader project is needed.
		var jarPaths = [ expandPath( "./jsoup-1.22.1.jar" ) ];
		var doc = createObject( "java", "org.jsoup.Jsoup", jarPaths )
			.parseBodyFragment( generatedContent.trim() )
		;

		// Overwrite the contents of the current tag with the translated DOM tree.
		cfsavecontent( variable = "thistag.generatedContent" ) {

			renderChildren( doc.body() );

		}

	}


	/**
	* I iterate over the given container's nodes, using a depth-first approach, and
	* translate the HTML elements into CFMailML custom tag invocations. This method
	* expects to be able to write to the output buffer as its implementation mechanism.
	*/
	private void function renderChildren( required any parentNode ) {

		for ( var node in parentNode.childNodes() ) {

			var nodeName = node.nodeName().lcase();

			switch ( nodeName ) {
				// Whitelist node names that have corresponding custom tags.
				case "a":
				case "blockquote":
				case "code":
				case "div":
				case "em":
				case "h1":
				case "h2":
				case "h3":
				case "h4":
				case "h5":
				case "h6":
				case "hr":
				case "img":
				case "li":
				case "mark":
				case "ol":
				case "p":
				case "pre":
				case "span":
				case "strike":
				case "strong":
				case "symbol":
				case "table":
				case "td":
				case "th":
				case "tr":
				case "ul":
					renderNodeAsTag( node, nodeName );
				break;
				// Translate some non-supported tags into supported tags.
				case "b":
					renderNodeAsTag( node, "strong" );
				break;
				case "i":
					renderNodeAsTag( node, "em" );
				break;
				// Output text nodes as-is.
				case "##text":
					writeOutput( node.text() );
				break;
				// For any HTML tag that we don't support as a ColdFusion custom tag,
				// we're going to render it simply without any of the CFMailML powers.
				default:
					writeOutput( "<#nodeName#>" );
					renderChildren( node );
					writeOutput( "</#nodeName#>" );
				break;
			}

		}

	}


	/**
	* I translate the given node into a CFMailML custom tag. This method assumes that the
	* node has already been identifies as being CFMailML compatible. As such, this method
	* merely maps node names and attributes onto custom tag inputs.
	*/
	private void function renderNodeAsTag(
		required any node,
		required string nodeName
		) {

		var stringAttributes = [ "class", "style" ];
		var booleanAttributes = [];
		var tagAttributes = {};

		// Identify special attributes for different custom tags.
		switch ( nodeName ) {
			case "a":
				stringAttributes.append( "href" );
			break;
		}

		// Map string attributes from DOM node to custom tag attributes.
		for ( var attrName in stringAttributes ) {

			if ( node.hasAttr( attrName ) ) {

				tagAttributes[ attrName ] = encodeForHtmlAttribute( node.attr( attrName ) );

			}

		}

		// Map Boolean attributes from DOM node to custom tag attributes.
		for ( var attrName in booleanAttributes ) {

			tagAttributes[ attrName ] = node.hasAttr( attrName );

		}

		// Note: Adobe ColdFusion has an issue where pushing the "template" attribute into
		// the attributeCollection *sometimes* throws an error. As such, I'm explicitly
		// providing it in the tag invocation.
		cfmodule(
			template = "../../../cfmailml/core/html/#nodeName#.cfm",
			attributeCollection = tagAttributes
			) {
			renderChildren( node );
		}

	}

</cfscript>
