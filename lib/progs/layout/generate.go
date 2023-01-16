package main

import "fmt"

func generateConfig(cfg *Config, sway bool) error {
	isSway = sway
	for _, out := range cfg.Outputs {
		if out.Letter != "" {
			fmt.Printf("bindsym Mod4+%s focus output %s\n", out.Letter, outputName(out.Output))
			fmt.Printf("bindsym Mod4+shift+%s move workspace to output %s\n", out.Letter, outputName(out.Output))
		}
		if sway {
			fmt.Printf(`output %q {
  pos %d %d
  res %dx%d
}
`, outputName(out.Output), out.Position.X, out.Position.Y, out.Resolution.X, out.Resolution.Y)
		}
	}
	return nil
}
