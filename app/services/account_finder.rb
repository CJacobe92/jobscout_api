module AccountFinder
  def find_account(credential)
    admin = find_admin(credential)
    return admin if admin

    owner = find_owner(credential)
    return owner if owner

    employee = find_employee(credential)
    return employee if employee

    applicant = find_applicant(credential)
    return applicant if applicant
  end

  private

  def find_admin(credential)
    email = Admin.find_by(email: credential)
    return email if email

    username = Admin.find_by(username: credential)
    return username if username

    id = Admin.find_by(id: credential)
    return id if id

    nil
  end

  
  def find_owner(credential)
    email = Owner.find_by(email: credential)
    return email if email

    username = Owner.find_by(username: credential)
    return username if username

    id = Owner.find_by(id: credential)
    return id if id

    nil
  end

  def find_employee(credential)
    email = Employee.find_by(email: credential)
    return email if email

    username = Employee.find_by(username: credential)
    return username if username

    id = Employee.find_by(id: credential)
    return id if id

    nil
  end

  def find_applicant(credential)
    email = Applicant.find_by(email: credential)
    return email if email

    username = Applicant.find_by(username: credential)
    return username if username

    id = Applicant.find_by(id: credential)
    return id if id

    nil
  end

end