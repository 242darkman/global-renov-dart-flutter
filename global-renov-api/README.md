# GlobalRenov' API Documentation

## Overview

This API is designed for the fictitious company GlobalRenov', which offers energy renovation services to homeowners. The API facilitates the management of service interventions, allowing users to authenticate, create, update, and track the status of interventions.

# Running the sample

## Running API

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

If you have Docker Desktop installed, you
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

## Intervention Routes

  > Note: To access the intervention routes, you must include a valid Bearer token in the Authorization header of your requests.

### POST `/interventions/create`
- **Description**: Create a new intervention record.
- **Body**:
  ```json
  {
    "status": "scheduled",
    "date": "2024-04-16",
    "customer": "Pedri Potter",
    "address": {
      "street": "54 rue Simone Veil",
      "city": "Venissieux",
      "postalCode": "69200"
    },
    "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
  }
  ```
- **Response**: Returns the created intervention.
  ```json
    {
      "interventions": [
        {
          "id": "-Nvb03pFmRY4WgvTZs9W",
          "status": "scheduled",
          "date": "2024-04-16",
          "customer": "Pedri Potter",
          "address": {
            "street": "54 rue Simone Veil",
            "city": "Venissieux",
            "postalCode": "69200"
          },
          "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
        }
      ],
      "metadata": {}
    }
  ```

### PUT `/interventions/update/<id>`
- **Description**: Update an existing intervention.
- **Parameter**: `id` - The ID of the intervention to update.
- **Body**:
  ```json
  {
    "description": "Updated description of the intervention."
  }
  ```
- **Response**: Returns the updated intervention details.
```json
    {
      "interventions": [
        {
          "id": "-Nvb03pFmRY4WgvTZs9W",
          "status": "scheduled",
          "date": "2024-04-16",
          "customer": "Pedri Potter",
          "address": {
            "street": "54 rue Simone Veil",
            "city": "Venissieux",
            "postalCode": "69200"
          },
          "description": "Updated description of the intervention."
        }
      ],
      "metadata": {}
    }
  ```

### PATCH `/interventions/change-status/<id>`
- **Description**: Change the status of an existing intervention.
- **Parameter**: `id` - The ID of the intervention whose status is to be updated.
- Authorized statuses: `['scheduled', 'closed', 'canceled']`
- **Body**:
  ```json
  {
    "status": "closed"
  }
  ```
- **Response**: Returns the updated intervention details.
```json
    {
      "interventions": [
        {
          "id": "-Nvb03pFmRY4WgvTZs9W",
          "status": "closed",
          "date": "2024-04-16",
          "customer": "Pedri Potter",
          "address": {
            "street": "54 rue Simone Veil",
            "city": "Venissieux",
            "postalCode": "69200"
          },
          "description": "Updated description of the intervention."
        }
      ],
      "metadata": {}
    }
  ```

  ### DELETE `/interventions/delete/<id>`
- **Description**: Delete an intervention by ID.
- **Parameter**: `id` - The ID of the intervention to delete.
- **Response**: Confirmation of deletion.
```json
    {
      "message": "Intervention -Nvb03pFmRY4WgvTZs9W deleted successfully"
    }
  ```

### GET `/interventions/<id>`
- **Description**: Retrieve details of a specific intervention by ID.
- **Parameter**: `id` - The ID of the intervention.
- **Response**: Returns the details of the specific intervention.
```json
    {
	"interventions": [
		{
			"id": "-Nvb03pFmRY4WgvTZs9W",
			"status": "scheduled",
			"date": "2024-04-16",
			"customer": "Pedri Potter",
			"address": {
				"street": "54 rue Simone Veil",
				"city": "Venissieux",
				"postalCode": "69200"
			},
			"description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
		}
	],
	"metadata": {}
}
  ```

### GET `/interventions/`
- **Description**: Retrieve all interventions.
- **Response**: Returns a list of all interventions.
```json
    {
      "interventions": [
        {
          "id": "-NvX9Hu6IxDI4MWX0bhC",
          "status": "scheduled",
          "date": "2024-04-30",
          "customer": "John Smith",
          "address": {
            "street": "12 rue des lilas",
            "city": "Lyon",
            "postalCode": "69001"
          },
          "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
        },
        {
          "id": "-NvX9M6Tb4qYYk0580cy",
          "status": "canceled",
          "date": "2024-04-09",
          "customer": "John Smith",
          "address": {
            "street": "12 rue des lilas",
            "city": "Lyon",
            "postalCode": "69001"
          },
          "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
        },
        {
          "id": "-NvX9_yKmYoqpdr69gqT",
          "status": "closed",
          "date": "2024-04-13",
          "customer": "John Smith",
          "address": {
            "street": "12 rue des lilas",
            "city": "Lyon",
            "postalCode": "69001"
          },
          "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
        },
        {
          "id": "-Nvb03pFmRY4WgvTZs9W",
          "status": "scheduled",
          "date": "2024-04-16",
          "customer": "Pedri Potter",
          "address": {
            "street": "54 rue Simone Veil",
            "city": "Venissieux",
            "postalCode": "69200"
          },
          "description": "Lorem ipsum dolor sit amet consectetur. Justo urna et pulvinar aliquet odio aliquet quam. Facilisis molestie tellus amet vulputate. Velit est semper convallis etiam nibh dui a."
        }
      ],
      "metadata": {
        "total": 4
      }
    }
  ```