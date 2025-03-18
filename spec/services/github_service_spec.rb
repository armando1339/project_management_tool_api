require 'rails_helper'

RSpec.describe GithubService, type: :service do
  let(:service) { described_class.new }

  describe "#fetch_latest_public_repositories", :vcr do
    it "returns a list of repositories" do
      VCR.use_cassette("github_latest_repos_page_1") do
        repos = service.fetch_latest_public_repositories(page: 1, per_page: 2)

        expect(repos).to be_an(Array)
        expect(repos.size).to eq(2)
        expect(repos.first).to have_key("full_name")
        expect(repos.first).to have_key("html_url")
      end
    end

    it "returns different repositories for different pages" do
      VCR.use_cassette("github_latest_repos_page_1_2") do
        repos_page_1 = service.fetch_latest_public_repositories(page: 1, per_page: 2)
        repos_page_2 = service.fetch_latest_public_repositories(page: 2, per_page: 2)

        expect(repos_page_1).not_to eq(repos_page_2)
      end
    end
  end
end
