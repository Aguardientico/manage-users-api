# Manage Users DEMO

App that handle a CRUD for users

A demo client is located at [Client](https://github.com/Aguardientico/manage-users-ui)

#### To setup the app run the following:
```
bundle install
# Yes, I know it is a bad practice but it is just a Demo APP
# And it will allow to share the key to be able to use the
# credentials
echo '0dbe5b66971bb4e622e35a43792c046a' > config/master.key
bin/rails db:setup

# To run tests
bin/rspec

# To be able to run client in the same machine
bin/rails -p 3001
```

#### Default admin user
**email:** admin@example.org
**password:** password

Seed is creating 100 users to be able to test the app

## API Docs
### Auth
#### POST /api/sign_in
Generates a JWT token if credentials are valid

##### Errors
401 - Credentials are invalid

##### Params
```
{
  "email": string-required,
  "password": string-required
}
```

##### Returns
200 - OK
```
{
  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
}
```
##### Response Headers
**Token** Required for subsequent requests

#### POST /api/sign_up
Creates a user and generates a JWT token if user can be created

##### Errors
400 - Can't create the user

##### Params
```
{
  "email": string-required,
  "password": string-required
}
```

##### Returns
200 - OK
```
{
  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
  }
```
##### Response Headers
**Token** Required for subsequent requests

### Users
The following requests should include an `Authorization` header to work.  
The following format is used based on the code generated on sign in/sign up:  
`Bearer here-the-generated-token`

Token has a duration of 24 hours

##### Errors
Following requests share the following error codes:  
401 - Credentials are invalid  
400 - Can't create/update resource  
403 - User is not admin  
404 - Resource was not found  

#### GET /api/users
Returns first 10 users order by `id` by default  
Can filter and paginate the results

##### Params
```
{
  "term": string-optional,
  "page": numeric-optional
}
```

##### Returns
200 - OK
```
[{
  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
}]
```
##### Response Headers
**X-Total-Pages** Helpful to generate pagination in client

#### GET /api/users/:id
Return user based on hashed id

##### Returns
200 - OK
```
{
  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
}
```

#### POST /api/users
Creates a user and returns their attributes

##### Params
```
{
  "email": string-required,
  "password": string-required
  "first_name": string-required,
  "last_name": string-required,
  "job_title": string-optional,
}
```

##### Returns
200 - OK
```
{
  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
}
```

#### PATCH/PUT /api/users/:id
Updates user data

##### Params
```
{
  "first_name": string-required for users without the value,
  "last_name": string-required for users without the value,
  "job_title": string-optional,
}
```

##### Returns
200 - OK
```

  "email": string,
  "first_name": string,
  "last_name": string,
  "job_title": string|null,
  "is_admin": boolean,
  "hashed_id": uuid
}
```

#### DELETE /api/users/:id
Deletes user

##### Returns
200 - OK
```json
{
  "id": uuid
}
```
