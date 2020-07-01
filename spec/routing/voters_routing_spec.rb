require "rails_helper"

RSpec.describe VotersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/voters").to route_to("voters#index")
    end

    it "routes to #show" do
      expect(get: "/voters/1").to route_to("voters#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/voters").to route_to("voters#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/voters/1").to route_to("voters#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/voters/1").to route_to("voters#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/voters/1").to route_to("voters#destroy", id: "1")
    end
  end
end
