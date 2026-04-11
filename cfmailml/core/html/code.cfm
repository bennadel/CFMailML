<cfmodule template="../TrimOutput.cfm">

<!--- Define custom tag attributes. --->
<cfparam name="attributes.class" type="string" default="" />
<cfparam name="attributes.style" type="string" default="" />

<!--- // ------------------------------------------------------------------------- // --->
<!--- // ------------------------------------------------------------------------- // --->

<cfswitch expression="#thistag.executionMode#">
	<cfcase value="end">
		<cfoutput>

			<cfmodule
				template="../Styles.cfm"
				variable="inlineStyle"
				entityName="code"
				entityClass="#attributes.class#"
				entityStyle="#attributes.style#">
			</cfmodule>

			<code
				class="#trim( 'html-entity-code #attributes.class#' )#"
				style="#inlineStyle#"
				>#thistag.generatedContent#</code>

		</cfoutput>
	</cfcase>
</cfswitch>

<!--- Reset the generated content since we're overriding the output. --->
<cfset thistag.generatedContent = "" />

<!--- End of fanatical whitespace management. --->
</cfmodule><cfexit method="exitTemplate" />
