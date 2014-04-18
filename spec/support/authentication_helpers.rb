module AuthenticationHelpers
  def sign_in_as!(user, pass)
    #visit '/login'
    #fill_in 'Email', :with => user.email
    #fill_in 'Password', :with => pass
    #click_button 'Login'
  end
end

def appoint_admin(u)
  admin_role.users << u
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, :type => :feature
end
