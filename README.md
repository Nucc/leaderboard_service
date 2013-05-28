Ranking Service
===

This is a very simple ranking service application. Follow the next description to install it on your server:

Installation
---

1. You'll need Redis server. You can download it here where there's a step-by-step installation process:

        http://redis.io/download

2. Clone the project from github:

        $ git clone git@github.com:Nucc/leaderboard_service.git

3. Install the dependencies:

        $ bundle install

4. Finally just start the service with the next command:

        $ ruby lib/server


Usage
---

The server is running on localhost:4567 by default. You can manage the scoreboard with HTTP requests:

  1. Create new user with score:

        [POST] http://localhost:4567/username/score

        Example: curl http://localhost:4567/username/1234 -d ""

  2. Get TOP10 users:

        [GET] http://localhost:4567/

        Example: curl http://localhost:4567/

  3. Get the rank and the score of the current user. Returns 404 if user is missing:

        [GET] http://localhost:4567/username

        Example: curl http://localhost:4567/username

  4. Update the score of a user:

        [POST] http://localhost:4567/username/new_score

        Example: http://localhost:4567/username/5555


Contribution, Testing
---

If you want to add new feature to it, just fork off and make your change and make a pull request. Don't forget to test it before making the pull request:

    $ rake test
