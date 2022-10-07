package service

type User struct {
	Username string  `json:"Username"`
	Balance  float32 `json:"Balance"`
}

type UserService interface {
	GetByUsername(username string) (*User, error)
	Create(User) (*User, error)
	Update(User) (*User, error)
	Delete(username string) (*User, error)
}
