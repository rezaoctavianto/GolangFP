package entities

import "time"

type Book struct {
	Id       uint
	Title    string
	Author   Author
	Genre    string
	Description string
	Release_Date string
	Updated_At time.Time
	Added_At time.Time
}
