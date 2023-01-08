package main

import (
	"encoding/json"
	"fmt"
	"math"
	"os/exec"
	"strconv"
	"strings"
)

func ipcCommand() string {
	if isSway {
		return "swaymsg"
	} else {
		return "i3-msg"
	}
}

func outputName(output string) string {
	if isSway {
		return output
	}
	i := strings.LastIndexByte(output, '-')
	if i == -1 {
		return output
	}
	pfx := output[:i+1]
	idx, err := strconv.Atoi(output[i+1:])
	if err != nil {
		return output
	}
	if pfx == "DP-" {
		pfx = "DisplayPort-"
	}
	return pfx + strconv.Itoa(idx-1)
}

func moveWorkspace(number, output string) error {
	return run(ipcCommand(), fmt.Sprintf("[workspace=%s] move workspace to output %s", number, outputName(output)))
}

func selectWorkspace(number string) error {
	return run(ipcCommand(), fmt.Sprintf("workspace %s", number))
}

func focusDisplay(output string) error {
	return run(ipcCommand(), fmt.Sprintf("focus output %s", outputName(output)))
}

func configureOutputs(outs []Output) error {
	if isSway {
		for _, out := range outs {
			if err := run("swaymsg", fmt.Sprintf("output %s res %s@%dHz pos %d %d", outputName(out.Output), out.Resolution, out.RefreshRate, out.Position.X, out.Position.Y)); err != nil {
				return err
			}
		}
		return nil
	} else {
		var args []string
		for _, out := range outs {
			args = append(args, "--output", outputName(out.Output), "--mode", out.Resolution.String(), "--pos", out.Position.String(), "--rate", strconv.Itoa(out.RefreshRate), "--rotate", "normal")
			if out.Primary {
				args = append(args, "--primary")
			}
		}
		return run("xrandr", args...)
	}
}

func outputs() ([]Output, error) {
	if !isSway {
		return []Output{}, nil
	}

	out, err := exec.Command("swaymsg", "-t", "get_outputs", "--raw").CombinedOutput()
	if err != nil {
		return nil, fmt.Errorf("getting outputs: %w", err)
	}
	var outs []struct {
		Name   string `json:"name"`
		Active bool   `json:"active"`
		Mode   struct {
			Width   int `json:"width"`
			Height  int `json:"height"`
			Refresh int `json:"refresh"`
		} `json:"current_mode"`
		Position struct {
			X int `json:"x"`
			Y int `json:"y"`
		} `json:"rect"`
	}
	if err := json.Unmarshal(out, &outs); err != nil {
		return nil, fmt.Errorf("parsing outputs: %w", err)
	}
	var ret []Output
	for _, out := range outs {
		if !out.Active {
			continue
		}
		ret = append(ret, Output{
			Output:      out.Name,
			Resolution:  XY{X: out.Mode.Width, Y: out.Mode.Height},
			Position:    XY{X: out.Position.X, Y: out.Position.Y},
			RefreshRate: int(math.Round(float64(out.Mode.Refresh) / 1000)),
		})
	}

	return ret, nil
}

func workspaces() (map[string]string, error) {
	out, err := exec.Command(ipcCommand(), "-t", "get_workspaces", "--raw").CombinedOutput()
	if err != nil {
		return nil, fmt.Errorf("getting workspaces: %w", err)
	}
	var ws []struct {
		Name   string `json:"name"`
		Output string `json:"output"`
	}
	if err := json.Unmarshal(out, &ws); err != nil {
		return nil, fmt.Errorf("parsing workspaces: %w", err)
	}
	ret := map[string]string{}
	for _, w := range ws {
		ret[w.Name] = w.Output
	}
	return ret, nil
}
