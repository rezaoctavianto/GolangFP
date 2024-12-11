package collectioncontroller

import (
	"Authors/models/bookmodel"
	"net/http"
	"text/template"

	"github.com/gin-gonic/gin"
)

func Index(c *gin.Context) {
	books := bookmodel.GetAll()
	data := map[string]any{
		"books": books,
	}
	temp, err := template.ParseFiles("views/collection/index.html")
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	temp.Execute(c.Writer, data)
}
