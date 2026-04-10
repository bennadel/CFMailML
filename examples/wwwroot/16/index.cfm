
<!--- Import custom tag libraries. --->
<cfimport prefix="core" taglib="../../../cfmailml/core/" />
<cfimport prefix="ex16" taglib="." />
<cfimport prefix="html" taglib="../../../cfmailml/core/html/" />

<!--- // ------------------------------------------------------------------------- // --->
<!--- // ------------------------------------------------------------------------- // --->

<core:Email
	subject="This contains mixed-source content."
	teaser="User submitted content included!">
	<core:Body>

		<html:h1>
			Testing User Generated Content
		</html:h1>

		<html:p>
			The problem with <html:strong>User Generated Content</html:strong> (<html:code>UGC</html:code>) is that it's not built with CFMailML custom tags. Which means that it doesn't inherently use any of the styling and rendering mechanics provided by this library.
		</html:p>

		<html:p>
			However, this <html:em>experiment</html:em> parses the UGC with <html:a href="https://jsoup.org/">jSoup</html:a>; and then traverses the DOM tree, translating HTML elements into CFMailML custom tag invocations.
		</html:p>

		<html:hr />

		<!---
			The UserGeneratedContent.cfm custom tag will take the tag body, parse it into
			a Document Object Model (DOM) using jSoup. Then, will walk the DOM tree and
			translate DOM nodes into CFMailML custom tag invocations. Which means that the
			UGC elements will be able to pick up and use any of the inherited styles.
		--->
		<ex16:UserGeneratedContent>
			<!---
				Part of the power of CFMailML is that we can scope styles to a tag
				context. The following HtmlEntityTheme tags will define stles that will
				only be available inside the UserGeneratedContent tag.
			--->
			<core:HtmlEntityTheme entity="p, li">
				color: hotpink ;
			</core:HtmlEntityTheme>
			<core:HtmlEntityTheme entity="li">
				font-weight: 700 ;
			</core:HtmlEntityTheme>
			<core:HtmlEntityTheme entity="a">
				color: darkblue ;
			</core:HtmlEntityTheme>

			<cfoutput>
				#fileRead( expandPath( "./user_content.htm" ), "utf-8" )#
			</cfoutput>
		</ex16:UserGeneratedContent>

		<html:hr />

		<html:p>
			Notice that none of the CSS styles that were scoped to the <html:code>UserGeneratedContent.cfm</html:code> tag were leaked outside of that tag's boundary.
		</html:p>

	</core:Body>
</core:Email>
