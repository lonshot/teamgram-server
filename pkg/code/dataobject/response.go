package dataobject

type VerifyResponse struct {
	Valid          bool   `json:"valid"`
	Auto           bool   `json:"auto"`
	ConfirmationId string `json:"confirmationId"`
}
