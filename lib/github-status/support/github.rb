require 'contracts'
require 'octokit'

module GitHubStatus
  module Support
    module GitHub
      include ::Contracts::Core
      include ::Contracts::Builtin
      include Source

      Contract None => Octokit::Client
      def github
        Octokit.api_endpoint = api_endpoint if api_endpoint
        Octokit.web_endpoint = web_endpoint if web_endpoint
        @github ||= Octokit::Client.new access_token: access_token
      end

      Contract None => String
      def canonical_sha
        @canonical_sha ||= (sha.match(/^.{40}$/) || github.commit(repo, sha).sha).to_s
      end
    end
  end
end
