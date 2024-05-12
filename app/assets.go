package app

import (
	"fmt"
	"net/http"
	"os"
	"strings"
)

func NewFileLoader() *FileLoader {
	return &FileLoader{}
}

type FileLoader struct {
	http.Handler
}

func (h *FileLoader) ServeHTTP(res http.ResponseWriter, req *http.Request) {
	var err error
	requestedFilename := strings.TrimPrefix(req.URL.Path, "/")
	fileData, err := os.ReadFile(requestedFilename)
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte(fmt.Sprintf("Could not load file %s", requestedFilename)))
	}

	res.Write(fileData)
}
