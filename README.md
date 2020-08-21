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
- ***AJAX*** elements
- Files management with ***ActiveStorage*** and ***AWS***
- Links management with ***Cocoon Gem***
- WebSocket pub/sub with ***ActionCable***
- ***REST API***
    - #GET /api/v1/profiles
    - #GET /api/v1/profiles/me
    -
    - #GET /api/v1/questions
    - #GET /api/v1/questions/:id
    - #POST /api/v1/questions
    - #PATCH /api/v1/questions/:id
    - #DELETE /api/v1/questions/:id
    -
    - #GET /api/v1/questions/:id/answers
    - #GET /api/v1/answers/:id
    - #POST /api/v1/questions/:id/answers
    - #PATCH /api/v1/answers/:id
    - #DELETE /api/v1/answers/:id
- Background jobs with ***ActiveJob***
- Full text search with ***Sphinx***
- ***Deploy***
    - Main tool ***Capistrano***
    - Monitoring with ***Monit***
    - ***Unicorn***
    - Backup with ***Backup Gem***
- Caching elements
- Visual design - ***Bootstrap 4.5***
- ***Rating*** for questions & answers
- ***Mailers***
    - Subscriptions for questions (_new answers notification_)
    - Daily Digest (_all new questions in 24 hours_)

Under the direciton of [Thinknetica](https://thinknetica.com/)

_Creation date:_
>03 / 06 / 2020
