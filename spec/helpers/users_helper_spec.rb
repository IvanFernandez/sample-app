require 'spec_helper'

describe UsersHelper do
	describe "user helper defines a gravatar_for method" do
		let(:user) { FactoryGirl.create(:user) }
		it {respond_to? gravatar_for(user)}
	end

	describe "gravatar_for method allows a size parameter" do
		let(:user) { FactoryGirl.create(:user) }
		it {respond_to? gravatar_for(user, :size => 40)}
	end
end
