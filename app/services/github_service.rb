require 'net/http'

class GithubService
  GITHUB_API_URL = "https://api.github.com"

  def fetch_latest_public_repositories(page: 1, per_page: 30)
    uri = URI("#{GITHUB_API_URL}/search/repositories?q=stars:>1000&sort=stars&order=desc&page=#{page}&per_page=#{per_page}")

    response = send_request(uri)
    parsed_response = parse_response(response)

    parsed_response["items"] || []
  end

  private

  def send_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["User-Agent"] = "ProjectManagementAPI"
    request["Accept"] = "application/vnd.github.v3+json"

    http.request(request)
  rescue StandardError => e
    Rails.logger.error("GitHub API Error: #{e.message}")
    nil
  end

  def parse_response(response)
    return nil unless response&.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON Parsing Error: #{e.message}")
    nil
  end
end
