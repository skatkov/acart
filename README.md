## Features
aCart is not a regular amazon shortener. It can produce **very short links**, **include your associate tag** with them. But what separates aCart from rest is:
- Creating a bundle of products with a single link
- Link will redirect to a checkout page with all products in a cart
- Once at a checkout, user can remove item completely ot change quantity

Example:
- https://www.acart.to/X 


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
