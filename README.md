# Golang FP

<p align="center">
  <a href="https://gin-gonic.com" target="_blank">
    <img src="https://raw.githubusercontent.com/gin-gonic/logo/master/gin-logo.png" width="400" alt="Gin Logo">
  </a>
</p>

<p align="center">
  <a href="https://github.com/gin-gonic/gin/actions">
    <img src="https://github.com/gin-gonic/gin/workflows/tests/badge.svg" alt="Build Status">
  </a>
  <a href="https://pkg.go.dev/github.com/gin-gonic/gin">
    <img src="https://pkg.go.dev/badge/github.com/gin-gonic/gin.svg" alt="GoDoc">
  </a>
  <a href="https://goreportcard.com/report/github.com/gin-gonic/gin">
    <img src="https://goreportcard.com/badge/github.com/gin-gonic/gin" alt="Go Report Card">
  </a>
</p>

---

# Author Tracker Website

The **Author Tracker Website** is a web application built using the Gin framework in Go. It allows users to manage authors and books efficiently, featuring CRUD operations and a user-friendly interface for organizing and viewing book collections. This project also demonstrates clear separation of concerns using controllers, models, and views.

---

## Goals

1. Create a four-page website with structured navigation:
   - **Main Page**: "Get Started" button leading to the author page.
   - **Author Page**: Includes `index.html`, `edit.html`, and `create.html` for managing authors.
   - **Book Page**: Displays and manages books with `create.html`, `detail.html`, `edit.html`, and `view.html`.
   - **Collection Page**: Lists book titles, authors, descriptions, and release dates.
2. Implement a One-to-Many relationship between authors and books.
3. Design simple controllers and models to support the application’s functionality.

---

## Key Features

### Main Page
- Welcome page with a "Get Started" button linking to the author management page.

### Author Management
- Add, update, delete, and view authors.
- Includes:
  - `index.html` for listing authors.
  - `create.html` for adding authors.
  - `edit.html` for updating author details.

### Book Management
- Add, update, delete, and view books.
- Includes:
  - `create.html` for adding books.
  - `detail.html` for viewing book details.
  - `edit.html` for updating book information.
  - `view.html` for listing books.

### Collection Page
- Displays all book titles, author names, descriptions, and release dates.

---

## Development Structure

### 1. Setup Project
- Initialize a new Go project.
- Add Gin framework and necessary packages.
- Configure the project folder structure:

```
author-tracker/
├── controllers/
│   ├── homecontroller.go
│   ├── authorcontroller.go
│   ├── bookcontroller.go
│   └── collectioncontroller.go
├── models/
│   ├── authormodel.go
│   └── bookmodel.go
├── entities/
│   ├── author.go
│   └── book.go
├── views/
│   ├── main.html
│   ├── authors/
│   │   ├── index.html
│   │   ├── create.html
│   │   └── edit.html
│   ├── books/
│   │   ├── create.html
│   │   ├── detail.html
│   │   ├── edit.html
│   │   └── view.html
│   └── collection.html
├── main.go
└── go.mod
```

### 2. Database Design

#### Authors Table
```sql
DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
  id INT AUTO_INCREMENT NOT NULL,
  name VARCHAR(128) NOT NULL,
  birthdate DATE NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);
```

#### Books Table
```sql
DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id INT AUTO_INCREMENT NOT NULL,
  title VARCHAR(128) NOT NULL,
  author_id INT NOT NULL,
  description TEXT,
  release_date DATE,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);
```

### 3. Controllers

#### HomeController
Handles navigation from the main page to other pages.

```go
package controllers

import (
  "html/template"
	"net/http"

	"github.com/gin-gonic/gin"
)

func Welcome(c *gin.Context) {
	temp, err := template.ParseFiles("views/index.html")
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
	}
	temp.Execute(c.Writer, nil)
}
```

#### AuthorController
Manages author-related operations (CRUD).

```go
package controllers

import (
	"Authors/entities"
	"Authors/models/authormodel"
	"net/http"
	"strconv"
	"text/template"
	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	// Index displays a list of authors
	c.HTML(http.StatusOK, "authors/index.html", nil)
}

func Create(c *gin.Context) {
	if c.Request.Method == http.MethodPost {
		// Add handles adding new authors
	} else {
		c.HTML(http.StatusOK, "authors/create.html", nil)
	}
}

func Edit(c *gin.Context) {
	if c.Request.Method == http.MethodPost {
		// Logic to update author
	} else {
		c.HTML(http.StatusOK, "authors/edit.html", nil)
	}
}

// Delete handles deleting an author
func Delete(c *gin.Context) {
	idString := c.Query("id")
	id, err := strconv.Atoi(idString)
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	if err := authormodel.Delete(id); err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	c.Redirect(http.StatusSeeOther, "/authors")
}
```

#### BookController
Handles book-related operations (CRUD).

```go
package controllers

import (
	"Authors/entities"
	"Authors/models/authormodel"
	"Authors/models/bookmodel"
	"html/template"
	"net/http"
	"strconv"
	"time"
	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	c.HTML(http.StatusOK, "books/view.html", nil)
}

func Create(c *gin.Context) {
	if c.Request.Method == http.MethodPost {
		// Logic to add book
	} else {
		c.HTML(http.StatusOK, "books/create.html", nil)
	}
}

func Detail(c *gin.Context) {
	c.HTML(http.StatusOK, "books/detail.html", nil)
}

func Edit(c *gin.Context) {
	if c.Request.Method == http.MethodPost {
		// Logic to update book
	} else {
		c.HTML(http.StatusOK, "books/edit.html", nil)
	}
}

func Delete(c *gin.Context) {
	id, err := strconv.Atoi(c.Query("id"))
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	if err := bookmodel.Delete(id); err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	c.Redirect(http.StatusSeeOther, "/books")
}
```

#### CollectionController
Displays the collection of books and authors.

```go
package controllers

import (
  "html/template"
	"net/http"
	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	// Logic to list book collections
	c.HTML(http.StatusOK, "collection.html", nil)
}
```

---

## Relationships

#### Author Model
```go
package models

type Author struct {
	Id   int
	Name string
	DoB  string
	Updated_At time.Time
}
```

#### Book Model
```go
package models

type Book struct {
	Id       uint
	Title    string
	Author   Author
	Genre    string
	Description string
	Updated_At time.Time
	Added_At time.Time
}
```

---

## Routes

```go
router := gin.Default()

// Home Page
router.GET("/", homecontroller.Welcome)

// Author Routes
authorRoutes := router.Group("/authors")
{
	authorRoutes.GET("", authorcontroller.Index)
	authorRoutes.GET("/create", authorcontroller.Create)
	authorRoutes.POST("/create", authorcontroller.Create)
	authorRoutes.GET("/edit", authorcontroller.Edit)
	authorRoutes.POST("/edit", authorcontroller.Edit)
}

// Book Routes
bookRoutes := router.Group("/books")
{
	bookRoutes.GET("", bookcontroller.Index)
	bookRoutes.GET("/create", bookcontroller.Create)
	bookRoutes.POST("/create", bookcontroller.Create)
	bookRoutes.GET("/detail", bookcontroller.Detail)
	bookRoutes.GET("/edit", bookcontroller.Edit)
	bookRoutes.POST("/edit", bookcontroller.Edit)
}

// Collection Page
router.GET("/collection", collectioncontroller.Index)

router.Run(":8080")
```

