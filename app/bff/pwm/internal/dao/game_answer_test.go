package dao

import "testing"

func TestTaskAnswerKind(t *testing.T) {
	tests := map[string]string{
		"Q-2":       "question_2",
		" q-3 ":     "question_3",
		"Q-4":       "question_4",
		"Fill text": "fill_text",
		"Photo":     "photo",
		"VIDEO":     "video",
		"Voice":     "voice",
		"Q Chain":   "unknown",
	}
	for input, expected := range tests {
		if actual := taskAnswerKind(input); actual != expected {
			t.Fatalf("taskAnswerKind(%q) = %q, want %q", input, actual, expected)
		}
	}
}

func TestPlainTaskAnswerText(t *testing.T) {
	input := `<span class='task-answer-text'>Tell me &amp; </span><b>answer</b><br/>next`
	if actual, expected := plainTaskAnswerText(input), "Tell me & answer\nnext"; actual != expected {
		t.Fatalf("plainTaskAnswerText() = %q, want %q", actual, expected)
	}
}
