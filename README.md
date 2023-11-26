# README

A hacky modular Rails app. This is more of a thought experiment, and is not really meant to be production level. The code and ux isn't great, but it scratches an itch that I had.

I wanted to try making a more modular Rails app, some hacky configuration changes were made and the asset pipeline was removed. Views, controllers and models are now more closely grouped via their domain as opposed to what they are.

The app is to fill an itch for playing music at adult hockey games, and it allows inputing a song from either Soundcloud or YouTube, and one can specify the start and stop time. Additionally, songs be tagged, so searching for warmup music vs intra-period stoppage music, as well as trying to normalize the volume between songs is supported as well.

Deployed with Dokku on top of DigitalOcean.

### Local
To run the Rails app (may need to update credentials with `credentials:edit`):

`SECRET_KEY_BASE=1234 RAILS_MASTER_KEY=$(cat config/master.key)  docker-compose up -d --force-recreate`

### Production
To deploy to production (will need to create/set a dokku remote/repository based on the docs):

`git push dokku main:main`
