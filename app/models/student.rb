class Student < User
  has_many :answers
  has_many :enrollments
  has_many :sections, through: :enrollments
end