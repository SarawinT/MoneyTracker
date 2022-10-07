package repository

import (
	"errors"
	"moneytracker/logs"

	_ "github.com/go-sql-driver/mysql"
	"github.com/jmoiron/sqlx"
)

type userRepositoryDB struct {
	db *sqlx.DB
}

func NewUserRepositoryDB(db *sqlx.DB) userRepositoryDB {
	return userRepositoryDB{db: db}
}

func (r userRepositoryDB) GetByUsername(username string) (*User, error) {
	user := User{}
	query := "SELECT Username, Balance FROM UserTbl WHERE Username = ?"

	err := r.db.Get(&user, query, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return &user, err
}

func (r userRepositoryDB) Create(user User) (*User, error) {
	query := "INSERT INTO UserTbl (Username, Balance) VALUES (?, ?)"

	_, err := r.db.Exec(query, user.Username, user.Balance)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return &user, err
}

func (r userRepositoryDB) Update(username string, balance float32) (*User, error) {
	query := "UPDATE UserTbl SET Balance = ? WHERE Username = ?"

	_, err := r.db.Exec(query, balance, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	user, err := r.GetByUsername(username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return user, err
}

func (r userRepositoryDB) Delete(username string) (*User, error) {
	user, err := r.GetByUsername(username)
	if err != nil {
		logs.Error(err)
		return nil, errors.New("no username in database")
	}

	query := "DELETE FROM UserTbl WHERE Username = ?"
	_, err = r.db.Exec(query, username)
	if err != nil {
		logs.Error(err)
		return nil, err
	}

	return user, err
}
