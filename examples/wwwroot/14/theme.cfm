<!---
	We're going to load a custom font for this email. Note that if we load this font,
	we have a large variety in FONT-WEIGHT options. However, if our font fails to
	load (or is not supported in a given email client), we will NOT have all of these
	font-weight options at our disposal.
	--
	CAUTION: ImportURLs are only applied in a NON-MSO context (login within the root
	cf_email ColdFusion custom tag).
--->
<cfset theme = getBaseTagData( "cf_email" ).theme />
<cfset theme.importUrls.append( "https://fonts.googleapis.com/css?family=Poppins:500|Roboto:100,200,300,400,500,600,700" ) />
