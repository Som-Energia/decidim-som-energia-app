# PARTICIPA.SOMENERGIA.COOP

This is the open-source repository for https://participa.somenergia.coop, based on [Decidim](https://github.com/decidim/decidim).

[![Lint](https://github.com/Som-Energia/decidim-som-energia-app/actions/workflows/lint.yml/badge.svg)](https://github.com/Som-Energia/decidim-som-energia-app/actions/workflows/lint.yml)
[![Test](https://github.com/Som-Energia/decidim-som-energia-app/actions/workflows/test.yml/badge.svg)](https://github.com/Som-Energia/decidim-som-energia-app/actions/workflows/test.yml)

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

- Decidim Awesome: https://github.com/decidim-ice/decidim-module-decidim_awesome/
- Term Customizer: https://github.com/openpoke/decidim-module-term_customizer

