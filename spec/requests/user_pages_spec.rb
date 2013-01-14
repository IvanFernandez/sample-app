require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('h1',    text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1',    text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "signup" do

		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			describe "after submission" do
				describe "every field is incorrect" do
					before { click_button submit }
					it { should have_selector('title', text: 'Sign up') }
					it { should have_content('error') }
					it { should have_content('Password is too short')}
				end
			end
			describe "on submission" do
				describe "password isn't too short" do
					before do
						fill_in "Name",         with: "Example User"
						fill_in "Email",        with: "user@example.com"
						fill_in "Password",     with: "foobar"
						fill_in "Confirmation", with: "foobar2"
					end
					before { click_button submit }
					it { should_not have_content('Password is too short')}
					it { should have_content('Password doesn\'t match confirmation')}
				end
				describe "not to create an user" do
					it "should not create a user" do
						expect { click_button submit }.not_to change(User, :count)
					end
				end
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email('user@example.com') }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit edit_user_path(user) }
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_selector('title', text: 'Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end
		end
	end
end
