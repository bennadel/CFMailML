<cfscript>

	param name="url.exampleID" type="numeric" default=0;

	exampleID = val( url.exampleID );
	exampleSlug = numberFormat( exampleID, "00" );
	examples = [
		{ id: 1,  name: "Hello world" },
		{ id: 2,  name: "Inline themeing" },
		{ id: 3,  name: "Encapsulated themeing" },
		{ id: 4,  name: "Desktop / mobile layouts" },
		{ id: 5,  name: "Media queries" },
		{ id: 6,  name: "Dark mode" },
		{ id: 7,  name: "Multi-slot projection" },
		{ id: 8,  name: "Encapsulation technqiues" },
		{ id: 9,  name: "Comment email" },
		{ id: 10, name: "Code snippets" },
		{ id: 11, name: "Symbols" },
		{ id: 12, name: "Providers" },
		{ id: 13, name: "Margins" },
		{ id: 14, name: "Font-Weight" },
		{ id: 15, name: "Un-encoded protocols" }
	];

	platformID = server.keyExists( "lucee" )
		? "lucee"
		: "acf"
	;
	platforms = [
		{
			id: "acf",
			name: "Adobe ColdFusion",
			authority: "http://localhost:8081"
		},
		{
			id: "lucee",
			name: "Lucee CFML",
			authority: "http://localhost:8082"
		}
	];

</cfscript>
<cfoutput>
	<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>
			CFMailML Examples
		</title>
		<style type="text/css">

			html {
				box-sizing: content-box ;

				& * {
					box-sizing: inherit ;
				}
			}

			body {
				display: flex ;
				font-family: Avenir, Montserrat, Corbel, URW Gothic, source-sans-pro, sans-serif ;
				height: 100vh ;
				margin: 0 ;
				overflow: hidden ;
				padding: 0 ;
			}

			main {
				background-color: ##f6f6f6 ;
				flex: 0 0 auto ;
				overflow: auto ;
				overscroll-behavior: contain ;
				padding: 10px ;
			}

			aside {
				flex: 1 1 auto ;
				min-width: 700px ;
			}

			iframe {
				border: 0 ;
				display: block ;
				min-height: 100vh ;
				max-height: 100vh ;
				width: 100% ;
			}

			h1 {
				margin-top: 0 ;
			}

			ul {
				margin-bottom: 0 ;
			}

			a {
				color: inherit ;
			}

			.items {
				margin: 0 ;
				padding: 0 ;
			}
			.items_item {
				list-style-type: none ;
				margin: 0 0 5px 15px ;
			}
			.items_link {
				border: 1px solid ##eaeaea ;
				border-radius: 2px ;
				display: flex ;
				flex-direction: column ;
				gap: 0 ;
				padding: 5px 10px ;
				text-decoration: none ;

				&[data-selected] {
					background-color: ##ffff04 ;
					border-color: ##d5d500 ;
				}
			}
			.items_name {
				text-decoration: underline ;
			}
			.items_description {
				opacity: 0.7 ;
			}

		</style>
	</head>
	<body>
		<main>

			<h1>
				CFMailML
			</h1>

			<h2>
				Platforms
			</h2>

			<ul class="items">
				<cfloop array="#platforms#" item="platform">
					<li class="items_item">
						<a
							href="#platform.authority#/index.cfm?exampleID=#encodeForUrl( exampleID )#"
							<cfif ( platform.id eq platformID )>
								data-selected
							</cfif>
							class="items_link">
							<span class="items_name">
								#encodeForHtml( platform.name )#
							</span>
						</a>
					</li>
				</cfloop>
			</ul>

			<h2>
				Examples
			</h2>

			<ul class="items">
				<cfloop array="#examples#" item="example">
					<li class="items_item">
						<a
							href="?exampleID=#encodeForUrl( example.id )#"
							<cfif ( example.id eq exampleID )>
								data-selected
							</cfif>
							class="items_link">
							<span class="items_name">
								Example #encodeForUrl( example.id )#
							</span>
							<span class="items_description">
								#encodeForHtml( example.name )#
							</span>
						</a>
					</li>
				</cfloop>
			</ul>

		</main>
		<aside>

			<cfif exampleID>
				<iframe
					src="./#encodeForUrl( exampleSlug )#/index.cfm"
				></iframe>
			</cfif>

		</aside>
	</body>
	</html>
</cfoutput>
