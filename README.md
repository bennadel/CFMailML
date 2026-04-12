
# CFMailML (CFMail Markup Language)

A DSL (Domain Specific Language) for rendering `CFMail` templates without a build step.

This is a <mark>**work in progress**</mark>.


## Prior Art

### Git Repositories

These were my original repositories. I'm now attempting to collapse them into a single shared repository that works for both CFML engines.

* [Original Lucee CFML version](https://github.com/bennadel/ColdFusion-Custom-Tag-Emails).
* [Original Adobe ColdFusion version](https://github.com/bennadel/ColdFusion-Custom-Tag-Email-ACF).

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

* Move sibling ColdFusion custom tags onto the same line of code (spaces are handled better than newlines in Adobe's whitespace management).

* Make sure the custom tags are wrapped in a `CFOutput` tag. For some reasons, the whitespace management makes fewer mistakes when it's wrapped in `CFOutput`.

Personally, I recommend disabling the feature altogether (in the CFAdmin or CFConfig settings). I always err on the side of explicit code. Plus, I don't like any settings that can exist outside of the source-control system.

[blog-4887]: https://www.bennadel.com/blog/4887-strange-whitespace-management-issue-with-coldfusion-custom-tags.htm "Read article: Strange Whitespace Management Issue With ColdFusion Custom Tags"
