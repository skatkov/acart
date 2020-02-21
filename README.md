## Features
- Amazon product shortener has an unique ability to bundle multiple amazon products into one short link.
- After user follows this link, he will be redirected to checkout page with all products added to cart and your associate tag injected.
- Once at a checkout, user can remove some item completely ot change quantity
- Shortener picks most shortest urls available, e.g. https://www.acart.to/p


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
