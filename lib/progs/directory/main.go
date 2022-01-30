package main

import (
	"flag"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"sort"
	"strconv"
	"strings"
)

func main() {
	servers := flag.String("map", "", "servers to map")
	port := flag.Int("port", 80, "port to serve on")
	flag.Parse()

	var directory directory
	for _, ent := range strings.Split(*servers, ",") {
		fs := strings.Split(ent, ":")
		if len(fs) != 2 {
			log.Fatalf("invalid map field %q", ent)
		}
		port, err := strconv.Atoi(fs[0])
		if err != nil {
			log.Fatalf("invalid map field %q: %v", ent, err)
		}
		directory = append(directory, entry{port, fs[1]})
	}

	sort.Slice(directory, func(i, j int) bool {
		return directory[i].Name < directory[j].Name
	})

	http.Handle("/", directory)
	http.ListenAndServe(fmt.Sprintf("[::]:%d", *port), nil)
}

type entry struct {
	Port int
	Name string
}

type directory []entry

func (d directory) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	page.Execute(w, map[string]interface{}{
		"Hostname": "acrux",
		"Dir":      d,
	})
}

var page = template.Must(template.New("name").Parse(`
<html>
<body style="font-size: 28px; text-align: center;">
{{ $hostname := .Hostname }}
{{ range .Dir }}
<a href="http://{{$hostname}}:{{.Port}}/">{{.Name}}</a><br>
{{ end }}
</body>
</html>
`))
