package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
)

var (
	cfgPath     = flag.String("config", "", "path to config file")
	debug       = flag.Bool("debug", false, "print debug output")
	interactive = flag.Bool("interactive", false, "run interactively through dmenu")

	isSway = os.Getenv("XDG_SESSION_DESKTOP") == "sway"
)

func main() {
	flag.Parse()
	cfg, err := getConfig(*cfgPath)
	if err != nil {
		log.Fatalf("reading config: %s", err)
	}

	var layout string
	if *interactive {
		layout, err = dmenu(cfg)
		if err != nil {
			log.Fatalf("getting layout: %s", err)
		}
	} else if flag.NArg() > 0 {
		layout = flag.Arg(0)
	} else {
		log.Fatalf("need a layout name")
	}

	if err := maybeSetOutputs(cfg); err != nil {
		log.Fatalf("setting outputs: %s", err)
	}
	if err := setLayout(cfg, layout); err != nil {
		log.Fatalf("setting layout: %s", err)
	}
}

type Config struct {
	Outputs map[string]Output `json:"outputs"`
	Layouts map[string]Layout `json:"layouts"`
}

type Output struct {
	Output      string `json:"output"`
	Position    XY     `json:"position"`
	Resolution  XY     `json:"resolution"`
	RefreshRate int    `json:"refreshRate"`
	Letter      string `json:"letter"`
	Primary     bool   `json:"primary,omitempty"`
}

type Layout map[string][]string

type XY struct {
	X int `json:"x"`
	Y int `json:"y"`
}

func (xy XY) String() string {
	return fmt.Sprintf("%dx%d", xy.X, xy.Y)
}

func getConfig(path string) (*Config, error) {
	if path == "" {
		cfg, err := os.UserConfigDir()
		if err != nil {
			return nil, err
		}
		path = filepath.Join(cfg, "layout/config")
	}
	bs, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var ret Config
	if err := json.Unmarshal(bs, &ret); err != nil {
		return nil, err
	}
	return &ret, nil
}

func dmenu(cfg *Config) (string, error) {
	layouts := make([]string, 0, len(cfg.Layouts))
	for layout := range cfg.Layouts {
		layouts = append(layouts, layout)
	}
	sort.Strings(layouts)

	cmd := exec.Command("dmenu", "-i")
	cmd.Stdin = strings.NewReader(strings.Join(layouts, "\n") + "\n")
	bs, err := cmd.Output()
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(bs)), nil
}

func maybeSetOutputs(cfg *Config) error {
	outs, err := outputs()
	if err != nil {
		log.Fatalf("getting outputs: %s", err)
	}
	want := make([]Output, 0, len(cfg.Outputs))
	for _, out := range cfg.Outputs {
		want = append(want, out)
	}
	if outputsMatch(outs, want) {
		return nil
	}
	return configureOutputs(want)
}

func setLayout(cfg *Config, layout string) error {
	outputToNums := cfg.Layouts[layout]
	if outputToNums == nil {
		return fmt.Errorf("no layout named %q", layout)
	}
	spaces, err := workspaces()
	if err != nil {
		return err
	}

	var defaultOutput string
	for outStr, workspaces := range outputToNums {
		out := cfg.Outputs[outStr]
		if out.Output == "" {
			return fmt.Errorf("no output named %q", outStr)
		}
		for _, ws := range workspaces {
			if ws == "*" {
				if defaultOutput != "" {
					return fmt.Errorf("multiple default output assignments")
				}
				defaultOutput = out.Output
				continue
			}
			current := spaces[ws]
			delete(spaces, ws)
			if current == out.Output {
				continue
			}
			if err := moveWorkspace(ws, out.Output); err != nil {
				return err
			}
		}
	}
	if defaultOutput != "" {
		for ws, out := range spaces {
			if out == defaultOutput {
				continue
			}
			if err := moveWorkspace(ws, defaultOutput); err != nil {
				return err
			}
		}
	}

	for _, workspaces := range outputToNums {
		if len(workspaces) > 0 && workspaces[0] == "*" {
			if err := selectWorkspace(workspaces[0]); err != nil {
				return err
			}
		}
	}
	for _, out := range cfg.Outputs {
		if out.Primary {
			if err := focusDisplay(out.Output); err != nil {
				return err
			}
			break
		}
	}
	return nil
}

func run(cmd string, args ...string) error {
	if *debug {
		fmt.Printf("run: %s %s\n", cmd, strings.Join(args, " "))
		return nil
	}
	out, err := exec.Command(cmd, args...).CombinedOutput()
	if err != nil {
		return fmt.Errorf("executing \"%s %s\": %w\nOutput: %s", cmd, strings.Join(args, " "), err, string(out))
	}
	return nil
}

func outputsMatch(a, b []Output) bool {
	if len(a) != len(b) {
		return false
	}
	sort.Slice(a, func(i, j int) bool { return a[i].Output < a[j].Output })
	sort.Slice(b, func(i, j int) bool { return b[i].Output < b[j].Output })
	for i, oa := range a {
		ob := b[i]
		if isSway {
			oa.Primary = false
			ob.Primary = false
		}
		if oa != ob {
			return false
		}
	}
	return true
}
