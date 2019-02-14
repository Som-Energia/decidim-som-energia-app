# HOW TO UPGRADE PARTICIPA.SOMENERGIA.COOP

## Upgrade notes

Update your Gemfile:
```
gem "decidim", "0.XX.X"
gem "decidim-dev", "0.XX.X"
```

Run these commands to upgrade and make sure you get all the latest migrations:
```
# to be executed locally on the developer's machine
bundle update decidim
bin/rails decidim:upgrade
git add db/migrations
git commit db/migrations
git push

# to be executed in the deployment environments
bin/rails db:migrate
```

## Change Logs
Follow the instructions desribed in the Change Log for each decidim version:
- [0.15](https://github.com/decidim/decidim/blob/0.15-stable/CHANGELOG.md)
- [0.16](https://github.com/decidim/decidim/blob/0.16-stable/CHANGELOG.md)
