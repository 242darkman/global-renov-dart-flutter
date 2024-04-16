# GlobalRenov' API Documentation

## Overview

This API is designed for the fictitious company GlobalRenov', which offers energy renovation services to homeowners. The API facilitates the management of service interventions, allowing users to authenticate, create, update, and track the status of interventions.

# Running the sample

## Running app

```
$ dart run bin/server.dart
Server listening on port 8080
```

API is available on :
```
http://0.0.0.0:8080
or
http://localhost:8080
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

## API Endpoints

### Authentication Routes

#### POST `/auth/sign-up`
- **Description**: Register a new user.
- **Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword",
    "firstName": "John",
    "lastName": "Smith"
  }
  ```
- **Response**:
  ```json
    {
      "users": [
        {
          "id": "user_id",
          "email": "user@example.com",
          "emailVerified": false,
          "displayName": "John Smith"
        }
      ],
      "metadata": {
        "creationTime": "2023-01-01T00:00:00.000Z",
        "lastSignInTime": "2023-01-01T00:00:00.000Z"
      }
    }
  ```

- Error:
  - Code: 500 (Internal Server Error)
  - Body: Error creating user



#### POST `/auth/sign-in`
- Description: Authenticate an existing user.
- Body:
  ```json
  {
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```

- **Response**:
  ```json
    {
      "users": [
        {
          "id": "user_id",
          "email": "user@example.com",
          "emailVerified": false,
          "displayName": "John Doe"
        }
      ],
      "metadata": {
        "creationTime": "2023-01-01T00:00:00.000Z",
        "lastSignInTime": "2023-01-01T00:00:00.000Z"
      },
      "token": "firebase_id_token"
    }
  ```

- Error:
  - Code: 500 (Internal Server Error)
  - Body: Error signing in user


#### POST `/auth/sign-out`
- Description: Sign out the current user.
- Response :
  ```json
    {
      "message": "Signed out successfully"
    }
  ```