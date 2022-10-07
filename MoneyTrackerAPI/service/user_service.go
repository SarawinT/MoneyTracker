package service

import (
	"moneytracker/errs"
	"moneytracker/logs"
	"moneytracker/repository"
)

type userService struct {
	userRepo repository.UserRepository
}

func NewUserService(userRepo repository.UserRepository) userService {
	return userService{userRepo: userRepo}
}

func (s userService) GetByUsername(username string) (*User, error) {
	user, err := s.userRepo.GetByUsername(username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	u := User{
		Username: user.Username,
		Balance:  user.Balance,
	}

	return &u, nil

}

func (s userService) Create(userPost User) (*User, error) {

	user := repository.User{
		Username: userPost.Username,
		Balance:  userPost.Balance,
	}

	u, err := s.userRepo.Create(user)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	userResponse := User{
		Username: u.Username,
		Balance:  u.Balance,
	}

	return &userResponse, nil

}

func (s userService) Update(user User) (*User, error) {

	checkID, err := s.userRepo.GetByUsername(user.Username)
	if checkID == nil || err != nil {
		return nil, errs.NewNotFoundError("username not found")
	}

	u, err := s.userRepo.Update(user.Username, user.Balance)

	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	userResponse := User{
		Username: u.Username,
		Balance:  u.Balance,
	}

	return &userResponse, nil
}

func (s userService) Delete(username string) (*User, error) {
	user, err := s.userRepo.Delete(username)
	if err != nil {
		logs.Error(err)
		return nil, errs.NewUnexpectedError()
	}

	u := User{
		Username: user.Username,
		Balance:  user.Balance,
	}

	return &u, nil

}
