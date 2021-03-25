# PARTICIPA.SOMENERGIA.COOP


This is the open-source repository for https://participa.somenergia.coop, based on [Decidim](https://github.com/decidim/decidim).

![Test](https://github.com/Som-Energia/decidim-som-energia-app/workflows/Test/badge.svg?branch=staging)

![Participa Homepage](app/assets/images/screenshot.png)

## Deploying the app

Deployed with [Capistrano](http://capistranorb.com/) using [Figaro](https://github.com/laserlemon/figaro) for `ENV` configuration.

Please refer to the private documentation repository for details.

**Developers note**:

Be sure to define an ENV variable with a route to a CAS server (not ending with `/`) to be able to start the app:

IE: in a `.rbenv-vars` file:

```
CAS_BASE_URL=https://some-cas-url
```

## Applied hacks & customizations

This Decidim application comes with a bunch of customizations, some of them done via some initializer or monkey patching. Other with external plugins.

### Plugins

- Custom CAS authentication: https://github.com/Som-Energia/codit-devise-cas-authenticable and https://github.com/Som-Energia/decidim-cas-client
- Decidim Awesome: https://github.com/Platoniq/decidim-module-decidim_awesome/
- Term Customizer: https://github.com/mainio/decidim-module-term_customizer

### Customizations:

- Different emails sent for users belonging to CAS or administrators
- Custom technical menu only of members of such assembly

