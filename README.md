<img src="app/assets/images/qna-logo.png" width="200"/>

###### :page_with_curl: QnA project
---
### Educational project from a programming school
###### by Alexandr Babitsky

__A simple stackoverflow clone.__

### Main technologies:
1. Ruby version - ***2.7.1***
2. Rails version - ***6.0.3***
3. Database - ***PostgreSQL***

### Features:
* Authentication with ***Devise***
* Authorization with ***CanCanCan***
* Social login with ***OAuth*** (GitHub & Facebook)
* ***CRUD***
    * Questions
    * Answers
    * Comments
* All covered tests with ***RSpec***
* ***AJAX*** elements
* Working with files using ***ActiveStorage and AWS***
* Working with links with ***Cocoon Gem***
* Implemented websocket using ***ActionCable***
* ***REST API*** users/questions/answers/comments with tests
* Background jobs with ***ActiveJob and Sidekiq***
* Full text search with ***Sphinx***
* ***Deploy***
    * Deployed using ***Capistrano & Unicorn***
    * Monitoring with ***Monit***
    * Backup with ***Backup Gem***
* Caching
* Mailers
    * Subscription to question updates
    * Daily digest notifications
* Questions and answers rating system
* Best answer reward and common rewards list
Under the direciton of [Thinknetica](https://thinknetica.com/)
