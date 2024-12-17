# CslaGenFork

![Logo](https://raw.github.com/CslaGenFork/CslaGenFork/master/Support/Logos/Project-Logo-final.gif)

O/RM code generator for CSLA .NET  generating Stored Procedures, Business Layer and Data Access Layer code for Wisej, WinForms, ASP.NET, WPF and Silverlight.

Targets CSLA 

* 8 (limited scenarios)
* 5 (most scenarios)
* 4.3-4.6

There is a complete set of C# templates. Currently there are VB templates, but only for non DAL architecture. You are welcome to contribute with VB templates for DAL DataReader and DAL using DTO.

## 2024

Some CSLA 8 templates added or updated.

## 2022 Jun 06

Some common CSLA 5 templates added. 

## 2017 Mar 01 - Version 4.6.0 released ![](https://raw.github.com/CslaGenFork/CslaGenFork/master/Support/Home/Home_star.png)

This release brings a lot of new features and some usability improvements. It's available at [CslaGenFork release 4.6.0](https://github.com/CslaGenFork/CslaGenFork/releases/tag/v4.6.0)

### Fixes and new features

1. Besides SQL Server, code generation can target other database engines.
2. Numerous fixes to VB code generation
3. New kinds of CslaObject: abstract base classes, custom criteria classes (wip). The *place holder* is a nice feature that can be used to group objects (in light blue)

![](https://raw.github.com/CslaGenFork/CslaGenFork/master/Support/Home/Home_CGF-PlaceHolder.png)

4. Improved property handling with support for custom types (enums etc), database unbound properties and properties persisted to the database as null (read and WRITE)
5. Much improved inheritance support
6. Handle the Saved static event raised by EditableRoot with Weak Event (the generated code was causing memory leaks)
7. Improved database type handling (doesn't crash on geography, etc)
8. The "rules from DLL" feature supports rules with generic type parameters.

#### UI improvements

- Improve Enum's display - for instance, show **Editable Child Collection** instead of **EditableChildCollection** or show **C#** instead of **CSharp**
- Improve UI field hiding (show only UI fields that make sense)
- Improve type filtering (show only objects/properties that make sense).
- Introduce **Don't ask again** MessageBoxEx control and apply it where it fits.

### Breaking changes

The incomplete feature **Generate BypassPropertyChecks** was dropped.
Dropped legacy support: pre CSLA .NET 4.0 projects, active objects and plugin system.

## Other projects

2017 Sep 04 - Rules sample moved to CslaContrib ![](https://raw.github.com/CslaGenFork/CslaGenFork/master/Support/Home/Home_star.png)
- The rules in CslaGenFork library were added to [CslaContrib library](https://github.com/MarimerLLC/cslacontrib);
- They are available on NuGet as **CslaContrib**

## Get started

### [Useful links](https://github.com/CslaGenFork/CslaGenFork/wiki/Useful-links)

Browse forums, product sites, manuals and samples.

### [Is code generation a good idea?](https://github.com/CslaGenFork/CslaGenFork/wiki/Code-generation-is-a-good-idea)

If you were told generated code is bug ridden or rigid or code gen tools are just toys, then have a second opinion.

### [Why would I use CslaGenFork?](https://github.com/CslaGenFork/CslaGenFork/wiki/Why-use-CslaGenFork)

If you had some bad experiences with CslaGen or other code gen tools, then you don't need a feature list but an argument list.

# Miscelaneous

## About the license

CslaGenFork is MIT licensed.

## Acknowledgements

CslaGen couldn't exist without the free CodeSmith DLL. Great care was taken in not breaching the CodeSmith license agreement neither by CslaGenFork nor by anyone using it, Thank you CodeSmith.

![ReSharper logo](https://raw.github.com/CslaGenFork/CslaGenFork/master/Support/Home/Home_ReSharper.png)
