# Templet Rails

## Sections

[Forward](#forward)
a quick run through and info on learning resources.

[Introduction](#intro)
a short summary.

[FAQ](#faq)
frequently asked questions.

[Generators](#gen)
where you get started.

[Notes](#notes)
a wider summary.

<a name="forward"></a> 
## Forward

### Outline

This is a framework to render views in Rails.

It replaces ERb (HAML, etc.) scripts with pure Ruby classes
that, by default, render (Bootstrap) HTML for the standard REST actions.

This facilitates a more object oriented approach to writing view code,
yet the framework retains compatibility with
Rails' view scripts and Helper methods.

If you're familiar with Rails,
it shouldn't take you too much effort to learn this framework.
Its underlying API is not large or complicated,
and you can have a REST interface up and running
as quickly as you can with Rails' scaffold generators.

### Example Application

To learn it practically, there is an example Rails app,
[templet_demo](https://github.com/srycyk/templet_demo),
which is a small administrative front-end of just three models.

This small app has lots of examples that illustrate
how to customise views using the framework.

By itself, this app should provide enough information
for you to write code in the framework effectively.
It demonstrates most of the finer points involved in
adapting it for particular requirements.

### Documentation Sources

For a broad, more theoretical, overview of the framework,
there is this guide.

Although it's quite wordy, short of examples, not exhaustive,
and a lot to take in at one sitting,
it does explain why you may want to use the framework,
where you begin,
how it works,
what it contains,
as well as outlining its internal organisation.

In addition, there is another guide, to be found at
[templet](https://github.com/srycyk/templet),
which describes the DSL that renders HTML tags.

This DSL, which is heavily used by the higher-level framework,
is so straightforward and succinct
that you may only need a passing acquaintance with its documentation.
_You may well pick it up as you go along._

For devoted punishment gluttons, there is yet more to read -
the source code carries comments
and the purpose of each class is spelled out.

<a name="intro"></a> 
## Introduction

### Packaging

These facilities come in two gems,
[templet](https://github.com/srycyk/templet)
and
[templet\_rails](https://github.com/srycyk/templet_rails).

The first is a self-contained DSL for rendering markup, i.e. HTML pages.

The second, which relies on the first,
is a framework (packaged as a Rails Engine)
that has similar functionality to
the Rails scaffold generator.
It is just as easy to get working and to change,
but it is, arguably, more modular and concise.

> Naturally, these gems need to be declared in your *Gemfile*.
> Please see the *Configuration* section below for further details.

### Basic Design

The framework is small and simple.
So much so that *framework* may be too grand a term,
as it could equally be described as a pattern,
with an attached API.

The framework follows many of Rails' (naming) conventions,
notably it provides default behaviour
that can be easily overridden or supplanted.

### Benefits

It allows the DRY principle to be more easily applied to the views
than with the usual templates, (like ERb &amp; HAML),
which are essentially a single stretch of in-line code
that can quickly become long and repetitive.

This framework promotes productivity
as the views can be written in idiomatic Ruby,
thus allowing more standardisation, reuse and encapsulation.

The framework does *not*, in any way, *monkey-patch* the Rails core,
and should work with just about any version of Rails, even future ones!
Though it requires a fairly recent (i.e. supported) version of Ruby.

### Installing

An installation involves issuing a few commands,
and, almost certainly,
it will cause no conflicts with other packages.
Likewise, a de-installation is even less trouble.

### Twitter Bootstrap Dependency

In the framework, as it stands,
you do really need to use *Twitter Bootstrap 3.3*.
_Without it, the HTML will look awful!_

If you don't currently use this particular Bootstrap (3.3) version,
it won't be difficult, or take too long, to update the source yourself.

But if you don't use Bootstrap, it'll take you some time
to modify the source to accommodate some other CSS library.
 
### Main Sections

The framework is divided into the following parts:

1. The framework's core code.
   This is accessed from inside of the *templet_rails* engine.
   But if you decide to modify this code yourself,
   there is a generator that will copy it into
   your application's file system,

2. Application code. This consists of your own
   modules that cater for specific use-cases.
   _As a part of the initial installation,
   there are general-purpose classes pre-installed in this area,
   most of which are for a prototype layout._

3. A declarative testing sub-system in Rspec, which is optional.

### Usage

#### Two Basic Steps

To build individual application modules with the framework,
you need to create a Controller and *Viewer* class,
both of which can be generated.

##### The Controller

A controller will look pretty much the same as usual,
except for the way the view is invoked.

You render a view by calling, from the controller,
a method on an instance of a *Viewer* class.

However, you shouldn't need to refer to this *Viewer* class directly,
as there are controller utilities that provide shortcuts
to launch the view rendering.

##### The Viewer

This *Viewer* class carries out all of the HTML rendering,
and it lets you diverge from default functionality
that is provided by its superclasses.

Inside this *Viewer* class, you're able to override a hatful of methods,
for either fine, or coarse, grained modifications.

Normally, there is just one of these classes per controller,
and they have (public) method names in common.
For example, an *index* method, in the controller,
calls a counterpart *index* method in the *Viewer* class.

Among other things, this *Viewer* class offers the following features:

1. A main surrounding Layout which can be varied,
   (maybe by inheritance),
   and also be shared by a specified subset of pages.
   For JS requests, obviously, it's left out.

2. Partials that let you split a whole page into discrete parts.
   Like the Layouts above, they are similar (in intent) to
   their correlates in Rails, but here they are Ruby (subclasses)
   that render HTML by means of a rudimentary DSL.

3. An API to render composite HTML components,
   like forms, tables and lists.

4. Utility classes that build collections of REST links for actions
   on any type of model - with or without a corresponding parent model.
   These links can be wrapped in HTML lists, or in any markup you like.
   By subclaassing, you can add extra links to these menus.

5. Access all of the Rails *ActionView* methods,
   such as *link_to*, *text\_field\_tag* &amp; *render*,
   as well as those you may have added yourself in the traditional
   Rails-generated Helper modules -
   but with this framework, you won't need these anymore!

### Getting Started

#### Generators

The gem for the framework consists of several generators.
These are your starting point in application development.

A few are to do with the installation of the framework,
and are to be run just once.

The others are for producing application code,
and are to be run multiple times with varying arguments.

Principally, there is a scaffold generator that creates, at once,
a controller, a *Viewer* class (to customise the HTML output),
some RSpec tests, and a Rails routing entry.

The generated code code should work without intervention,
providing default behaviour that can be easily modified,

More information on using the generators is given below.

#### Environment Setup

Be aware that you'll need to add some simple configuration directives,
which are mentioned in the *Configuration* section at the end.

<a name="faq"></a> 
## Frequently Asked Questions

### What is it?

It is a framework, together with associated libraries,
for rendering views in Rails.
It provides scaffold-like functionality,
and it permits you to render markup (HTML) in pure Ruby,
thereby lending itself to component-based OO paradigms.

The framework is pretty sparse, has few dependencies,
and is not difficult to code in.

### Why use it?

Primarily, it's to boost development efficiency.

But you may also find it more comfortable to work with,
as it gives you more of a free rein than, say, ERb scripts.

#### *It's quick*

Using the supplied generators,
(which work like Rails' scaffolding),
you can have a viable fully-functional REST interface up and running
in next to no time.

And when you need to augment or alter the default functionality,
it lets you do so easily and briefly.

#### *It's flexible*

In Rails, object oriented support stops at the view stage.

When you use scripts like ERb or HAML or SLIM,
you're constrained by their in-line procedural methodology.

These scripts often end up being monolithic and awkward to maintain.
Code sharing is too verbose,
as it can result in a proliferation of tiny files and
complex helper methods, which, since they are global in scope,
need to be named with care.

In contrast, within this framework everything can be written in
unrestrained Ruby,
allowing you to use the language's object oriented, and functional,
features as you see fit.

For example, using this framework, it's much easier
to implement general-purpose components,
to fine-tune small variations,
to enforce site-wide uniformity in presentation,
to produce syntactically correct HTML,
and to rearrange the various sections of a page.

### How easy is to learn?

For a Rails developer its workings should be intuitive.
Also, the API is relatively small, and what you need to know
to get started is even smaller.

### Is it compatible with traditional view rendering?

In this framework, you're still able to use the
(convenient and well known) Rails helper methods,
like *render*, *link\_to* and *options\_from\_collection\_for\_select*.

This allows you to *mix 'n' match* the two approaches,
allowing them both to sit alongside one another.

### How is this facility used?

You can use it as a framework
that performs the entire view rendering process,
or you can use it as a library (toolkit) to render view segments.

#### *As a framework*

To use it as a framework there are generally just two classes to create,
(though in the very simplest cases there is only one).

1. A *Controller* class, which is almost the same as usual,
   the only major difference is in the way the view handling is executed,
   which is by the class described directly below.

2. A *Viewer* class, which renders complete HTML pages
   for (the actions of) its corresponding controller,
   with which it has a similarly named public API.
   For example, both may have public methods, *index* and *show*.

#### *As a library*

If, instead, you want to use it as library for rendering components such
as forms, tables, lists, navigation buttons, Bootstrap menus, etc..
There are a several *mixin* Ruby modules, and utility classes,
included that facilitate this.

At present, you'll have to dip into the source yourself to learn this API,
though it is covered briefly later on.

### Will using it have any unwanted side-effects?

Highly unlikely, as it doesn't alter anything in any existing classes,
and there aren't too many calls to the Rails API.

It has only one run-time dependency on a third-party gem,
which is *Twitter Bootstrap 3.3*, (for HTML styling).

### What does it contain?

The package consists of two relatively small gems,
which are both run-time dependencies.
The first is a DSL for rendering HTML,
the second is an engine that is for use with Rails and Bootstrap (3.3),
that contains the framework's source and several generators.

### Where does it add its code?

Your application view's code is put under *app/helpers/app/*.
There's a generator to set this area up.

The framework's source is accessed from
within the *templet_rails* engine.
But if you plan to change the source,
you can use a generator to copy it into your app directly.

### Is it easy to deinstall?

If you try it out, and then opt to ditch it,
a rollback will almost certainly be effortless.

It will just involve deleting a number of files,
for which there's a generator, *templet:destroy*.

This generator deletes all of the framework
and the nearly all of the application files -
your controllers and entries in *config/routes.rb* are left alone.

### What does it depend on?

Apart from Rails itself, there is a dependency on *Twitter Bootstrap 3.3*.

This is not strictly compulsory, (it'll spit out the HTML regardless)
but, right now, you'll have to change the source code yourself
to disentangle this dependency,

It's currently for Bootstrap version 3.3, but if you do
fork the code for compatibility with, say, Bootstrap 4,
you should only be occupied for a few hours,
and you'll only need to edit a half-dozen files at most.

However, if you don't use Bootstrap,
and you choose to adapt this framework
to work with some other styling (CSS) API,
it'll likely take you a good while.
_Not so much in the number of code changes,
but in tracking them down._

### Will it be supported?

No guarantee!
But will you need long-term external support? Probably not.

The code-base is so small that taking responsibility
for its upkeep should not be too onerous.
There is little to go wrong.

Dealing with future Ruby and Rails deprecations
will probably be your biggest risk.

### Are there tests?

It comes supplied with a rudimentary testing system.

This consists of Rspec *shared\_examples* that
test the controller's JSON output,
and other *shared\_examples* that test the output of the *Viewer* classes,
using (Nokogiri) CSS selectors on the resultant HTML.

Although limited in scope, these tests can be written in 
a very small chunk of declarative code.
Nonetheless, in their present form,
they are not a viable substitute for the usual testing suites.

When running the tests, it needs the gems:
*rspec*, *nokogiri* and *factory_bot*,
for which (model) factories have previously been defined.

### What sort of applications is it most suited for?

1. It's ideal for REST-based apps, especially administrative dashboards.

2. Experimental or MVP sites, where it can quickly plug holes.
   The framework reduces development time because many modifications
   can be written in small (centralised) code sections,
   and more complex modifications can be structured in whatever
   way you think best.

3. In general, it's for data-base driven (form-filling) sites -
   not really for fancy (JS-heavy, graphic-laden) sites
   where data is passively consumed.

### What are its advantages?

1. As well as being quicker to develop in, it seems to run a bit faster
   than the conventional Rails ERb rendering.

2. Presentational changes can be made from a single place,
   and then they'll propagate immediately throughout the whole site.
   For example, all textual HTML links can be changed to iconic
   in a single line of code.

3. It lets you do things like putting view segments
   into variables that you can pass around for, say,
   later rendition within another (nested) component.

4. It can be used alongside existing views scripts and Helper methods.

5. Testing view components is made easier, as they can be implemented
   in separate stand-alone classes with regulated input.

### What are its disadvantages?

1. The bare Bootstrap styling is characterless,
   and the HTML will be tricky for web designers to modify.

2. The way in which this framework is laid out may
   rub against your existing practices,
   which may necessitate so much code reorganisation
   that adopting the framework won't be worthwhile.

3. Some functionality, provided by Rails, for view rendering
   become unavailable.
   Principally these things are: view path look-ups,
   shortcuts for rendering collections,
   inferring partial names from instance variables,
   and an inability to *yield* additional content
   at arbitrary positions on the page, i.e. *content_for* blocks.
   _But in practice, this shouldn't be much of a constraint._

4. Caching view segments may be prove harder than usual.
   You should still be able to use Rails' low-level fragment caching,
   but partial caching is impossible.

5. Having to learn how to use the caboodle in the first place.
   But since you've ploughed through this far, you're getting there,
   and I congratulate your endurance!

6. But seriously, there may be possible security issues with
   code injection attacks.
   This is because the whole page is made *html_safe*.
   Probably the best way of safeguarding against this is by including
   model validations to ensure that malicious snippets of code
   cannot be saved to begin with.
   There is a validator module,
   (*app/models/concerns/nasty_char_validator.rb*, in *templet_demo*)
   which can be added to model classes to prevent users from saving
   records containing field values with non-standard punctuation.
   Alternatively, you could *sanitize* input fields
   in a *before_validation* callback (inside of a model).

### How does it compare to similar offerings?

Although the following claims do present
this framework in its *best light*,
nevertheless, some might say otherwise.

1. It is similar in function to data-base maintenance gems,
   (like *active_admin*),
   but while such like provide a finished application,
   (which can only be modified via a restrictive DSL),
   this framework provides a prototype (preliminary) application,
   (which can be modified in any way you wish).

2. It has the modularity of say, *cells*, but does not rely on
   scripts behind the scenes, which add a layer of complexity,
   requiring you, for one, to flit between multiple file edits.

3. It has the *kick-start* convenience of Rails's scaffolding. 

4. You can write HTML with the economy of HAML or SLIM,
   and be assured that it's well-formed.

5. The *Viewer* classes, in themselves, have the simplicity of, say,
   Sinatra scripts, as they permit a number of distinct web pages
   to be defined in a single file, which is fine in simple cases.
   But in more complicated cases, you'd write a dedicated class
   to render the HTML, and you'd invoke it from the *Viewer* class.

<a name="gen"></a> 
## Generators

The generators are your first port of call.
One is invoked to install the framework's core code.
Others are invoked as an initial step in developing application modules.

The generators are contained in the engine, *templet_rails*.
Apart from documentation, this gem contains nothing else of interest,
and it's only for use in the development environment.

These generators are listed as follows:

```
$ rails g
...
Templet:
  templet:controller
  templet:core_install
  templet:core_rspec
  templet:destroy
  templet:install
  templet:routes
  templet:rspec
  templet:scaffold
  templet:viewer
...
```

> *Troubleshooting tip.* If you're unable to see these generators as listed,
> from the command-line, try this: `$ mkdir lib/generators`.

### Generating Application Code

The first generator to run is *templet:install*,
which prepares an area for putting your 
application code in - once and for all.

Prior to using these generators, you need a model already in place,
which you can create using the standard Rails (model) generator.

#### Scaffold Generator

These generators replace Rails' controller and view generators,
with which they have a lot in common.
That is, they provide basic REST functionality,
(i.e. a data-base administration interface),
that should run without error straight off.
And the code produced is ready for you to customise.

The quickest way to start is by using the *templet:scaffold* generator,
which creates the following:

1. A controller that is similar to a regular REST controller, which:
   * Handles the HTTP request formats: HTML, JS &amp; JSON
   * Can be namespaced, i.e. nested within a Ruby module
   * Allows you to restrict the supported REST actions
   * Allows you to declare a parent (and grand-parent)
     for the main model, which can have any name you like

2. A *Viewer* subclass that renders all of the HTML
   for each controller action.
   It's usually generated with little in its body,
   as it's for you to change.

3. Some Rspec tests for the controller and *Viewer* classes.

4. REST routing entries, which are written to *config/routes.rb*.

In succession, the scaffold runs the four generators:

1. templet:controller
3. templet:viewer
2. templet:rspec
4. templet:routes

Each of these generators can be invoked singly,
which is useful, if, say, you don't want Rspec tests installed.

#### Generator Remarks

There are several options available which let you specify the names of
controllers, models, installation directories, etc..
For full information on usage, call any of them with the *--help* option.
For example, `rails g templet:install --help`
The scaffold generator lists all of the options concerned with
producing application code.

Like in Rails, the generators only provide support for REST functionality.
If your requirements diverge from this,
and you're forced to write code from scratch,
then the code these generators produce
probably won't be a great deal of use.
_In such cases, you should still find the framework no more difficult
to code in than traditional view scripts - and maybe it'll be easier._

#### Deinstallation

If you decide to remove the framework, and it artefacts,
you can run the generator *templet:destroy*.
This deletes __all__ associated files, apart from the controllers.
You do this with:

```
$ rails generator templet:destroy --all
```

### Framework Installation

Although it is more convenient to access
the framework from within the engine, (*templet_rails*), 
the generator, *templet:core_install*,
will copy the complete source code of the framework into
your local file system.

This should only be done if you require
to alter the framework's source code.

To install the framework from the command line, you key in:

````
$ rails generator templet:core_install
````

#### Testing the Framework Internally

If you wish to add some tests for the framework itself,
then you can run the generator *templet:core_rspec*.
This generator copies files into your *spec/helpers/* directory tree,
(inside the sub-directories: *app/* and *templet/*).

This part is best left out, as it adds clutter,
slowing down your test suite without any real pay back.
However, if you modify the framework for yourself
then these tests may be useful.

<a name="notes"></a> 
## Notes

This part recaps some of what was said before, but in a bit more depth.

### Overall (Onion) Structure

The framework has a strict hierarchy,
in which the higher layers depend on those below.
Starting at the bottom, there are four layers:

1. A bare-boned DSL that renders markup tags. You pass in a number of
   method look-up contexts into this API,
   as well as local variables as and when they're required.

2. Support for components (as Ruby classes) that render
   (encapsulated) view segments.

3. A Rails-like micro-framework that stands in for an existing
   view handling mechanism, e.g. ERb or Haml scripts.
   The framework provides default functionality
   that can be readily changed.

4. A Rails scaffolding substitute, that generates a REST administrative
   interface. This consists of pairs of Controller and *Viewer* classes.

This description, admittedly, is too abstract and refined -
so don't linger as more concrete details come next.

### The Framework

#### Prerequisites

At run-time, the framework has two dependent
gems, *templet* and *templet_rails*
_The first is a DSL to generate HTML, the second is a Rails Engine._

For testing, it requires the gems: *rspec*, *nokogiri* and *factory_bot*.
Also, it needs *factory_bot* factories defined for
each of the models that are subjects of the tests.

The testing, however, is optional.
If you write a comprehensive set of tests yourself,
the ones that this framework provides will be too superficial.

### Writing Applications

As is usual in Rails, it's assumed that your application will,
for the most part, be made up of a series of REST interfaces,
which contain models that are mapped to some sort of data-store.

If your requirements don't square with this methodology,
then the framework may only be of limited assistance,
but this much is also true of Rails itself.

#### Application Code Locations

In addition to the core code, (mentioned in the preceding section),
the generator, *templet:install*, also creates another directory tree
for view-specific application code.

The generator installs a skeletal application area,
under the directory, *app/helpers/app/*.
Also, there's a file *app/helpers/app.rb*,
which is for your own global settings,
and which you can delete.

Your own application code is to be put here.
_At present, relocating this directory might cause issues._

The generator also installs (in this area) some place-holder
classes for the HTML layouts and REST link menus.
These are put in the sub-directory, *layouts/*.
The code placed here is really only a suggestion,
so will need editing or, most likely, drastic revision,
However, its basic structure indicates how application
modules may be assembled.

> By the way, **no** files are needed in the view's usual directory tree,
> i.e. *app/views/* - except mailers, of course.
> Nor are (the Rails generated) Helper modules needed.
> However, the base directory (*app/helpers/*) remains in use.

#### Application Modules

As said, to hook into the framework, 
you build individual application modules with a *Controller* and,
nearly always, a *Viewer* class.
As said, both of these classes can be generated.

#### The Controller

The controller is put in its usual location and will look familiar.
It carries out its tasks in the usual way - for example,
you still apply filters and define instance variables for use in the view.
The only substantial difference is in the view dispatching.

For brevity, helper methods are provided that reduce the
view dispatching to a line, or two, of code.

#### Invoking the View from the Controller

To render a view, the controller calls a method
on an instance of a *Viewer* class,
which, by convention, shares the name of the controller's calling method.

To save you from having to construct (and execute)
a *Viewer* class explicitly,
there are several controller helper methods,
(kept in Ruby modules in *app/controllers/templet/*),
that simplify the process of dealing with this *Viewer* class,
which can, sometimes, require a fair few input parameters.

These helper methods cater for the output formats: *html, js &amp; json*.
And should be useful if you write controller code by hand.

The *Viewer* is actually called from the controller's
built-in *render* helper method, as an *inline* template.
Eventually, the call is reduced to line of code resembling:
`render inline: 'ViewerClass.new.index'`.

However, in the current implementation,
this *inline* template does not call the *Viewer* class directly,
but instead uses a bridging class, *ViewerCallString*.

This class compiles a string of executable Ruby that makes the
actual call to the *Viewer*, that initiates the view rendering.
This round about path is taken so to pass in (implicitly)
a number of variables for accessing within the view context.
_This source of this class, *ViewerCallString* is quite well documented._

#### The Viewer Class

This class, which is placed under the directory, *app/helpers/app/*,
(or sub-directory thereof),
performs the functions of the usual view templates, such as ERb scripts.
It renders an entire HTML page for each appropriate controller action.

It inherits from a few superclasses,
(e.g. *Templet::ViewerRest*),
that provide very basic behaviour that you'll,
inevitably, need to extend or replace.
You can do this at any granularity:

1. For small changes, like specifying the fields
   to display on the *index* or *show* pages.

2. For medium-sized changes, like adding pagination, images,
   supplementary text, contextual variation, link sets, etc..

3. For big changes, you may siphon off all of the HTML rendering to a
   separate class, (perhaps inheriting from *Templet::Component::Partial*).
   Or even, pathologically, resort back to ERb scripts,
   (in which case, you'd run the script with the Rails-supplied
   helper method *render*).

Changes for the first two of these can often be made by overriding methods.

> The superclass naming convention, where you append the substring *Viewer*
> onto a singular declension of the controller's (camel-cased) name,
> saves you from having to explicitly state
> the fully qualified class name when you call instances
> of this *Viewer* class from the controller.
> An example might make this easier to swallow: this (derived) class
> should be called something like *App::UserViewer* or,
> if it's to be namespaced, *App::Admin::UserViewer*.

#### The Viewer Subclass

As said, the *Viewer* class inherits from a number of superclasses.
These are: *App::BaseViewer*, (for site-wide settings), which inherits
a non-abstract base class, *Templet::ViewerRest*,
which, in turn, inherits from the abstract class, *Templet::ViewerBase*.

The purpose of these subclasses are to render markup (HTML)
for each of the corresponding controller actions.
To expedite this, these superclasses expose the following functions
that may be made use of when applying your own changes:

1. Shared layout handling, which can be varied per controller,
   (or action), via directives in the *Viewer* class.

2. Ready access to the underlying API.

3. Providing access to a number of named data items for use in the view.
   Most of these are set up in the call from the controller, like
   instance variables, literal names and run-time options.

In very simple cases, you can use an instance
of *Templet::ViewerRest*, or *App::BaseViewer*, directly,
whereupon a REST interface should still be fully operational.
_Your own subclasses let you deviate from the
provided *no-frills* functionality._

#### HTML Layouts

As in Rails, you can specify a layout that is to be used by all
(or a circumscribed group of) controllers.

However, in this framework, by default,
there are two layouts, an outer and inner.

These are specified by class names returned by the *Viewer*
instance methods, *layout_class* and *panel_class*.
The former is for the outer layout, the latter for the inner.

##### The Outer Layout

This is equivalent to the layout that comes with Rails.
It contains everything except for the HTML *body* tag,
that is, it populates in the *head* tag,
pulling in assets, such as the *Bootstrap* CSS and JS libraries.

This (outer) layout is specified in a class
kept inside of the framework's directory tree,
namely, *app/helpers/templet/layouts/html.rb*.
It is rendered inside the *body* HTML tag.

If the HTTP request is for the JS output format (i.e. remote, AJAX)
then this (outer) layout is omitted - as you'd expect!

##### The Inner Layout

As said, you can also specify a further inner layout,
which allows you to display supplementary markup,
like menus and headings.
This inner layout is included in JS (AJAX) requests.

These layout classes are put in the directory, *app/helpers/app/layouts/*.

As noted, you'll want to change this inner layout,
as it generated for you with pre-written sample code,
intended to be illustrative.

This sample code is nested via inheritance chains,
whose participant classes have names that are prefixed with *Layout*.

In this directory, there are also sample classes,
suffixed with *Option*,
that provide custom functionality for the assorted page sections.
They are set up in the class, *OptionsConfig*.
You may possibly adopt this pattern in your own code,
or just get rid of it.

#### REST Link Menus

There are general-purpose classes to render lists of HTML links that
point to actions in REST controllers, e.g. index, show &amp; edit.
These classes are in the directory, *app/helpers/templet/links/*.

They are for use with any type of *ActiveRecord* model,
combined with, if need be, a model's parent and grand-parent.
And even a dependent's name, (i.e. a model's children),
which is used to display a forward HTML link.

There are, primarily, two template classes
that render a list of HTML links for REST actions.
These two are *Templet::Links::BsLinkSetNavigation*
and *Templet::Links::BsLinkSetCollection*.
The former is given a model *instance* (for the actions: edit show etc.).
The latter is given a model's *name* (for the actions: index new etc.).

You can add arbitrary links (at certain spots) to these lists of HTML links
by subclassing one of the two above classes.

These classes inherit from *Templet::Links::BsLinkSetBase*,
which have utility methods to render individual HTML links.

The directory, *app/helpers/app/links/*, is reserved for
your own classes that render HTML link menus.
Your own classes can inherit from one of the three classes above.

The (list of) links can be presented in HTML containers,
such as the various *Bootstrap* Button Groups and Navbars.
There are some factories (in *app/helpers/templet/utils/*)
that do this for you.

This part has, perhaps, the most intricate functionality,
and is best learned by looking at sample code in the example app,
[templet_demo](https://github.com/srycyk/templet_demo).

> Do note that this example app has many other examples of API usage,
> and is complementary to this guide,
> as it has lots of examples that are absent in this guide.

#### HTML Components

The API has utility mixin methods to render standard
HTML lists and tables - to which CSS class names can be passed.

1. The lists (HTML tag *ul*) take as input a Ruby Array of list items.

2. The tables take as input a Ruby Hash, where the key is the heading,
   and the value is, usually, a Ruby Proc, to which individual models
   are passed, taken one-by-one from a given Array of models.

2. Definition (HTML tag *dl*) lists take as input
   a similar kind of Hash as the tables (i.e. item *2*).
   If this Hash has lambdas as values,
   a single model should be passed to this method as well.

There are other API facilities including:

1. Mixin methods to render Bootstrap components,
   e.g. for the grid system and button groups.

2. Mixin methods that return various lambdas
   that are used by the generic components.
   A model instance is often passed into these lambdas.

3. Classes to let you render HTML input forms in a short block of code.
   The outputted HTML will be adorned with Bootstrap's regalia,
   i.e. in a *form-group*, with optional help text, etc..
   The main HTML input types are supported.

4. Classes to render composite view segments, like a search form.

> These facilities are in sub-directories below *app/helpers/templet/*,
> and are *mixins/ (1 &amp; 2)*, *forms/ (2)*, and *utils/ (3)*.

### System Variables

Within the viewer class there are a number of objects made available
that you can reference in your own custom view code.

The principal object is *renderer*, and is used to render markup using
the DSL that is mentioned many times above.
This object is an instance of *Templet::Renderer* (in the gem *templet*),
and can be used in two ways:

  1. To render HTML snippets by means of its *call* method,
     to which a block is passed, as in:
     `renderer.call { span 'Goodbye cruel world' }`.

  2. Directly, as in `renderer.root_path`. to retrieve single values.

For REST controllers, there are the objects *model*, *parent*, and
perhaps *grand\_parent*, as well as a few others.
These are used for generic components,
such as REST link menus and headings.

If you prefer more natural names than *model* or *parent*,
(or if you require extra input for the view),
you can define instance variables in the controller
and then pass their names into the *Viewer* class,
whereupon they will become accessible (by name) in the view code.

### Framework Code

Normally, the framework's source code will be accessed
from within the *templet_rails* engine.

But if you require to modify the framework's code yourself, 
you can copy the source into your application file system.

The core code, which can be installed by the
generator, *templet:core_install*,
is placed in two directories:

1. In *app/helpers/templet/*, which is a tree (of several branches)
   that contains the bulk of the code.
   It contains the run-time framework and libraries.
   _Incidentally, there is a generator option to relocate this directory._

2. In *app/controllers/templet/*, which contains a few controller modules
   of helper methods that simplify the process of invoking the view.

Also, there is another file, *app/helpers/templet_helper.rb*
which can be safely deleted.
It is reserved for global setting for the framework.

If you install the core code locally,
the engine, *templet_rails*, will no longer be required at run-time.

### Configuration

The example application,
[templet_demo](https://github.com/srycyk/templet_demo),
has all of these configuration settings in place,
so may be worth looking at if anything goes wrong in your app.

#### Adding Gems

There are two necessary lines to add to your *Gemfile*:

```
  gem 'templet', git: 'https://github.com/srycyk/templet'

  gem 'templet_rails', git: 'https://github.com/srycyk/templet_rails', group: :development
```

You can, instead, leave the *git* address out,
and fetch the gems directly from the repository, *rubygems.org*.
Fetching from *github*, however, will give you the most recent version.

In addition, there are following gems:

```
  gem 'jquery-rails'
  gem 'bootstrap-sass', '~> 3.3.7'

  group :development, :test do
    gem 'factory_bot_rails', '4.10.0'
  end

  # These are optional
  gem 'sqlite3' # or some other DB gem
  gem 'kaminari' # if you want to use paging
```

#### Rspec Support

If running tests, add these lines to *spec/spec_helper.rb*:

```
require 'factory_bot'

Dir["./spec/support/**/*.rb"].each {|file| require file }
```

The testing suites require that you have *factory\_bot* factories
set up for the models that are to be the subject of the tests.

Also, the installation will add a number of configuration files
in *spec/support/apis/* and *spec/support/templet/*.

## Licence

The gem is available as open source under the terms
of the [MIT License](https://opensource.org/licenses/MIT).

### Contact

If you have any queries or suggestions,
mail me at stephen.rycyk@googlemail.com

### To Do

* Allow more flexibility about where the directory trees are to be situated.
* Make Rspec support more optional. Should it be explicitly requested?
* Decouple ActiveRecord dependencies.
* Add support for rendering serialized fields.
* Make calling the Viewer class from controller less cumbersome.
* Refactor the classes producing REST link menus.
* Add support for mailer templates, so that HTML and plain-text formatted
  mails are both rendered from a single source of text.
* Support for Bootstrap 4.