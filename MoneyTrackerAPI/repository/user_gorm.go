package repository

import (
	"moneytracker/logs"

	_ "github.com/go-sql-driver/mysql"
	"gorm.io/gorm"
)

type userRepositoryGORM struct {
	db *gorm.DB
}

func NewUserRepositoryGORM(db *gorm.DB) userRepositoryGORM {
	return userRepositoryGORM{db: db}
}

func (r userRepositoryGORM) GetByUsername(username string) (*User, error) {
	user := User{}
	tx := r.db.Where(&User{Username: username}).Find(&user)

	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &user, nil
}

func (r userRepositoryGORM) Create(user User) (*User, error) {
	tx := r.db.Create(user)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &user, nil
}

func (r userRepositoryGORM) Update(username string, balance float32) (*User, error) {
	user := User{Username: username, Balance: balance}

	tx := r.db.Model(&user).Where(&User{Username: username}).Update("balance", balance)

	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return &user, nil
}

func (r userRepositoryGORM) Delete(username string) (*User, error) {
	user, err := r.GetByUsername(username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	tx := r.db.Delete(user)
	if tx.Error != nil {
		logs.Error(tx.Error)
		return nil, tx.Error
	}

	return user, nil
}
