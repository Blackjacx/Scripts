# Fastlane Documentation:
# https://github.com/fastlane/fastlane/tree/master/fastlane/docs
#
# Fastlane actions: 
# https://docs.fastlane.tools/actions/
#
# Bitrise with fastlane example:
# https://github.com/bitrise-samples/fastlane/blob/master/BitriseFastlaneSample/fastlane/Fastfile
#
# AUTHENTICATION
# https://docs.fastlane.tools/best-practices/continuous-integration/
# https://github.com/fastlane/fastlane/tree/master/spaceship
#
# Change the syntax highlighting to Ruby
# All lines starting with a # are ignored when running `fastlane`
#
#
# This file was created by the help of https://gist.github.com/ulhas/e8e529d08849b8cda947
#
#
# NOTE: To use faslane first do:
#           gem install bundler && bundle install
#
#       and then run:
#           bundle exec fastlane release product_name:Gasoline version:"1.0.0" github_account:"blackjacx"
#           bundle exec fastlane test product_name:Gasoline
#
# Configure the following environment variables for your project 
# on your CI and in fastlane/.env:
#
# ENV["GITHUB_TOKEN"] = "..."
# ENV["SLACK_URL"] = "..."
# ENV["BITRISE_DEPLOY_DIR"] = "..."
# ENV['CRASHLYTICS_API_TOKEN'] = "..."
# ENV['CRASHLYTICS_BUILD_SECRET'] = "..."
# ENV['FASTLANE_USER'] = "..."
# ENV['FASTLANE_PASSWORD'] = "..."
# ENV['FASTLANE_DONT_STORE_PASSWORD'] = "..."



# TODO: deploy to TestFlight, Crashlytics, Hockey, ... & move away from Bitrise
# TODO: dSYM's are missing on upload to crashlytics



# This is the minimum version number required. 
# Update this, if you use features of a newer version.
fastlane_version "2.55.0"

default_platform :ios


platform :ios do

  before_all do
  end

  after_all do
    # This is called, only if the executed lane was successful
    slack(success: true, message: "*Successfully Built App 🎉*")
    clean_build_artifacts
  end

  error do |lane, exception|
    # This block is called, only if the executed lane failed
    slack(success: false, message: "*#{lane} failed with #{exception.message}*")
    clean_build_artifacts
  end

  ##############################################################################
  # Playground Lane
  ##############################################################################

  lane :playground do |options|
  end

  ##############################################################################
  # Release Lane
  ##############################################################################

  desc "Releases a new product version"
  lane :release do |options|

    possible_release_types = ["appstore", "nightly", "beta"]

    if !options[:product_name]; raise "No product_name provided!".red; end
    if !options[:build]; raise "No build provided!".red; end
    if !options[:github_account]; raise "No github_account provided!".red; end
    if !possible_release_types.include? options[:release_type]
      raise "Please set release_type to one of: #{possible_release_types}".red
    end

    product_name = options[:product_name]
    build = options[:build]
    github_account = options[:github_account]
    release_type = options[:release_type]
    project = "#{product_name}.xcodeproj"
    workspace = "#{product_name}.xcworkspace"
    version = get_version_number(xcodeproj: "#{project}", target: "#{product_name}")
    deploy_dir = ENV["BITRISE_DEPLOY_DIR"]
    ipa_name = "#{product_name}.ipa"
    ipa_path = "#{deploy_dir}/#{product_name}.ipa"
    dsym_path = "#{deploy_dir}/#{product_name}.app.dSYM.zip"
    run_danger = options[:run_danger]
    tester_emails = message = File.read('../testers.txt') rescue ""

    test(product_name: product_name, run_danger: run_danger)

    # Increments CFBundleVersion by one and sets CFBundleShortVersionString
    increment_version_number(version_number: version)
    increment_build_number(build_number: build)

    # read changelog
    changelog = read_changelog(section_identifier: "[#{version}]")

    gym(
      workspace: workspace, 
      scheme: product_name,
      output_directory: deploy_dir,
      output_name: "#{ipa_name}",
      export_method: "ad-hoc",
      include_bitcode: true,
      include_symbols: true,
      clean: true
    )

    github_release = set_github_release(
      repository_name: "#{github_account}/#{product_name}",
      api_token: ENV["GITHUB_TOKEN"],
      name: version,
      tag_name: version,
      description: ("#{changelog}" rescue "No changelog provided"),
      commitish: "master"
    )
    
    crashlytics(
      crashlytics_path: "./Pods/Crashlytics/iOS/Crashlytics.framework",
      emails: tester_emails
    )

    upload_symbols_to_crashlytics(dsym_path: "#{dsym_path}")

    # testflight(
    #   changelog: changelog,
    #   ipa: "#{ipa_path}"
    # )

    slack_message = "*Successfully Built App 🎉*\n" \
                    "Hey @channel, Product Version #{version} " \
                    "is out 🤜:boom:🤛\n\n" \
                    "In the following you'll find whats new in this " \
                    "release:\n\n" \
                    "#{changelog}\n\n" \
                    "You'll be notified via TestFlight about the new version.\n"
    slack(success: true, message: slack_message)
  end

  ##############################################################################
  # Test Lane
  ##############################################################################

  desc "Runs tests optionally with danger"
  lane :test do |options|

    if !options[:product_name]; raise "No product_name provided!".red; end

    product_name = options[:product_name]
    run_danger = options[:run_danger]

    cocoapods(use_bundle_exec: true, repo_update: true)

    # Easily run tests of your iOS app using scan
    scan(
      workspace: "#{product_name}.xcworkspace",
      scheme: product_name,
      clean: true,
      devices: ["iPhone 7"],
      skip_build: true,
      thread_sanitizer: true,
      output_types: "html",
      skip_slack: true,
      output_directory: ENV["BITRISE_DEPLOY_DIR"]
    )

    # Runs danger for the project
    if run_danger
      danger(
        use_bundle_exec: true,
        github_api_token: ENV["GITHUB_TOKEN"],
        verbose: true
      )
    end
  end

  ##############################################################################
  # Manually Refreshing Crashlytics dSYM's
  ##############################################################################

  lane :refresh_dsyms do
    # This needs to be done after uploading a new app to ITC since Apple 
    # recompiles the apps from bitcode hich results in new dSYM's.
    # NOTE: upload_symbols_to_crashlytics relies in the installed Fabric.app
    # Reference: https://github.com/fastlane/fastlane/issues/10255
    download_dsyms(
      username: "user@company.com", 
      app_identifier: "com.redacted.redacted", 
      version: "latest")
    upload_symbols_to_crashlytics()
  end
end
