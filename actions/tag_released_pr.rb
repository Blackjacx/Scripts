module Fastlane
  module Actions
    module SharedValues
    end

    class TagReleasedPrAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        # UI.message "Parameter Github Token: #{params[:github_token]}"
        # UI.message "Parameter Github Account: #{params[:github_account]}"
        # UI.message "Parameter Github Repo: #{params[:github_repo]}"
        # UI.message "Parameter Version: #{params[:release_version]}"
        # UI.message "Parameter PR id: #{params[:pr_id]}"
        # UI.message "Parameter PR title: #{params[:pr_title]}"

        sh "curl https://api.github.com/repos/#{params[:github_account]}/#{params[:github_repo]}/issues/#{params[:pr_id]}/comments -H \"Authorization: token #{params[:github_token]}\"  --data \"{\\\"body\\\": \\\"Congratulations! 🎉 This was released in version [#{params[:release_version]}](https://github.com/#{params[:github_account]}/#{params[:github_repo]}/releases/tag/#{params[:release_version]}) 🚀\\\"}\""
        sh "curl https://api.github.com/repos/#{params[:github_account]}/#{params[:github_repo]}/pulls/#{params[:pr_id]} -H \"Authorization: token #{params[:github_token]}\" --data \"{\\\"title\\\": \\\"#{params[:pr_title]} [#{params[:release_version]}]\\\"}\""
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Append the release version to the title and add a release comment to the PR."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :github_token,
                                       env_name: "GITHUB_TOKEN", # The name of the environment variable
                                       description: "API Token for Github", # a short description of this parameter
                                       verify_block: proc do |value|
                                          UI.user_error!("No Github API token for TagReleasedPrAction given, pass using `github_token: 'token'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :github_account,
                                       env_name: "GITHUB_ACCOUNT",
                                       description: "Account name of your github repo, mostly your user name",
                                       verify_block: proc do |value|
                                          UI.user_error!("No Github account name for TagReleasedPrAction given, pass using `github_account: 'account'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :github_repo,
                                       env_name: "GITHUB_REPO",
                                       description: "Repository name of your github repo",
                                       verify_block: proc do |value|
                                          UI.user_error!("No Github repository name for TagReleasedPrAction given, pass using `github_repo: 'repo'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :release_version,
                                       env_name: "RELEASE_VERSION",
                                       description: "The version you want to release",
                                       verify_block: proc do |value|
                                          UI.user_error!("No release_version for TagReleasedPrAction given, pass using `release_version: 'version'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :pr_id,
                                       env_name: "PULL_REQUEST_ID",
                                       description: "The id of the pull request you want to tag",
                                       verify_block: proc do |value|
                                          UI.user_error!("No PR id for TagReleasedPrAction given, pass using `pr_id: 'id'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :pr_title,
                                       env_name: "PULL_REQUEST_TITLE",
                                       description: "The title of the pull request you want to tag",
                                       verify_block: proc do |value|
                                          UI.user_error!("No PR title for TagReleasedPrAction given, pass using `pr_title: 'id'`") unless (value and not value.empty?)
                                       end),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Blackjacx"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 
        true
      end
    end
  end
end
