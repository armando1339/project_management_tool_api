# Project Management Tool API

![Build Status](https://github.com/armando1339/project_management_tool_api/actions/workflows/ci.yml/badge.svg)

## Overview

Project Management Tool API is an **API-only** application built with **Ruby on Rails** that allows managing **projects and tasks**. It includes **authentication and authorization** using **Doorkeeper (OAuth 2.0)** and **Pundit**, and exposes **endpoints to retrieve public repositories from GitHub**.

## Features

- **Project and Task Management** (CRUD)**
- **Authentication with OAuth2 (Doorkeeper)**
- **Role-based Authorization (Pundit)**
- **Endpoints to fetch GitHub repositories**
- **Pagination in JSON responses**
- **Automated testing with RSpec**
- **CI/CD with GitHub Actions**

---

## **Setup & Installation**

### **Prerequisites**

Before starting, make sure you have installed:

- **Ruby 3.4.2**
- **Rails 8.0.2**
- **PostgreSQL**
- **Bundler**

### **Clone the Repository**

```sh
git clone git@github.com:armando1339/project_management_tool_api.git
cd project_management_tool_api
```

### **Install Dependencies**

```sh
bundle install
```

### **Set Up the Database**

```sh
rails db:create && rails db:migrate && rails db:seed
```

### **Start the Server**

```sh
rails s
```

The API will be available at `http://localhost:3000`.

---

## **Running Tests**

To run automated tests, use:

```sh
bundle exec rspec
```

The tests include:

- **Models**
- **Policies (Pundit)**
- **Controllers**
- **Services (`GithubService`)**

**CI/CD:** The tests also run automatically on **GitHub Actions**.

---

## **Key Architectural Decisions**

### **API-Only with Rails**

The project is designed as a **RESTful API**, using Rails in **API-only mode** (`--api`).

### **Authentication with OAuth2 (Doorkeeper)**

**Doorkeeper** was chosen for authentication, which provides:

- **OAuth2 token-based authentication**
- **Higher security**
- **Easier integration with mobile apps and frontend**

### **Authorization with Pundit**

**Pundit** is used to define user permissions in policies.

**User Roles and Permissions:**

- **Admin:** Full access to all endpoints.
- **Project Manager:** Can create, update, and delete projects and tasks.
- **Developer:** Can view and update tasks but cannot create or delete projects.

### **GitHub API Integration**

A `GithubService` was implemented to fetch **popular GitHub repositories**.

### **Automated Testing**

Includes:

- **RSpec** for model, controller, services and policy tests.
- **VCR** for integration tests with the GitHub API.
- **FactoryBot** for generating test data efficiently.

### **CI/CD with GitHub Actions**

A workflow in `.github/workflows/ci.yml` was set up to execute:

- **Brakeman** (security scanning)
- **RuboCop** (code linting)
- **RSpec** (tests)

---

## **User Roles & API Permissions**

### **Admin**

- ✅ Can view, create, update, and delete projects.
- ✅ Can view, create, update, and delete tasks.
- ✅ Can view public repositories from GitHub API.

### **Project Manager**

- ✅ Can view, create and update projects.
- ✅ Can view, create, update, and delete tasks.
- ✅ Can view public repositories from GitHub API.
- 🚫 Cannot delete projects.

### **Developer**

- ✅ Can view projects.
- ✅ Can view, create, and update tasks assigned to them.
- ✅ Can view public repositories from GitHub API.
- 🚫 Cannot create or delete projects.
- 🚫 Cannot delete tasks.

### **Unauthorized Users (Guests)**

- 🚫 Cannot access the API. Authentication is required.
