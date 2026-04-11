<cfmodule template="../TrimOutput.cfm">

<!--- Define custom tag attributes. --->
<cfparam name="attributes.class" type="string" default="" />
<cfparam name="attributes.href" type="string" />
<cfparam name="attributes.decoration" type="boolean" default="true" />
<cfparam name="attributes.style" type="string" default="" />
<cfparam name="attributes.target" type="string" default="_blank" />

<!--- // ------------------------------------------------------------------------- // --->
<!--- // ------------------------------------------------------------------------- // --->

<cfswitch expression="#thistag.executionMode#">
	<cfcase value="end">
		<cfoutput>

			<cfmodule
				template="../Styles.cfm"
				variable="inlineStyle"
				entityName="a"
				entityClass="#attributes.class#"
				entityStyle="#attributes.style#">
				<cfif ! attributes.decoration>
					text-decoration: none ;
				</cfif>
			</cfmodule>

			<a
				href="#attributes.href#"
				target="#attributes.target#"
				class="#trim( 'html-entity-a #attributes.class#' )#"
				style="#inlineStyle#"
				>#thistag.generatedContent#</a>

		</cfoutput>
	</cfcase>
</cfswitch>

<!--- Reset the generated content since we're overriding the output. --->
<cfset thistag.generatedContent = "" />

<!--- End of fanatical whitespace management. --->
</cfmodule><cfexit method="exitTemplate" />
