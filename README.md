
# CFMailML (CFMail Markup Language)

This is a <mark>**work in progress**</mark>.

CFMailML is a set of ColdFusion custom tags that create a DSL (Domain Specific Language) for rendering `CFMail` templates without a build step. This DSL is an attempt to present like basic HTML on the surface; then, render cross email-client compatible code that hides ~~all~~ (er, some) of the complexity required to get email templates to render the same whether your readers are using Outlook for Desktop or GMail for Web.

For example, you write your straightforward "HTML" with imported ColdFusion custom tags:

```cfml
<html:p>
	<html:a href="https://www.bennadel.com/">Visit my Site</html:a>
</html:p>
```

And what you get in your rendered page is:

```html
<p class="html-entity-p" style="font-family:helvetica,arial,sans-serif; mso-line-height-rule:exactly; color:#22252b; font-size:18px; font-weight:400; line-height:25px; margin:0px; padding:0px;">
	<a href="https://www.bennadel.com/" target="_blank" class="html-entity-a" style="color:#3f51b5; text-decoration:underline;"
		>Visit my Site</a>
</p>

<table aria-hidden="true" role="presentation" width="100%" border="0" cellpadding="0" cellspacing="0" style="height:16px; margin:0px;">
<tr>
	<td style="font-family:arial,verdana,helvetica,sans-serif; mso-line-height-rule:exactly; font-size:16px; height:16px; line-height:70%; overflow:hidden;">
		<div style="height:16px; overflow:hidden;">
			&nbsp;<br />
		</div>
	</td>
</tr>
</table>
```

All of that insanity that you see &mdash; that's what's required to get your email to look good in all the various email clients. You think it's 2026? Maybe in your world; but for email clients, it's still 2015. And [according to Litmus][litmus-report], Outlook Desktop is still the 3rd-most-used email client.

[litmus-report]: https://www.litmus.com/email-client-market-share


## Installation

To use the CFMailML project, you can download this repository and then copy the `cfmailml` directory into your application. The location of the directory is up to you - it just needs to be accessible as an import path for `<cfimport>`. Personally, I like to keep it alongside my email templates so that all my email authoring is collocated.

Once the `cfmailml` directory is copied into your application, there are two sets of imports / tag prefixes to setup:

* `<core:*>` - these are the higher-level architectural custom tags.
* `<html:*>` - these are the lower-level "HTML" custom tags.

At a minimum, every email template must be wrapped in a single `<core:Email>` tag. This sets up the underlying data structures and renders the final HTML output. A minimal CFMailML email might look like this:

```cfml
<cfimport prefix="core" taglib="./cfmailml/core/" />
<cfimport prefix="html" taglib="./cfmailml/core/html/" />

<core:Email subject="Welcome to CFMailML">
	<html:h1>
		CFMailML Makes ColdFusion Emails Fun
	</html:h1>
	<html:p>
		And a little bit easier to write, I hope.
	</html:p>
</core:Email>
```

Please note that the `<cfimport>` tags are **compile time constructs**. This means that you can't using per-application path mappings for the `taglib` attribute. It also means that the `<cfimport>` tags need to be in _every template_ that references the associated `prefix`.

The above ColdFusion page doesn't send an email. In fact, the CFMailML project doesn't know anything about _how_ email gets delivered. It doesn't care if you're sending email using the SMTP protocol with `CFMail` or an API request with `CFHttp`. The CFMailML project is only concerned with _rendering HTML_. It's still up to your project mechanics to capture that HTML output and send it.

How you capture and send email is going to be very particular to your application. I like to define my email templates as standalone `.cfm` pages. Then, I `CFInclude` them into either a `CFSaveContent` buffer or a `CFMail` tag directly:

```cfml
public void function sendWelcomeEmail( required string toUser ) {

	// Capture the CFMailMl template into a local variable/buffer.
	// Since I'm using a simple include, the CFMailML template will
	// have access to THIS component and all the LOCAL variables
	// defined in this function call.
	savecontent variable = "local.body" {
		include "/emails/welcome.cfm";
	}

	sendEmail(
		to = toUser,
		subject = "Welcome to the app",
		body = body
	);

}
```

One benefit of defining your CFMailML templates as standalone `.cfm` files is that you can easily test them by including them into a development SMTP workflow or a static rendering experience. All you have to do is mock-out any data that [the **pure email template**][blog-4581] might need before you `CFInclude` it.

[blog-4581]: https://www.bennadel.com/blog/4581-define-your-email-content-using-pure-templates-in-coldfusion.htm "Read article: Define Your Email Content Using Pure Templates In ColdFusion"

