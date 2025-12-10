package env2

import (
	"flag"
)

var (
	MyAppName      = "Play with Me"
	MyWebSite      = "wb.playwith-me.com"
	TDotMe         = "t.me"
	PredefinedUser = false
	ServiceUserId  = 777000

	// PredefinedUser2
	// predefined2 - auto register
	PredefinedUser2 = false
)

func init() {
	flag.StringVar(&MyAppName, "app_name", "Play with Me", "app_name")
	flag.StringVar(&MyWebSite, "site_name", "wb.playwith-me.com", "site_name")
	flag.StringVar(&TDotMe, "t.me", "t.me", "t.me")
	flag.BoolVar(&PredefinedUser, "predefined", false, "predefined")
	flag.BoolVar(&PredefinedUser2, "predefined2", false, "predefined2")
}

func IsTDotMe(me string) bool {
	switch me {
	case "wb.playwith-me.com":
		return true
	case "t.me":
		return true
	case TDotMe:
		return true
	}

	return false
}
