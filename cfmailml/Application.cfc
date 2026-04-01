component {

	// Nothing in this DSL (Domain Specific Language) should be executable as an incoming
	// request. Everything in this DSL is intended to be consumed as a ColdFusion Custom
	// Tag, either via CFModule (faster) or via CFImport (slower).
	abort;

}
