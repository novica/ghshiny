# GHShiny

This app is a wrapper around the `ghapi` package and follows the same functionality.

It is build with {golem} and has:

* Token authentication module
* Module for listing all repositories  which the authenticated user has access to. 
* Module for updating description of a repository.
* Module for listing usernames of collaborators.
* Module for adding collaborators to a repository.

# Docker
Build with: `docker build -t shiny-test --build-arg token=your-token-here . `

Run with: `docker run --rm -t -i -p 8080:8080 shiny-test`
