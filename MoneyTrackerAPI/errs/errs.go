package errs

import (
	"net/http"

	"github.com/gofiber/fiber/v2"
)

type AppError struct {
	Code    int
	Message string
}

func (e AppError) Error() string {
	return e.Message
}

func NewNotFoundError(message string) error {
	return AppError{
		Code:    http.StatusNotFound,
		Message: message,
	}

}

func NewUnexpectedError() error {
	return AppError{
		Code:    fiber.StatusInternalServerError,
		Message: "Unexpected Error",
	}

}

func NewBadRequestError() error {
	return AppError{
		Code:    fiber.StatusBadRequest,
		Message: "Bad Request",
	}
}

func NewValidationError(message string) error {
	return AppError{
		Code:    http.StatusUnprocessableEntity,
		Message: message,
	}
}
