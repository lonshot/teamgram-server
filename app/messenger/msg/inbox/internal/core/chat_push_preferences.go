package core

type chatPushSettings struct {
	ShowPreviews int32  `db:"show_previews"`
	Silent       int32  `db:"silent"`
	MuteUntil    int32  `db:"mute_until"`
	Sound        string `db:"sound"`
}

// Database -1 values mean inherit. Rows are ordered scope first, peer second;
// selecting only the peer row would discard independently configured scope fields.
func resolveChatPushSettings(rows []chatPushSettings) chatPushSettings {
	result := chatPushSettings{ShowPreviews: 1, Sound: "default"}
	for _, row := range rows {
		if row.ShowPreviews != -1 {
			result.ShowPreviews = row.ShowPreviews
		}
		if row.Silent != -1 {
			result.Silent = row.Silent
		}
		if row.MuteUntil != -1 {
			result.MuteUntil = row.MuteUntil
		}
		if row.Sound != "-1" {
			result.Sound = row.Sound
		}
	}
	return result
}

func chatPushPreview(show bool, title, body string) (string, string) {
	if !show {
		return "Play with Me", "Sent you a message"
	}
	if len([]rune(body)) > 256 {
		body = string([]rune(body)[:256])
	}
	return title, body
}
