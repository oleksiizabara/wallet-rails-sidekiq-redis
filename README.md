# README

heroku(simple frontend part): https://enigmatic-castle-24143.herokuapp.com/
doc(simple user documentation): https://enigmatic-castle-24143.herokuapp.com/documentation

All logic is concentrated in /services/ and /query/
Controllers are auto-generated and slightly adapted for easy front-end use.

/services/ - data processing and modification
/query/ - search for data in the database

wallets
- wallet (https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/blob/master/app/models/wallet.rb)
 |_
    - personal (https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/blob/master/app/models/personal.rb)
    - team (https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/blob/master/app/models/team.rb)
    - family (https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/blob/master/app/models/family.rb)


The transaction is processed using the state machine pattern:
https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/tree/master/app/services/transaction_state_machine

Before proceeding to the next stage, validation takes place in accordance with the type of wallet

The current balance is calculated and saved in the database as the difference of all completed transactions:
https://github.com/oleksiizabara/wallet-rails-sidekiq-redis/blob/3e4750d37290f652c5c9a07fed89e1a91f46b989/app/models/wallet.rb#L69

deploy:

* rails db:create
* rails db:migrate
* rails db:seed

* redis-server
* rails s
* sidekiq

http://localhost:3000