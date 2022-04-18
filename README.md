## WARNING
This project is abandoned!!! But you are free to browse around -- I still think it was a useful excersise in building url shorteners.

Please use at your own risk, Amazon is pretty sketchy about this thing being legal or not. (and everyone is scared of Amazon closing their accounts for any minor issue... so you probably should not use it)

## Features
aCart.to is not a regular amazon shortener. It can produce **very short links** and **include associate tag**. But what separates aCart.to apart from the rest are other features:
- Bundles multiple products with a single link
- After pressing a link, user will be redirected to checkout page with products prefilled
- Once at checkout, user can remove all or some items before making a purchase


## Database Setup

We're using PostgreSQL database. You can create required database account with this:

```bash
  createuser -U postgres acart
  createdb -U postgres -O acart acart_production
  createdb -U postgres -O acart acart_test
  createdb -U postgres -O acart acart_development
```

## Alogirthm

https://stackoverflow.com/questions/742013/how-do-i-create-a-url-shortener
