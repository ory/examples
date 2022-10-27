package models


type Relation struct {
	Object string `json:"object"`
	Relation string `json:"relation"`
	Subject string `json:"subject"`
}