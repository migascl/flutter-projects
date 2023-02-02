# Application

## How to Setup

- Run ```flutter get``` to get the dependencies;
- Copy ```.env.example``` and rename it to ```.env``` and point the ```API_URL``` to the API's address;
- Make sure the API is online before running the application.

## Project Structure

### Assets

This folder contains all the static assets used by the app, such as images.

### Lib

This folder contains all the code of the application, organized by function (model, provider, views, etc...)

- **Models**: Classes used to represent the data structure of entities
- **Provider**: Providers manage the current state and data of a certain model. They are provide a communication layer between the API and the user.
- **Views**: All UI/UX components.
    - **Screens**: Single use pages or popups organized by entity.
    - **Widgets**: Miscellaneous multiple use components.
- **Utils**: Folder containing various utilities and services (such as API logic).