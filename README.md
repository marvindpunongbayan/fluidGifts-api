# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 2.7.2
* Rails version 6.1.3.1
* Postgrel 
* GraphQL

1. User Structure
  - Basic details (name, email, password)
  - Role (customer, admin, vendor)
  - With image upload using base64 image hash (Dynamic image variant)
  - Complete validations especially password (8 characters long and must contain: a capital letter, a lowercase letter, a number, and a special character.)
2. Flexible Resolvers Users
  - Will return all the users
  - With authorized user checker
  - With filters (id, name, email, with_image)
  - With dynamic filter operator (OR or AND) for queries
  - With limit and offset (for pagination)
3. Mutations
  - With flexible admin and user auth checker (depends on user’s role)
  - Sessions
    -- Login
    -- Forgot Password (with generate token and expiration date)
    -- Forgot Password Checker for Token Validations
    -- Change Password (with restrictions)
  - User Management
    -- CRUD
4. Test cases (RSpec)
