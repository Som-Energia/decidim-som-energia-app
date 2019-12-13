# Overrides

This document lists all the overrides that have been done at the Decidim platform. Those overrides can conflict with platform updates. During a platform upgrade they need to be compared to the ones of the Decidim project.

The best way to spot these problems is revewing the changes in the files that are overriden using git history and apply the changes manually.

## Controllers

**Decidim::Initiatives::InitiativesController**

The `#default_filter_params` method is being modified so that the default value of the filter `:state` is `"closed"` instead of `"open"`. This change is required to have effect until a date given by the Product Owner, which is the date that marks the start of the signature period for a set of initiatives in the platform.

After the given date, we will have to think what to do with this decorator. Remove it or modify it to make the feature configurable.

Files:
- `app/decorators/decidim/initiatives/initiatives_controller_decorator.rb`