If you ever need to update the CFMailML library, all you have to do is replace the `cfmailml` directory with the latest version.


## Prior Art

I've been using the CFMailML concept for years but didn't have a name for it. Here is all the work I have prior to the codification of this project.

### Git Repositories

These were my original repositories. I'm now attempting to collapse them into a single shared repository that works for both CFML engines.

* [Original Lucee CFML version](https://github.com/bennadel/ColdFusion-Custom-Tag-Emails).
* [Original Adobe ColdFusion version](https://github.com/bennadel/ColdFusion-Custom-Tag-Email-ACF).

Note that at the time of this writing, Boxlang's CFML parser does not support the `<cfimport>` tag for ColdFusion custom tags. As such, this library doesn't work in Boxlang.

### Blog Posts

These were my exploratory blog posts about this topic (using custom tags to generate `CFMail` content).

* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part XV](https://www.bennadel.com/blog/4052-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-xv.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part XIV](https://www.bennadel.com/blog/4038-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-xiv.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part XIII](https://www.bennadel.com/blog/4002-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-xiii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part XII](https://www.bennadel.com/blog/4000-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-xii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part XI](https://www.bennadel.com/blog/3992-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-xi.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part X](https://www.bennadel.com/blog/3991-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-x.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part IX](https://www.bennadel.com/blog/3988-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-ix.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part VIII](https://www.bennadel.com/blog/3986-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-viii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part VII](https://www.bennadel.com/blog/3985-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-vii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part VI](https://www.bennadel.com/blog/3984-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-vi.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part V](https://www.bennadel.com/blog/3983-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-v.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part IV](https://www.bennadel.com/blog/3982-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-iv.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part III](https://www.bennadel.com/blog/3981-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-iii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part II](https://www.bennadel.com/blog/3979-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47-part-ii.htm)
* [Using ColdFusion Custom Tags To Create An HTML Email DSL In Lucee CFML 5.3.7.47, Part I](https://www.bennadel.com/blog/3975-using-coldfusion-custom-tags-to-create-an-html-email-dsl-in-lucee-cfml-5-3-7-47.htm)
* [Adobe ColdFusion 2018 Compatible Version Of My ColdFusion Custom Tag DSL For HTML Emails](https://www.bennadel.com/blog/4064-adobe-coldfusion-2018-compatible-version-of-my-coldfusion-custom-tag-dsl-for-html-emails.htm)
* [Fixing Protocols In My ColdFusion Custom Tag DSL For HTML Emails](https://www.bennadel.com/blog/4123-fixing-protocols-in-my-coldfusion-custom-tag-dsl-for-html-emails.htm)
* [Yahoo! Mail Does Not Render Anchor Tags With Encoded HREF Attributes](https://www.bennadel.com/blog/4115-yahoo-mail-does-not-render-anchor-tags-with-encoded-href-attributes.htm)


## Whitespace Management Issues

Within the internals of the `core/html` tags, I try to _never_ add additional, meaningful whitespace to the rendered output. This way, if you have two ColdFusion custom tags butting-up against each other, the resultant HTML tags will also be butting-up against each other. In Adobe ColdFusion, however, there is an "Enable Whitespace Management" feature in the CFAdmin that can be _too aggressive_ about whitespace elimination:

> **Enable Whitespace Management**
>
> \[x\] Reduces the file size of the pages that ColdFusion returns to the browser by removing many of the extra spaces, tabs, and carriage returns that ColdFusion might otherwise persist from the CFML source file.

This feature, which is enabled by default on Adobe ColdFusion servers, [can sometimes remove the necessary whitespace][blog-4887] that separates your tags. If this happens, you have a fwe choices (from the edge-cases that I tested):

* Disable whitespace management (recommended). This feature feels like "magic"; and generally speaking, we want less magic in our code.

* Move sibling ColdFusion custom tags onto the same line of code. Spaces seem to be handled better than newlines in Adobe's whitespace management.

* Make sure the custom tags are wrapped in a `CFOutput` tag. For some reasons, the whitespace management makes fewer mistakes when it's wrapped in `CFOutput`.

Personally, I recommend disabling the feature altogether (in the CFAdmin or CFConfig settings). I always err on the side of explicit code. Plus, I don't like any settings that can exist outside of the source-control system.

[blog-4887]: https://www.bennadel.com/blog/4887-strange-whitespace-management-issue-with-coldfusion-custom-tags.htm "Read article: Strange Whitespace Management Issue With ColdFusion Custom Tags"
