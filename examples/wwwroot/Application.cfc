component {

	// Define the application settings.
	this.name = "CFMailML_Examples";
	this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;
	// As a security best practice, we DO NOT WANT to search for unscoped variables in any
	// scope other than the core variables, local, and arguments scope. The CGI, FORM,
	// URL, COOKIE, etc. should only ever be referenced explicitly.
	this.searchImplicitScopes = false;
	// Make sure that every struct key-case matches its original defining context. This
	// way, we don't get any unexpected upper-casing of keys (a legacy CFML behavior).
	this.serialization = {
		preserveCaseForStructKey: true,
		preserveCaseForQueryColumn: true
	};
	// Make sure that all arrays are passed by reference. Historically, arrays have been
	// passed by value, which has no place in a modern language.
	this.passArrayByReference = true;
	// In addition to CFM/CFML files, only allow HTML files to be compiled and executed
	// as CFML code when transcluded with a cfinclude tag. All other includes will be
	// consumed as static content.
	this.compileExtForInclude = "html";
	// Stop ColdFusion from replacing "<script>" tags with "InvalidTag". This doesn't
	// really help us out.
	this.scriptProtect = "none";
	// Block all file extensions by default. This will require each fileUpload() call to
	// have an explicit set of allow-listed mime-types.
	this.blockedExtForFileUpload = "*";

	// Define the server mappings (for components and expandPath() calls).
	this.wwwRoot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings = {};

	// Define to mail server settings.
	// this.smtpServerSettings = this.config.smtp;

	// ---
	// LIFE-CYCLE METHODS.
	// ---

	/**
	* I get called once to initialize the request.
	*/
	public void function onRequestStart() {

		cfsetting(
			requestTimeout = 20,
			showDebugOutput = false
		);

		request.platform = platformGet();

	}


	/**
	* I handle uncaught errors within the application.
	*/
	public void function onError( required any exception ) {

		// FOR DEBUGGING PURPOSES ONLY.
		writeDump( exception.rootCause ?: exception.cause ?: exception );
		abort;

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I get details about the current runtime engine.
	*/
	private struct function platformGet() {

		if ( server.keyExists( "lucee" ) ) {

			var slug = "lucee";
			var name = "Lucee CFML";
			var version = {
				major: listFirst( server.lucee.version, "." ),
				details: server.lucee.version
			};

		} else {

			var slug = "acf";
			var name = "Adobe ColdFusion";
			var version = {
				major: listFirst( server.coldfusion.productVersion ),
				details: server.coldfusion.productVersion
			};

		}

		return {
			id: "#slug##version.major#",
			slug: slug,
			name: name,
			version: version
		};

	}

}
	