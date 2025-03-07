# PARTICIPA.SOMENERGIA.COOP

This is the open-source repository for https://participa.somenergia.coop, based on [Decidim](https://github.com/decidim/decidim).

![Test](https://github.com/Som-Energia/decidim-som-energia-app/workflows/Test/badge.svg?branch=main)

## Deploying the app

This uses Docker (see the provided Dockerfile)

**Developers note**:

If using the cas-omniauth authenticable, you need to defined the CAS_HOST env.

```bash
CAS_HOST=cas.example.org
```

## Applied hacks & customizations

This Decidim application comes with a bunch of customizations, some of them done via some initializer or monkey patching. Other with external plugins.

### Plugins

- Decidim Awesome: https://github.com/Platoniq/decidim-module-decidim_awesome/
- Term Customizer: https://github.com/mainio/decidim-module-term_customizer

