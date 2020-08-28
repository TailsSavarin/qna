![Travis-ci](https://travis-ci.com/TailsSavarin/qna.svg?branch=master)
![CI](https://github.com/TailsSavarin/qna/workflows/CI/badge.svg?branch=master)

<img src="app/assets/images/qna-logo.png" width="200"/>

###### :page_with_curl: QnA project
---
### Educational project from a programming school
###### by Alexandr Babitsky

__A simple stackoverflow clone.__

##### Main technologies:
1. Ruby version - ***2.7.1***
2. Rails version - ***6.0.3***
3. Database - ***PostgreSQL***

##### Features:
- Authentication with ***Devise***
- Social login with ***OAuth***
    - GitHub
    - Facebook
- Authorization with ***CanCanCan***
- Covered with tests by ***RSpec***
    - Acceptance tests
    - Unit tests
- ***CRUD***
    - Questions
    - Answers
    - Comments
- ***AJAX*** elements
- Files management with ***ActiveStorage*** and ***AWS***
- Links management with ***Cocoon Gem***
- WebSocket pub/sub with ***ActionCable***
- ***REST API***
    - #GET _/api/v1/profiles_
    - #GET _/api/v1/profiles/me_

    - #GET _/api/v1/questions_
    - #GET _/api/v1/questions/:id_
    - #POST _/api/v1/questions_
    - #PATCH _/api/v1/questions/:id_
    - #DELETE _/api/v1/questions/:id_

    - #GET _/api/v1/questions/:id/answers_
    - #GET _/api/v1/answers/:id_
    - #POST _/api/v1/questions/:id/answers_
    - #PATCH _/api/v1/answers/:id_
    - #DELETE _/api/v1/answers/:id_
- Background jobs with ***ActiveJob***
- Full text search with ***Sphinx***
- ***Deploy***
    - Web Server ***Nginx***
    - App Server ***Unicorn***
    - Main tool ***Capistrano***
    - Monitoring with ***Monit***
    - Backup with ***Backup Gem***
- Caching elements
- Visual design - ***Bootstrap 4.5***
- ***Rating system*** for questions & answers
- Author of question can choose the ***best answer***
- For the best answer, user can get ***reward***
- ***Mailers***
    - Subscriptions for questions (_new answers notification_)
    - Daily Digest (_all new questions in 24 hours_)

Under the direciton of [Thinknetica](https://thinknetica.com/)

_Creation date:_
>03 / 06 / 2020
