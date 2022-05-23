package auth

type (
	AccessControl interface {
		GrantAccess(string, string) error
		CheckAccess(string, string) error
	}
)
