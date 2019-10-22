# Microblogger

This application was built as an excercise in developing with Ruby on Rails, following guidance in the book
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](https://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

## [Visit the site](https://microblogger-dfe-application.herokuapp.com/)

## Installation
First clone the repo and then install the needed gems (without production):
```
$ cd /path/to/repos
$ git clone https://github.com/HerrHemd/microblogger.git microblogger
$ cd microblogger
$ bundle install --without production
```

Next, migrate the database:
```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:
```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:
```
$ rails server
```

## Roadmap
- Ability for users to follow one-another (with their posts appearing in your feed)
- Update feeds with AJAX

## License

All source code in this app is under the MIT License. Use of code from the original [Ruby on Rails Tutorial](https://www.railstutorial.org/) will require inclusion of a copyright notice. See [LICENSE.md](LICENSE.md) for details.
