module AccountFinder
  def find_account(credentials)
    admin = find_admin(credentials)
    return admin if admin

    owner = find_owner(credentials)
    return owner if owner

    employee = find_employee(credentials)
    return employee if employee

    applicant = find_applicant(credentials)
    return applicant if applicant
  end

  private

  def find_admin(credentials)
    email = Admin.find_by(email: credentials)
    return email if email

    username = Admin.find_by(username: credentials)
    return username if username

    id = Admin.find_by(id: credentials)
    return id if id

    nil
  end

  
  def find_owner(credentials)
    email = Owner.find_by(email: credentials)
    return email if email

    username = Owner.find_by(username: credentials)
    return username if username

    id = Owner.find_by(id: credentials)
    return id if id

    nil
  end

  def find_employee(credentials)
    email = Employee.find_by(email: credentials)
    return email if email

    username = Employee.find_by(username: credentials)
    return username if username

    id = Employee.find_by(id: credentials)
    return id if id

    nil
  end

  def find_applicant(credentials)
    email = Applicant.find_by(email: credentials)
    return email if email

    username = Applicant.find_by(username: credentials)
    return username if username

    id = Applicant.find_by(id: credentials)
    return id if id

    nil
  end

end