


# Versioned dependencies

## Short term goal

A modest goal would be to provide dependencies for packages on Github. So
let's do just that first.

We can try to add versioned dependencies to this later.

## Short term 'How to'

This can be done with adding two extra fields to `DESCRIPTION`,
`Dependencies` and `BuildDependencies`. We can write the new
package manager that recognizes these fields, and installs the
specified packages from Github, in a non-versioned way.

Dependencies can be specified in the `npm.js` way. E.g.
`hadley/httr#0.5` means a tag on Github. Non-Github repositories
can be specified as `git://github.com/user/project.git#commit-ish`,
or any of the other supported `git` protocols.

## Long term goals

* Compatibility with CRAN, if possible. It is questionable, what gains
  this would have, though. If a package is on CRAN, then it should always
  work with the most recent versions of CRAN packages. So what is the
  point of versioned dependencies then?
* Seemless operation. Detailed below.
* We do preferably everything at installation time, so that we
  can use `library()`, `require()` and `::` and `:::` to use dependencies.
  This might not be possible.

## Long term 'How to'

* We add a new `Dependencies` field to `DESCRIPTION`. This includes the
  versioned dependencies.
* `Dependencies` is ignored by CRAN, so CRAN dependencies should be in the
  usual `Imports` field.
* `NAMESPACE` is used by CRAN, so it should include whatever CRAN neeeds.
* We essentially rename the package to `package@version`.
* It is not quite clear how vague version numbers like `1.0.x` would
  work.
* It is not clear how we can make sure that recursive `loadNamespace`
  calls handle versioned dependencies. One way would be to create the
  whole DAG of packages that have to be loaded, and load then in
  topological ordering, so that no recursive `loadNamespace` call is
  triggered at all.
