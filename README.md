# README

This is a little showcase to show how a search with arbitrary product groups and categories is possible.


```
┌──────────────────┐            ┌──────────────────┐          ┌──────────────────┐
│                  │            │                  │          │                  │
│   Category       ├──────────► │  CriteriaGroup   ├───────►  │  Criteria        │
│                  │ has_many ve│                  │ has_many │                  │
└──────────────────┘            └──────────────────┘          └───┬────────────┬─┘
                                                                  │ can have   │
                                                                  ▼            ▼
                                                              ┌─────────┐  ┌────────┐
                                                              │numeric  │  │fixed   │
                                                              │values   │  │text    │
                                                              │         │  │values  │
                                                              │         │  │        │
                                                              └─────────┘  └────────┘
                                                                    ▲          ▲
                                                                    │          │
                                ┌──────────────────┐                │          │
                                │                  │                │          │
                                │  Company         ├────────────────┴──────────┘
                                │                  │   defines matching values
                                └──────────────────┘
```

Features:
- Search with categories from the database
- 
- I18n

##### Tech

The demo uses following tools

- Ruby [3.1.0](https://github.com/mark-a/b2b_market_draft/blob/main/Gemfile#L4)
- Rails [7.0.2](https://github.com/mark-a/b2b_market_draft/blob/main/Gemfile#L7)
- sqlite 3 (>= 3.27) [can easily changed to postgres, mysql or similar]

Most of it can be installed via the following command after installing ruby:

```bash
bundle 
```


##### Create and setup the database

Run the following commands to create and setup the database.

```bash
bundle exec rake db:create
bundle exec rake db:setup
```

##### Start the server

You can start the rails server using the command given below.

```bash
bundle exec rails s
```

The default url is http://localhost:3000 in development mode(default)
