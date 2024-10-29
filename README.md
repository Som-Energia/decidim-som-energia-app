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

```bash
CAS_BASE_URL=https://some-cas-url
```

## Applied hacks & customizations

This Decidim application comes with a bunch of customizations, some of them done via some initializer or monkey patching. Other with external plugins.

### Plugins

- Custom CAS authentication: https://github.com/Som-Energia/codit-devise-cas-authenticable and https://github.com/Som-Energia/decidim-cas-client
- Decidim Awesome: https://github.com/Platoniq/decidim-module-decidim_awesome/
- Term Customizer: https://github.com/mainio/decidim-module-term_customizer

### Customizations

#### Custom embed views for consultation results [PR #64](https://github.com/Som-Energia/decidim-som-energia-app/pull/64)

Add custom routes into consultations to allow embed them in external sites via iframes.

A consultation can be embedded by adding the suffix `summary` in theyr main URL, this also works for individual questions.

Examples:

http://localhost:3000/consultations/ut-inventore/summary

http://localhost:3000/questions/voluptatibus-voluptas/summary

Use locales if needed:

http://localhost:3000/questions/voluptatibus-voluptas/summary?locale=es

Navigation between questions and consultation in embed mode is automatically taken into account.

In development mode there's 2 additional routes to demonstrate this behaviour:

http://localhost:3000/question_summaries/preview

http://localhost:3000/consultation_summaries/preview

#### Different emails sent for users belonging to CAS or administrators [PR #62](https://github.com/Som-Energia/decidim-som-energia-app/pull/62)

#### Custom technical menu only of members of such assembly [PR #66](https://github.com/Som-Energia/decidim-som-energia-app/pull/66)

#### The Awesome Alternative Assemblies Hack [PR #65](https://github.com/Som-Energia/decidim-som-energia-app/pull/65)

Introduces an experimental feature that allows to add an alternative Assemblies menu.
It uses the Assemblies types to divide the assemblies into the original and the different alternative menus.

For instance, imagine you have these assembly types:

- Governance [Assembly Type ID: 12]
- Participation [Assembly Type ID: 17]
- Others [Assembly Type ID: 9]

And these assemblies with these types assigned:

- Assembly 1 (Governance, Assembly Type ID: 12)
- Assembly 2 (Participation, Assembly Type ID: 17)
- Assembly 3 (no Assembly Type assigned)

And, finally, let's imagine we have configured that types "Participation (17)" and "Others (9)" should be in a different main menu than the normal "ASSEMBLIES", called for instance "PARTICIPATIVE ASSEMBLIES".

Now "Assembly 1" and "Assembly 3" will be listed under the normal "ASSEMBLIES" menu, but "Assembly 2" will not.

Then, another menu item will appear next to "ASSEMBLIES" called "PARTICIPATIVE ASSEMBLIES", when clicking on it, the user will see only the assemblies assigned to types 17 and 9, in this case only the "Assembly 2".

Finally, incorrect routes will be automatically redirected to the correct ones.

##### Configuration for duplicating assemblies

It is configured via the `secrets.yml` file in a new section `alternative_assembly_types`:

```yaml
default: &default
  alternative_assembly_types:
    -
      key: local_groups # used to search a I18n key and a route path
      position_in_menu: 2.6
      assembly_type_ids: [17]
```

- **alternative_assembly_types**: must be an array in YAML format, each entry will correspond to a new entry in the main Decidim menu next to the "ASSEMBLIES" item.
- **key**: the identifier for the menu and URL path. For instance, if it is `local_groups` we will have a new menu entry for the url `<host>/local_groups` and the name specified in the I18n key `decidim.assemblies.alternative_assembly_types.local_groups`.
- **position_in_menu**: Where to place the item in the main menu, the usual "ASSEMBLIES" item have the value `2.5`, lower this number will put it before and vice-versa.
- **types**: and array of IDs for the model `Decidim::AssembliesType`. All assemblies assigned to this ID will be listed here and not in the normal "ASSEMBLIES" menu.

#### Alternative Processes Hack

Introduces an experimental feature that allows to add an alternative Processes menu.
It uses the ParticipatoryProcess slug to divide the processes into the original and the different alternative menus.

For instance, imagine you have these processes:

- Process 1 (slug: "normal-slug-1")
- Process 2 (slug: "normal-slug-2")
- Special Process 1 (slug: "special-slug-1")
- Special Process 2 (slug: "special-slug-2")

And let's imagine we have configured that processes with a slug starting with "special" should be in a different main menu than the normal "PROCESSES", called for instance "SPECIAL PROCESSES".

Now, "Process 1" and "Process 2" will be listed under the normal "ASSEMBLIES" menu, and "Special Process 1" and "Special Process 2" will appear in the new menu item called "SPECIAL PROCESSES".

Finally, incorrect routes will be automatically redirected to the correct ones.

##### Configuration for duplicating processes

It is configured via the `secrets.yml` file in a new section `scoped_participatory_process_slug_prefixes`:

```yaml
default: &default
  scoped_participatory_process_slug_prefixes:
    -
      key: general_assemblies # used to search a I18n key and a route path
      position_in_menu: 2.6
      slug_prefixes: ["SomAG"]
```

- **scoped_participatory_process_slug_prefixes**: must be an array in YAML format, each entry will correspond to a new entry in the main Decidim menu next to the "PROCESSES" item.
- **key**: the identifier for the menu and URL path. For instance, if it is `general_assemblies` we will have a new menu entry for the url `<host>/general_assemblies` and the name specified in the I18n key `decidim.participatory_processes.scoped_participatory_process_slug_prefixes.general_assemblies`.
- **position_in_menu**: Where to place the item in the main menu, the usual "PROCESSES" item have the value `2.0`, lower this number will put it before and vice-versa.
- **slug_prefixes**: and array of prefixes for the slug of the participatory process. All participatory processes that have an slug starting with this word will be listed here and not in the normal "PROCESSES" menu.

#### Extra menu items for participatory processes & assemblies

Extra menu items in a participatory process (or an assembly) can defined in addition to the ones generated by the components.

Works exclusively using ENV vars following this scheme:

1. Add an ENV var like `EXTRA_PROCESS_MENU_***` where `***` is the slug of a participatory process.
2. Set the value of that ENV var to a pair of a model and a slug of a participatory space, separated by a slash `/`, for instance: `Decidim::Assembly/some-assembly` or `Decidim::ParticipatoryProcess/some_process`
3. A new menu item will appear to link the referenced participatory space
4. Also works for assemblies, examples:
  `EXTRA_ASSEMBLY_MENU_MY_ASSEMBLY=Decidim::ParticipatoryProcess/my_process`
  `EXTRA_PROCESS_MENU_MY_PROCESS=Decidim::Assembly/my_assembly`
  `EXTRA_PROCESS_MENU_MY_PROCESS=Decidim::ParticipatoryProcess/my_process`
