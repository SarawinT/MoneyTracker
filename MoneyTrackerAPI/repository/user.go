package repository

type User struct {
	Username string  `db:"Username"`
	Balance  float32 `db:"Balance"`
}

func (u User) TableName() string {
	return "usertbl"
}

type UserRepository interface {
	GetByUsername(username string) (*User, error)
	Create(User) (*User, error)
	Update(username string, balance float32) (*User, error)
	Delete(username string) (*User, error)
}
